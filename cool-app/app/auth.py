from flask import Blueprint, render_template, request, redirect, url_for, session
from werkzeug.security import generate_password_hash, check_password_hash
from forms import LoginForm, RegisterForm
import psycopg2
import os

auth_bp = Blueprint('auth', __name__)

def get_db():
    return psycopg2.connect(
        host=os.environ["POSTGRES_HOST"],
        database=os.environ["POSTGRES_DB"],
        user=os.environ["POSTGRES_USER"],
        password=os.environ["POSTGRES_PASSWORD"]
    )

@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        conn = get_db()
        cur = conn.cursor()
        cur.execute("SELECT id, name, password FROM users WHERE email=%s", (form.email.data,))
        user = cur.fetchone()
        cur.close()
        conn.close()
        if user and check_password_hash(user[2], form.password.data):
            session['user'] = {'id': user[0], 'name': user[1]}
            return redirect(url_for('home'))
        else:
            return render_template('login.html', form=form, error="Invalid credentials")
    return render_template('login.html', form=form)

@auth_bp.route('/register', methods=['GET', 'POST'])
def register():
    form = RegisterForm()
    if form.validate_on_submit():
        conn = get_db()
        cur = conn.cursor()
        hashed_pw = generate_password_hash(form.password.data)
        try:
            cur.execute("INSERT INTO users (name, email, password) VALUES (%s, %s, %s)",
                        (form.name.data, form.email.data, hashed_pw))
            conn.commit()
        except Exception as e:
            conn.rollback()
            return render_template('register.html', form=form, error="Email already exists.")
        finally:
            cur.close()
            conn.close()
        return redirect(url_for('auth.login'))
    return render_template('register.html', form=form)

@auth_bp.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('home'))
