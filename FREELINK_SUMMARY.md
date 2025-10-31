# Free Link API Mock - Quick Summary

## What Was Created

✅ **18 Mock Response Files** - Comprehensive coverage of all scenarios
✅ **18 Configured Endpoints** - Ready to use in `config.yaml`
✅ **Complete Testing Guide** - `FREELINK_API_TESTING_GUIDE.md`
✅ **Automated Test Script** - `test_freelink_api.sh`

---

## Quick Start

### 1. Start the Mock Server

```bash
cd /Users/sudheesh.ms/Documents/PROJECTS/Personal_Projects/api-mock-server
./run.sh
```

The server will start on `http://localhost:5000`

### 2. Test All Scenarios

```bash
# In a new terminal
./test_freelink_api.sh
```

This will test all 18 endpoints (4 success + 14 error scenarios)

### 3. Share with External Client

```bash
# Get your IP
./get_ip.sh

# Share this URL with client:
# http://10.196.172.16:5000
```

---

## Available Endpoints

### ✅ Success Scenarios (4)

| Endpoint | Description |
|----------|-------------|
| `POST /freelink/v1/success/item` | Item URL without pb_id |
| `POST /freelink/v1/success/item-with-pbid` | Item URL with pb_id |
| `POST /freelink/v1/success/shop` | Shop URL |
| `POST /freelink/v1/success/deeplink` | Deeplink (210 prefix) |

### ❌ Error Scenarios (14)

| Endpoint | Error Code | Description |
|----------|------------|-------------|
| `POST /freelink/v1/error/key-missing` | 1001 | Key missing |
| `POST /freelink/v1/error/key-invalid` | 1010 | Invalid key |
| `POST /freelink/v1/error/affiliate-id-missing` | 1001 | Affiliate ID missing |
| `POST /freelink/v1/error/affiliate-id-format` | 1008 | Invalid affiliate ID format |
| `POST /freelink/v1/error/affiliate-id-discrepancy` | 1008 | ID mismatch |
| `POST /freelink/v1/error/afid-missing` | 1001 | AF ID missing |
| `POST /freelink/v1/error/afid-not-exist` | 1007 | AF ID not found |
| `POST /freelink/v1/error/afid-status` | 1007 | AF ID status not ok |
| `POST /freelink/v1/error/afid-blacklisted` | 1006 | AF ID blacklisted |
| `POST /freelink/v1/error/url-missing` | 1001 | URL missing |
| `POST /freelink/v1/error/url-format` | 1003 | Invalid URL format |
| `POST /freelink/v1/error/url-denied` | 1002 | URL blocked/denied |
| `POST /freelink/v1/error/pbid-format` | 1005 | Invalid pb_id format |
| `POST /freelink/v1/error/shop-not-exist` | 1009 | Shop not found |
| `POST /freelink/v1/error/system` | 5002 | System error (500) |

---

## Example Usage

### Success Request

```bash
curl -X POST http://localhost:5000/freelink/v1/success/item \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 123456,
    "url": "https://item.rakuten.co.jp/shop/item/",
    "key": "test_key"
  }'
```

**Response:**
```json
{
  "status": "Success",
  "affiliate_link": "https://hb.afl.rakuten.co.jp/ichiba/g00ufupf.a861qbea.g00ufupf.a861r0ce/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Firisplaza-r%2F310999-cp%2F&link_type=hybrid_url&rafcid=wsc_u_fl_c2FtcGxlX2NsaWVudA%3D%3D"
}
```

### Error Request

```bash
curl -X POST http://localhost:5000/freelink/v1/error/key-missing \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 123456,
    "url": "https://item.rakuten.co.jp/shop/item/"
  }'
```

**Response:**
```json
{
  "status": "Error",
  "code": 1001,
  "description": "key is not included in the request"
}
```

---

## Files Created

```
api-mock-server/
├── responses/
│   ├── freelink_success_item.json
│   ├── freelink_success_item_with_pbid.json
│   ├── freelink_success_shop.json
│   ├── freelink_success_deeplink.json
│   ├── freelink_error_key_missing.json
│   ├── freelink_error_key_invalid.json
│   ├── freelink_error_affiliate_id_missing.json
│   ├── freelink_error_affiliate_id_format.json
│   ├── freelink_error_affiliate_id_discrepancy.json
│   ├── freelink_error_afid_missing.json
│   ├── freelink_error_afid_not_exist.json
│   ├── freelink_error_afid_status.json
│   ├── freelink_error_afid_blacklisted.json
│   ├── freelink_error_url_missing.json
│   ├── freelink_error_url_format.json
│   ├── freelink_error_url_denied.json
│   ├── freelink_error_pbid_format.json
│   ├── freelink_error_shop_not_exist.json
│   └── freelink_error_system.json
├── config.yaml (updated with 18 endpoints)
├── FREELINK_API_TESTING_GUIDE.md (complete guide)
├── FREELINK_SUMMARY.md (this file)
└── test_freelink_api.sh (test script)
```

---

## For Your Client

Send them:

1. **Server URL**: `http://10.196.172.16:5000`
2. **Endpoint List**: They can see all endpoints at `http://10.196.172.16:5000/endpoints`
3. **Testing Guide**: Share `FREELINK_API_TESTING_GUIDE.md`

### Client Quick Test

```bash
# They can test with:
curl -X POST http://10.196.172.16:5000/freelink/v1/success/item \
  -H "Content-Type: application/json" \
  -d '{
    "affiliate_id": "g00ufupf.a861qbea.g00ufupf.a861r0ce",
    "af_id": 123456,
    "url": "https://item.rakuten.co.jp/shop/item/",
    "key": "test_key"
  }'
```

---

## Coverage

Based on `freeLink.php` implementation:

✅ **Success Response Format** - Matches exactly  
✅ **Error Response Format** - Matches exactly  
✅ **All Error Codes** - Complete coverage (1001-5002)  
✅ **URL Types** - Item, Shop, Generic, Deeplink  
✅ **Optional Parameters** - pb_id, shop_id  
✅ **Status Codes** - 200, 400, 500  

---

## Next Steps

1. ✅ Server is configured and ready
2. ✅ All 18 scenarios are mocked
3. ✅ Test script is available
4. 📤 Share with your client
5. 🧪 Client can test all scenarios

**Documentation Available:**
- `README.md` - General server documentation
- `CHEATSHEET.md` - Quick reference
- `FREELINK_API_TESTING_GUIDE.md` - Complete API guide
- `FREELINK_SUMMARY.md` - This summary

---

## Support

If you need to modify responses:
1. Edit files in `responses/` directory
2. No need to restart server (responses are read on each request)
3. Update `config.yaml` if adding new endpoints
4. Restart server if changing `config.yaml`

**Quick Commands:**
```bash
./run.sh                    # Start server
./test_freelink_api.sh      # Test all endpoints
./get_ip.sh                 # Get your network IP
curl localhost:5000/health  # Check server health
```




