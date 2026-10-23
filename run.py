import os
from dotenv import load_dotenv

load_dotenv()

from app import create_app
from app.extensions import db
from scripts.seed_demo import seed_demo_store

app = create_app()

@app.cli.command("seed-demo")
def seed_demo_cmd():
    """Seed deterministic sample store and sales."""
    seed_demo_store(app=app, force_reset=True)

@app.cli.command("init-db")
def init_db_cmd():
    """Initialize empty database tables."""
    with app.app_context():
        db.create_all()
        print("[+] StockSense database tables initialized.")

if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port, debug=True)
