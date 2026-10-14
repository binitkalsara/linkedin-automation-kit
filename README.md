# LinkedIn Automation Sovereignty Kit
## Universal, safe, one-click LinkedIn data enrichment & monitoring
### Works on: Hermes Desktop (Windows) + Termux (Android)
### For: Marketers, Partnership leads, Freelancers, AI Agents
### License: MIT — free to use, modify, distribute

[Buy me a coffee](https://ko-fi.com/binitkalsara)
*Support this project with a coffee — helps keep updates coming.*

---
## ⚠️ READ FIRST: What this does (and doesn't do)

**This kit automates:**
- ✅ LinkedIn profile data extraction (name, headline, about, experience, education)
- ✅ Website URL verification
- ✅ Profile change detection (>5% change triggers alert)
- ✅ Telegram alert notifications
- ✅ Daily cron-friendly execution

**This kit does NOT:**
- ❌ Scrape private data
- ❌ bypass LinkedIn login walls
- ❌ Send connection requests or messages
- ❌ Violate LinkedIn TOS

---
## 🛠️ Quickstart: One-command setup

### Option A: Hermes Desktop (Windows) — Recommended
```bash
# 1. Install Hermes if not already (download from nousresearch.com)
# 2. Open terminal in Hermes
# 3. Run:
hermes setup --quick --gateway --tools

# 4. When prompted, enable:
#   - Browser Use (option 1: Local Browser)
#   - Firecrawl API key (or skip — local browser works)

# 5. Run the enrichment:
hermes run scripts/linkedin-daily-enrich.sh
```

### Option B: Termux (Android)
```bash
# 1. Install Termux from F-Droid or Play Store
# 2. pkg install python git curl
# 3. git clone https://github.com/binitkalsara/linkedin-automation-kit
# 4. cd linkedin-automation-kit
# 5. chmod +x *.sh
# 6. bash setup-termux.sh
```

---
## 📁 What you get

```
/linkedin-automation-kit
├── README.md            # You are here
├── setup-hermes.bat     # One-click Hermes config (double-click)
├── setup-termux.sh      # One-click Termux config
├── linkedin-daily-enrich.sh  # Main enrichment script (run daily)
├── check-blocking.py    # "Am I at risk of block today?"
├── alert-telegram.sh    # Send alert to your Telegram (one-time setup)
├── profiles/            # Pre-configured Hermes profiles (clone per client)
│   ├── base-profile/    # Base config you duplicate
│   └── example-config.yaml
├── scripts/             # Supporting scripts
│   └── gitignore-global
└── SOUL.md              # Universal problem statement (no client names)
```

---
## 🔑 Required (free) accounts

1. **Telegram Bot** — @BotFather → /newbot → save token
   - You'll get: `123456789:AAHb...`
   - Put it in `config.yaml` or `setup-termux.sh`

2. **LinkedIn login** — you must be logged into LinkedIn in your browser
   - This kit reads publicly available data only
   - Keep Chrome open & logged in for best results

3. **Hermes Desktop OR Termux** — pick one (both supported)

---
## ⚡ One-click usage

### Daily enrichment (Hermes):
```bash
# Open Hermes terminal, run:
hermes run scripts/linkedin-daily-enrich.sh
```
*Output: CSV file with enriched data in ./output/*

### Risk check (anywhere):
```bash
python3 check-blocking.py
```
*Output: "SAFE" or "REVIEW TODAY" with reasons*

### Telegram alert test:
```bash
bash alert-telegram.sh "Test message"
```
*Output: Message appears in your Telegram chat*
