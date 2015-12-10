---
title: API Reference

language_tabs:
  - http
  - javascript

toc_footers:
  - <a href='#'>Sign Up for RingCentral for Developers</a>
  - <a href='http://github.com/tripit/slate'>Documentation Powered by Slate</a>

includes:
  - errors

search: true
---

# Introduction

Welcome to the RingCentral CTI Developer Tutorial. This tutorial uses the [RingCentral JavaScript SDK](http://github.com/ringcentral/js-sdk).

Call management integration typically includes monitoring of incoming calls, listing calls and performing of RingOuts, all of which are covered in this tutorial.

# Quickstart

## Retrieve Call Logs

```http
GET https://platform.ringcentral.com/restapi/v1.0/account/~/extension/~/call-log HTTP/1.1
Authorization: Bearer U0pDMDFQMDFQQVMwMnxBQUFWZmY4ZXoxMlh
Accept: application/json
```

```
HTTP/1.1 200 OK
Content-Language: en
Content-Type: application/json; charset=UTF-8
Content-Length: 4145

{
    "uri": ".../account/401501489004/extension/401501489004/call-log?dateFrom=2013-01-01T00:00:00.000Z&page=1&perPage=100",
    "records": [
        {
            "uri": ".../account/401501489004/extension/401501489004/call-log/IXtVRs-3B7A_PfE",
            "id": "IXtVRs-3B7A_PfE",
            "sessionId": "404769762004",
            "startTime": "2014-09-22T12:58:09.000Z",
            "duration": 4,
            "type": "Voice",
            "direction": "Inbound",
            "action": "Phone Call",
            "result": "Accepted",
            "to": {
                "phoneNumber": "18662130006",
                "name": "Rose White"
            },
            "from": {
                "phoneNumber": "16504445567",
                "name": "Phillip Marco",
                "location": "Palo Alto, CA"
            }
        },
        {
            "uri": ".../account/401501489004/extension/401501489004/call-log/IXtVPRjQvSF5Pe4",
            "id": "IXtVPRjQvSF5Pe4",
            "sessionId": "404769755004",
            "startTime": "2014-09-22T12:58:06.000Z",
            "duration": 10,
            "type": "Voice",
            "direction": "Outbound",
            "action": "VoIP Call",
            "result": "Call connected",
            "to": {
                "phoneNumber": "16504445567",
                "location": "Palo Alto, CA"
            },
            "from": {
                "phoneNumber": "16504445567",
                "name": "Irene Fox"
            }
        },
        {
            ...
        }
    ],
    "paging": {
        "page": 1,
        "perPage": 100,
        "pageStart": 0,
        "pageEnd": 6
    },
    "navigation": {
        "firstPage": {
            "uri": ".../account/401501489004/extension/401501489004/call-log?dateFrom=2013-01-01T00:00:00.000Z&page=1&perPage=100"
        }
    }
}
```

To access a Call Log resource you will require this URI:

`GET /restapi/v1.0/account/{accountId}/extension/{extensionId}/call-log`

Send the request having specified particular accountId and extensionId or using simplified syntax with tilde characters. Please note, that if dateFrom parameter is not specified, server will return records for last week only.

## Retrieve Filtered Call Logs

```http
GET https://platform.ringcentral.com/restapi/v1.0/account/~/extension/~/call-log?dateFrom=2014-09-18&phoneNumber=16504445567&dateTo=2014-09-25&type=Voice HTTP/1.1
Authorization: Bearer U0pDMDFQMDFQQVMwMnxBQUFWZmY4ZXoxMl
Accept: application/json
```

```
HTTP/1.1 200 OK
Content-Language: en
Content-Type: application/json; charset=UTF-8
Content-Length: 1725

{
    "uri": ".../account/401501489004/extension/401501489004/call-log?phoneNumber=16504445567&type=Voice&dateFrom=2014-09-18T00:00:00.000Z&dateTo=2014-09-25T00:00:00.000Z&page=1&perPage=100",
    "records": [
        {
            "uri": ".../account/401501489004/extension/401501489004/call-log/IXtVRs-3B7A_PfE",
            "id": "IXtVRs-3B7A_PfE",
            "sessionId": "404769762004",
            "startTime": "2014-09-22T12:58:09.000Z",
            "duration": 4,
            "type": "Voice",
            "direction": "Inbound",
            "action": "Phone Call",
            "result": "Accepted",
            "to": {
                "phoneNumber": "18662130006",
                "name": "Steve Jones"
            },
            "from": {
                "phoneNumber": "16504445567",
                "name": "Tony Black",
                "location": "Palo Alto, CA"
            }
        },
        {
            "uri": ".../account/401501489004/extension/401501489004/call-log/IXtVPRjQvSF5Pe4",
            "id": "IXtVPRjQvSF5Pe4",
            "sessionId": "404769755004",
            "startTime": "2014-09-22T12:58:06.000Z",
            "duration": 10,
            "type": "Voice",
            "direction": "Outbound",
            "action": "VoIP Call",
            "result": "Call connected",
            "to": {
                "phoneNumber": "16504445567",
                "location": "Palo Alto, CA"
            },
            "from": {
                "phoneNumber": "18662130006",
                "name": "Steve Jones"
            }
        }
    ],
    "paging": {
        "page": 1,
        "perPage": 100,
        "pageStart": 0,
        "pageEnd": 1
    },
    "navigation": {
        "firstPage": {
            "uri": ".../account/401501489004/extension/401501489004/call-log?phoneNumber=16504445567&type=Voice&dateFrom=2014-09-18T00:00:00.000Z&dateTo=2014-09-25T00:00:00.000Z&page=1&perPage=100"
        }
    }
}
```

You may get exactly the records you require by setting a few filters. For example if you need the records over a week (dateFrom, dateTo) of voice calls (type) to/from a certain number (phoneNumber), sned the request having set the following query parameters:

* `dateFrom` = 2014-09-18
* `dateTo` = 2014-09-25
* `type` = Voice
* `phoneNumber` = 16504445567

## Send SMS Message

```http
POST https://platform.ringcentral.com/restapi/v1.0/account/~/extension/~/sms HTTP/1.1
Authorization: Bearer U0pDMDFQMDFQQVMwMXxBQUFWZmY4ZXoxMlhvUFI5dmhYVzV
Content-Type: application/json
Accept: application/json
Content-Length: 323

{
    "to": [{"phoneNumber": "+18662130006"}],
    "from": {"phoneNumber": "+16504445567"},
    "text": "Test SMS message from Platform server"
}
```

```
HTTP/1.1 200 OK
Content-Language: en
Content-Type: application/json; charset=UTF-8
Content-Length: 926

{
    "uri": ".../account/401474882008/extension/401474882008/message-store/402206716008",
    "id": 402206716008,
    "to": [
        {
            "phoneNumber": "+16505393204",
            "location": "San Mateo, CA"
        }
    ],
    "from": {
        "phoneNumber": "+18004900003"
    },
    "type": "SMS",
    "creationTime": "2014-09-24T07:04:26.000Z",
    "readStatus": "Read",
    "priority": "Normal",
    "attachments": [
        {
            "id": 402206716008,
            "uri": ".../account/401474882008/extension/401474882008/message-store/402206716008/content/402206716008",
            "type": "Text",
            "contentType": "text/plain"
        }
    ],
    "direction": "Outbound",
    "availability": "Alive",
    "subject": "Test SMS message from Platform server",
    "messageStatus": "Sent",
    "smsSendingAttemptsCount": 1,
    "conversationId": 5578972751633835268,
    "lastModifiedTime": "2014-09-24T07:04:26.534Z"
}
```

If you need to send a text message to somebody, you should use this URI:

`POST /restapi/v1.0/account/{accountId}/extension/{extensionId}/sms`

Send `POST` request: Specify `accountId` and `extensionId` in the request URL or use simplified syntax with tilde characters. Specify the recipient phone number in the `to` field and one of your valid RingCentral phone numbers in the `from` field. Enter your message in the `text` field.

## Send Pager Message

# Getting Started

## Installing the SDK

To install the SDK, follow the online instructions posted at Github:

[https://github.com/ringcentral/js-sdk#installation](https://github.com/ringcentral/js-sdk#installation)

## Instantiating the SDK

```javascript
var RC_SERVER_PRODUCTION = 'https://platform.ringcentral.com';
var RC_SERVER_SANDBOX = 'https://platform.devtest.ringcentral.com';

var rcsdk = new RCSDK({
    server: RC_SERVER_SANDBOX,
    appKey: 'yourAppKey',
    appSecret: 'yourAppSecret'
});
```

The SDK is represented by the global RCSDK constructor. Your application must create an instance of this object.

In order to bootstrap the RingCentral JavaScript SDK, you have to first get a reference to the Platform singleton and then configure it. Before you can do anything using the Platform singleton, you need to configure it with the server URL (this tells the SDK which server to connect to) and your unique API key (this is provided by RingCentral’s developer relations team).

<aside class="notice">
This instance will be used later on to perform calls to API.
</aside>

## Getting the Platform Singleton

```javascript
var platform = rcsdk.getPlatform();
```

Now that you have your platform singleton and SDK has been configured with the correct server URL and API key, your application can log in so that it can access the features of the API.

## Login

```javascript
platform.authorize({
    username: '+18001234567', // your phone number in E.164 format
    extension: '101', // leave blank if direct number is used
    password: 'yourpassword'
}).then(function(ajax) {
    // your code here
}).catch(function(e) {
    alert(e.message  || 'Server cannot authorize user');
});
```

To log in to RingCentral, get the Platform object and call its authorize method, providing valid username, extension, and password values. Enter your phone number in E.164 format for username. The `+` may be omitted.

A Promise is returned, and you can use its then method to specify your continuation function, and its catch method to specify an error handling function.

## Handling Authn Exceptions

```javascript
platform.on(platform.events.accessViolation, function(e){
    // do something
});
```

To handle possible access or authentication exceptions that may occur while the application is running (after the user has successfully logged in), you can provide a handler for the `accessViolation` platform event.

<aside class="success">
A recommended way to handle access or authentication exceptions is to direct the user to the login page or UI. The login page may attempt to automatically re-authenticate the user using stored authentication data (see below).
</aside>

## Determining Authn Status

```javascript
// To check authentication status:
platform.isAuthorized()
    .then(function(){ ... })
    .catch(function(e){ ... });

// Checking authn status synchronously
// without auto-refresh of the access token
if (platform.isTokenValid()) {...}
```

The `isAuthorized` method will automatically perform a refresh of the access token, if needed. This method may be used in the login page of your application for automatic login.

There is also a synchronous method for checking the authentication status that does not automatically perform a refresh of the access token.

## Manual Access Token Refresh

```javascript
// Refreshing the access token manually
platform.refresh().then(...)
```

Access token refresh normally happens automatically for common use cases. On rare occasions, you may perform a refresh of the access token manually by calling the refresh method using the `platform.refresh()` method.

## Logout

```javascript
// without callback
platform.logout()
// with callback
platform.logout().then(...)
```

Your application can log out the user by calling the `platform.logout()` method.

# Call Management

If you are integrating with a CRM or ERP system, use of the JavaScript SDK is highly recommended. Following is an example of a call management integration that includes monitoring of incoming calls and performing of RingOuts.

A call management integration usually consists of the following tasks:

* Track the telephony status
* View the list of active calls
* View the recent calls

## Call States

```javascript

// 1) Missed inbound call  (Ringing -> No Call)
{
  "body": {
    "telephonyStatus": "Ringing",
                    "extensionId": 607457016,
                    "activeCalls": [{"direction": "Inbound", "from": "13027430863", "telephonyStatus": "Ringing", "to":   "18885434778", "sessionId": "67029198021", "id": "8ad4d5ea165f4e2aa00474a666368728"}],
    "sequence": 133702
  },
  "timestamp": "2015-04-10T18:48:55.133+0000",
  "uuid": "2b5bb8c0-c36c-46af-bd93-fb41e330d87c",
  "event": "/restapi/v1.0/account/~/extension/607457016/presence?detailedTelephonyState=true"
}
 
{
  "body": {
    "telephonyStatus": "NoCall",
    "extensionId": 607457016,
    "activeCalls": [{"direction": "Inbound", "from": "13027430863", "telephonyStatus": "NoCall", "to": "18885434778", "sessionId": "67029198021", "id": "8ad4d5ea165f4e2aa00474a666368728"}],
    "sequence": 133857
  },
  "timestamp": "2015-04-10T18:49:14.679+0000",
  "uuid": "a5a876ab-3356-41e5-b1fe-fff91da3a281",
  "event": "/restapi/v1.0/account/~/extension/607457016/presence?detailedTelephonyState=true"
}

// 2) Answered inbound call (Ringing -> CallConnected -> NoCall)
 
{
  "body": {
    "telephonyStatus": "Ringing",
    "extensionId": 607457016,
    "activeCalls": [{"direction": "Inbound", "from": "13027430863", "telephonyStatus": "Ringing", "to": "18885434778", "sessionId": "67029198021", "id": "61803278cbf74d7490539a6174a6c094"}],
    "sequence": 133897
  },
  "timestamp": "2015-04-10T18:49:20.858+0000",
  "uuid": "c394ccf6-85dd-4da4-a87e-d31fac7f1283",
  "event": "/restapi/v1.0/account/~/extension/607457016/presence?detailedTelephonyState=true"
}
 
{
  "body": {
    "telephonyStatus": "CallConnected",
    "extensionId": 607457016,
    "activeCalls": [{"direction": "Inbound", "from": "13027430863", "telephonyStatus": "CallConnected", "to": "18885434778", "sessionId": "67029198021", "id": "61803278cbf74d7490539a6174a6c094"}],
    "sequence": 133942
  },
  "timestamp": "2015-04-10T18:49:26.687+0000",
  "uuid": "96df6fdd-a2a4-42fb-bc34-cffb5d637754",
  "event": "/restapi/v1.0/account/~/extension/607457016/presence?detailedTelephonyState=true"
}
 
{
  "body": {
    "telephonyStatus": "NoCall",
    "extensionId": 607457016,
    "activeCalls": [{"direction": "Inbound", "from": "13027430863", "telephonyStatus": "NoCall", "to": "", "sessionId": "67029198021", "id": "61803278cbf74d7490539a6174a6c094"}],
  "sequence": 134051
  },
  "timestamp": "2015-04-10T18:49:41.828+0000",
  "uuid": "7fa7ac3c-5b7b-4127-88ec-9734f478d4a3",
  "event": "/restapi/v1.0/account/~/extension/607457016/presence?detailedTelephonyState=true"
}

// 3) 2-legged Ringout
{
  "body": {
    "telephonyStatus": "Ringing",
    "extensionId": 255537016,
"activeCalls": [{"to": "16502008440", "direction": "Outbound", "from": "16509540334", "sessionId": "915021981016", "telephonyStatus": "Ringing"}],
    "sequence": 46061598
  },
  "timestamp": "2015-04-17T19:38:59.718+0000",
  "uuid": "305b8075-5dad-4686-b22a-d26744802566", "event": "/restapi/v1.0/account/~/extension/255537016/presence?detailedTelephonyState=true"
}
 
{
  "body": {
    "telephonyStatus": "CallConnected",
    "extensionId": 255537016,
    "activeCalls": [{"direction": "Outbound", "from": "16509540334", "telephonyStatus": "CallConnected", "to": "16502008440", "sessionId": "915021981016", "id": "b5ea44d61b6a4658aadf948348db069c"}],
    "sequence": 46062162
  },
  "timestamp": "2015-04-17T19:39:12.950+0000",
  "uuid": "71673991-dad0-4c8e-9c22-78b0244c790c",
  "event": "/restapi/v1.0/account/~/extension/255537016/presence?detailedTelephonyState=true"
}
 
{
  "body": {
    "telephonyStatus": "NoCall",
    "extensionId": 255537016,
    "activeCalls": [{"direction": "Outbound", "from": "16509540334", "telephonyStatus": "NoCall", "to": "16502008440", "sessionId": "915021981016", "id": "b5ea44d61b6a4658aadf948348db069c"}],
    "sequence": 46063265
  },
  "timestamp": "2015-04-17T19:39:40.172+0000",
  "uuid": "97b01949-1438-45f2-856a-54f89e83367f",
  "event": "/restapi/v1.0/account/~/extension/255537016/presence?detailedTelephonyState=true"
}
```

* A call may consist of multiple call legs. Top-level telephonyStatus should be aggregated across these multiple call legs. 
* A call is identified by its sessionId. For tracking a call, application should match by sessionId across activeCall items from multiple notifications.
* In some rare cases notifications can be delivered in incorrect order. Application should remember largest “sequence” value from an event for a given call (identified by its sessionId) and ignore any events which come later with smaller “sequence”

Some typical event flows for inbound calls are listed for the following scenarios:

1. Missed inbound call  (Ringing -> No Call)
1. Answered inbound call (Ringing -> CallConnected -> NoCall)
1. 2-legged Ringout

## Call Notification

```javascript
var subscription = rcsdk.getSubscription();

subscription
    .on(subscription.events.notification, function(msg) {
        console.log(msg, msg.body);
    })
    .register({
        events: [
            '/account/~/extension/~/presence?detailedTelephonyState=true'
        ]
    })
    .then(...);
```

To get notification of inbound and outbound call events, your application can receive push notifications from the RingCentral Connect Platform by subscribing to specific events, such as the telephony presence event.

## Caller ID & Called Number

```javascript
var subscription = rcsdk.getSubscription();

subscription
    .on(subscription.events.notification, function(msg) {
        console.log(msg.body.activeCalls[n].from); // activeCalls is array
        console.log(msg.body.activeCalls[n].to);
    })
    .register({
        events: [
            '/account/~/extension/~/presence?detailedTelephonyState=true'
        ],
    })
    .then(...);
```

Subscript to the account using the `detailedTelephonyState` to get caller info (caller id and called number) from telephony presence events.

## Call Information During Call

```javascript
platform.apiCall({
    url: rcsdk.getCallHelper().createUrl({active: true}),
    get: { // this can be omitted
        page: 1,
        perPage: 10
    }
}).then(function(ajax) {
    console.log(ajax.data.records);
}.catch(function(e) {
    alert('Active Calls Error: ' + e.message);
});
```

To determine call duration or any other information about the call during the call, the application needs to remember discovered calls and save the time at which they were discovered (had Ringing or Connected status) and then duration can be calculated as difference between now and the saved time.

The application may periodically (around 2-5 minutes) poll the active calls endpoint to make sure that even missed event notifications will not affect the application state. The application may also load a list of active calls after receiving event notifications. Please keep in mind that application may exceed RPS limits and will be throttled in this case, so application must handle this situation.

## Determining End of Call

The application is responsible for caching active calls. A common method is to use a session ID to track a call. 
Your application may gather information about discovered calls and when it sees “No Call” after “Connected” status it means that the call has ended. Also the call will disappear from active calls list. See the section below on determining call duration of a recently ended call for more info.

## Call Duration Post-Call

```javascript
// Determining call duaration of a recently ended call.
platform.apiCall({
    url: rcsdk.getCallHelper().createUrl({active: true}),
    get: { // this can be omitted
        page: 1,
        perPage: 10
    }
}).then(function(ajax) {
    console.log(ajax.data.records);
}.catch(function(e) {
    alert('Active Calls Error: ' + e.message);
```

Completed calls will stay in Active Calls for a limited time (few minutes). Use the following code to determine the duration of a recently completed call.

## Call and Event Matching

To match calls and events from the call log or active calls, use the `sessionId` property of calls from events’ active calls array and call log or active calls response.

## Multiple Concurrent Calls

To handle multiple concurrent calls, each call event will contain information about all calls, application must go through all calls in `msg.body.activeCalls` array. The application must remember `sequenceNumber` and ignore events with smaller sequence number than already received.

## Call Control

The RingCentral Connect Platform does not currently support any call control functions.

# Call Queries

A call management integration usually consists of tracking the telephony call status per the above and the following call query tasks:

* View active calls
* View recently ended calls
* View historical calls

## View Active Calls

```javascript
var activeCalls = [],
    Call = rcsdk.getCallHelper();

// This call may be repeated when needed, for example as a response to incoming Subscription
platform.apiCall(Call.loadRequest(null, {
    url: Call.createUrl({active: true}),
    query: { // this can be omitted
        page: 1,
        perPage: 10
    }
})).then(function(response) {
    activeCalls = Call.merge(activeCalls, response.data.records); // safely merge existing active calls with new ones
}.catch(function(e) {
    alert('Active Calls Error: ' + e.message);
});
```

By default, the load request returns calls that were made during the last week. To alter the time frame, provide custom query.dateTo and query.dateFrom properties.

## View Recently Ended Calls

```javascript
// Getting historical call information
platform.apiCall({
    url: rcsdk.getCallHelper().createUrl(),
    get: { // this can be omitted
        page: 1,
        perPage: 10
    }
}).then(function(ajax) {
    console.log(ajax.data.records);
}.catch(function(e) {
    alert('Calls Error: ' + e.message);
});
```

Recently ended calls appear in Call Log with some delay (seconds to a minute or so) so the recommended way to retrieve them is to use Active Calls API.

<aside class="notice">
Completed calls stay in the Call Log for 2 years.
</aside>

## View Historical Calls

```javascript
var calls = [],
    Call = rcsdk.getCallHelper();

// This call may be repeated when needed, for example as a response to incoming Subscription
platform.apiCall(Call.loadRequest(null, {
    query: { // this can be omitted
        page: 1,
        perPage: 10
    },
})).then(function(response) {
    calls = Call.merge(calls, response.data.records); // safely merge existing active calls with new ones
}).catch(function(e) {
    alert('Recent Calls Error: ' + e.message);
});
```

By default, the load request returns calls that were made during the last week. To alter the time frame, provide custom query.dateTo and query.dateFrom properties.

# Making Calls (RingOut)  (Changes by anil)

Outbound calls using RingCentral can be made using the RingOut functionality.


Conveniently make calls by clicking any number in your online account, including contacts, messages, and call logs.
Use RingOut : 

* To dial any number you see on a Web page, email or Word document.
* Make calls directly from within any application, including Microsoft® Outlook® by highlighting any number on your computer and click `RingOut` to dial the number.
* Listen to any voicemail message and return the call with a single touch.

## Making a RingOut Call

```http
POST https://platform.ringcentral.com/restapi/v1.0/account/~/extension/~/ringout HTTP/1.1
Authorization: Bearer U0pDMDFQMDFQQVMwMXxBQUFWZmY4ZXoxMlhvUFI5dmhYVzV
Content-Type: application/json
Accept: application/json
Charset=UTF-8

{
    "to": [{"phoneNumber": "+18662130006"}],
    "from": {"phoneNumber": "+16504445567"},
    "callerId": {"phoneNumber": "16504445567"},
    "playPrompt": true
}
```

```javascript
// Phone numbers should be in E.164 format.
platform
    .apiCall(rcsdk.getRingoutHelper().saveRequest({
        from: {phoneNumber: '+16501111111'},
        to: {phoneNumber: '+18882222222'},
        callerId: {phoneNumber: '+18882222222'}, // optional,
        playPrompt: false // optional
    }))
    .then(function(ajax) {
      // here application can start polling
      // also save ajax.data as, for example, prevRingoutData
    })
    .catch(handleError);
```

```http
HTTP/1.1 200 OK
Content-Language: en
Content-Type: application/json; charset=UTF-8
Content-Length: 926

{
  "uri": "https://platform.devtest.ringcentral.com/restapi/v1.0/account/131192004/extension/131192004/ringout/1412?#",
  "id": 1412,
  "status": {
    "callStatus": "InProgress",
    "callerStatus": "InProgress",
    "calleeStatus": "InProgress"
  }
}
```

To make a RingOut call you will require this URI:

`POST /restapi//v1.0/account/{accountId}/extension/{extensionId}/ringout`

Send `POST` request:

*Path Parameters*

| Parameter | Type | Description |
|-----------|------|-------------|
| `accountId` | integer | integer or `~` for authorized user |
| `extensionId` | integer | integer or `~` for authorized user |

*Request Body*

| Parameter   | Type | Description |
|-------------|------|-------------|
| `from` | Caller Info, `phoneNumber` property only | Caller Info object with only `phoneNumber` |
| `to` | Caller Info, `phoneNumber` property only | Caller Info object with only `phoneNumber` |
| `callerId` | Caller Info, `phoneNumber` property only | The number to be displayed. |
| `playPrompt` | boolean, True | False | Optional audio prompt |


## Two-Legged Calls

When making a call, the RingCentral system establishes two calls, one for each of the two parties being connected, and then connects them. This results in events for two calls (2-legged calls) when initiated as a single click-to-dial API call.

<img src="images/ringout.png">

## Polling Outbound Call Status

```http
POST https://platform.ringcentral.com/restapi/v1.0/account/~/extension/~/ringout/ringoutId HTTP/1.1
Authorization: Bearer U0pDMDFQMDFQQVMwMXxBQUFWZmY4ZXoxMlhvUFI5dmhYVzV
Content-Type: application/json
Accept: application/json
Charset=UTF-8
ringoutId: 1234
```

```http
HTTP/1.1 200 OK
Content-Language: en
Content-Type: application/json; charset=UTF-8
Content-Length: 926

{
  "uri": "https://platform.devtest.ringcentral.com/restapi/v1.0/account/131192004/extension/131192004/ringout/1412?#",
  "id": 1412,
  "status": {
    "callStatus": "InProgress",
    "callerStatus": "Success",
    "calleeStatus": "InProgress"
  }
}
```

```javascript
// Poll for the status of an ongoing outbound call
function update(next, delay) {

    if (!rcsdk.getRingoutHelper().isInProgress(ringout)) return;

    platform
        .apiCall(rcsdk.getRingoutHelper().loadRequest(prevRingoutData))
        .then(function(ajax) {
            // also save ajax.data as, for example, prevRingoutData
            console.log(ajax.data); // updated status of ringout
            timeout = next(delay); // you can increase delay here
        })
        .catch(handleError);

}

var timeout = rcsdk.getUtils().poll(update, 3000); // stay in RPS limits

// To stop polling:

rcsdk.getUtils().stopPolling(timeout);
```

To poll the status of an ongoing outbound call you will require this URI:

`GET /restapi/v1.0/account/{accountId}/extension/{extensionId}/ringout/ringoutId`

Send `GET` request: 


*Path Parameters*

| Parameter | Type | Description |
|-----------|------|-------------|
| `accountId` | integer | integer or `~` for authorized user |
| `extensionId` | integer | integer or `~` for authorized user |
| `ringoutId` | integer | integer

To notify the completition of the *First Leg* of the *Two Legged* Ringout call, the `callerStatus` would change from `InProgress` to `Success`.


## Outbound Call Control

The RingCentral Connect Platform does not currently support control of outbound calls. However, you can cancel ringout call while callee party status is `InProgress`. To do that make a `DELETE` request to ringout URI.   


`DELETE /restapi/v1.0/account/{accountId}/extension/{extensionId}/ringout/ringoutId`

Send `DELETE` request:

WIP

*Path Parameters*

| Parameter | Type | Description |
|-----------|------|-------------|
| `accountId` | integer | integer or `~` for authorized user |
| `extensionId` | integer | integer or `~` for authorized user |

*Request Body*

| Parameter   | Type | Description |
|-------------|------|-------------|


## Outbound Call Statuses

```http
POST https://platform.ringcentral.com/restapi/v1.0/account/~/extension/~/call-log HTTP/1.1
Authorization: Bearer U0pDMDFQMDFQQVMwMXxBQUFWZmY4ZXoxMlhvUFI5dmhYVzV
Content-Type: application/json
Accept: application/json
Charset=UTF-8
```
```
HTTP/1.1 200 OK
Content-Language: en
Content-Type: application/json; charset=UTF-8
Content-Length: 926

{{
      "uri": "https://platform.devtest.ringcentral.com/restapi/v1.0/account/131192004/extension/131192004/call-log/AP7vT6913YfpH1o?view=Simple",
      "id": "AP7vT6913YfpH1o",
      "sessionId": "12038956004",
      "startTime": "2015-07-16T21:10:34.000Z",
      "duration": 26,
      "type": "Voice",
      "direction": "Outbound",
      "action": "RingOut Web",
      "result": "Call connected",
      "to": {
        "phoneNumber": "+18882222222",
        "location": "Salinas, CA"
      },
      "from": {
        "phoneNumber": "+16501111111",
        "name": "Ring Central"
      }
    }
```

* A 2-legged RingOut call is represented in events as an outbound call between `from` and `to` numbers provided in RingOut API request. 

    The `from` and `to` numbers could be either one of:

    `RC Main Number`,
    `RC Extension number`,
    `External Number`


* There is the known issue: notification with `CallConnected` status comes after first leg is connected. So actually a call can be missed by callee but it won’t be reflected in event flow; but it will be reflected in call log using the `result` parameter.

    Inorder to check the presence event use the API :

    `GET /v1.0/account/{accountId}/extension/{extensionId}/call-log`

    Send `GET` request :

    *Path Parameters*

    | Parameter | Type | Description |
    |-----------|------|-------------|
    | `accountId` | integer | integer or `~` for authorized user |
    | `extensionId` | integer | integer or `~` for authorized user |


* Phone numbers in notification (`from` and `to`) may be either E.164 phone numbers (with or without `+`) or short extension numbers (e.g. “101”) for calls between extensions
* For some RC phone system configurations when multiple devices are ringing for inbound call, you may get transitional notifications with `NoCall` status which will be immediately followed by `Ringing` or `CallConnected` (for the same `sessionId`).



## Polling & Events Notification
```http
POST https://platform.ringcentral.com/restapi/v1.0/account/~/active-calls HTTP/1.1
Authorization: Bearer U0pDMDFQMDFQQVMwMXxBQUFWZmY4ZXoxMlhvUFI5dmhYVzV
Content-Type: application/json
Accept: application/json
Charset=UTF-8
```

```
HTTP/1.1 200 OK
Content-Language: en
Content-Type: application/json; charset=UTF-8
Content-Length: 3855

{
  "uri": "https://platform.devtest.ringcentral.com/restapi/v1.0/account/131192004/active-calls?page=1&perPage=100",
  "records": [
    {
      "uri": "https://platform.devtest.ringcentral.com/restapi/v1.0/account/131192004/extension/131192004/call-log/AP7wasrRyBHhRB4?view=Simple",
      "id": "AP7wasrRyBHhRB4",
      "sessionId": "12039160004",
      "startTime": "2015-07-16T22:04:46.000Z",
      "duration": 24,
      "type": "Voice",
      "direction": "Outbound",
      "action": "RingOut Web",
      "result": "Call connected",
      "to": {
        "phoneNumber": "+18882222222",
        "location": "Salinas, CA"
      },
      "from": {
        "name": "Ring Central"
      }
    },
    {
      "uri": "https://platform.devtest.ringcentral.com/restapi/v1.0/account/131192004/extension/131192004/call-log/AP7wbC4XQG9rRBA?view=Simple",
      "id": "AP7wbC4XQG9rRBA",
      "sessionId": "12039161004",
      "startTime": "2015-07-16T22:04:32.000Z",
      "duration": 38,
      "type": "Voice",
      "direction": "Inbound",
      "action": "Phone Call",
      "result": "Accepted",
      "to": {
        "phoneNumber": "+16501111111",
        "name": "Ring Central",
        "location": "Rochester, NY"
      },
      "from": {
        "phoneNumber": "+18882222222",
        "location": "Salinas, CA"
      }
    }

    ]
}
```

All RingOut calls will appear in event notifications and active calls endpoint. The difference between what RingOut polling provides is more granular status updates (application can track status of both parties). Normally it should be represented by two independent views/flows in application. In general there is no point to match ringout calls with any of active calls, those process may happen concurrently.

If the application needs to track outbound calls and save them somewhere, it is better to initiate the ringout and NOT poll it, but expect a notification and work only with notifications/active calls.

    To get the status of the current active call use the API:

    `GET /v1.0/account/{accountId}/active-calls`

    Send `GET` request :

*Path Parameters*

| Parameter | Type | Description |
|-----------|------|-------------|
| `accountId` | integer | integer or `~` for authorized user |
| `extensionId` | integer | integer or `~` for authorized user |


    

