# Dockerfile
# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install Poetry and project dependencies
RUN pip install poetry && poetry install --no-dev

# Copy the service account key file into the container
# COPY enhanced-cable-424409-b7-d1d5573121bf.json /app/enhanced-cable-424409-b7-d1d5573121bf.json

# Set environment variable for Google Cloud credentials
ENV GOOGLE_APPLICATION_CREDENTIALS="/app/enhanced-cable-424409-b7-d1d5573121bf.json"

# Expose port 8002 for FastAPI to the outside world
EXPOSE 8002

# # Expose port 8080 for Airflow webserver
# EXPOSE 8080

# Command to run FastAPI with Uvicorn when the container starts
CMD ["poetry", "run", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8002"]
# CMD ["bash", "-c", "poetry run uvicorn app.main:app --host 0.0.0.0 --port 8002 & airflow webserver & airflow scheduler"]


# create a service account and upload the json to the container
# docker build -t 920dd3ce4227 .
# docker run -d -p 8002:8002 fastapi-app


#docker build -t airflow_fastapi_image .
#docker run -p 8002:8002 -p 8080:8080 airflow_fastapi_image
