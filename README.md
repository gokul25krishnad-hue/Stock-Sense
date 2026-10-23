# StockSense AI — Small-Retail Demand Forecasting & Reorder Intelligence Platform

> **Problem Statement:** PS11 — StockSense: Small-Retail Reorder Planner  
> **Target Audience:** Independent retail grocers, Kirana store operators, pharmacies, and small supermarket managers.  
> **Architecture:** 100% Local-First, Research-Grade ML & Deterministic Inventory Decision Engine.  
> **Key Guarantee:** Zero cloud lock-in, zero external paid APIs, strictly leak-free chronological forecasting, auditable reorder mathematics.

---

## 1. Problem Context & Solution Mission

Small retailers face a daily double-sided inventory squeeze:
1. **Costly Stockouts:** High-velocity, staple products run out of stock unexpectedly during supplier replenishment lead times, leading to lost revenue and customer defection.
2. **Dead Capital & Waste:** Slow-moving or seasonal products are over-purchased, locking up precious working capital on dusty shelves or expiring.

Traditional retail ERPs cost thousands of dollars per month and assume reliable enterprise data. StockSense AI is built from the ground up for small retail:
- **Zero Internet Requirement:** Fully functional offline using a local SQLite persistence layer and locally bundled Plotly.js charts.
- **Explainable Mathematics:** Every replenishment recommendation displays the exact formula inputs: on-hand, on-order, inventory position, lead-time demand, safety stock, reorder point, MOQ, and order multiples.
- **Honest Model Selection:** Scikit-learn Machine Learning regressors compete against statistical baselines (Seasonal Naive, Moving Average, Croston). If a baseline outperforms ML on held-out windows, the baseline wins and is deployed.

---

## 2. System Architecture & Tech Stack

```
stocksense/
├── app/
│   ├── __init__.py               # Flask application factory, Jinja filters, route blueprints
│   ├── config.py                 # Configuration classes (Development, Testing, Production)
│   ├── extensions.py             # SQLAlchemy, LoginManager, CSRFProtect
│   ├── models/                   # 10 Normalized Relational Tables
│   │   ├── user.py               # Store and User models (bcrypt hashing, roles)
│   │   ├── product.py            # Catalogue, MOQ, pack multiples, supplier relations
│   │   ├── sale.py               # Historical sales transactions & net demand
│   │   ├── inventory.py          # Auditable inventory ledger movements
│   │   ├── supplier.py           # Supplier lead times, contacts, performance
│   │   ├── purchase_order.py     # PO lifecycle (Draft, Ordered, Partial, Received)
│   │   ├── forecast_run.py       # Forecast runs, predictions, recommendations, experiments
│   │   ├── import_job.py         # CSV ingestion jobs & error logging
│   │   ├── audit.py              # Store-isolated security & operational audit trail
│   │   └── copilot.py            # Local conversation history & tool grounding
│   ├── routes/                   # 15 Modular Blueprint Controllers
│   │   ├── auth.py               # Registration, login, rate limiting, demo fast-login
│   │   ├── dashboard.py          # Operational cockpit & KPI cards
│   │   ├── products.py           # Product catalog CRUD, stock ledger view
│   │   ├── sales.py              # Sales history view
│   │   ├── imports.py            # CSV import wizard, column mapping, rejected rows
│   │   ├── forecasting.py        # Forecast workspace, Plotly interactive charts
│   │   ├── inventory.py          # Reorder planner, What-If simulator, overstock, ledger
│   │   ├── suppliers.py          # Supplier management & fulfillment intelligence
│   │   ├── purchase_orders.py    # PO creation, partial/complete receipt workflow
│   │   ├── reports.py            # Downloadable CSV report exports
│   │   ├── experiments.py        # Model laboratory, rolling backtests, benchmarks
│   │   ├── methodology.py        # In-app research principles & mathematical definitions
│   │   ├── copilot.py            # Local natural language query assistant
│   │   ├── anomalies.py          # Demand spike & sudden drop anomaly scanner
│   │   └── api.py                # REST API v1 endpoints
│   ├── services/                 # Pure Business Logic & ML Engines
│   │   ├── csv_import_service.py # Chunked ingestion, duplicate policies, transaction safety
│   │   ├── data_validation_service.py # Pre-import schema & data sanity checks
│   │   ├── feature_engineering.py# Leak-free time features, shifted rolling windows, lags
│   │   ├── forecasting_service.py# Baselines, HistGradientBoosting, recursive forecasts
│   │   ├── backtesting_service.py# Rolling-origin chronological evaluation & metrics
│   │   ├── uncertainty_service.py# Empirical residual quantiles & reliability scoring
│   │   ├── reorder_service.py    # ROP, Safety Stock (Method A & B), PO generation
│   │   ├── inventory_risk_service.py # Days of inventory, dead stock, what-if planning
│   │   ├── optimization_service.py # Integer knapsack replenishment under budget caps
│   │   ├── supplier_intelligence_service.py # Observed vs quoted supplier lead times
│   │   ├── reporting_service.py  # RFC 4180 compliant CSV exports
│   │   ├── audit_service.py      # Immutable event logging
│   │   └── anomaly_service.py    # Statistical outlier detection
│   ├── static/                   # Bundled assets (CSS, Vanilla JS, Plotly.js 4.5MB offline)
│   └── templates/                # Responsive Jinja2 HTML5 semantic templates
├── scripts/
│   ├── generate_demo_data.py     # Deterministic synthetic sales generator (seed=42)
│   └── seed_demo.py              # Database seeding & re-seeding command
├── tests/                        # 27 Comprehensive Automated Pytest Suites
├── pytest.ini                    # Pytest configuration & warning suppression
├── requirements.txt              # Pinned, compatible Python dependencies
├── .env.example                  # Environment configuration template
├── README.md                     # This comprehensive documentation
└── run.py                        # Entrypoint script with CLI commands
```

---

## 3. Core Mathematical Formulations

### 1. Inventory Position ($IP$)
$$\text{Inventory Position} = \text{On-Hand Stock} + \text{On-Order Stock} - \text{Backorders}$$
*A draft purchase order does not count as physical on-hand stock, but is tracked as on-order once placed.*

### 2. Reorder Point ($ROP$)
$$\text{ROP} = \hat{D}_L + \text{SS}$$
Where:
- $\hat{D}_L$: Expected demand during supplier lead time $L$, computed as $\sum_{t=1}^{L} \hat{y}_t$ from the product's daily forecast.
- $\text{SS}$: Safety Stock buffer to protect against demand volatility.

### 3. Safety Stock Formulations
- **Method A (Service-Level Normal Buffer):**
  $$\text{SS} = Z_{\alpha} \times \sqrt{L} \times \max(\sigma_{\text{daily}}, \text{RMSE}_{\text{backtest}})$$
  Where $Z_{0.95} = 1.645$, $Z_{0.99} = 2.326$.
- **Method B (Empirical Protection Level):**
  $$\text{SS} = \max\left(0, \text{Quantile}_{\alpha}\left(\sum_{\tau=1}^{L} y_{\tau}\right) - \hat{D}_L\right)$$
  Directly uses the historical $\alpha$-quantile of empirical rolling lead-time demand sums without assuming a Gaussian distribution.

### 4. Target Stock Level ($TSL$) & Order Quantity
$$\text{TSL} = \hat{D}_{L+R} + \text{SS}$$
$$\text{Base Order Quantity} = \max(0, \text{TSL} - \text{IP})$$
$$\text{Final Order Quantity} = \max\left(\text{MOQ}, \left\lceil \frac{\text{Base Order Quantity}}{\text{Pack Multiple}} \right\rceil \times \text{Pack Multiple}\right)$$
*Discontinued products have their replenishment automatically suppressed ($Q^* = 0$).*

### 5. Time-Series Metrics & Zero-Denominator Safety
- **MAE:** $\frac{1}{n}\sum |y_t - \hat{y}_t|$
- **RMSE:** $\sqrt{\frac{1}{n}\sum (y_t - \hat{y}_t)^2}$
- **WAPE:** $\frac{\sum |y_t - \hat{y}_t|}{\sum y_t}$ (defined when $\sum y_t > 0$, immune to individual zero-demand days)
- **sMAPE:** $\frac{200\%}{n}\sum \frac{|y_t - \hat{y}_t|}{|y_t| + |\hat{y}_t| + \epsilon}$
- **Forecast Bias:** $\frac{\sum (\hat{y}_t - y_t)}{\sum y_t}$ (positive = overforecasting, negative = underforecasting)
- **Prediction Interval Coverage:** $\frac{1}{n}\sum \mathbb{I}(\hat{y}_t^{\text{lower}} \le y_t \le \hat{y}_t^{\text{upper}})$

---

## 4. Quick Start & Setup Instructions

### Prerequisites
- Python 3.11, 3.12, 3.13, or 3.14.

### 1. Installation
Clone or open the project folder:
```bash
cd stocksense
```

Install the pinned dependencies:
```bash
pip install -r requirements.txt
```

### 2. Database Initialization & Seeding
Initialize the SQLite database and seed the deterministic demonstration dataset:
```bash
# Initialize database tables
python run.py init-db

# Seed 10 realistic retail products, 3 suppliers, and 180 days of daily sales
python scripts/seed_demo.py
```

### 3. Start the Server
```bash
# Option A: Windows 1-Click Launcher
launch.bat

# Option B: Python Command Line
python run.py
```
Open your browser at **[http://127.0.0.1:5000](http://127.0.0.1:5000)**.

### Demo User Accounts & Role Permissions
| Role | Email | Password | Access Level & Permissions |
|---|---|---|---|
| **Store Owner (Admin)** | `admin@stocksense.local` | `AdminPass2026!` | Superuser: Store settings, database reset, user governance, audit trail, purchase order approvals. |
| **Inventory & Purchasing Manager** | `demo@stocksense.local` | `StockSenseDemo2026!` | Operational: Catalogue management, supplier terms, safety stock calibration, draft PO creation, stock receipts. |
| **Sales & Demand Analyst** | `staff@stocksense.local` | `StaffPass2026!` | Analytics: Demand forecasting engine, model visualisations, backtest diagnostics (MAE/WAPE), CSV sales ingestion. |

*Quick Development Login:* On the login page, click any of the **1-Click Role Direct Sign-In** cards for instant access to the tailored role experience.

---

## 5. Automated Test Suite Execution

Run the complete test suite:
```bash
pytest
```

All 32 automated tests pass with 0 failures:
- Unit tests: demand aggregation, lag features, rolling windows, zero-denominator safety, safety stock, reorder point formulas.
- Integration tests: user auth, role-based access control, CSV import buffer, PO receipt ledger transitions.
- ML correctness tests: strictly past features, zero data leakage, chronological backtesting, non-negative bounds.
- AI Copilot tests: tool invocation, executive health digest, and explainable reorder narratives.
