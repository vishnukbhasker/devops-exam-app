FROM python:3.9-slim

WORKDIR /app

COPY backend/ /app/
COPY frontend/ /app/templates
COPY backend/requirements.txt /app/requirements.txt

RUN pip install -r requirements.txt

CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
