@echo off
title StockSense - Small-Retail Reorder Planner
echo ===================================================
echo Starting StockSense Offline Platform...
echo ===================================================

cd /d "%~dp0"

echo [1/3] Verifying Python environment...
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python is not installed or not in PATH.
    echo Please install Python 3.11+ from https://www.python.org/
    pause
    exit /b 1
)

echo [2/3] Checking dependencies...
python -c "import flask, pandas, numpy, sklearn, sqlalchemy" >nul 2>&1
if errorlevel 1 (
    echo Installing dependencies from requirements.txt...
    python -m pip install -r requirements.txt
)

echo [3/3] Checking local database...
if not exist "instance\stocksense.db" (
    echo Seeding demonstration database...
    python scripts\seed_demo.py
)

echo.
echo ===================================================
echo StockSense server is launching at:
echo http://localhost:5000
echo.
echo Demo User: demo@stocksense.local
echo Password:  StockSenseDemo2026!
echo ===================================================
echo.

start http://localhost:5000
python run.py
pause
