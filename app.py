#!/usr/bin/env python3
"""
Simple API Mock Server
Serves static JSON responses based on configured endpoints
Perfect for external client testing when stage environment is not accessible
"""

from flask import Flask, jsonify, request, send_from_directory
from flask_cors import CORS
import json
import os
import yaml
from pathlib import Path

app = Flask(__name__)
CORS(app)  # Enable CORS for external access

# Configuration
CONFIG_FILE = 'config.yaml'
RESPONSES_DIR = 'responses'

def load_config():
    """Load endpoint configuration from YAML file"""
    config_path = Path(CONFIG_FILE)
    if not config_path.exists():
        return {}
    
    with open(config_path, 'r') as f:
        return yaml.safe_load(f) or {}

def load_json_response(filename):
    """Load JSON response from file"""
    file_path = Path(RESPONSES_DIR) / filename
    if not file_path.exists():
        return None
    
    with open(file_path, 'r') as f:
        return json.load(f)

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        "status": "healthy",
        "message": "API Mock Server is running"
    })

@app.route('/endpoints', methods=['GET'])
def list_endpoints():
    """List all configured endpoints"""
    config = load_config()
    endpoints = []
    
    for endpoint_path, endpoint_config in config.get('endpoints', {}).items():
        endpoints.append({
            "path": endpoint_path,
            "methods": endpoint_config.get('methods', ['GET']),
            "description": endpoint_config.get('description', ''),
            "response_file": endpoint_config.get('response_file', '')
        })
    
    return jsonify({
        "total": len(endpoints),
        "endpoints": endpoints
    })

@app.route('/<path:path>', methods=['GET', 'POST', 'PUT', 'DELETE', 'PATCH'])
def handle_request(path):
    """Handle all configured endpoint requests"""
    config = load_config()
    endpoints = config.get('endpoints', {})
    
    # Normalize path
    request_path = f"/{path}"
    
    # Check if endpoint is configured
    if request_path not in endpoints:
        return jsonify({
            "error": "Endpoint not configured",
            "path": request_path,
            "message": f"No mock response configured for {request_path}",
            "hint": "Check config.yaml or use /endpoints to see available endpoints"
        }), 404
    
    endpoint_config = endpoints[request_path]
    
    # Check if method is allowed
    allowed_methods = endpoint_config.get('methods', ['GET'])
    if request.method not in allowed_methods:
        return jsonify({
            "error": "Method not allowed",
            "allowed_methods": allowed_methods
        }), 405
    
    # Get response file based on method or use default
    response_mapping = endpoint_config.get('responses', {})
    response_file = response_mapping.get(request.method) or endpoint_config.get('response_file')
    
    if not response_file:
        return jsonify({
            "error": "No response file configured",
            "path": request_path,
            "method": request.method
        }), 500
    
    # Load and return response
    response_data = load_json_response(response_file)
    
    if response_data is None:
        return jsonify({
            "error": "Response file not found",
            "file": response_file,
            "path": f"{RESPONSES_DIR}/{response_file}"
        }), 500
    
    # Get status code (default 200)
    status_code = endpoint_config.get('status_code', 200)
    
    # Optional delay simulation (in seconds)
    delay = endpoint_config.get('delay', 0)
    if delay > 0:
        import time
        time.sleep(delay)
    
    return jsonify(response_data), status_code

@app.errorhandler(404)
def not_found(e):
    return jsonify({
        "error": "Not found",
        "message": "Endpoint not configured",
        "hint": "Use /endpoints to see all available endpoints"
    }), 404

@app.errorhandler(500)
def internal_error(e):
    return jsonify({
        "error": "Internal server error",
        "message": str(e)
    }), 500

if __name__ == '__main__':
    # Create responses directory if it doesn't exist
    Path(RESPONSES_DIR).mkdir(exist_ok=True)
    
    # Print startup information
    print("\n" + "="*60)
    print("🚀 API Mock Server Starting...")
    print("="*60)
    
    config = load_config()
    if config and 'endpoints' in config:
        print(f"\n📋 Loaded {len(config['endpoints'])} endpoint(s):")
        for endpoint in config['endpoints']:
            print(f"   • {endpoint}")
    else:
        print("\n⚠️  No endpoints configured. Please edit config.yaml")
    
    print(f"\n📝 Utility endpoints:")
    print(f"   • GET  /health     - Health check")
    print(f"   • GET  /endpoints  - List all configured endpoints")
    
    print(f"\n🌐 Server will be accessible at:")
    print(f"   • Local:   http://localhost:5000")
    print(f"   • Network: http://<your-ip>:5000")
    print("\n" + "="*60 + "\n")
    
    # Run server
    app.run(
        host='0.0.0.0',  # Accessible from network
        port=5000,
        debug=True
    )

