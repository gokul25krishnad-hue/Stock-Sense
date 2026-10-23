# StockSense — 100% Offline User & Troubleshooting Guide

This guide provides instructions to run **StockSense** completely offline on Windows, macOS, or Linux, without requiring an internet connection or external APIs.

---

## 1. Offline Readiness Architecture

StockSense is engineered for offline execution:
- **Local Persistence:** Uses SQLite (`instance/stocksense.db`), which requires no database server daemon or network connection.
- **Vendored Visualizations:** Interactive Plotly charts use the locally vendored bundle at `app/static/js/plotly.min.js` (4.55 MB). The HTML templates load this local asset rather than pulling from a CDN.
- **Embedded Machine Learning:** Forecasting algorithms (`HistGradientBoostingRegressor`, `SeasonalNaive`, `MovingAverage`, `Croston`) run locally via `scikit-learn`, `numpy`, and `scipy`. No cloud AI APIs or LLM tokens are needed.
- **Pre-Seeded Database:** The included `instance/stocksense.db` contains pre-seeded products, suppliers, 180 days of historical sales, baseline models, and active reorder recommendations.

---

## 2. Quickstart Instructions

### Step 1: Unzip the Package
Extract `stocksense.zip` to a directory of your choice, for example:
```
C:\Projects\stocksense
```

### Step 2: Open Terminal / PowerShell
Navigate into the extracted folder:
```powershell
cd "C:\Projects\stocksense"
```

### Step 3: (If not yet installed) Install Python Dependencies
If running on a new machine where dependencies aren't yet installed:
```powershell
pip install -r requirements.txt
```
*(Once dependencies are installed in your Python environment, no internet connection is ever needed again).*

### Step 4: Launch the Server
```powershell
python run.py
```
Output will show:
```
 * Serving Flask app 'run.py'
 * Debug mode: on
 * Running on http://127.0.0.1:5000
```

### Step 5: Open in Your Browser
Open any web browser and go to:
👉 **`http://localhost:5000`**

---

## 3. Pre-Configured Credentials

The local database comes pre-seeded. You can log in using:
- **Store Name:** `Metro Express Retail`
- **Email:** `demo@stocksense.local`
- **Password:** `StockSenseDemo2026!`

Alternatively, click the **"⚡ One-Click Demo Store Sign-In"** button on the login screen to enter immediately.

---

## 4. Troubleshooting & Error Solutions

### Issue 1: `Address already in use` or Port 5000 Conflict
**Symptom:** `OSError: [Errno 48] Address already in use` or `[WinError 10048]`  
**Cause:** Another application (or a previous instance of Flask) is using port 5000.  
**Solution:** Specify a different port using an environment variable or command-line:
```powershell
# In PowerShell:
$env:PORT="5050"
python run.py
```
Then navigate to: **`http://localhost:5050`**

---

### Issue 2: `ModuleNotFoundError: No module named 'flask'`
**Symptom:** Python cannot find Flask or related libraries.  
**Cause:** Running with a Python executable different from where dependencies were installed, or virtual environment is not activated.  
**Solution:**  
Check which python you are using:
```powershell
where.exe python
python -m pip list
```
If needed, create and activate a dedicated virtual environment:
```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
python run.py
```

---

### Issue 3: PowerShell Script Execution Policy Error
**Symptom:** `File ... Activate.ps1 cannot be loaded because running scripts is disabled on this system.`  
**Cause:** Windows PowerShell default execution policy is `Restricted`.  
**Solution:**  
Run this command in PowerShell to allow script execution for current session:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\venv\Scripts\Activate.ps1
```

---

### Issue 4: Database File Locked / Reset Needed
**Symptom:** Database gets corrupted or you want to restart fresh with standard demo data.  
**Solution:**  
Run the idempotent seed script to cleanly re-initialize:
```powershell
python scripts/seed_demo.py
```
Or click the **"⚡ Reset Demo Dataset"** button on the web dashboard topbar.

---

### Issue 5: Plotly Charts Not Showing
**Symptom:** Chart areas appear blank.  
**Cause:** JavaScript is disabled in the browser, or local files failed to serve.  
**Solution:**
- Verify that `app/static/js/plotly.min.js` exists and is non-empty (~4.5MB).
- Ensure your browser allows JavaScript on `localhost`.
- Check browser Developer Tools (F12) Console for any client-side errors.

---

## 5. Offline Verification Checklist

| Feature | Offline Method | Status |
|---|---|---|
| Database | SQLite in `instance/stocksense.db` | 100% Local |
| Forecasting Models | `scikit-learn`, `numpy`, `scipy` | 100% Local |
| Charts | `app/static/js/plotly.min.js` | 100% Local |
| CSV Imports/Exports | Built-in Python `csv` & `pandas` | 100% Local |
| User Auth & Sessions | Local SQLite password hashes & cookies | 100% Local |

---

## 6. Running the Automated Test Suite Offline

To verify all 17 tests:
```powershell
python -m pytest tests/ -v
```
All unit, integration, machine-learning data-leakage, and end-to-end tests will run in-memory and report passes without internet access.
