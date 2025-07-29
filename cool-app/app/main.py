from flask import Flask, render_template, redirect, url_for, session
from auth import auth_bp
import os

app = Flask(__name__)
app.secret_key = os.environ.get('SECRET_KEY', 'supersecret')
app.register_blueprint(auth_bp)

@app.route('/')
def home():
    return render_template('index.html', user=session.get("user"))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
