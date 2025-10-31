#!/bin/bash

# Quick test script to verify the server is working

echo "🧪 Testing API Mock Server..."
echo ""

# Test health endpoint
echo "Testing /health endpoint..."
curl -s http://localhost:5000/health | python3 -m json.tool
echo ""

# Test endpoints list
echo "Testing /endpoints endpoint..."
curl -s http://localhost:5000/endpoints | python3 -m json.tool
echo ""

# Test sample user endpoint
echo "Testing /api/v1/users endpoint..."
curl -s http://localhost:5000/api/v1/users | python3 -m json.tool
echo ""

echo "✅ All tests completed!"




