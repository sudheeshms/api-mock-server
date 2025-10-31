# Free Link API - Testing Guide

## Overview

This guide provides comprehensive testing scenarios for the **RAFL Free Link API** (`POST /freelink/v1`). The mock server includes all success and error scenarios based on the actual API implementation.

## Base URL

```
Local:   http://localhost:5000
Network: http://10.196.172.16:5000
```

## API Specification

### Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `affiliate_id` | string | Yes | Affiliate ID in format: `{hex}.{hex}.{hex}` |
| `af_id` | integer | Yes | Affiliate user ID |
| `url` | string | Yes | Target URL to create affiliate link for |
| `key` | string | Yes | API authentication key |
| `pb_id` | string | No | Publisher ID (alphanumeric) |
| `shop_id` | string | No | Shop ID (overrides URL parsing) |

### Success Response Format

```json
{
  "status": "Success",
  "affiliate_link": "https://hb.afl.rakuten.co.jp/..."
}
```

### Error Response Format

```json
{
  "status": "Error",
  "code": 1001,
  "description": "Error message"
}
```

---

## Test Scenarios

## 🟢 SUCCESS SCENARIOS

### 1. Item URL - Without pb_id

**Endpoint:** `POST /freelink/v1/success/item`

**Description:** Create affiliate link for a regular Rakuten item URL

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/success/item \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 123456,
    "url": "https://item.rakuten.co.jp/irisplaza-r/310999-cp/",
    "key": "test_api_key_12345"
  }'
```

**Expected Response:**
```json
{
  "status": "Success",
  "affiliate_link": "https://hb.afl.rakuten.co.jp/ichiba/g00ufupf.a861qbea.g00ufupf.a861r0ce/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Firisplaza-r%2F310999-cp%2F&link_type=hybrid_url&rafcid=wsc_u_fl_c2FtcGxlX2NsaWVudA%3D%3D"
}
```

---

### 2. Item URL - With pb_id

**Endpoint:** `POST /freelink/v1/success/item-with-pbid`

**Description:** Create affiliate link with publisher ID tracking

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/success/item-with-pbid \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 123456,
    "url": "https://item.rakuten.co.jp/irisplaza-r/310999-cp/",
    "key": "test_api_key_12345",
    "pb_id": "test_pb_id"
  }'
```

**Expected Response:**
```json
{
  "status": "Success",
  "affiliate_link": "https://hb.afl.rakuten.co.jp/ichiba/g00ufupf.a861qbea.g00ufupf.a861r0ce/test_pb_id?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Firisplaza-r%2F310999-cp%2F&link_type=hybrid_url&rafcid=wsc_u_fl_c2FtcGxlX2NsaWVudA%3D%3D"
}
```

---

### 3. Shop URL

**Endpoint:** `POST /freelink/v1/success/shop`

**Description:** Create affiliate link for a shop page

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/success/shop \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 123456,
    "url": "https://www.rakuten.co.jp/sampleshop/",
    "key": "test_api_key_12345"
  }'
```

**Expected Response:**
```json
{
  "status": "Success",
  "affiliate_link": "https://hb.afl.rakuten.co.jp/ichiba/g00ufupf.a861qbea.g00ufupf.a861r0ce/https%3A%2F%2Fwww.rakuten.co.jp%2Fsampleshop%2F&link_type=hybrid_url&rafcid=wsc_u_fl_c2FtcGxlX2NsaWVudA%3D%3D"
}
```

---

### 4. Deeplink (210 prefix shop)

**Endpoint:** `POST /freelink/v1/success/deeplink`

**Description:** Create deeplink for shops starting with 210 prefix

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/success/deeplink \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 123456,
    "url": "https://item.rakuten.co.jp/210/sample-item/",
    "key": "test_api_key_12345"
  }'
```

**Expected Response:**
```json
{
  "status": "Success",
  "affiliate_link": "https://rpx.a8.net/svt/ejp?a8mat=3N9XYZ+ABCDEF+GHI+JKLMN&rakuten_url=https%3A%2F%2Fitem.rakuten.co.jp%2F210%2Fsample-item%2F&link_type=hybrid_url&rafcid=wsc_u_fl_c2FtcGxlX2NsaWVudA%3D%3D"
}
```

---

## 🔴 ERROR SCENARIOS

### 1. Key Missing (Code: 1001)

**Endpoint:** `POST /freelink/v1/error/key-missing`

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/error/key-missing \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 123456,
    "url": "https://item.rakuten.co.jp/shop/item/"
  }'
```

**Response:** `400 Bad Request`
```json
{
  "status": "Error",
  "code": 1001,
  "description": "key is not included in the request"
}
```

---

### 2. Key Invalid (Code: 1010)

**Endpoint:** `POST /freelink/v1/error/key-invalid`

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/error/key-invalid \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 123456,
    "url": "https://item.rakuten.co.jp/shop/item/",
    "key": "invalid_key_12345"
  }'
```

**Response:** `400 Bad Request`

---

### 3. Affiliate ID Missing (Code: 1001)

**Endpoint:** `POST /freelink/v1/error/affiliate-id-missing`

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/error/affiliate-id-missing \
  -H "Content-Type: application/json" \
  -d '{
    "af_id": 123456,
    "url": "https://item.rakuten.co.jp/shop/item/",
    "key": "test_api_key_12345"
  }'
```

---

### 4. Affiliate ID Format Error (Code: 1008)

**Endpoint:** `POST /freelink/v1/error/affiliate-id-format`

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/error/affiliate-id-format \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "invalid_format",
    "af_id": 123456,
    "url": "https://item.rakuten.co.jp/shop/item/",
    "key": "test_api_key_12345"
  }'
```

---

### 5. Affiliate ID Discrepancy (Code: 1008)

**Endpoint:** `POST /freelink/v1/error/affiliate-id-discrepancy`

**Description:** affiliate_id and af_id don't match

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/error/affiliate-id-discrepancy \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 999999,
    "url": "https://item.rakuten.co.jp/shop/item/",
    "key": "test_api_key_12345"
  }'
```

---

### 6. AF ID Missing (Code: 1001)

**Endpoint:** `POST /freelink/v1/error/afid-missing`

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/error/afid-missing \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "url": "https://item.rakuten.co.jp/shop/item/",
    "key": "test_api_key_12345"
  }'
```

---

### 7. AF ID Does Not Exist (Code: 1007)

**Endpoint:** `POST /freelink/v1/error/afid-not-exist`

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/error/afid-not-exist \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 999999,
    "url": "https://item.rakuten.co.jp/shop/item/",
    "key": "test_api_key_12345"
  }'
```

---

### 8. AF ID Status Not OK (Code: 1007)

**Endpoint:** `POST /freelink/v1/error/afid-status`

**Description:** Affiliate ID is registered but status is not "ok"

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/error/afid-status \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 123456,
    "url": "https://item.rakuten.co.jp/shop/item/",
    "key": "test_api_key_12345"
  }'
```

---

### 9. AF ID Blacklisted (Code: 1006)

**Endpoint:** `POST /freelink/v1/error/afid-blacklisted`

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/error/afid-blacklisted \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 666666,
    "url": "https://item.rakuten.co.jp/shop/item/",
    "key": "test_api_key_12345"
  }'
```

---

### 10. URL Missing (Code: 1001)

**Endpoint:** `POST /freelink/v1/error/url-missing`

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/error/url-missing \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 123456,
    "key": "test_api_key_12345"
  }'
```

---

### 11. URL Format Error (Code: 1003)

**Endpoint:** `POST /freelink/v1/error/url-format`

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/error/url-format \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 123456,
    "url": "not-a-valid-url",
    "key": "test_api_key_12345"
  }'
```

---

### 12. URL Denied (Code: 1002)

**Endpoint:** `POST /freelink/v1/error/url-denied`

**Description:** URL is in the denied/blocked list

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/error/url-denied \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 123456,
    "url": "https://mobile.rakuten.co.jp/blocked-url/",
    "key": "test_api_key_12345"
  }'
```

---

### 13. PB ID Format Error (Code: 1005)

**Endpoint:** `POST /freelink/v1/error/pbid-format`

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/error/pbid-format \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 123456,
    "url": "https://item.rakuten.co.jp/shop/item/",
    "key": "test_api_key_12345",
    "pb_id": "invalid@pbid!"
  }'
```

---

### 14. Shop ID Does Not Exist (Code: 1009)

**Endpoint:** `POST /freelink/v1/error/shop-not-exist`

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/error/shop-not-exist \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 123456,
    "url": "https://item.rakuten.co.jp/shop/item/",
    "key": "test_api_key_12345",
    "shop_id": "999999"
  }'
```

---

### 15. System Error (Code: 5002)

**Endpoint:** `POST /freelink/v1/error/system`

**Description:** Internal server error

**cURL Example:**
```bash
curl -X POST http://localhost:5000/freelink/v1/error/system \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 123456,
    "url": "https://item.rakuten.co.jp/shop/item/",
    "key": "test_api_key_12345"
  }'
```

**Response:** `500 Internal Server Error`

---

## Error Code Reference

| Code | Description |
|------|-------------|
| 1001 | Required parameter missing |
| 1002 | URL is wrong (denied/blocked) |
| 1003 | URL format error |
| 1005 | pb_id format error |
| 1006 | af_id is blacklisted |
| 1007 | af_id does not exist or status not ok |
| 1008 | affiliate_id format error or discrepancy |
| 1009 | shop_id does not exist |
| 1010 | Key authentication error |
| 5002 | System/Other error |

---

## Quick Test Script

Save this as `test_freelink_api.sh`:

```bash
#!/bin/bash

BASE_URL="http://localhost:5000"

echo "Testing Free Link API Endpoints..."
echo ""

# Test Success Scenarios
echo "✅ Testing Success: Item URL"
curl -s -X POST $BASE_URL/freelink/v1/success/item \
  -H "Content-Type: application/json" \
  -d '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","af_id":123456,"url":"https://item.rakuten.co.jp/shop/item/","key":"test_key"}' \
  | python3 -m json.tool
echo ""

# Test Error Scenarios
echo "❌ Testing Error: Key Missing"
curl -s -X POST $BASE_URL/freelink/v1/error/key-missing \
  -H "Content-Type: application/json" \
  -d '{"affiliate_id":"g00ufupf.a861qbea.g00ufupf.a861r0ce","af_id":123456,"url":"https://item.rakuten.co.jp/shop/item/"}' \
  | python3 -m json.tool
echo ""

echo "Test complete!"
```

Run it:
```bash
chmod +x test_freelink_api.sh
./test_freelink_api.sh
```

---

## Notes

1. **All endpoints use POST method** - Free Link API only accepts POST requests
2. **Content-Type must be application/json**
3. **Status codes**: 200 for success, 400 for validation errors, 500 for system errors
4. **The mock responses match the actual API structure** based on the implementation in `freeLink.php`

## Getting Your Server IP

To share with external clients:

```bash
# Run this in your terminal
./get_ip.sh
```

Then share: `http://<YOUR_IP>:5000/freelink/v1/success/item`




