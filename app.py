import time
from flask import Flask, render_template, request, redirect, url_for, session
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash
import os

app = Flask(__name__)
app.secret_key = 'your_secret_key'

# Get MySQL environment variables or use defaults this is for docker-compose

mysql_host = os.getenv('MYSQL_HOST', 'mysql')
mysql_user = os.getenv('MYSQL_USER', 'root')
mysql_password = os.getenv('MYSQL_ROOT_PASSWORD', 'password')
mysql_database = os.getenv('MYSQL_DATABASE', 'my_db')
mysql_port = int(os.getenv('MYSQL_PORT', 3306))


# Add a delay to allow MySQL to start
max_attempts = 10
for _ in range(max_attempts):
    try:
        # Create a connection to MySQL server
        db = mysql.connector.connect(
            host=mysql_host,
            user=mysql_user,
            password=mysql_password,
        )
        cursor = db.cursor()

        # Check if the database exists, and create it if not
        cursor.execute("CREATE DATABASE IF NOT EXISTS " + mysql_database)
        db.database = mysql_database

        # Create users table if it doesn't exist
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS users (
                id INT AUTO_INCREMENT PRIMARY KEY,
                username VARCHAR(255) NOT NULL,
                password VARCHAR(255) NOT NULL
            )
        ''')

        break  # Break out of the loop if the connection is successful

    except Exception as e:
        print(f"Failed to connect to MySQL: {e}")
        if _ < max_attempts - 1:
            time.sleep(5)  # Wait for 5 seconds before retrying
        else:
            raise Exception("Failed to connect to MySQL after multiple attempts")

# The rest of your Flask app code remains unchanged

# Prevent caching after logout
@app.after_request
def add_header(response):
    response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, post-check=0, pre-check=0, max-age=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '-1'
    return response

@app.route('/')
def index():
    return redirect(url_for('login'))

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        cursor.execute("SELECT * FROM users WHERE username=%s", (username,))
        user = cursor.fetchone()

        if user is None:
            hashed_password = generate_password_hash(password, method='pbkdf2:sha256')
            cursor.execute("INSERT INTO users (username, password) VALUES (%s, %s)", (username, hashed_password))
            db.commit()
            return redirect(url_for('login'))
        else:
            return "User already exists. <a href='/login'>Login</a>"

    return render_template('signup.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        cursor.execute("SELECT * FROM users WHERE username=%s", (username,))
        user = cursor.fetchone()

        if user is not None and check_password_hash(user[2], password):
            session['username'] = username
            return redirect(url_for('dashboard'))
        else:
            return "Invalid credentials. <a href='/login'>Login</a>"

    return render_template('login.html')

@app.route('/dashboard')
def dashboard():
    if 'username' in session:
        return render_template('dashboard.html', username=session['username'])
    else:
        return redirect(url_for('login'))

@app.route('/logout')
def logout():
    session.pop('username', None)
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

