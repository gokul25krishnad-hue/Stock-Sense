# ⚡ StockSense — 100% Offline Quick Start & Demo Guide
### Built by Team **Neural Ninjas** | Problem Statement: **PS11 — Small-Retail Reorder Planner (India Edition)**

Welcome to **StockSense**! This package is completely self-contained and operates **100% offline** without needing an active internet connection, external APIs, cloud subscriptions, or Docker. All currency calculations, purchase orders, and recommendations are formatted in **Indian Rupees (₹ / INR)** for small retailers and Kirana store owners.

---

## 🚀 1-Click Quick Start (Windows)

Simply double-click:
```cmd
run_offline.bat
```
This batch script will:
1. Verify Python is installed on your computer.
2. Automatically initialize and seed the demo SQLite database (`instance/stocksense.db`) if not already present.
3. Launch the local web server at `http://127.0.0.1:5000`.
4. Automatically open your default web browser to the login page!

### Manual Terminal Start (Any Operating System: Windows / Mac / Linux)
```bash
# 1. Open terminal inside the 'stocksense' directory
cd stocksense

# 2. Run the application
python run.py
```
Then navigate to: **`http://127.0.0.1:5000`** in your browser.

---

## 🔑 Demo Credentials & Multi-Role Access

A pre-populated, realistic Indian retail store dataset is already loaded into `instance/stocksense.db` with 3 dedicated roles:

1. **👑 Admin / Store Owner:**
   - **Email:** `admin@stocksense.local`
   - **Password:** `AdminPass2026!`
   - **Capabilities:** Full system authority, audit trail inspection, raw CSV imports, and demonstration resets.
2. **⚡ Store Manager:**
   - **Email:** `demo@stocksense.local`
   - **Password:** `StockSenseDemo2026!`
   - **Capabilities:** Daily demand forecasting, replenishment planning, purchase order creation, and stock adjustments.
3. **🛒 Billing Staff / Cashier:**
   - **Email:** `staff@stocksense.local`
   - **Password:** `StaffPass2026!`
   - **Capabilities:** Sales recording, quick product inventory lookups, and shipment receiving.

*On the login page, you can also click the **"⚡ 1-Click Role Logins"** buttons to enter immediately with zero typing!*

---

## ♿ Advanced Accessibility & Voice Guidance Suite

StockSense was designed specifically for small retail shop owners, elderly merchants, low-tech staff, and users of all abilities:
- **🔊 Voice Guidance (Text-To-Speech):** Click **"🔊 Read Page Aloud"** at any time. StockSense speaks the screen summary, active inventory alerts, and replenishment actions in clear spoken English (100% offline using the browser's built-in Web Speech API). Press <kbd>Escape</kbd> or click "⏹️ Stop Voice" to cancel speech.
- **👁️ Ultra High Contrast Mode (WCAG AAA):** Click **"👁️ High Contrast"** on the top toolbar to switch to a stark yellow-on-black theme with high-visibility borders, ideal for low-vision users or bright shop floor lighting.
- **🔠 Dynamic Text Scaling:** Toggle between Standard (`A`), Large (`A+`, 115%), and Extra Large (`A++`, 130%) text sizes with 1 click.
- **Persistent Preferences:** Contrast and text size selections are saved in local storage and persist across every page.
- **Currency in Indian Rupees (₹ / INR):** All prices, estimated reorder costs, capital exposure, and purchase order line items are formatted with the official Indian Rupee symbol (`₹`).
- **Large Touch Targets ($\ge 44 \times 44$px):** Perfectly sized for touchscreen POS terminals, tablets, and easy clicking without mouse misclicks.
- **Keyboard & Screen-Reader Navigation:** Includes a visible "Skip to content" link, full keyboard support (press `Escape` to close modals), and semantic ARIA landmarks.
- **Mobile & Tablet Drawer:** Responsive sidebar collapses on small screens with a single-tap hamburger toggle.

---

## 🧪 Running Automated Tests

To verify all mathematical guarantees, data validations, and end-to-end workflows:
```bash
python -m pytest tests/ -v
```
All **17 tests pass** across:
- `test_units.py`: Inventory formulas, safety stock calculations, MOQ rounding.
- `test_integrations.py`: CSV import error handling, rejected rows file downloads, purchase order lifecycle.
- `test_ml_correctness.py`: No data leakage, strict chronological splits, monotonic quantiles.
- `test_end_to_end.py`: Complete user journey from CSV ingestion to physical receipt in the stock ledger.

---

## 🛠️ Offline Support & Troubleshooting

- **Error: "Port 5000 is already in use"**
  Edit `run.py` and change `port=5000` to `port=5050` or `port=8080`.
- **Reset Demo Data to Fresh State:**
  Inside the app, click the **"⚡ Reset Demo Dataset"** button on the top-right of the dashboard, or run:
  ```bash
  python scripts/seed_demo.py
  ```
- **Vendored Plotly JS:**
  The interactive chart engine `plotly.min.js` (4.55 MB) is pre-bundled locally inside `app/static/js/plotly.min.js`, ensuring zero external network calls.
