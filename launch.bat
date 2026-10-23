@echo off
title StockSense AI -- Small-Retail Reorder Planner
echo =========================================================================
echo       STOCKSENSE AI -- SMALL-RETAIL DEMAND FORECASTING PLATFORM
echo                           Problem Statement: PS11
echo =========================================================================
echo.
echo [1/3] Checking Python environment...
python --version
if errorlevel 1 (
    echo [ERROR] Python is not installed or not in PATH!
    pause
    exit /b 1
)

echo.
echo [2/3] Seeding demo retail database (Deterministic dataset, seed=42)...
python scripts\seed_demo.py
if errorlevel 1 (
    echo [WARNING] Seed script completed with warnings or DB already present.
)

echo.
echo [3/3] Launching StockSense AI Full-Stack Server...
echo.
echo   * Web Dashboard UI:  http://127.0.0.1:5000/
echo   * React SaaS UI:     http://127.0.0.1:5000/app/
echo   * REST API v1:       http://127.0.0.1:5000/api/v1/
echo   * Currency:          Indian Rupee (INR / Rs.)
echo.
echo Press Ctrl+C in this terminal window to stop the server.
echo =========================================================================
python run.py
pause
