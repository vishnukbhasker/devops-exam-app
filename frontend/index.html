from flask import Flask, render_template, request, redirect, url_for, session, make_response
import random
import mysql.connector
from questions import questions
import os
from io import BytesIO
from datetime import datetime
from xhtml2pdf import pisa
from flask import render_template_string

app = Flask(__name__)
app.secret_key = os.getenv('FLASK_SECRET_KEY', 'devops-exam-secret-key')


# Helper: Connect to MySQL
def get_db_connection():
    try:
        return mysql.connector.connect(
            host=os.getenv('MYSQL_HOST', 'mysql'),
            user=os.getenv('MYSQL_USER', 'root'),
            password=os.getenv('MYSQL_PASSWORD', 'rootpass'),
            database=os.getenv('MYSQL_DATABASE', 'devops_exam')
        )
    except Exception as e:
        app.logger.error(f"Database connection failed: {e}")
        return None


# Helper: Load certificate template
def read_certificate_template():
    cert_path = os.path.join(os.path.dirname(__file__), 'certificate.html')
    if not os.path.exists(cert_path):
        app.logger.warning("certificate.html not found. Using fallback.")
        return "<h1>Certificate for {{ name }}</h1><p>Score: {{ score }}</p><p>Date: {{ date }}</p>"
    with open(cert_path, 'r') as file:
        return file.read()


@app.route('/')
def index():
    try:
        return render_template('index.html')
    except Exception as e:
        app.logger.error(f"Template rendering failed: {e}")
        return f"<h2>Error: Template 'index.html' not found.</h2><p>{e}</p>", 500


@app.route('/start', methods=['POST'])
def start_exam():
    session['name'] = request.form['name']
    session['score'] = 0
    session['current'] = 0
    random.shuffle(questions)
    session['questions'] = questions[:5]  # Limit to 5 questions
    return redirect(url_for('question'))


@app.route('/question')
def question():
    if session.get('current') >= len(session['questions']):
        return redirect(url_for('result'))

    q = session['questions'][session['current']]
    return render_template_string("""
        <h2>Question {{ num }}</h2>
        <form method="POST" action="{{ url_for('answer') }}">
            <p>{{ q['question'] }}</p>
            {% for option in q['options'] %}
                <input type="radio" name="answer" value="{{ option }}" required> {{ option }}<br>
            {% endfor %}
            <button type="submit">Submit</button>
        </form>
    """, q=q, num=session['current'] + 1)


@app.route('/answer', methods=['POST'])
def answer():
    q = session['questions'][session['current']]
    if request.form['answer'] == q['answer']:
        session['score'] += 1
    session['current'] += 1
    return redirect(url_for('question'))


@app.route('/result')
def result():
    name = session.get('name', 'User')
    score = session.get('score', 0)
    cert_template = read_certificate_template()
    cert_html = render_template_string(cert_template, name=name, score=score, date=datetime.now().strftime("%Y-%m-%d"))

    pdf = BytesIO()
    pisa_status = pisa.CreatePDF(cert_html, dest=pdf)
    if pisa_status.err:
        return "<h2>Failed to generate certificate</h2>"

    response = make_response(pdf.getvalue())
    response.headers['Content-Type'] = 'application/pdf'
    response.headers['Content-Disposition'] = f'attachment; filename=certificate_{name}.pdf'
    return response


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
