#!/bin/bash

echo "Running Flask application in the local system..."

# Create virtual environment only if it doesn't exist
if [ ! -d "flask" ]; then
    echo "Creating Python3 virtual environment..."
    python3 -m venv flask
fi

# Activate virtual environment
echo "Activating venv..."
source flask/bin/activate

# Install Flask inside the venv
echo "Installing Flask..."
pip install --upgrade pip
pip install flask

# Ensure log file exists and is writable
sudo touch /var/log/flask-app.log
sudo chmod 666 /var/log/flask-app.log

# Start Flask app in background, redirect logs
echo "Starting Flask app in background..."
python flask/app.py >> /var/log/flask-app.log 2>&1 &

# Tail the log file
echo "Tailing the Flask app log..."
tail -f /var/log/flask-app.log