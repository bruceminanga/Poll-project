#!/bin/sh

echo "Making migrations..."
python manage.py makemigrations polls

echo "Applying migrations..."
python manage.py migrate

echo "Starting server..."
gunicorn poll_project.wsgi:application --bind 0.0.0.0:8000