#!/bin/bash

# Script to get your local IP address for sharing with clients

echo "=================================================="
echo "🌐 Your Network IP Addresses"
echo "=================================================="
echo ""

# Get WiFi IP (en0)
WIFI_IP=$(ipconfig getifaddr en0 2>/dev/null)
if [ ! -z "$WIFI_IP" ]; then
    echo "📶 WiFi (en0): $WIFI_IP"
    echo "   Share with client: http://$WIFI_IP:5000"
    echo ""
fi

# Get Ethernet IP (en1)
ETH_IP=$(ipconfig getifaddr en1 2>/dev/null)
if [ ! -z "$ETH_IP" ]; then
    echo "🔌 Ethernet (en1): $ETH_IP"
    echo "   Share with client: http://$ETH_IP:5000"
    echo ""
fi

# If neither found, show all IPs
if [ -z "$WIFI_IP" ] && [ -z "$ETH_IP" ]; then
    echo "🔍 All network interfaces:"
    ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print "   " $2}'
    echo ""
fi

echo "📝 Useful endpoints for client:"
echo "   /health     - Health check"
echo "   /endpoints  - List all available endpoints"
echo ""
echo "=================================================="

