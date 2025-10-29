# API Mock Server - Quick Reference

## 🚀 Quick Start

```bash
# First time setup
./setup.sh

# Start the server
./run.sh

# Get your IP to share with client
./get_ip.sh

# Test the server (in another terminal)
./test_server.sh
```

## 🔗 Your Server URLs

**Local access:**
```
http://localhost:5000
```

**Network access (share with client):**
```
http://10.196.172.16:5000
```

## 📋 Built-in Endpoints

- `GET /health` - Health check
- `GET /endpoints` - List all configured endpoints

## ➕ Adding New Endpoints

### Step 1: Create JSON response file

`responses/my_endpoint.json`:
```json
{
  "status": "success",
  "data": { "your": "data" }
}
```

### Step 2: Configure endpoint

`config.yaml`:
```yaml
endpoints:
  /api/v1/my-endpoint:
    methods: ['GET']
    description: "My endpoint"
    response_file: "my_endpoint.json"
    status_code: 200
```

### Step 3: Restart server

Press `Ctrl+C` and run `./run.sh` again.

## 🧪 Testing Examples

```bash
# Health check
curl http://localhost:5000/health

# List endpoints
curl http://localhost:5000/endpoints

# Test your endpoint
curl http://localhost:5000/api/v1/users

# POST request
curl -X POST http://localhost:5000/api/v1/products \
  -H "Content-Type: application/json" \
  -d '{"name": "Test"}'
```

## 🎯 Advanced Features

### Multiple HTTP methods with different responses

```yaml
/api/v1/resource:
  methods: ['GET', 'POST', 'DELETE']
  responses:
    GET: "resource_list.json"
    POST: "resource_created.json"
    DELETE: "resource_deleted.json"
```

### Simulate slow responses

```yaml
/api/v1/slow:
  methods: ['GET']
  response_file: "data.json"
  delay: 2  # seconds
```

### Custom status codes

```yaml
/api/v1/not-found:
  methods: ['GET']
  response_file: "404.json"
  status_code: 404
```

## 🐛 Troubleshooting

**Client can't connect:**
- Ensure you're on the same network
- Check firewall isn't blocking port 5000
- Verify you shared the correct IP

**Endpoint returns 404:**
- Check path in `config.yaml` (must start with `/`)
- Visit `/endpoints` to see configured endpoints
- Restart server after config changes

**Response file not found:**
- Ensure file is in `responses/` directory
- Check filename matches exactly (case-sensitive)
- Validate JSON syntax

## 📁 Project Structure

```
api-mock-server/
├── app.py              # Main server
├── config.yaml         # Endpoint configuration
├── responses/          # JSON responses
├── setup.sh           # Setup script
├── run.sh             # Run script
├── get_ip.sh          # Get IP helper
└── test_server.sh     # Test script
```

## 🎓 Tips for Client Testing

1. **Share the IP**: Run `./get_ip.sh` and share the URL
2. **Share endpoints**: Point client to `/endpoints` for API discovery
3. **Provide realistic data**: Use actual API response structure
4. **Test error cases**: Create endpoints for error scenarios
5. **Document changes**: Update `config.yaml` comments
6. **Version responses**: Name files like `users_v1.json`, `users_v2.json`

## 💡 Common Use Cases

### Replicate your staging API

1. Export staging responses: `curl https://stage.example.com/api/users > responses/users.json`
2. Add to `config.yaml` with same path
3. Client uses your mock server with exact same responses

### Test different scenarios

Create multiple response files:
- `users_success.json`
- `users_empty.json`
- `users_error.json`

Switch between them by editing `config.yaml`.

### Simulate pagination

```yaml
/api/v1/users:
  methods: ['GET']
  response_file: "users_page1.json"

/api/v1/users?page=2:
  methods: ['GET']
  response_file: "users_page2.json"
```

---

**Need help?** Check the full README.md for detailed documentation.

