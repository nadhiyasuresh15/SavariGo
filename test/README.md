Appium E2E test harness

Quick start

1. Install Python dependencies:

```powershell
python -m pip install -r test\requirements.txt
```

2. Start Appium server and ensure an Android device/emulator is available.

3. Edit `test/appium_config.json` to match your `appPackage`, `appActivity`, and UI selectors (accessibility ids or resource-ids).

4. Run the test:

```powershell
python test\appium_e2e.py
```

Outputs
- `test/appium_e2e_report_<ts>.xlsx` — timestamped report
- `test/appium_e2e_report_latest.xlsx` — latest report (overwritten each run)

Notes
- The script uses accessibility ids defined in `test/appium_config.json` under `selectors`.
- If your Flutter widgets expose semantics labels or keys, use those values as accessibility ids in the config.
