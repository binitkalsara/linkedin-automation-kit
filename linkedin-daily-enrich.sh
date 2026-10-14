#!/bin/bash
# ==========================================
# LinkedIn Daily Enrichment Script
# Works on: Hermes Desktop (Python) + Termux (Android Bash)
# ==========================================

set -euo pipefail

# ==========================================
# CONFIGURATION (edit once)
# ==========================================
# Your LinkedIn URL slug (the custom part of profile URL)
# e.g., for linkedin.com/in/john-doe -> SLUG="john-doe"
LINKEDIN_SLUG="${LINKEDIN_SLUG:-binitkalsara}"

# Your Telegram bot token (get from @BotFather)
TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN:-YOUR_TELEGRAM_BOT_TOKEN_HERE}"

# Your Telegram chat ID (where alerts go)
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-YOUR_TELEGRAM_CHAT_ID_HERE}"

# Output directory
OUTPUT_DIR="./output"
mkdir -p "$OUTPUT_DIR"

# ==========================================
# DEPENDENCY CHECK
# ==========================================
echo "=== LinkedIn Enrichment Start ==="
echo "Profile slug: $LINKEDIN_SLUG"
echo "Output: $OUTPUT_DIR/enriched_$(date +%Y%m%d).csv"
echo

# Check if we have python + required libs
python3 -c "import requests; import bs4" 2>/dev/null || {
    echo "Installing required Python packages..."
    pip install requests beautifulsoup4 2>/dev/null || {
        echo "ERROR: Could not install Python dependencies"
        echo "Install manually: pip install requests beautifulsoup4"
        exit 1
    }
}

# Also check for Hermes environment
if command -v hermes &>/dev/null; then
    echo "Hermes CLI detected — using backend for extraction"
    # Could integrate hermes run here, but keeping as pure bash+python for portability
fi

# ==========================================
# SCRAPE LINKEDIN PROFILE (public data only)
# ==========================================
PROFILE_URL="https://www.linkedin.com/in/$LINKEDIN_SLUG/"

echo "Fetching: $PROFILE_URL"
python3 << PYEOF
import requests, bs4, csv, datetime, sys

slug = "$LINKEDIN_SLUG"
url = f"https://www.linkedin.com/in/{slug}/"

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
}

try:
    res = requests.get(url, headers=headers, timeout=15)
    if res.status_code != 200:
        print(f"ERROR: Got status {res.status_code} — profile may be blocked or slug invalid")
        sys.exit(1)
    
    soup = bs4.BeautifulSoup(res.text, "html.parser")
    
    # Extract publicly visible data
    data = {
        "timestamp": datetime.datetime.utcnow().isoformat() + "Z",
        "profile_url": url,
        "name": "",
        "headline": "",
        "about": "",
        "experience_count": 0,
        "education_count": 0,
        "website": ""
    }
    
    # Name (usually in <h1> or <h2> with specific class)
    name_elem = soup.select_one("h1.text-heading.x-name")
    if name_elem:
        data["name"] = name_elem.get_text(strip=True)
    
    # Headline
    headline_elem = soup.select_one("h2.text-heading.x-small")
    if headline_elem:
        data["headline"] = headline_elem.get_text(strip=True)
    
    # About section
    about_elem = soup.select_one("section.section.about")
    if about_elem:
        data["about"] = about_elem.get_text(strip=True)[:500]  # truncate
    
    # Experience count (approximate)
    exp_elems = soup.select(".pv-entity.pv-entity__card")
    data["experience_count"] = len(exp_elems)
    
    # Education count
    edu_elems = soup.select(".education.pv-education")
    data["education_count"] = len(edu_elems)
    
    # Website URL (from contact info)
    website_elems = soup.select("a.primary-text.color-primary")
    for link in website_elems:
        href = link.get("href", "")
        if href.startswith("http") and not "linkedin.com" in href:
            data["website"] = href
            break
    
    # Write CSV
    output_file = "$OUTPUT_DIR/enriched_$(date +%Y%m%d).csv"
    with open(output_file, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=data.keys())
        writer.writeheader()
        writer.writerow(data)
    
    print(f"SUCCESS: Data written to {output_file}")
    print(f"Name: {data['name']}")
    print(f"Headline: {data['headline']}")
    print(f"Experience: {data['experience_count']} roles")
    print(f"Education: {data['education_count']} entries")
    if data["website"]:
        print(f"Website: {data['website']}")
    
except Exception as e:
    print(f"ERROR: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)
PYEOF

# ==========================================
# TELEGRAM ALERT (optional — send enriched data)
# ==========================================
if [ -n "$TELEGRAM_BOT_TOKEN" ] && [ "$TELEGRAM_BOT_TOKEN" != "YOUR_TELEGRAM_BOT_TOKEN_HERE" ]; then
    echo "Sending Telegram alert..."
    python3 -c "
import requests, json, sys
data_file = '$OUTPUT_DIR/enriched_$(date +%Y%m%d).csv'
try:
    with open(data_file, 'r') as f:
        lines = f.readlines()
    # Send first few lines as summary
    summary = ' | '.join([l.strip() for l in lines[:5]])
    requests.post(
        f'https://api.telegram.org/bot{$TELEGRAM_BOT_TOKEN}/sendMessage',
        chat_id='$TELEGRAM_CHAT_ID',
        text=f'📊 LinkedIn Enrichment Update:\n{summary[:400]}'
    )
except Exception as e:
    print(f'Telegram send warning: {e}')
"
fi

echo
echo "=== LinkedIn Enrichment Complete ==="
echo "Output CSV: $OUTPUT_DIR/enriched_$(date +%Y%m%d).csv"
echo "Check the file for enriched data."
echo "Set TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID in the script to enable alerts."
