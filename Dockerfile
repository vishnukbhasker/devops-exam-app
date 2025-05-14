FROM python:3.9-slim

WORKDIR /app

# Copy backend app files
COPY backend/ /app/

# Copy frontend HTML templates
COPY frontend/ /app/templates
COPY frontend/admin.html /app/templates
COPY frontend/exam.html /app/templates
COPY frontend/result.html /app/templates
# Copy and install dependencies
COPY backend/requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

# Run the Flask app
CMD ["flask", "run", "--host=0.0.0.0", "--port=5000"]
