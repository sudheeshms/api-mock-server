#!/bin/bash

# API Mock Server - Run Script
# Simple script to activate venv and start the server

set -e

# Check if venv exists
if [ ! -d "venv" ]; then
    echo "❌ Virtual environment not found!"
    echo "Please run: ./setup.sh first"
    exit 1
fi

# Activate venv and run
source venv/bin/activate
python app.py

