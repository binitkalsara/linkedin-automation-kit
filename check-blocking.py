#!/usr/bin/env python3
"""=== Check LinkedIn Automation Risk ===
Determines if your current setup is at risk of getting blocked today.
Works on Hermes Desktop + Termux + pure Python environments.
"""

import sys
import os
import json
import urllib.request

# Configuration — user sets these once
LINKEDIN_PROFILE_VIEWS_TODAY = int(os.getenv("LINKEDIN_VIEWS_TODAY", "15"))
TELEGRAM_BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN", "")
TELEGRAM_CHAT_ID = os.getenv("TELEGRAM_CHAT_ID", "")

def check_risk_factors():
    """Evaluate each risk factor and return score + recommendations."""
    score = 0
    reasons = []

    # Factor 1: Too many profile views in one day
    # LinkedIn throttle after ~30-50 views/day from same IP/method
    if LINKEDIN_VIEWS_TODAY > 30:
        score += 2
        reasons.append(f"⚠️  {LINKEDIN_VIEWS_TODAY} views today — consider reducing to <30")

    # Factor 2: No user-agent rotation (fixed UA = easier to detect)
    # Default: assume risk if not configured otherwise
    score += 1
    reasons.append("ℹ️  Using default user-agent — consider rotating weekly")

    # Factor 3: No pauses between actions
    score += 1
    reasons.append("ℹ️  No random delays between actions — add time.sleep(2-5)")

    # Factor 4: Using same device/proxy continuously
    score += 1
    reasons.append("ℹ️  Same device/proxy — consider IP rotation weekly")

    # Determine risk level
    if score >= 5:
        level = "HIGH 🔴"
        action = "STOP TODAY — review your automation pipeline"
    elif score >= 3:
        level = "MEDIUM 🟡"
        action = "REDUCE frequency, add delays, rotate IP"
    else:
        level = "LOW 🟢"
        action = "You're safe for today — keep monitoring"

    # Output
    print("=" * 50)
    print("  LinkedIn Automation Risk Assessment")
    print("=" * 50)
    print(f"  Risk Score: {score}/6")
    print(f"  Current Level: {level}")
    print()
    print("  Risk Factors:")
    for r in reasons:
        print(f"  {r}")
    print()
    print(f"  Recommendation: {action}")
    print("=" * 50)

    # Optional: Telegram alert
    if TELEGM_BOT_TOKEN and TELEGRAM_CHAT_ID and score >= 3:
        try:
            import requests
            msg = f"*LinkedIn Risk Alert*\nScore: {score}/6\nLevel: {level}\nAction: {action}"
            requests.post(
                f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage",
                chat_id=TELEGRAM_CHAT_ID,
                text=msg,
                parse_mode="Markdown"
            )
        except Exception:
            pass

    return score

if __name__ == "__main__":
    check_risk_factors()
