# API Mock Server

A simple, configurable mock API server for testing external client integrations when stage environments are not accessible.

## Features

- 🚀 Simple setup and configuration
- 📝 YAML-based endpoint configuration
- 🎯 Support for multiple HTTP methods (GET, POST, PUT, DELETE, PATCH)
- 🔄 Different responses for different methods on the same endpoint
- ⏱️ Simulated delay for testing slow responses
- 🌐 Network accessible (clients can access from their machines)
- 🔍 Built-in endpoint discovery (`/endpoints`)
- ❤️ Health check endpoint (`/health`)
- 🎨 CORS enabled for browser testing

## Quick Start

### 1. Run Setup (First Time Only)

```bash
./setup.sh
```

This will create a virtual environment and install all dependencies.

### 2. Run the Server

```bash
./run.sh
```

Or manually:
```bash
source venv/bin/activate
python app.py
```

The server will start on `http://localhost:5000` and will be accessible from your network.

### 3. Find Your Network IP

To share with external clients, find your local IP address:

**macOS/Linux:**
```bash
# Option 1
ifconfig | grep "inet " | grep -v 127.0.0.1

# Option 2
ipconfig getifaddr en0  # For WiFi
```

**Windows:**
```cmd
ipconfig | findstr IPv4
```

Share the URL with your client: `http://<YOUR_IP>:5000`

## Configuration

### Adding New Endpoints

Edit `config.yaml` to add your endpoints:

```yaml
endpoints:
  /your/api/endpoint:
    methods: ['GET', 'POST']
    description: "Your endpoint description"
    response_file: "your_response.json"
    status_code: 200
    delay: 0  # Optional: delay in seconds
```

### Creating Response Files

1. Add JSON files to the `responses/` directory
2. Reference them in `config.yaml`

**Example:**

Create `responses/my_data.json`:
```json
{
  "status": "success",
  "data": {
    "key": "value"
  }
}
```

Add to `config.yaml`:
```yaml
endpoints:
  /api/my-endpoint:
    methods: ['GET']
    response_file: "my_data.json"
```

### Advanced: Method-Specific Responses

Return different responses for different HTTP methods:

```yaml
endpoints:
  /api/resource:
    methods: ['GET', 'POST', 'DELETE']
    description: "Resource with multiple methods"
    responses:
      GET: "resource_list.json"
      POST: "resource_created.json"
      DELETE: "resource_deleted.json"
```

## Built-in Endpoints

- `GET /health` - Health check
- `GET /endpoints` - List all configured endpoints

## Usage Examples

### Using curl

```bash
# Health check
curl http://localhost:5000/health

# List all endpoints
curl http://localhost:5000/endpoints

# Test your endpoint
curl http://localhost:5000/api/v1/users

# POST request
curl -X POST http://localhost:5000/api/v1/products \
  -H "Content-Type: application/json" \
  -d '{"name": "Test Product"}'
```

### Using Browser

Simply visit: `http://localhost:5000/endpoints`

### For External Clients

Share your network IP:
```
http://192.168.1.100:5000/api/v1/users
```

## Tips for External Client Testing

1. **Find Your IP**: Use `ifconfig` or `ipconfig` to find your local IP
2. **Firewall**: Ensure port 5000 is not blocked by your firewall
3. **Same Network**: Client must be on the same network (or use VPN)
4. **Share Documentation**: Use `/endpoints` to share available endpoints
5. **Response Validation**: Provide actual sample data matching your API spec

## Customization

### Change Port

Edit `app.py`:
```python
app.run(host='0.0.0.0', port=8080)  # Change to your preferred port
```

### Add Authentication

Add simple token validation in `app.py`:
```python
@app.before_request
def check_auth():
    token = request.headers.get('Authorization')
    if not token or token != 'Bearer your-test-token':
        return jsonify({"error": "Unauthorized"}), 401
```

### Add Request Logging

The server runs in debug mode, so all requests are logged automatically.

## Project Structure

```
api-mock-server/
├── app.py                 # Main application
├── config.yaml           # Endpoint configuration
├── requirements.txt      # Python dependencies
├── responses/           # JSON response files
│   ├── users_list.json
│   ├── user_detail.json
│   └── ...
└── README.md            # This file
```

## Troubleshooting

### Cannot access from external machine

1. Check firewall settings
2. Ensure server is running with `host='0.0.0.0'`
3. Verify you're using the correct IP address
4. Ensure both machines are on the same network

### Endpoint returns 404

1. Check `config.yaml` - ensure path matches exactly (including leading `/`)
2. Visit `/endpoints` to see all configured endpoints
3. Check server logs for errors

### Response file not found

1. Ensure file exists in `responses/` directory
2. Check filename matches exactly (case-sensitive)
3. Verify JSON syntax is valid

## Security Note

⚠️ This server is for **testing purposes only**. Do not use in production:
- No authentication/authorization
- No input validation
- Debug mode enabled
- Accessible from network

## License

Free to use for testing purposes.

