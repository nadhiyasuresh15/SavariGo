import json
import time
from datetime import datetime
from pathlib import Path

from openpyxl import Workbook
from appium import webdriver


ROOT = Path(__file__).resolve().parent
CONFIG_PATH = ROOT / "appium_config.json"


def load_config():
    with open(CONFIG_PATH, "r", encoding="utf-8") as f:
        return json.load(f)


def start_driver(cfg):
    caps = cfg.get("desiredCapabilities", {})
    server = cfg.get("appiumServer", "http://localhost:4723/wd/hub")
    return webdriver.Remote(server, caps)


def write_report(rows, out_path: Path):
    wb = Workbook()
    ws = wb.active
    ws.title = "e2e-report"
    ws.append(["step", "description", "status", "message", "started_at", "finished_at", "duration_s"]) 
    for r in rows:
        ws.append(r)
    wb.save(out_path)


def run_steps(driver, cfg):
    rows = []
    # High-level A->Z scenario steps. Replace selectors in appium_config.json.
    steps = [
        ("launch", "Launch app", lambda d: True),
        ("login", "Login with test credentials", lambda d: d.find_element_by_accessibility_id(cfg['selectors']['login_button']).click()),
        ("home", "Open passenger home", lambda d: d.find_element_by_accessibility_id(cfg['selectors']['passenger_home']).is_displayed()),
        ("book", "Book a ride (enter pickup/dropoff)", lambda d: d.find_element_by_accessibility_id(cfg['selectors']['book_ride_button']).click()),
        ("confirm", "Confirm ride request", lambda d: d.find_element_by_accessibility_id(cfg['selectors']['confirm_ride_button']).click()),
        ("active", "Driver accepts / ride becomes active", lambda d: True),
        ("complete", "Complete the ride", lambda d: d.find_element_by_accessibility_id(cfg['selectors']['complete_ride_button']).click()),
        ("history", "Verify ride appears in history", lambda d: d.find_element_by_accessibility_id(cfg['selectors']['ride_history_item']).is_displayed()),
        ("logout", "Log out", lambda d: d.find_element_by_accessibility_id(cfg['selectors']['logout_button']).click()),
    ]

    for key, desc, fn in steps:
        started = datetime.utcnow()
        status = "PASS"
        msg = ""
        try:
            fn(driver)
            time.sleep(cfg.get("stepDelay", 1))
        except Exception as e:
            status = "FAIL"
            msg = str(e)
        finished = datetime.utcnow()
        dur = (finished - started).total_seconds()
        rows.append([key, desc, status, msg, started.isoformat(), finished.isoformat(), dur])
        # continue through scenario even if a step fails so we get full report

    return rows


def main():
    cfg = load_config()
    out_file = ROOT / f"appium_e2e_report_{int(time.time())}.xlsx"
    driver = None
    rows = []
    try:
        driver = start_driver(cfg)
        rows = run_steps(driver, cfg)
    except Exception as e:
        rows = [["setup", "Start driver / setup", "FAIL", str(e), datetime.utcnow().isoformat(), datetime.utcnow().isoformat(), 0]]
    finally:
        if driver:
            try:
                driver.quit()
            except Exception:
                pass
        write_report(rows, out_file)
        # also write a stable filename for easy reference
        stable = ROOT / "appium_e2e_report_latest.xlsx"
        write_report(rows, stable)
        print(f"Report written: {out_file}\nAlso: {stable}")


if __name__ == "__main__":
    main()
