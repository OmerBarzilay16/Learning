from flask import Flask, jsonify
import psycopg2
import os

app = Flask(__name__)

# Database connection details from environment variables (good for Docker later)
DB_HOST = os.environ.get("DB_HOST", "localhost")
DB_NAME = os.environ.get("DB_NAME", "mydatabase")
DB_USER = os.environ.get("DB_USER", "postgres")
DB_PASSWORD = os.environ.get("DB_PASSWORD", "password")

@app.route('/')
def get_data():
    try:
        # Connect to PostgreSQL
        conn = psycopg2.connect(
            host=DB_HOST,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )
        cursor = conn.cursor()
        cursor.execute('SELECT * FROM mytable;')  # Replace "mytable" with your actual table
        rows = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(rows)
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
