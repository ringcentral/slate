# Changelog

## 23.10.25
1. Increased API signature validity window from 5s to 10s to reduce time sync issues.

## 21.03.25
1. Better documentation for Websocket public channel 'candlesticks', now clearly states even Mark Price candles can be fetched.
2. /positions REST API fixed documentation for query parameters.
3. Better documentation for Websocket public channel 'announcements'.

## 20.02.25
1. Removed Websocket RPC section. Use REST API endpoints with normal HTTP requests (RPC requests still work, it is recommended not to use them).
2. Fixed documentation: "User-Agent" header is necessary for authenticated HTTP requests.
3. Fixed documentation: Better examples and documentation under 'General Information', 'Authentication', etc tabs.
4. Created separate documentation site for Indian and Global site for easier understanding and better examples for both.

## 18.10.2024
1. Added clickable links to the corresponding API response json schemas under some API "Responses" table. Updated some schemas to match the response. (This is a documentation fix, no changes in API)
2. Added "Testnet" REST and Websocket host endpoints.
3. Changed "Rate Limits" description and added an example.


## 01.05.2024
1. Added "po" positions key in /v2/user_trades websocket private channel.
2. Removed "fok" type for orders, as they are no longer supported.


## V2 Rest Api
Our v2 Api is significantly faster than the v1 api. Our focus while rebuilding v2 Apis was on the following

1. Remove Api gateway overheads as much as possible.
2. Remove overheads due to deep nesting in response payload.
3. Better Api structure to query only required data.

> New Response Format

```json
// The new format supports sending meta data alongside response body. 
// Success format
{
  "success": true,
  "result": "....",         // response body
  "meta": {
    "after": "...",       // cursor for pagination, is returned in meta
    "before": null,
  },
}

// Error Format
{
  "success": false,
  "error": {
    "code": "insufficient_margin",             // error code
    "context": {                              // error context
      "additional_margin_required": "0.121"
    }
  }
}
```

### Key Api changes
- We have completely removed nested product/asset payloads from live orders and live positions. This ensures the payload is light.
- Rate limiting now works on a fixed window instead of a rolling window.
- Ticker Api - now includes turnover in USD, mark price, spot price.
- Orderbook and trades are now returned in separate Apis.
- For supporting trading strategies which require latest positions, Now we have two different Apis to query position. 
  
  /v2/positions - returns only size and entry price. This should be used when you want to get the latest position, but dont need the margin dependent fields like liquidation price, bankruptcy price etc

  /v2/positions/margined - returns all fields including margin dependent fields. When the position is updated due to a fill, changes might take some time to reflect in this Api.

- All Apis that support pagination now use cursor based pagination, instead of fixed page size pagination. Check more details in our [python rest client docs](https://github.com/delta-exchange/python-rest-client)


## New Socket Channels
- Socket Api interface hasn't changed much in terms of connection management and authentication. 
- We have deprecated old channels and created new channels which make integration easier. 
- To support easy management of live data, all private data channels now support initial snapshots and sequence numbers.

### List of new public channels
- v2/ticker - now includes turnover in USD, mark price, spot price
- candlesticks - subscribe to ohlc candle updates for different resolutions
- all_trades - subscribe to all public trades for a symbol

### List of new private channels
- orders - subscribe to lifecycle of live orders
- user_trades - subscribe to live user trades/fills feed
- positions - subscribe to position updates
- margins - get margin/wallet updates