# Authentication

Api endpoints that place orders or fetch account related information needs to authenticated using api key and api secret.



## Common Errors

### SignatureExpired Error

* ```{ "error": "SignatureExpired", "message": "your signature has expired" }```

**Explanation:**  This error occurs when the timestamp used to generate your API request signature is more than **10 seconds** old by the time it reaches Delta Exchange servers. The platform enforces this time window to prevent replay attacks. You can check server time and request time in the api error response too.

### 🔧 Troubleshooting

**1. Sync Your System Clock**

- Ensure your system time is accurate using NTP (Network Time Protocol).
  - **Linux/macOS:** `sudo ntpdate pool.ntp.org`
  - **Windows:** Make sure the *Windows Time* service is running and properly synced.
- Enable automatic time synchronization in your system settings to prevent future drifts.

**2. Check Network Latency**

- Check for any network latency on your side.
- Use a stable and high-speed internet connection.

**3. Verify Timestamp Generation**

- Use Unix timestamp format (seconds since epoch).
- Don't reuse stale timestamps; update the timestamp before every request.
- Ensure the timestamp used in the signature matches the one sent in the request.
- Refer to the sample code block on the right.

```
# python code to generate signature
timestamp = str(int(time.time()))
signature_data = method + timestamp + path + query_string + payload
signature = generate_signature(api_secret, signature_data)
```

### InvalidApiKey Error

* ```{ "error": "InvalidApiKey", "message": "Api Key not found" }```

**Explanation:**  The API key in your request doesn't exist or is invalid. This can happen due to using keys from the wrong environment or deleted keys. 

### 🔧 Troubleshooting

**1. Verify the Correct Environment**

- API keys created at [Delta](https://global.delta.exchange) account must be used only with production apis.(prod api - [https://api.delta.exchange](https://api.delta.exchange))
- API keys created at [Demo](https://demo-global.delta.exchange) account must be used only with testnet apis.(testnet api - [https://testnet-api.delta.exchange](https://testnet-api.delta.exchange)) 

**2. Check API Key Validity**

- Log into Delta Exchange and confirm the key exists and is active.  
- Check for any typos in the key too.


### UnauthorizedApiAccess Error

* ```{ "error": "UnauthorizedApiAccess", "message": "Api Key not authorised to access this endpoint" }```

**Explanation:**  Your API key doesn't have permission to access this endpoint. Delta Exchange allows permission-based control for each key. There are two permissions given 1. Read Data ✅ 2. Trading ✅

### 🔧 Troubleshooting

**1. Check API Key Permissions**

- Go to API Management on Delta Exchange.  
- Verify respective permissions: 1. Read Data 2. Trading, are enabled ✅ or not.
- If required, create a new api key with the right permissions enabled ✅.

**2. Verify Endpoint Requirements**

- Market data: requires Read Data permissions only. 
- Orders, Positions, Wallets: requires Trading permission.

**3. Consider Security Best Practices**

- Grant only necessary permissions.  
- Use separate keys for different use-cases.


### IP Not Whitelisted Error

* ```{ "success": false, "error": { "code": "ip_not_whitelisted_for_api_key" } }```

**Explanation:**  This occurs when the request originates from an IP not allowed for the given API key. Delta Exchange enforces IP whitelisting as a security measure. Consider whitelisting he IP returned into the api error response.

### 🔧 Troubleshooting

**1. Update IP Whitelist**

- Log into Delta Exchange > API Management  
- Add your IP to the API key’s whitelist. The IP can be found into the api error response. 
- You can whitelist a list of IPs too. Enter them as comma separated list.
- Delta support both IPv4 and IPv6 formats for whitelisting.

**2. Consider Network Behavior**

- VPNs or ISPs with dynamic IPs may require frequent updates.  
- Consider cloud hosted machine with static IP for production to avoid whitelisting repeatedly.

### Request Forbidden Error

* ```{ "error": "Forbidden", "message": "Request blocked by CDN" } ```

**Explanation:**  Your request was blocked before reaching the Delta API gateway. This usually happens when required headers are missing (e.g., User-Agent), or when requests originate from environments where the IP is hidden or blocked by the CDN.

### 🔧 Troubleshooting

**1. Add a User-Agent Manually**

- Some HTTP clients (e.g., in certain programming languages) do not send a User-Agent header by default.
- Set a valid User-Agent string in your request to avoid being rejected.

**2. Trace Request Headers**

- Inspect the request/response headers using tools like curl -v, Postman, or your language’s HTTP client debugger.
- Check if required headers are present and correctly passed through.

**3. Verify Request IP**

- Some hosted environments or proxies mask the client IP.
- Confirm that the request includes a valid IP address visible to the CDN. If the IP is hidden or blocked, the request will be rejected.

### Signature Mismatch Error

* ```{ "success": false, "error": { "code": "Signature Mismatch" } }```

**Explanation:**  This error occurs when the signature generated on your end does not match the one received by Delta Exchange. This can happen due to incorrect timestamp, payload, or method used in the signature generation.

### 🔧 Troubleshooting

**1. Verify Signature Generation**

- Ensure you are using the correct http method (GET/POST) and the same payload as in the request.
- Check that the timestamp used in the signature matches the one sent in the request.
- Ensure you are using the correct API secret for the signature generation.
- Make sure you are using the correct endpoint path and query parameters in the signature generation.
- Ensure that the payload is properly formatted and matches the request body.
- Check for any extra spaces or characters in the signature string.
- Refer to the sample code block (see [Signing a Message](/#signing-a-message)).

By following these troubleshooting steps, you can resolve common Delta Exchange API authentication and authorization issues. For persistent problems, contact Delta Exchange support.

(Note - **api key creation blocked - When user enters wrong otp/mfa code more than 5 times, Delta exchange blocks api key creation for next 30 mins. After then, users can try creating again.**)

## Generating an API Key

Before being able to sign any requests, you must create an API key via the Delta website. Upon creating a key you will receive api key and api secret, which you must remember and secure at your end. The Key and Secret will be randomly generated.

You can create a new API key from here :
[https://global.delta.exchange/app/account/manageapikeys](https://global.delta.exchange/app/account/manageapikeys)

To create an API key with Trading permissions, whitelisted IP(s) must be provided. API requests using this API key will only succeed, if made from a machine with an IP address that was whitelisted. Multiple IPs can be whitelisted for a single API key. IP values can take IPv4 and IPv6. Whitelisted IPs can be changed and updated from the same page.

Common issues:  
1. Your machine is using IPv6 instead of IPv4 or vice-versa. Disable the one that isn’t whitelisted from your network settings or whitelist both.  
2. Your ISP may automatically change the IP address at your home, office about once a week. Update your whitelisted IP in such case.  
3. If you are using a Web Service/Cloud provider like AWS, assign a static public IPv4 address to your machine.  

## API Key Permissions

You can restrict the functionality of API keys. Before creating the key, you must choose what permissions you would like the key to have. The permissions are:

- Trading - Allow a key to have trading permissions. This includes placing new orders, cancelling orders, closing positions, changing margin & leverage.


## Creating a Request

All Authenticated requests must contain the following headers:

**api-key**: The api key as a string.

**signature**: The hex-encoded signature (see [Signing a Message](/#signing-a-message)).

**timestamp**: A timestamp for your request.


All request bodies should have content type application/json and be valid JSON.

## Signing a Message

The signature header is generated by creating a sha256 HMAC using the secret key on the prehash string **method + timestamp + requestPath + query params + body** (where + represents string concatenation) and convert output to hexdigest. The timestamp value is the same as the 'timestamp' header.

**Signature created in the last 10 seconds is allowed. if signature reaches delta system post 10 seconds of generation, then it will fail.**

> Code samples

```shell

# GET /orders
# queryString: product_id=1&state=open

# Generating signature:
echo -n "GET1542110948/v2/orders?product_id=1&state=open" | openssl dgst -sha256 -hmac "7b6f39dcf660ec1c7c664f612c60410a2bd0c258416b498bf0311f94228f"

# Sample Request:
# Url:
#  /v2/orders?product_id=1&state=open
# Headers:
#  signature: ad767fead0bdbe91ba1e4feb142079245fecd66aa5e47a70b40ba1a4c9b4e3db
#  api-key: a207900b7693435a8fa9230a38195d
  #timestamp: 1542110948

```

```python
import hashlib
import hmac
import requests
import time

api_key = 'a207900b7693435a8fa9230a38195d'
api_secret = '7b6f39dcf660ec1c7c664f612c60410a2bd0c258416b498bf0311f94228f'

def generate_signature(secret, message):
    message = bytes(message, 'utf-8')
    secret = bytes(secret, 'utf-8')
    hash = hmac.new(secret, message, hashlib.sha256)
    return hash.hexdigest()

url = "https://api.delta.exchange/v2/orders"

# Get open orders
payload = ''
method = 'GET'
timestamp = str(int(time.time()))
path = '/v2/orders'
query_string = '?product_id=1&state=open'
signature_data = method + timestamp + path + query_string + payload
signature = generate_signature(api_secret, signature_data)

req_headers = {
  'api-key': api_key,
  'timestamp': timestamp,
  'signature': signature,
  'User-Agent': 'python-rest-client',
  'Content-Type': 'application/json'
}
query = {"product_id": 139, "state": 'open'}

response = requests.request(
    method, url, data=payload, params=query, timeout=(3, 27), headers=req_headers
)

# Place new order
method = 'POST'
timestamp = str(int(time.time()))
path = '/v2/orders'
query_string = ''
payload = "{\"order_type\":\"limit_order\",\"size\":3,\"side\":\"buy\",\"limit_price\":\"0.0005\",\"product_id\":16}"
signature_data = method + timestamp + path + query_string + payload
signature = generate_signature(api_secret, signature_data)

req_headers = {
  'api-key': api_key,
  'timestamp': timestamp,
  'signature': signature,
  'User-Agent': 'python-rest-client',
  'Content-Type': 'application/json'
}

response = requests.request(
    method, url, data=payload, params={}, timeout=(3, 27), headers=req_headers
)

```
