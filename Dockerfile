# --- Stage 1: Build ---
# Use a specific Python version
FROM python:3.9-slim as builder
# Set working directory
WORKDIR /app
# Set environment variables to prevent Python from writing pyc files and buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
# Install OS-level dependencies if needed (e.g., for psycopg2 build from source - binary avoids this)
# RUN apt-get update && apt-get install -y --no-install-recommends build-essential libpq-dev
# Install Python dependencies
# Copy only requirements first to leverage Docker cache
COPY requirements.txt .
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r requirements.txt

# --- Stage 2: Final ---
FROM python:3.9-slim
WORKDIR /app
# Set environment variables like before
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
# Install OS dependencies needed at runtime (e.g., libpq for psycopg2-binary)
RUN apt-get update && apt-get install -y --no-install-recommends libpq5 && rm -rf /var/lib/apt/lists/*
# Copy installed dependencies from builder stage
COPY --from=builder /app/wheels /wheels
COPY --from=builder /app/requirements.txt .
RUN pip install --no-cache /wheels/*
# Copy project code into the container
COPY . .
# Run collectstatic to gather static files into STATIC_ROOT
# This needs to happen *after* code is copied and dependencies are installed
RUN python manage.py collectstatic --noinput
# Make entrypoint script executable
RUN chmod +x entrypoint.sh
# Expose the port Gunicorn will run on
EXPOSE 8000
# Use the entrypoint script to run migrations before starting the server
CMD ["./entrypoint.sh"]