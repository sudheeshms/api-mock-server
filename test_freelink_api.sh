#!/bin/bash

# Free Link API - Comprehensive Test Script
# Tests all success and error scenarios

BASE_URL="${1:-http://localhost:5000}"

echo "=================================================="
echo "🧪 Free Link API - Testing All Scenarios"
echo "=================================================="
echo "Base URL: $BASE_URL"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counter
SUCCESS_COUNT=0
ERROR_COUNT=0
TOTAL_TESTS=0

# Function to test endpoint
test_endpoint() {
    local name=$1
    local endpoint=$2
    local payload=$3
    local expected_status=$4
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    echo -e "${YELLOW}Test #$TOTAL_TESTS: $name${NC}"
    
    response=$(curl -s -w "\n%{http_code}" -X POST "$BASE_URL$endpoint" \
        -H "Content-Type: application/json" \
        -d "$payload")
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" = "$expected_status" ]; then
        echo -e "${GREEN}✓ PASS${NC} (HTTP $http_code)"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
        echo -e "${RED}✗ FAIL${NC} (Expected: $expected_status, Got: $http_code)"
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi
    
    echo "$body" | python3 -m json.tool 2>/dev/null || echo "$body"
    echo ""
}

echo "=================================================="
echo "🟢 SUCCESS SCENARIOS"
echo "=================================================="
echo ""

# Success Test 1: Item URL without pb_id
test_endpoint \
    "Success: Item URL" \
    "/freelink/v1/success/item" \
    '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","af_id":123456,"url":"https://item.rakuten.co.jp/shop/item/","key":"test_key"}' \
    "200"

# Success Test 2: Item URL with pb_id
test_endpoint \
    "Success: Item URL with pb_id" \
    "/freelink/v1/success/item-with-pbid" \
    '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","af_id":123456,"url":"https://item.rakuten.co.jp/shop/item/","key":"test_key","pb_id":"test_pb"}' \
    "200"

# Success Test 3: Shop URL
test_endpoint \
    "Success: Shop URL" \
    "/freelink/v1/success/shop" \
    '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","af_id":123456,"url":"https://www.rakuten.co.jp/shop/","key":"test_key"}' \
    "200"

# Success Test 4: Deeplink
test_endpoint \
    "Success: Deeplink (210 prefix)" \
    "/freelink/v1/success/deeplink" \
    '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","af_id":123456,"url":"https://item.rakuten.co.jp/210/item/","key":"test_key"}' \
    "200"

echo "=================================================="
echo "🔴 ERROR SCENARIOS"
echo "=================================================="
echo ""

# Error Test 1: Key missing
test_endpoint \
    "Error: Key missing (1001)" \
    "/freelink/v1/error/key-missing" \
    '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","af_id":123456,"url":"https://item.rakuten.co.jp/shop/item/"}' \
    "400"

# Error Test 2: Key invalid
test_endpoint \
    "Error: Key invalid (1010)" \
    "/freelink/v1/error/key-invalid" \
    '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","af_id":123456,"url":"https://item.rakuten.co.jp/shop/item/","key":"invalid"}' \
    "400"

# Error Test 3: Affiliate ID missing
test_endpoint \
    "Error: Affiliate ID missing (1001)" \
    "/freelink/v1/error/affiliate-id-missing" \
    '{"af_id":123456,"url":"https://item.rakuten.co.jp/shop/item/","key":"test_key"}' \
    "400"

# Error Test 4: Affiliate ID format
test_endpoint \
    "Error: Affiliate ID format (1008)" \
    "/freelink/v1/error/affiliate-id-format" \
    '{"affiliate_id":"invalid","af_id":123456,"url":"https://item.rakuten.co.jp/shop/item/","key":"test_key"}' \
    "400"

# Error Test 5: Affiliate ID discrepancy
test_endpoint \
    "Error: Affiliate ID discrepancy (1008)" \
    "/freelink/v1/error/affiliate-id-discrepancy" \
    '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","af_id":999999,"url":"https://item.rakuten.co.jp/shop/item/","key":"test_key"}' \
    "400"

# Error Test 6: AF ID missing
test_endpoint \
    "Error: AF ID missing (1001)" \
    "/freelink/v1/error/afid-missing" \
    '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","url":"https://item.rakuten.co.jp/shop/item/","key":"test_key"}' \
    "400"

# Error Test 7: AF ID not exist
test_endpoint \
    "Error: AF ID not exist (1007)" \
    "/freelink/v1/error/afid-not-exist" \
    '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","af_id":999999,"url":"https://item.rakuten.co.jp/shop/item/","key":"test_key"}' \
    "400"

# Error Test 8: AF ID status
test_endpoint \
    "Error: AF ID status not ok (1007)" \
    "/freelink/v1/error/afid-status" \
    '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","af_id":123456,"url":"https://item.rakuten.co.jp/shop/item/","key":"test_key"}' \
    "400"

# Error Test 9: AF ID blacklisted
test_endpoint \
    "Error: AF ID blacklisted (1006)" \
    "/freelink/v1/error/afid-blacklisted" \
    '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","af_id":666666,"url":"https://item.rakuten.co.jp/shop/item/","key":"test_key"}' \
    "400"

# Error Test 10: URL missing
test_endpoint \
    "Error: URL missing (1001)" \
    "/freelink/v1/error/url-missing" \
    '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","af_id":123456,"key":"test_key"}' \
    "400"

# Error Test 11: URL format
test_endpoint \
    "Error: URL format (1003)" \
    "/freelink/v1/error/url-format" \
    '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","af_id":123456,"url":"not-a-url","key":"test_key"}' \
    "400"

# Error Test 12: URL denied
test_endpoint \
    "Error: URL denied (1002)" \
    "/freelink/v1/error/url-denied" \
    '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","af_id":123456,"url":"https://blocked.example.com/","key":"test_key"}' \
    "400"

# Error Test 13: PB ID format
test_endpoint \
    "Error: PB ID format (1005)" \
    "/freelink/v1/error/pbid-format" \
    '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","af_id":123456,"url":"https://item.rakuten.co.jp/shop/item/","key":"test_key","pb_id":"invalid@pb"}' \
    "400"

# Error Test 14: Shop not exist
test_endpoint \
    "Error: Shop not exist (1009)" \
    "/freelink/v1/error/shop-not-exist" \
    '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","af_id":123456,"url":"https://item.rakuten.co.jp/shop/item/","key":"test_key","shop_id":"999999"}' \
    "400"

# Error Test 15: System error
test_endpoint \
    "Error: System error (5002)" \
    "/freelink/v1/error/system" \
    '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","af_id":123456,"url":"https://item.rakuten.co.jp/shop/item/","key":"test_key"}' \
    "500"

echo "=================================================="
echo "📊 TEST SUMMARY"
echo "=================================================="
echo -e "Total Tests:    $TOTAL_TESTS"
echo -e "${GREEN}Passed:         $SUCCESS_COUNT${NC}"
echo -e "${RED}Failed:         $ERROR_COUNT${NC}"
echo ""

if [ $ERROR_COUNT -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}✗ Some tests failed${NC}"
    exit 1
fi




