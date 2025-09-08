from flask import Flask, jsonify, request
from sqlalchemy import create_engine, text

import os

DB_HOST = os.getenv("DB_HOST", "db")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME", "microapp")
DB_USER = os.getenv("DB_USER", "microuser")
DB_PASSWORD = os.getenv("DB_PASSWORD", "micropass")

DATABASE_URL = f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

app = Flask(__name__)

engine = create_engine(DATABASE_URL, pool_pre_ping=True)

def init_db():
    with engine.begin() as conn:
        conn.execute(text("""
            CREATE TABLE IF NOT EXISTS todos (
                id SERIAL PRIMARY KEY,
                title TEXT NOT NULL,
                created_at TIMESTAMPTZ DEFAULT NOW()
            )
        """))

@app.before_request
def ensure_db():
    init_db()

@app.get("/api/health")
def health():
    return jsonify({"status": "ok"}), 200

@app.get("/api/todos")
def list_todos():
    with engine.begin() as conn:
        rows = conn.execute(text("SELECT id, title, created_at FROM todos ORDER BY id DESC")).mappings().all()
        return jsonify([dict(r) for r in rows]), 200

@app.post("/api/todos")
def create_todo():
    data = request.get_json(silent=True) or {}
    title = (data.get("title") or "").strip()
    if not title:
        return jsonify({"error": "title is required"}), 400
    with engine.begin() as conn:
        row = conn.execute(text("INSERT INTO todos (title) VALUES (:t) RETURNING id, title, created_at"), {"t": title}).mappings().first()
        return jsonify(dict(row)), 201

@app.delete("/api/todos/<int:todo_id>")
def delete_todo(todo_id):
    with engine.begin() as conn:
        res = conn.execute(text("DELETE FROM todos WHERE id=:i RETURNING id"), {"i": todo_id}).rowcount
        if res == 0:
            return jsonify({"error": "not found"}), 404
        return jsonify({"ok": True}), 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)