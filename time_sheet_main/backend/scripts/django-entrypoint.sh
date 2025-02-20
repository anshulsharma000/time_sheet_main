#!/bin/sh

# Wait for the database to be ready
echo "Waiting for the database to be ready."
scripts/wait-script.sh db:5432 --timeout=60 -- echo "Database is ready."

# Create staticfiles directory with proper permissions
mkdir -p /home/user/app/backend/staticfiles
chmod -R 777 /home/user/app/backend/staticfiles

echo "Running Migration"
python manage.py migrate

echo "Ensuring required roles exist"
python manage.py ensure_roles

echo "Collecting static files"
python manage.py collectstatic --noinput

echo "Starting Server"
exec gunicorn core.wsgi --log-file - -b 0.0.0.0:8000 --reload --workers 2 --timeout 120 --max-requests 1000 --max-requests-jitter 50
