---
title: Tatango API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - shell
  - ruby
  - javascript

includes:
  - errors

search: true
---

# Before You Start

Welcome to the Tatango API! The Tatango API is designed for developers, engineers, or anyone else who's comfortable creating custom-coded solutions or integrating with RESTful APIS. If you're not familiar with API concepts like HTTP response codes, REST endpoints, and JSON, try <a href="https://zapier.com/apps/tatango/integrations" target="_blank">Zapier</a>.

You can view code examples in the dark area to the right, and you can switch the programming language of the examples with the tabs in the top right.

# Rate Limits

The Tatango API allows 1200 calls per hour or 1 call every 3 seconds. Please contact your account manager with your specific use case if you need a bump to this limit.

# Returning multiple results and pagination

By default, GET API calls that return multiple items in a list will return up to 10 items for a single call. The "pages_count" parameter in the returned JSON will indicate the number of "pages" included in the entire result set. (So for example, if a call to https://app.tatango.com/api/v2/lists finds 27 lists in the system, the JSON will include the following (see JSON snippet to the right):

```
   "per_page":10,
   "count":27,
   "page":1,
   "pages_count":3
```

Note that the "pages_count" parameter will default to 0 when there is no items in the list.

To fetch the next page of results, pass the "page" parameter on the URL, like this: https://app.tatango.com/api/v2/lists?page=2. You can also change the number of records returned in each "page" by passing in a "per_page" parameter as part of the URL, like this: https://app.tatango.com/api/v2/lists?per_page=50. Note that the system will only allow up to 1000 records to be returned in a single call.

# Authentication

Note: You can access your API key <a href="http://help.tatango.com/api/api-keys">here</a>.

> To authorize, use this code:

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/example-endpoint')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Get.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
response = http.request(request)
```

```shell
# With shell, you can just pass the correct email and api key with each request
curl -u emailaddress@mydomain.com:my_api_key https://app.tatango.com/api/v2/example-endpoint
```

```javascript
var request = new XMLHttpRequest();
request.open("POST", "https://app.tatango.com/api/v2/example-endpoint", false);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
request.send(null);
```

> Make sure to replace `my_api_key` with your API key, which can be obtained by logging into <a href="https://app.tatango.com/" target="_blank">https://app.tatango.com</a>.

Tatango authenticates API requests by validating an API key that must be passed with each API call. We use the built-in HTTP basic authentication scheme supported by most HTTP libraries. Use your login email as the username and the API key as the password.

# Accounts

## Get Current Account

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/accounts')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Get.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/accounts/me" -X GET \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open("GET", "https://app.tatango.com/api/v2/accounts/me", false);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
request.send(null);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "account": {
    "id": 37,
    "email": "myemail36@gmail.com",
    "username": "boowebb36"
  }
}
```

This endpoint retrieves the current account, as specified by the API key used to authenticate.

### HTTP Request

`GET https://app.tatango.com/api/v2/accounts/me`

<aside class="success">
You will receive a 200 status on success
</aside>
<aside class="error">
<strong>Disabled API Key</strong>
<p>
{"status":"error","error":"This API key is disabled"}
</p>
</aside>
<aside class="error">
<strong>Invalid API Key</strong>
<p>{"status":"error","error":"API key authorization failure"}</p>
</aside>

# Lists

Note: the following settings cannot be modified via the API:

- API Confirmation Resend Block Timeout
- Resubscribers

## List all Lists

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Get.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists" -X GET \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open("GET", "https://app.tatango.com/api/v2/lists", false);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
request.send(null);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "per_page": 10,
  "count": 3,
  "page": 1,
  "pages_count": 1,
  "lists": [
    {
      "id": 7,
      "name": "Mobile Campaign",
      "email_digest": "myemail12@gmail.com",
      "email_subscribe": null,
      "email_unsubscribe": null,
      "first_optin_message": "",
      "second_optin_message": "",
      "message_help": null,
      "message_stop": null,
      "message_reply": null,
      "message_already_subscribed": null,
      "message_yes": null,
      "keyword_names": [],
      "counts": {
        "subscribers": 0,
        "unsubscribed": 0,
        "cleaned": 0
      },
      "opt_in_type": "single",
      "opt_in_requests": []
    },
    {
      "id": 8,
      "name": "Pizza Campaign",
      "email_digest": "myemail14@gmail.com",
      "email_subscribe": null,
      "email_unsubscribe": null,
      "first_optin_message": "",
      "second_optin_message": "",
      "message_help": null,
      "message_stop": null,
      "message_reply": null,
      "message_already_subscribed": null,
      "message_yes": null,
      "keyword_names": [],
      "counts": {
        "subscribers": 0,
        "unsubscribed": 0,
        "cleaned": 0
      },
      "opt_in_type": "single",
      "opt_in_requests": []
    },
    {
      "id": 9,
      "name": "Pizza Campaign",
      "email_digest": "myemail15@gmail.com",
      "email_subscribe": null,
      "email_unsubscribe": null,
      "first_optin_message": "",
      "second_optin_message": "",
      "message_help": null,
      "message_stop": null,
      "message_reply": null,
      "message_already_subscribed": null,
      "message_yes": null,
      "keyword_names": ["NEWHOTELS"],
      "counts": {
        "subscribers": 0,
        "unsubscribed": 0,
        "cleaned": 0
      },
      "opt_in_type": "single",
      "opt_in_requests": []
    }
  ]
}
```

This endpoint retrieves a list of all lists owned by the current account.

### HTTP Request

`GET https://app.tatango.com/api/v2/lists`

## Retrieve List

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/<ID>')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Get.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/<ID>" -X GET \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open("GET", "https://app.tatango.com/api/v2/lists/<ID>", false);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
request.send(null);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "list": {
    "id": 2,
    "name": "Book Campaign",
    "email_digest": "myemail2@gmail.com",
    "email_subscribe": null,
    "email_unsubscribe": null,
    "first_optin_message": "",
    "second_optin_message": "",
    "message_help": null,
    "message_stop": null,
    "message_reply": null,
    "message_already_subscribed": null,
    "message_yes": null,
    "keyword_names": [],
    "counts": {
      "subscribers": 0,
      "unsubscribed": 0,
      "cleaned": 0
    },
    "opt_in_type": "single",
    "opt_in_requests": []
  }
}
```

This endpoint retrieves a specific list.

### HTTP Request

`GET https://app.tatango.com/api/v2/lists/<ID>`

### URL Parameters

| Parameter | Description                    |
| --------- | ------------------------------ |
| ID        | The ID of the list to retrieve |

## Configure List Opt-In Type

> Setting the opt-in type to "double" with a single opt_in_requests:

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/<ID>/opt_in_settings')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Put.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"opt_in_type":"double","opt_in_requests":[{"collected_data":"zip_code","request_message":"Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","retry_message":"Incorrect zip code. Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","follow_up":true,"follow_up_hour":2,"no_response_message":"Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","opt_in_message":null,"second_opt_in_message":null,"success_action":"nextrequest"},{"collected_data":"email_address","request_message":"Thank you! Reply with email address for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","retry_message":"Incorrect email. Reply with email address for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","follow_up":true,"follow_up_hour":24,"no_response_message":"Reply with email address for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","opt_in_message":null,"second_opt_in_message":null,"success_action":"nextrequest"},{"collected_data":"first_name","request_message":"Thank you! Reply with first name for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","retry_message":"Incorrect name. Reply with your first name for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","follow_up":true,"follow_up_hour":24,"no_response_message":"Reply with your first name for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","opt_in_message":null,"second_opt_in_message":null,"success_action":"nextrequest"},{"collected_data":"yes","request_message":"Thank you! Reply YES for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","retry_message":"Response not understood. Reply YES for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","follow_up":false,"follow_up_hour":null,"opt_in_message":"ACME Retail: You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com","second_opt_in_message":"ACME Retail: Welcome back! You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com","opt_in_message":"ACME Retail: You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com","second_opt_in_message":"ACME Retail: Welcome back! You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com","success_action":"optinsubscriber"}]})
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/<ID>/opt_in_settings" -d '{"opt_in_type":"double","opt_in_requests":[{"collected_data":"zip_code","request_message":"Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","retry_message":"Incorrect zip code. Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","follow_up":true,"follow_up_hour":2,"no_response_message":"Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","opt_in_message":null,"second_opt_in_message":null,"success_action":"nextrequest"},{"collected_data":"email_address","request_message":"Thank you! Reply with email address for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","retry_message":"Incorrect email. Reply with email address for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","follow_up":true,"follow_up_hour":24,"no_response_message":"Reply with email address for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","opt_in_message":null,"second_opt_in_message":null,"success_action":"nextrequest"},{"collected_data":"first_name","request_message":"Thank you! Reply with first name for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","retry_message":"Incorrect name. Reply with your first name for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","follow_up":true,"follow_up_hour":24,"no_response_message":"Reply with your first name for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","opt_in_message":null,"second_opt_in_message":null,"success_action":"nextrequest"},{"collected_data":"yes","request_message":"Thank you! Reply YES for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","retry_message":"Response not understood. Reply YES for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","follow_up":false,"follow_up_hour":null,"opt_in_message":"ACME Retail: You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com","second_opt_in_message":"ACME Retail: Welcome back! You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com","opt_in_message":"ACME Retail: You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com","second_opt_in_message":"ACME Retail: Welcome back! You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com","success_action":"optinsubscriber"}]}' -X PUT \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "PUT",
  "https://app.tatango.com/api/v2/lists/<ID>/opt_in_settings",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({
  opt_in_type: "double",
  opt_in_requests: [
    {
      collected_data: "zip_code",
      request_message:
        "Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      retry_message:
        "Incorrect zip code. Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      follow_up: true,
      follow_up_hour: 2,
      no_response_message:
        "Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      opt_in_message: null,
      second_opt_in_message: null,
      success_action: "nextrequest",
    },
    {
      collected_data: "email_address",
      request_message:
        "Thank you! Reply with email address for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      retry_message:
        "Incorrect email. Reply with email address for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      follow_up: true,
      follow_up_hour: 24,
      no_response_message:
        "Reply with email address for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      opt_in_message: null,
      second_opt_in_message: null,
      success_action: "nextrequest",
    },
    {
      collected_data: "first_name",
      request_message:
        "Thank you! Reply with first name for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      retry_message:
        "Incorrect name. Reply with your first name for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      follow_up: true,
      follow_up_hour: 24,
      no_response_message:
        "Reply with your first name for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      opt_in_message: null,
      second_opt_in_message: null,
      success_action: "nextrequest",
    },
    {
      collected_data: "yes",
      request_message:
        "Thank you! Reply YES for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      retry_message:
        "Response not understood. Reply YES for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      follow_up: false,
      follow_up_hour: null,
      opt_in_message:
        "ACME Retail: You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com",
      second_opt_in_message:
        "ACME Retail: Welcome back! You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com",
      opt_in_message:
        "ACME Retail: You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com",
      second_opt_in_message:
        "ACME Retail: Welcome back! You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com",
      success_action: "optinsubscriber",
    },
  ],
});
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "Opt in settings updated",
  "opt_in_type": "double",
  "opt_in_requests": [
    {
      "bypass_opt_in_response": false,
      "collected_data": "zip_code",
      "created_at": "2016-09-07T14:10:41-07:00",
      "follow_up": true,
      "follow_up_hour": 2,
      "id": 1,
      "list_id": 10,
      "no_response_message": "Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      "opt_in_message": null,
      "request_message": "Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      "retry_message": "Incorrect zip code. Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      "second_opt_in_message": null,
      "success_action": "nextrequest",
      "updated_at": "2016-09-07T14:10:41-07:00"
    },
    {
      "bypass_opt_in_response": false,
      "collected_data": "email_address",
      "created_at": "2016-09-07T14:10:41-07:00",
      "follow_up": true,
      "follow_up_hour": 2,
      "id": 2,
      "list_id": 10,
      "no_response_message": "Reply with email address for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      "opt_in_message": null,
      "request_message": "Thank you! Reply with email address for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      "retry_message": "Incorrect email. Reply with email address for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      "second_opt_in_message": null,
      "success_action": "nextrequest",
      "updated_at": "2016-09-07T14:10:41-07:00"
    },
    {
      "bypass_opt_in_response": false,
      "collected_data": "first_name",
      "created_at": "2016-09-07T14:10:41-07:00",
      "follow_up": true,
      "follow_up_hour": 2,
      "id": 3,
      "list_id": 10,
      "no_response_message": "Reply with your first name for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      "opt_in_message": null,
      "request_message": "Thank you! Reply with first name for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      "retry_message": "Incorrect name. Reply with your first name for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      "second_opt_in_message": null,
      "success_action": "nextrequest",
      "updated_at": "2016-09-07T14:10:41-07:00"
    },
    {
      "bypass_opt_in_response": false,
      "collected_data": "yes",
      "created_at": "2016-09-07T14:10:41-07:00",
      "follow_up": true,
      "follow_up_hour": 2,
      "id": 4,
      "list_id": 10,
      "no_response_message": null,
      "opt_in_message": "ACME Retail: You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com",
      "request_message": "Thank you! Reply YES for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      "retry_message": "Response not understood. Reply YES for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      "second_opt_in_message": "ACME Retail: Welcome back! You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com",
      "success_action": "optinsubscriber",
      "updated_at": "2016-09-07T14:10:41-07:00"
    }
  ]
}
```

> Setting the opt-in type to "double" with multiple opt_in_requests:

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/<ID>/opt_in_settings')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Put.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"opt_in_type":"double","opt_in_requests":[{"collected_data":"zip_code","request_message":"Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","retry_message":"Incorrect zip code. Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","follow_up":true,"follow_up_hour":2,"no_response_message":"Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","success_action":null}]})
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/<ID>/opt_in_settings" -d '{"opt_in_type":"double","opt_in_requests":[{"collected_data":"zip_code","request_message":"Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","retry_message":"Incorrect zip code. Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","follow_up":true,"follow_up_hour":2,"no_response_message":"Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","success_action":null}]}' -X PUT \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "PUT",
  "https://app.tatango.com/api/v2/lists/<ID>/opt_in_settings",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({
  opt_in_type: "double",
  opt_in_requests: [
    {
      collected_data: "zip_code",
      request_message:
        "Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      retry_message:
        "Incorrect zip code. Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      follow_up: true,
      follow_up_hour: 2,
      no_response_message:
        "Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      success_action: null,
    },
  ],
});
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "Opt in settings updated",
  "opt_in_type": "double",
  "opt_in_requests": [
    {
      "bypass_opt_in_response": false,
      "collected_data": "zip_code",
      "created_at": "2016-09-07T14:10:41-07:00",
      "follow_up": true,
      "follow_up_hour": 2,
      "id": 1,
      "list_id": 10,
      "no_response_message": "Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      "opt_in_message": null,
      "request_message": "Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      "retry_message": "Incorrect zip code. Reply with zip code for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
      "second_opt_in_message": null,
      "success_action": null,
      "updated_at": "2016-09-07T14:10:41-07:00"
    }
  ]
}
```

> Setting the opt-in type to "single":

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/<ID>/opt_in_settings')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Put.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"opt_in_type":"single","first_optin_message":"ACME Retail: You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com","second_optin_message":"ACME Retail: Welcome back! You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com"})
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/<ID>/opt_in_settings" -d '{"opt_in_type":"single","first_optin_message":"ACME Retail: You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com","second_optin_message":"ACME Retail: Welcome back! You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com"}' -X PUT \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "PUT",
  "https://app.tatango.com/api/v2/lists/<ID>/opt_in_settings",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({
  opt_in_type: "single",
  first_optin_message:
    "ACME Retail: You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com",
  second_optin_message:
    "ACME Retail: Welcome back! You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com",
});
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "opt_in_type": "single",
  "first_optin_message": "ACME Retail: You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com",
  "second_optin_message": "ACME Retail: Welcome back! You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com"
}
```

This endpoint configures an opt-in type for a list.

### HTTP Request

`PUT https://app.tatango.com/api/v2/lists/<ID>/opt_in_settings`

### URL Parameters

| Parameter | Description                  |
| --------- | ---------------------------- |
| ID        | The ID of the list to change |

### JSON Parameters (JSON Object)

| Parameter                              | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| bypass_opt_in_response                 | If this is set to true, then the usual "first_optin_message" or "second_optin_message" that Tatango sends when someone completes the opt-in process for a list, is not sent. Customers may use this functionality if they prefer to use a scheduled after opt-in message to welcome subscribers, rather than the "first_optin_message" or "second_optin_message".                                                                                                                         |
| opt_in_type                            | Opt in type (may be either "single" or "double")<br/><br />"single" - This opt-in type is used when you want the user to subscribe to a designated list by simply texting your opt-in keyword to your short code.<br/><br />"double" - This opt-in type is used when you want the user to provide you additional information such as email, name, zip codes, etc., after texting your opt-in keyword to your short code, but before subscribing them to a designated list.                |
| first_optin_message                    | This message is sent to a phone number after they've succesfully completed the single opt-in process for a specific list, and at no point in the past has been subscribed to the list. (only used with single opt-ins)<br/><br />Example Message: "ACME Retail: You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com                                                                                           |
| second_optin_message                   | This message is sent to a phone number after they've succesfully completed the single opt-in process for a specific list, and at some point in the past has been subscribed to the list. This happens when a phone number opts-in, opts-out, then opts-in again. (only used with single opt-ins)<br/><br />Example Message: "ACME Retail: Welcome back! You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com"  |
| opt_in_requests[collected_data]        | Array of opt-in requests, which designate the type of information you'd like a phone number to respond to the message [request_message] with. (only used with double opt-ins)<br /><br/><ul><li>"zip_code"</li><li>"email_address"</li><li>"first_name"</li><li>"yes"</li></ul>                                                                                                                                                                                                           |
| opt_in_requests[request_message]       | This message is received by a phone number after they text your opt-in keyword, and the opt_in_type is set as "double". It's critical in this message that you ask the user to respond back with whatever information you've set in [collected_data].<br /><br />Example Message: "ACME Retail: Reply YES for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com"                                                         |
| opt_in_requests[retry_message]         | If a phone number's response to the message [request_message] isn't valid, based on the information you're trying to collect based on [collected_data], this is the message that will be sent back in response.<br /><br />Example Message: "Response not understood. Reply YES for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com"                                                                                   |
| opt_in_requests[follow_up]             | If a phone number doesn't respond to [request_message], you have the option of sending a follow up message, which is [no_response_message], to re-request the information you're asking them for. (may be either "true" or "false")                                                                                                                                                                                                                                                       |
| opt_in_requests[follow_up_hour]        | If [follow_up] is "true" it's required that you set an amount of hours to have Tatango follow up with a phone number, if they don't respond to the [request_message]. The message that is sent to follow up, is [no_response_message].                                                                                                                                                                                                                                                    |
| opt_in_requests[no_response_message]   | This is the message sent to a phone number that doesn't respond to [request_message] after the amount of hours designated with [follow_up_hour], to re-request the information you're asking them for. (only used if [follow_up] is "true")<br/><br/>Example Message: "No response received. Reply YES for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com."                                                           |
| opt_in_requests[success_action]        | Use either "nextrequest" or "optinsubscriber".<br /><br />"nextrequest" - This option allows you to collect additional information from a user, before subscribing them to a designated list.<br /><br />"optinsubscriber" - This option ends the opt-in process, and subscribes the user to a designated list. (Required on last opt-in request)                                                                                                                                         |
| opt_in_requests[opt_in_message]        | This message is sent to a phone number after they've succesfully completed the double opt-in process for a specific list, and at no point in the past has been subscribed to the list. (only used with double opt-ins)<br /><br />Example Message: "ACME Retail: You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com"                                                                                         |
| opt_in_requests[second_opt_in_message] | This message is sent to a phone number after they've succesfully completed the double opt-in process for a specific list, and at some point in the past has been subscribed to the list. This happens when a phone number opts-in, opts-out, then opts-in again. (only used with double opt-ins)<br /><br />Example Message: "ACME Retail: Welcome back! You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com" |

## Creating a New List

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Post.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"list":{"name":"My awesome list","message_yes":"ACME Retail: Reply YES for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","message_help":"ACME Retail: Recurring SMS/MMS msgs. Text STOP 2 end. Msg&data rates may apply. Terms apply 12345-info.com. Msging help: help@12345-info.com","message_stop":"ACME Retail: You have been unsubscribed and will not receive any more messages.","message_reply":"ACME Retail: Thank you for your response. Reply STOP to end, HELP for help. Msg&data rates may apply. Terms apply 12345-info.com","message_already_subscribed":"ACME Retail: You already agreed to recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com","first_optin_message":"ACME Retail: You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com","second_optin_message":"ACME Retail: Welcome back! You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com","email_digest":"myemail18@gmail.com","email_subscribe":true,"email_unsubscribe":true}})
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/" -d '{"list":{"name":"My awesome list","message_yes":"ACME Retail: Reply YES for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com","message_help":"ACME Retail: Recurring SMS/MMS msgs. Text STOP 2 end. Msg&data rates may apply. Terms apply 12345-info.com. Msging help: help@12345-info.com","message_stop":"ACME Retail: You have been unsubscribed and will not receive any more messages.","message_reply":"ACME Retail: Thank you for your response. Reply STOP to end, HELP for help. Msg&data rates may apply. Terms apply 12345-info.com","message_already_subscribed":"ACME Retail: You already agreed to recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com","first_optin_message":"ACME Retail: You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com","second_optin_message":"ACME Retail: Welcome back! You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com","email_digest":"myemail18@gmail.com","email_subscribe":true,"email_unsubscribe":true}}' -X POST \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open("POST", "https://app.tatango.com/api/v2/lists/", false);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({
  list: {
    name: "My awesome list",
    message_yes:
      "ACME Retail: Reply YES for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
    message_help:
      "ACME Retail: Recurring SMS/MMS msgs. Text STOP 2 end. Msg&data rates may apply. Terms apply 12345-info.com. Msging help: help@12345-info.com",
    message_stop:
      "ACME Retail: You have been unsubscribed and will not receive any more messages.",
    message_reply:
      "ACME Retail: Thank you for your response. Reply STOP to end, HELP for help. Msg&data rates may apply. Terms apply 12345-info.com",
    message_already_subscribed:
      "ACME Retail: You already agreed to recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com",
    first_optin_message:
      "ACME Retail: You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com",
    second_optin_message:
      "ACME Retail: Welcome back! You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com",
    email_digest: "myemail18@gmail.com",
    email_subscribe: true,
    email_unsubscribe: true,
  },
});
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "List created",
  "list": {
    "id": 11,
    "name": "My awesome list",
    "email_digest": "myemail18@gmail.com",
    "email_subscribe": true,
    "email_unsubscribe": true,
    "first_optin_message": "ACME Retail: You already agreed to recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg & data rates may apply. Terms apply 12345-info.com",
    "second_optin_message": "ACME Retail: Welcome back! You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com",
    "message_help": "ACME Retail: Recurring SMS/MMS msgs. Text STOP 2 end. Msg&data rates may apply. Terms apply 12345-info.com. Msging help: help@12345-info.com",
    "message_stop": "ACME Retail: You have been unsubscribed and will not receive any more messages.",
    "message_reply": "ACME Retail: Thank you for your response. Reply STOP to end, HELP for help. Msg&data rates may apply. Terms apply 12345-info.com",
    "message_already_subscribed": "ACME Retail: Reply YES for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com",
    "message_yes": "ACME Retail: Recurring SMS/MMS msgs. Text STOP 2 end. Msg&data rates may apply. Terms apply 12345-info.com. Msging help: help@12345-info.com",
    "keyword_names": ["JOIN", "SAVE", "COUPONS", "SALE"],
    "counts": {
      "subscribers": 0,
      "unsubscribed": 0,
      "cleaned": 0
    },
    "opt_in_type": "single",
    "opt_in_requests": []
  }
}
```

This endpoint creates a new list.

Note: the following settings cannot be modified via the API:

- API Confirmation Resend Block Timeout
- Resubscribers

### HTTP Request

`POST https://app.tatango.com/api/v2/lists/`

### JSON Parameters (JSON Object)

| Parameter                        | Description                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| list[name]                       | List names are to help you distinguish which list is which, and are only visible to you, and are never seen by users. (Limit 25 characters)                                                                                                                                                                                                                                                                                                        |
| list[message_yes]                | This message is sent to a user when their mobile number is added to a list through the API. Users must respond “YES” or “Y” to this message, to be subscribed. <br /><br />Example Message: "ACME Retail: Reply YES for recurring autodialed SMS/MMS marketing msgs. No purchase rqd. Msg&data rates may apply. Terms apply 12345-info.com"                                                                                                        |
| list[message_help]               | This is the message that is sent back to users when they respond to any of your messages with the word "HELP".<br /><br />Example Message: ACME Retail: Recurring SMS/MMS msgs. Text STOP 2 end. Msg&data rates may apply. Terms apply 12345-info.com. Msging help: help@12345-info.com"                                                                                                                                                           |
| list[message_stop]               | This is the message that is sent back to users when they respond to any of your messages with the word "STOP".<br /><br />Example Message: "ACME Retail: You have been unsubscribed and will not receive any more messages."                                                                                                                                                                                                                       |
| list[message_reply]              | This is the message that is sent back to subscribers when they respond to a mass message that you send them.<br /><br />Example Message: "ACME Retail: Thank you for your response. Reply STOP to end, HELP for help. Msg&data rates may apply. Terms apply 12345-info.com"                                                                                                                                                                        |
| list[message_already_subscribed] | This is the message that is sent back to users when they're attempting to opt-in, but they're already subscribed to the list.<br /><br />Example Message: "ACME Retail: You already agreed to recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com"                                                                                                                                           |
| list[first_optin_message]        | This message is sent to a phone number after they've succesfully completed the opt-in process for a specific list, and at no point in the past has been subscribed to the list.<br /><br />Example Message: "ACME Retail: You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com"                                                                                         |
| list[second_optin_message]       | This message is sent to a phone number after they've succesfully completed the opt-in process for a specific list, and at some point in the past has been subscribed to the list. This happens when a phone number opts-in, opts-out, then opts-in again.<br /><br />Example Message: "ACME Retail: Welcome back! You agreed to receive recurring SMS/MMS msgs. Txt STOP 2 end, HELP 4 help. Msg&data rates may apply. Terms apply 12345-info.com" |
| list[email_digest]               | Receive a daily email with a list of phone numbers that subscribed and unsubscribed from a designated list. Leave blank if you dont want to receive this daily email.                                                                                                                                                                                                                                                                              |
| list[email_subscribe]            | Receive an email immediately when you get a new subscriber for a designated list. Email contains phone number of new subscriber. Leave blank if you dont want to receive this email.                                                                                                                                                                                                                                                               |
| list[email_unsubscribe]          | Receive an email immediately when a subscriber unsubscribes from a designated list. Email contains phone number of lost subscriber. Leave blank if you dont want to receive this email.                                                                                                                                                                                                                                                            |
| list[keyword_names]              | (optional) An array of keywords to associate to the list. See the FAQs below for keyword limitations.                                                                                                                                                                                                                                                                                                                                              |

<aside class="success">
  FAQs
  <ul>
    <li>
      <em>What are the limitations for a keyword?</em>
      <p>
         <ul>
           <li>A keyword must contain at least two characters and no more than 15 characters.</li>
           <li>Keywords are not case sensitive. FOO will match foo and FOO and Foo.</li>
           <li>You can't use obscene words. We're not going to spell them out here.</li>
         </ul>
      </p>
    </li>
    <li>
       <em>Are keywords case sensitive?</em>
       <p>No. The system checks for duplicate keywords by transforming all keywords to uppercase before performing matching algorithms.</p>
    </li>
    <li>
      <em>What happens if the keyword isn't available?</em>
      <p>The response from the API will be a 422 error with the response body looking like this: {"status":"error","error":"invalid keyword names: EXISTINGKW"}</p>
    </li>
    <li>
      <em>What happens if the keyword isn't available?</em>
      <p>Yes.  By utilizing <a href="#testing-keyword-availability-for-list">this</a> endpoint. The response will either be 200 OK {"status":"OK","keyword_name":"available"} or 200 OK  {"status":"OK","keyword_name":"unavailable","error":"Name is in use"}.</p>
    </li>
    <li>
      <em>Can I add multiple keywords to a list?</em>
      <p>Yes.  The keyword_names parameter would need to be an array, like this: {"keyword_names":["TEST","KEYWORD","NAMES"]}, of valid, not-already used, keywords.</p>
    </li>
    <li>
      <em>What is a REPLY Response?</em>
      <p>REPLY Response is the response sent to the subscriber if they respond to the message with the word REPLY.</p>
    </li>
  </ul>
</aside>

## Destroying a List

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Delete.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID" -d '' -X DELETE \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open("DELETE", "https://app.tatango.com/api/v2/lists/", false);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({ list: { name: "My awesome list" } });
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "List Destroyed"
}
```

This endpoint destroys a list.

### HTTP Request

`DELETE https://app.tatango.com/api/v2/lists/ID`

### URL Parameters

| Parameter | Description              |
| --------- | ------------------------ |
| ID        | ID of the list to delete |

## Setting(Updating) Keywords for a List

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/<ID>/keywords')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Put.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"keyword_names":["TEST","KEYWORD","NAMES"]}
)
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/<ID>/keywords" -d '{"keyword_names":["TEST","KEYWORD","NAMES"]}' -X PUT \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "PUT",
  "https://app.tatango.com/api/v2/lists/<ID>/opt_in_settings",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({ keyword_names: ["TEST", "KEYWORD", "NAMES"] });
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "Keywords changed",
  "keyword_names": ["TEST", "KEYWORD", "NAMES"]
}
```

This endpoint sets or updates keywords for a list.

### HTTP Request

`PUT https://app.tatango.com/api/v2/lists/<ID>/keywords`

### URL Parameters

| Parameter | Description                  |
| --------- | ---------------------------- |
| ID        | The ID of the list to change |

### JSON Parameters (JSON Object)

| Parameter     | Description            |
| ------------- | ---------------------- |
| keyword_names | Array of keyword names |

<aside class="success">
  <ul>
    <li>
      <em>What are the limitations for a keyword?</em>
      <p>A keyword must contain at least two characters.</p>
    </li>
    <li>
       <em>Are keywords case sensitive?</em>
       <p>No. The system checks for duplicate keywords by transforming all keywords to uppercase before performing matching algorithms.</p>
    </li>
    <li>
      <em>What happens if the keyword isn't available?</em>
      <p>The response from the API will be a 422 error with the response body looking like this: {"status":"error","error":"invalid keyword names: EXISTINGKW"}</p>
    </li>
    <li>
      <em>What happens if the keyword isn't available?</em>
      <p>Yes.  By utilizing <a href="#testing-keyword-availability-for-list">this</a> endpoint. The response will either be 200 OK {"status":"OK","keyword_name":"available"} or 200 OK  {"status":"OK","keyword_name":"unavailable","error":"Name is in use"}.</p>
    </li>
  </ul>
</aside>

## Updating a List

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Put.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"list":{"name":"Name"}})
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/" -d '{"list":{"name":"Name"}}' -X PUT \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open("PUT", "https://app.tatango.com/api/v2/lists/", false);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({ list: { name: "Name" } });
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "list": {
    "id": 1,
    "name": "Name",
    "email_digest": "myemail0@gmail.com",
    "email_subscribe": null,
    "email_unsubscribe": null,
    "first_optin_message": "",
    "second_optin_message": "",
    "message_help": null,
    "message_stop": null,
    "message_reply": null,
    "message_already_subscribed": null,
    "message_yes": null,
    "keyword_names": [],
    "counts": {
      "subscribers": 0,
      "unsubscribed": 0,
      "cleaned": 0
    },
    "opt_in_type": "single",
    "opt_in_requests": []
  }
}
```

This endpoint updates a list.

Note: the following settings cannot be modified via the API:

- API Confirmation Resend Block Timeout
- Resubscribers

### HTTP Request

`PUT https://app.tatango.com/api/v2/lists/ID`

### URL Parameters

| Parameter | Description                  |
| --------- | ---------------------------- |
| ID        | The ID of the list to change |

### JSON Parameters (JSON Object)

| Parameter                        | Description                                                                         |
| -------------------------------- | ----------------------------------------------------------------------------------- |
| list[name]                       | List name                                                                           |
| list[message_yes]                | API Opt-In Confirmation Request                                                     |
| list[message_help]               | HELP Response                                                                       |
| list[message_stop]               | STOP Response                                                                       |
| list[message_reply]              | REPLY Response                                                                      |
| list[message_already_subscribed] | Already Subscribed Response                                                         |
| list[first_optin_message]        | First Opt In Message                                                                |
| list[second_optin_message]       | Second Opt In Message                                                               |
| list[email_digest]               | Email to send email digest to. Leave blank if you dont want to receive              |
| list[email_subscribe]            | Email to send subscribe notifications to. Leave blank if you dont want to receive   |
| list[email_unsubscribe]          | Email to send unsubscribe notifications to. Leave blank if you dont want to receive |

# Subscribers

## Adding a Subscriber

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID/subscribers')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Post.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"subscriber":{"phone_number":"2141234567","first_name":"John","last_name":"Doe","email":"johndoe@domain.com","birthdate":"19780728","zip_code":"52421","gender":"Male","custom_field_key":"custom_value"}});
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID/subscribers" -d '{"subscriber":{"phone_number":"2141234567","first_name":"John","last_name":"Doe","email":"johndoe@domain.com","birthdate":"19780728","zip_code":"52421","gender":"Male","custom_field_key":"custom_value"}}' -X POST \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "POST",
  "https://app.tatango.com/api/v2/lists/ID/subscribers",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({
  subscriber: {
    phone_number: "2141234567",
    first_name: "John",
    last_name: "Doe",
    email: "johndoe@domain.com",
    birthdate: "19780728",
    zip_code: "52421",
    gender: "Male",
    custom_field_key: "custom_value",
  },
});
request.send(data);
```

> The above command returns possible JSON responses structured like this:

```json
{
   "status":"Subscriber being added to campaign pending confirmation",
   "subscriber":{
      "phone_number":"2141234567",
      "first_name":"John",
      "last_name":"Doe",
      "email":"johndoe@domain.com",
      "birthdate":"19780728",
      "zip_code":"52421",
      "gender":"Male",
      "cleaned_at":null,
      "subscribed_at":"2016-09-07T14:10:53-07:00",
      "opted_out_at":"2016-09-06T16:00:00-07:00",
      "optin_in_progress":true,
      "opt_in_method":"api",
      "keyword_name":null,
      "carrier":77,
      "carrier_name":"Verizon",
      "tags":[
        "shopping",
        "music",
        "malls"
      ],
      "custom_field_key":"custom_value"
   }
}

{
   "status":"Subscriber has been added - no opt-in message was sent due to list settings.",
   "subscriber":{
      "phone_number":"2141234567",
      "first_name":"John",
      "last_name":"Doe",
      "email":"johndoe@domain.com",
      "birthdate":"19780728",
      "zip_code":"52421",
      "gender":"Male",
      "cleaned_at":null,
      "subscribed_at":"2016-09-07T14:10:53-07:00",
      "opted_out_at":"2016-09-06T16:00:00-07:00",
      "optin_in_progress":true,
      "opt_in_method":"api",
      "keyword_name":null,
      "carrier":77,
      "carrier_name":"Verizon",
      "tags":[
        "shopping",
        "music",
        "malls"
      ],
      "custom_field_key":"custom_value"
   }
}

{
   "status":"Subscriber has already been sent opt-in message for this campaign.",
   "subscriber":{
      "phone_number":"2141234567",
      "phone_number":"2141234567",
      "first_name":"John",
      "last_name":"Doe",
      "email":"johndoe@domain.com",
      "birthdate":"19780728",
      "zip_code":"52421",
      "gender":"Male",
      "cleaned_at":null,
      "subscribed_at":"2016-09-07T14:10:53-07:00",
      "opted_out_at":"2016-09-06T16:00:00-07:00",
      "optin_in_progress":true,
      "opt_in_method":"api",
      "keyword_name":null,
      "carrier":77,
      "carrier_name":"Verizon",
      "tags":[
        "shopping",
        "music",
        "malls"
      ],
      "custom_field_key":"custom_value"
   }
}

{
   "status":"Subscriber is already subscribed to this campaign.",
   "subscriber":{
      "phone_number":"2141234567",
      "phone_number":"2141234567",
      "first_name":"John",
      "last_name":"Doe",
      "email":"johndoe@domain.com",
      "birthdate":"19780728",
      "zip_code":"52421",
      "gender":"Male",
      "cleaned_at":null,
      "subscribed_at":"2016-09-07T14:10:53-07:00",
      "opted_out_at":"2016-09-06T16:00:00-07:00",
      "optin_in_progress":true,
      "opt_in_method":"api",
      "keyword_name":null,
      "carrier":77,
      "carrier_name":"Verizon",
      "tags":[
        "shopping",
        "music",
        "malls"
      ],
      "custom_field_key":"custom_value"
   }
}

{
   "status":"Subscriber being added to campaign pending confirmation",
   "subscriber":{
      "phone_number":"2141234567",
      "phone_number":"2141234567",
      "first_name":"John",
      "last_name":"Doe",
      "email":"johndoe@domain.com",
      "birthdate":"19780728",
      "zip_code":"52421",
      "gender":"Male",
      "cleaned_at":null,
      "subscribed_at":"2016-09-07T14:10:53-07:00",
      "opted_out_at":"2016-09-06T16:00:00-07:00",
      "optin_in_progress":true,
      "opt_in_method":"api",
      "keyword_name":null,
      "carrier":77,
      "carrier_name":"Verizon",
      "tags":[
        "shopping",
        "music",
        "malls"
      ],
      "global_carrier_id": "100313",
      "global_carrier_name": "Verizon Wireless",
      "custom_field_key":"custom_value"
   }
}
```

This endpoint adds a subscriber to a list.

### HTTP Request

`POST https://app.tatango.com/api/v2/lists/ID/subscribers`

### URL Parameters

| Parameter | Description    |
| --------- | -------------- |
| ID        | ID of the list |

### JSON Parameters (JSON Object)

| Parameter                          | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| subscriber[phone_number]           | The wireless phone number of the subscriber.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| subscriber[first_name]             | (optional) First name - char(50)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| subscriber[last_name]              | (optional) Last name - char(50)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| subscriber[email]                  | (optional) Email - char(50)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| subscriber[birthdate]              | (optional) Birthdate - int(8)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| subscriber[zip_code]               | (optional) ZIP code - char(6)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| subscriber[gender]                 | (optional) Gender - char('Male' or 'Female')                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
| subscriber[bypass_opt_in_process]  | When true, the phone number will be added to the list without using the double opt-in method. This means numbers will not receive a "Reply YES to subscribe" message. This option does not suppress the message sent immediately after a phone number has been added to a list, confirming their subscription to the list. To disable the double opt-in method, and the message confirming a phone numbers subscription to a list, both subscriber[bypass_opt_in_process] and subscriber[bypass_opt_in_response] will have to be true. |
| subscriber[bypass_opt_in_response] | When true, suppress the message sent immediately after a phone number has been added to a list, confirming their subscription to the list. This option is independent of subscriber[bypass_opt_in_process].                                                                                                                                                                                                                                                                                                                            |
| subscriber[tags]                   | (optional) List of tags, comma separated, for example: 'vip customer, card holder, daily alerts'                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| subscriber[custom_field_key]       | (optional) Custom data value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |

### Responses Explained

| Key                 | Description                                                                                                                  |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| phone_number        | The wireless phone number of the subscriber.                                                                                 |
| cleaned_at          | If this subscriber was automatically unsubscribed from a list, then the date and time of that action will be displayed here. |
| subscribed_at       | The data that this subscriber first subscribed to this specific list.                                                        |
| opted_out_at        | The data that this subscriber last unsubscribed from this specific list.                                                     |
| opt_in_method       | The original opt-in method used by this subscriber to opt-in to this specific list.                                          |
| keyword_name        | If the subscriber opted-in by texting a keyword, that keyword they used will be displayed here.                              |
| carrier             | The ID of the wireless carrier for this specific subscriber.                                                                 |
| carrier_name        | The name of the wireless carrier for this specific subscriber.                                                               |
| global_carrier_id   | The ID of the global wireless carrier for this specific subscriber.                                                          |
| global_carrier_name | The name of the global wireless carrier for this specific subscriber.                                                        |

<aside>
<h3>FAQ About This Endpoint</h3>
  <ul>
    <li>
      <em>What happens when we use the add subscriber API to add a home phone number (i.e. non-cellular)?</em>
      <p>You will receive the message "Bad phone number: landline or unreachable carrier" with the status code 422.</p>
    </li>
    <li>
      <em>What happens when we use the add subscriber API to add a phone number that is currently unsubscribed from the list?</em>
      <p>We will initiate the process of resubscribing the phone number to the list.</p>
    </li>
    <li>
      <em>What happens when we use the add subscriber API to add a phone number that is already subscribed to the list?</em>
      <p>A 200 OK is returned and no changes are made the subscriber.</p>
    </li>
    <li>
      <em>Can I request something other than a reply of YES to opt-in when opting into an API?</em>
      <p>No. The reply is currently configured to YES.</p>
    </li>
    <li>
      <em>Can I add a subscriber via API with custom data for that subscriber?</em>
      <p>Yes. The optional parameters are listed for this API endpoint.</p>
    </li>
    <li>
      <em>For subscriber fields like name, birthday, etc., are there any limitations on what we can use, like character limit, only certain characters, etc?</em>
      <p>Yes. All optional parameters' limitations are noted - see the JSON parameters above.</p>
    </li>
    <li>
      <em>In what format should phone numbers be sent?</em>
      <p>The phone number should be a continuous string of ten digits - with no dashes and no country code (e.g. "2065551111").</p>
    </li>
    <li>
      <em>If an account has multiple lists, and a phone number has opted-out, or been cleaned from one list, can we use the API to add them to a new list?</em>
      <p>Yes - each list is a separate entity.</p>
    </li>
  </ul>
</aside>

## Getting a Subscriber

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID/subscribers/SUBSCRIBER_ID')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Get.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID/subscribers/SUBSCRIBER_ID" -d '' -X GET \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "GET",
  "https://app.tatango.com/api/v2/lists/ID/subscribers/SUBSCRIBER_ID",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
request.send(null);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "subscriber": {
    "phone_number": "2141234567",
    "first_name": "John",
    "last_name": "Doe",
    "email": "johndoe@mydomain.com",
    "birthdate": "19780728",
    "zip_code": "5124",
    "gender": "Male",
    "cleaned_at": null,
    "subscribed_at": "2016-09-07T14:10:53-07:00",
    "opted_out_at": null,
    "optin_in_progress": false,
    "opt_in_method": "api",
    "keyword_name": null,
    "carrier": 77,
    "carrier_name": "Verizon",
    "tags": ["shopping", "malls", "deals"],
    "global_carrier_id": "100313",
    "global_carrier_name": "Verizon Wireless",
    "total_messages_received": 121
  }
}
```

This endpoint returns information about a current subscriber.

### HTTP Request

`GET https://app.tatango.com/api/v2/lists/ID/subscribers/SUBSCRIBER_ID`

### URL Parameters

| Parameter     | Description                         |
| ------------- | ----------------------------------- |
| ID            | ID of the list                      |
| SUBSCRIBER_ID | ID of the subscriber (phone number) |

### Responses Explained

| Key                     | Description                                                                                                                  |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| phone_number            | The wireless phone number of the subscriber.                                                                                 |
| cleaned_at              | If this subscriber was automatically unsubscribed from a list, then the date and time of that action will be displayed here. |
| subscribed_at           | The data that this subscriber first subscribed to this specific list.                                                        |
| opted_out_at            | The data that this subscriber last unsubscribed from this specific list.                                                     |
| opt_in_method           | The original opt-in method used by this subscriber to opt-in to this specific list.                                          |
| keyword_name            | If the subscriber opted-in by texting a keyword, that keyword they used will be displayed here.                              |
| carrier                 | The ID of the wireless carrier for this specific subscriber.                                                                 |
| carrier_name            | The name of the wireless carrier for this specific subscriber.                                                               |
| global_carrier_id       | The ID of the global wireless carrier for this specific subscriber.                                                          |
| global_carrier_name     | The name of the global wireless carrier for this specific subscriber.                                                        |
| total_messages_received | The total amount of mass messages this specific subscriber has received over their lifetime from this specific list.         |

## Updating a Subscriber

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID/subscribers/SUBSCRIBER_ID')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Put.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"subscriber":{"first_name":"John","last_name":"Doe"}})
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID/subscribers/SUBSCRIBER_ID" -d '{"subscriber":{"first_name":"John","last_name":"Doe"}}' -X PUT \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "PUT",
  "https://app.tatango.com/api/v2/lists/ID/subscribers/SUBSCRIBER_ID",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify(
  '{"subscriber":{"first_name":"John","last_name":"Doe", "custom_field_key": "custom_value"}}'
);
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "Subscriber has been updated.",
  "subscriber": {
    "phone_number": "2141234567",
    "first_name": "John",
    "last_name": "Doe",
    "email": "",
    "birthdate": "",
    "zip_code": "",
    "gender": null,
    "cleaned_at": null,
    "subscribed_at": "2016-09-07T14:10:54-07:00",
    "opted_out_at": "2016-09-06T16:00:00-07:00",
    "optin_in_progress": true,
    "opt_in_method": "api",
    "keyword_name": null,
    "carrier": 77,
    "carrier_name": "Verizon",
    "tags": [],
    "global_carrier_id": "100313",
    "global_carrier_name": "Verizon Wireless",
    "custom_field_key": "custom_value"
  }
}
```

This endpoint updates a subscriber.

### Responses Explained

| Key                 | Description                                                                                                                  |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| phone_number        | The wireless phone number of the subscriber.                                                                                 |
| cleaned_at          | If this subscriber was automatically unsubscribed from a list, then the date and time of that action will be displayed here. |
| subscribed_at       | The data that this subscriber first subscribed to this specific list.                                                        |
| opted_out_at        | The data that this subscriber last unsubscribed from this specific list.                                                     |
| opt_in_method       | The original opt-in method used by this subscriber to opt-in to this specific list.                                          |
| keyword_name        | If the subscriber opted-in by texting a keyword, that keyword they used will be displayed here.                              |
| carrier             | The ID of the wireless carrier for this specific subscriber.                                                                 |
| carrier_name        | The name of the wireless carrier for this specific subscriber.                                                               |
| global_carrier_id   | The ID of the global wireless carrier for this specific subscriber.                                                          |
| global_carrier_name | The name of the global wireless carrier for this specific subscriber.                                                        |

<aside class="success">
  <h3>FAQS About This Endpoint</h3>
    <ul>
      <li>
        <em>If I add tags to an existing subscriber, does that add the tags to existing, or replace existing?</em>
        <p>The tags are added to any tags already applied, not replaced.</p>
      </li>
      <li>
        <em>Can I update custom subscriber data for a subscriber?</em>
        <p>Yes, the paramaters are listed below.</p>
      </li>
    </ul>
</aside>

### HTTP Request

`PUT https://app.tatango.com/api/v2/lists/ID/subscribers/SUBSCRIBER_ID`

### URL Parameters

| Parameter     | Description                         |
| ------------- | ----------------------------------- |
| ID            | ID of the list                      |
| SUBSCRIBER_ID | ID of the subscriber (phone number) |

### JSON Parameters (JSON Object)

| Parameter                    | Description                                                                                      |
| ---------------------------- | ------------------------------------------------------------------------------------------------ |
| ID                           | ID of the list                                                                                   |
| subscriber[phone_number]     | The wireless phone number of the subscriber.                                                     |
| subscriber[first_name]       | (optional) First name - char(50)                                                                 |
| subscriber[last_name]        | (optional) Last name - char(50)                                                                  |
| subscriber[email]            | (optional) Email - char(50)                                                                      |
| subscriber[birthdate]        | (optional) Birthdate - int(6)                                                                    |
| subscriber[zip_code]         | (optional) ZIP code - char(6)                                                                    |
| subscriber[gender]           | (optional) Gender - char('Male' or 'Female')                                                     |
| subscriber[tags]             | (optional) List of tags, comma separated, for example: 'vip customer, card holder, daily alerts' |
| subscriber[custom_field_key] | (optional) Custom data value                                                                     |

## Adding Multiple Tags to Multiple Subscribers

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID/bulk_taggings')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Post.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"bulk_tagging": {"phone_numbers":["2145550762","7185550549","2125550838"],"tags":["local_news","sports_news","celebrity_news","weather_news"]}});
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID/bulk_taggings" -d '{"bulk_tagging":{"phone_numbers":["2145550762","7185550549","2125550838"],"tags":["local_news","sports_news","celebrity_news","weather_news"]}}' -X POST \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "POST",
  "https://app.tatango.com/api/v2/lists/ID/bulk_taggings",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({
  bulk_tagging: {
    phone_numbers: ["2145550762", "7185550549", "2125550838"],
    tags: ["local_news", "sports_news", "celebrity_news", "weather_news"],
  },
});
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "Bulk tagging operation queued successfully.",
  "number_count": 3,
  "tag_count": 4,
  "subscribers_to_update": 3,
  "replace_tags": false,
  "not_subscribed": [
    "list of numbers passed numbers that are not subscribed, this will not display if all numbers are subscribed"
  ],
  "invalid_numbers": [
    "list of passed numbers that are invalid, this will not display if all numbers are valid"
  ]
}
```

This endpoint applies multiple tags to multiple subscribers

### Responses Explained

| Key                   | Description                                                                                                                                                                               |
| --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| number_count          | The number of phone numbers in your passed phone_numbers list                                                                                                                             |
| tag_count             | The number of tags in your passed tags list                                                                                                                                               |
| subscribers_to_update | The number of subscribed members to your list that will be updated with the new tags                                                                                                      |
| replace_tags          | If true all the tags for subscribers will be replaced with the new tags. If false it will add the new tags to the old tags                                                                |
| not_subscribed        | A list of phone numbers that were passed that are not subscribed to the defined list. If all numbers are subscribed this will not be displayed                                            |
| invalid_numbers       | A list of phone numbers that were passed in that are not valid phone numbers. An invalid number will also consist of landline phones. If all numbers are valid this will not be displayed |

### HTTP Request

`POST https://app.tatango.com/api/v2/lists/ID/bulk_taggings`

### URL Parameters

| Parameter | Description    |
| --------- | -------------- |
| ID        | ID of the list |

### JSON Parameters (JSON Object)

| Parameter                   | Description                                                                                                                                         |
| --------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| ID                          | ID of the list                                                                                                                                      |
| bulk_tagging[phone_numbers] | Array of phone numbers you want to modify. The max length of this array is 1000 values                                                              |
| bulk_tagging[tags]          | (optional) Array of tags to add. The max length of this array is 50 values                                                                          |
| bulk_tagging[replace_tags]  | (optional) Boolean value to replace tags. If it is true it will replace the old tags with the new tags. This value defaults to false if not defined |

### Other uses

You can also use this endpoint to mass remove tags from subscribers. For example if replace_tags is true and your tags list is empty it will remove all tags from your numbers list

## Unsubscribing a Subscriber

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID/subscribers/SUBSCRIBER_ID')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Delete.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID/subscribers/SUBSCRIBER_ID" -d '' -X DELETE \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "DELETE",
  "https://app.tatango.com/api/v2/lists/ID/subscribers/SUBSCRIBER_ID",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
request.send(null);
```

> The above command returns JSON structured like this:

```json
{
  "status": "successfully unsubscribed",
  "subscriber": {
    "phone_number": "2141234567",
    "first_name": "",
    "last_name": "",
    "email": "",
    "birthdate": "",
    "zip_code": "",
    "gender": null,
    "cleaned_at": null,
    "subscribed_at": "2016-09-07T14:10:53-07:00",
    "opted_out_at": "2016-09-07T14:10:54-07:00",
    "optin_in_progress": true,
    "opt_in_method": "api",
    "keyword_name": null,
    "carrier": 77,
    "carrier_name": "Verizon",
    "tags": [],
    "global_carrier_id": "100313",
    "global_carrier_name": "Verizon Wireless"
  }
}
```

This endpoint unsubscribes a subscriber.

### HTTP Request

`DELETE https://app.tatango.com/api/v2/lists/ID/subscribers/SUBSCRIBER_ID`

### URL Parameters

| Parameter     | Description                         |
| ------------- | ----------------------------------- |
| ID            | ID of the list                      |
| SUBSCRIBER_ID | ID of the subscriber (phone number) |

### Responses Explained

| Key                 | Description                                                                                                                  |
| ------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| phone_number        | The wireless phone number of the subscriber.                                                                                 |
| cleaned_at          | If this subscriber was automatically unsubscribed from a list, then the date and time of that action will be displayed here. |
| subscribed_at       | The data that this subscriber first subscribed to this specific list.                                                        |
| opted_out_at        | The data that this subscriber last unsubscribed from this specific list.                                                     |
| opt_in_method       | The original opt-in method used by this subscriber to opt-in to this specific list.                                          |
| keyword_name        | If the subscriber opted-in by texting a keyword, that keyword they used will be displayed here.                              |
| carrier             | The ID of the wireless carrier for this specific subscriber.                                                                 |
| carrier_name        | The name of the wireless carrier for this specific subscriber.                                                               |
| global_carrier_id   | The ID of the global wireless carrier for this specific subscriber.                                                          |
| global_carrier_name | The name of the global wireless carrier for this specific subscriber.                                                        |

## Get a List of Subscribed Phone Numbers

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID/subscribers')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Get.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID/subscribers" -d '' -X GET \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "GET",
  "https://app.tatango.com/api/v2/lists/ID/subscribers",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
request.send(null);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "per_page": 10,
  "count": 1,
  "page": 1,
  "pages_count": 1,
  "phone_numbers": ["2145550816"]
}
```

This endpoint gets a list of subscribed phone numbers for the requested list.

### HTTP Request

`GET https://app.tatango.com/api/v2/lists/ID/subscribers`

### URL Parameters

| Parameter | Description    |
| --------- | -------------- |
| ID        | ID of the list |

## Get a List of Unsubscribed Phone Numbers

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID/subscribers/unsubscribed')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Get.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID/subscribers/unsubscribed" -d '' -X GET \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "GET",
  "https://app.tatango.com/api/v2/lists/ID/subscribers/unsubscribed",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
request.send(null);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "per_page": 10,
  "count": 1,
  "page": 1,
  "pages_count": 1,
  "phone_numbers": ["2145550816"]
}
```

This endpoint gets a list of unsubscribed phone numbers.

### HTTP Request

`GET https://app.tatango.com/api/v2/lists/ID/subscribers/unsubscribed`

### URL Parameters

| Parameter | Description    |
| --------- | -------------- |
| ID        | ID of the list |

# Custom Fields

## Get a List of Custom Fields

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID/custom_fields')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Get.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID/custom_fields" -d '' -X GET \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "GET",
  "https://app.tatango.com/api/v2/lists/ID/custom_fields",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
request.send(null);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "custom_fields": [
    {
      "key": "some_custom_field_name",
      "pattern": "[A-Za-z0-9]",
      "max_length": 9999,
      "default_value": "The Default Value",
      "label": "The Label",
      "content_type": "text",
      "should_validate_regex_via_api": false
    }
  ]
}
```

### HTTP Request

`GET https://app.tatango.com/api/v2/lists/ID/custom_fields`

### URL Parameters

| Parameter | Description    |
| --------- | -------------- |
| ID        | ID of the list |

## Create a Custom Field

This endpoint creates a custom field.

### HTTP Request

`POST https://app.tatango.com/api/v2/lists/ID/custom_fields`

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID/custom_fields')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Post.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body(custom_field: {label: "The Label", key: "the_key", content_type: "text", max_length: 9999, pattern: "[A-Za-z0-9]", should_validate_regex_via_api: false, default_value: "The Default Value"})
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID/custom_fields" -d '{"custom_field": {"label": "The Label", "key": "the_key", "content_type": "text", "max_length": 9999, "pattern": "[A-Za-z0-9]", "should_validate_regex_via_api": false, "default_value": "The Default Value"}}' -X POST \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "POST",
  "https://app.tatango.com/api/v2/lists/ID/custom_fields",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({
  custom_field: {
    label: "The Label",
    key: "the_key",
    content_type: "text",
    max_length: 9999,
    pattern: "[A-Za-z0-9]",
    should_validate_regex_via_api: false,
    default_value: "The Default Value",
  },
});
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "custom_field": {
    "list_id": 30,
    "key": "the_key",
    "pattern": "[A-Za-z0-9]",
    "max_length": 9999,
    "default_value": "The Default Value",
    "can_insert": true,
    "can_segment": true,
    "created_at": "2023-11-22T08:14:19.000-08:00",
    "updated_at": "2023-11-22T08:14:19.000-08:00",
    "mask": null,
    "label": "The Label",
    "content_type": "text",
    "should_validate_regex_via_api": false
  }
}
```

> If there is an error, the endpoint will return the following JSON:

```json
{
  "status": "error",
  "error": "Content type string not allowed. Allowed types are: text, datetime, number"
}
```

```json
{
  "status": "error",
  "error": "Validation failed: Merge tag has already been taken, Label has already been taken"
}
```

### URL Parameters

| Parameter | Description    |
| --------- | -------------- |
| ID        | ID of the list |

### JSON Parameters (JSON Object)

| Parameter                                   | Type    | Description                                                                            |
| ------------------------------------------- | ------- | -------------------------------------------------------------------------------------- |
| custom_field[label]                         | string  | A human-readable label                                                                 |
| custom_field[key]                           | string  | The custom field key. Must only contain lower case characters, numbers and underscores |
| custom_field[content_type]                  | string  | Allowed content types are: text, datetime and number                                   |
| custom_field[max_length]                    | integer | The max length allowed for data in this custom field. Maximum value is 9999.           |
| custom_field[pattern]                       | regex   | A validation regex for the content of the data in the custom field                     |
| custom_field[should_validate_regex_via_api] | boolean | Whether or not the pattern regex should be validated via the API                       |
| custom_field[default_value]                 | string  | A default value for when none is provided. Must adhere to the `pattern` regex.         |

## Deleting a Custom Field

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID/custom_fields')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Delete.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body(key: "some_key")
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID/custom_fields" -d '{"key": "some_key"}' -X DELETE \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "DELETE",
  "https://app.tatango.com/api/v2/lists/ID/custom_fields",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({
  key: "some_key",
});
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "Custom field successfully deleted"
}
```

This endpoint deletes a custom field.

### HTTP Request

`DELETE https://app.tatango.com/api/v2/lists/ID/custom_fields`

### URL Parameters

| Parameter | Description    |
| --------- | -------------- |
| ID        | ID of the list |

### JSON Parameters (JSON Object)

| Key | Description          |
| --- | -------------------- |
| key | The custom field key |

# Tags

## Deleting a tag from all subscribers

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID/tags')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Delete.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body(tags: ["some_tag", "some_other_tag"])
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID/tags" -d '{"tags": ["some_tag", "some_other_tag"]}' -X DELETE \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open("DELETE", "https://app.tatango.com/api/v2/lists/ID/tags", false);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({
  tags: ["some_tag", "some_other_tag"],
});
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "Tags enqueued for deletion"
}
```

This endpoint deletes tags from all subscribers with the tag. After the endpoint is called, please allow up to 10 minutes for the tags provided to be removed from all subscribers.

### HTTP Request

`DELETE https://app.tatango.com/api/v2/lists/ID/tags`

### URL Parameters

| Parameter | Description    |
| --------- | -------------- |
| ID        | ID of the list |

### JSON Parameters (JSON Object)

| Key  | Description           |
| ---- | --------------------- |
| tags | An array of tag names |

# Messaging

The following characters can be used: a-z, A-Z, 0-9 and these special characters: .,:;!?()~=+-\_\/@$#&%

160 characters max

## Retrieve All Sent Messages in a List

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/<ID>/messages')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Get.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"start_date":"20160901", "end_date":"20161030"});
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/<ID>/messages" -d '{"start_date":"20160901", "end_date":"20161030"}' -X GET \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "GET",
  "https://app.tatango.com/api/v2/lists/<ID>/messages",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({ start_date: "20160901", end_date: "20161030" });
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "per_page": 10,
  "count": 2,
  "page": 1,
  "pages_count": 1,
  "messages": [
    {
      "id": 14523,
      "content": "AMCE Retail: Save $20 off this weekend when you spend more than $100 in-store. Show this text message to redeem. Reply STOP to end.",
      "status": "sent",
      "sent_at": "2016-09-07T14:10:53-07:00",
      "name": "my message name",
      "is_broadcast": true,
      "recipient_count": 679571,
      "success_count": 675232,
      "bounces_count": 4339,
      "pending_count": 0,
      "clean_count": 2342,
      "unsubscribe_count": 1362,
      "sms_count": 168808,
      "mms_count": 506424,
      "send_cost": 5096.78,
      "cancelled_at": null,
      "parts": {
        "sum": 679599,
        "minimum": 1,
        "maximum": 2
      }
    },
    {
      "id": 14523,
      "content": "AMCE Retail: Go to http://bit.ly/acme to see deals on anvils. Or check https://trackinglink.com. Reply STOP to end.",
      "sent_at": "2016-10-07T14:10:53-07:00",
      "status": "sent",
      "name": "another message name",
      "is_broadcast": true,
      "recipient_count": 679571,
      "success_count": 675232,
      "bounces_count": 4339,
      "pending_count": 0,
      "clean_count": 2342,
      "unsubscribe_count": 1362,
      "sms_count": 168808,
      "mms_count": 506424,
      "send_cost": 5096.78,
      "message_links": [
        {
          "id": 42,
          "link": "http://bit.ly/acme",
          "count": 2356,
          "display_count": 2356
        }
      ],
      "tracking_links": [
        {
          "link": "https://trackinglink.com",
          "click_count": 15,
          "unique_click_count": 10
        }
      ],
      "cancelled_at": null,
      "parts": {
        "sum": 679599,
        "minimum": 1,
        "maximum": 2
      }
    }
  ]
}
```

This endpoint retrieves all sent messages in a list.

Please note the `message_links` attribute will only be present on messages that have `bit.ly` links in their `content`.

Please note the `tracking_links` attribute will only be present on messages that have tracking links in their `content`.

Please note the `parts` attribute will be available 30 minutes after the message was sent.

### HTTP Request

`GET https://app.tatango.com/api/v2/lists/<ID>/messages`

### URL Parameters

| Parameter  | Description                                                                                      |
| ---------- | ------------------------------------------------------------------------------------------------ |
| ID         | The ID of the list                                                                               |
| start_date | (optional) A date in YYYYMMDD format. Messages sent before this date will not be returned (UTC). |
| end_date   | (optional) A date in YYYYMMDD format. Messages sent after this date will not be returned (UTC).  |

## Retrieve All Draft Messages in a List

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/<ID>/messages/draft')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Get.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"start_date":"20160901", "end_date":"20161030"});
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/<ID>/messages/draft" -d '{"start_date":"20160901", "end_date":"20161030"}' -X GET \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "GET",
  "https://app.tatango.com/api/v2/lists/<ID>/messages/draft",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({ start_date: "20160901", end_date: "20161030" });
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "per_page": 10,
  "count": 2,
  "page": 1,
  "pages_count": 1,
  "messages": [
    {
      "id": 14523,
      "content": "AMCE Retail: Save $20 off this weekend when you spend more than $100 in-store. Show this text message to redeem. Reply STOP to end.",
      "sent_at": "2016-09-07T14:10:53-07:00",
      "status": "draft",
      "name": "my message name",
      "is_broadcast": false,
      "recipient_count": 0,
      "success_count": 0,
      "bounces_count": 0,
      "pending_count": 0,
      "clean_count": 0,
      "unsubscribe_count": 0,
      "sms_count": 0,
      "mms_count": 0,
      "send_cost": 0.0,
      "attachment": "https://url-to-your-mms-attachment"
    },
    {
      "id": 14523,
      "content": "AMCE Retail: Go to http://bit.ly/acme to see deals on anvils. Reply STOP to end.",
      "sent_at": "2016-10-07T14:10:53-07:00",
      "status": "draft",
      "name": "another message name",
      "is_broadcast": false,
      "recipient_count": 0,
      "success_count": 0,
      "bounces_count": 0,
      "pending_count": 0,
      "clean_count": 0,
      "unsubscribe_count": 0,
      "sms_count": 0,
      "mms_count": 0,
      "send_cost": 0.0,
      "attachment": "https://url-to-your-mms-attachment",
      "message_links": [
        {
          "id": 42,
          "link": "http://bit.ly/acme",
          "count": 0,
          "display_count": 0
        }
      ]
    }
  ]
}
```

This endpoint retrieves all draft messages in a list.

### HTTP Request

`GET https://app.tatango.com/api/v2/lists/<ID>/messages/draft`

### URL Parameters

| Parameter  | Description                                                                                       |
| ---------- | ------------------------------------------------------------------------------------------------- |
| ID         | The ID of the list                                                                                |
| start_date | (optional) A date in YYYYMMDD format. Drafts created before this date will not be returned (UTC). |
| end_date   | (optional) A date in YYYYMMDD format. Drafts created after this date will not be returned (UTC).  |

## Retrieve All Scheduled Messages in a List

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/<ID>/messages/scheduled')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Get.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"start_date":"20160901", "end_date":"20161030"});
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/<ID>/messages/scheduled" -d '{"start_date":"20160901", "end_date":"20161030"}' -X GET \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "GET",
  "https://app.tatango.com/api/v2/lists/<ID>/messages/scheduled",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({ start_date: "20160901", end_date: "20161030" });
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "per_page": 10,
  "count": 2,
  "page": 1,
  "pages_count": 1,
  "messages": [
    {
      "id": 14523,
      "content": "AMCE Retail: Save $20 off this weekend when you spend more than $100 in-store. Show this text message to redeem. Reply STOP to end.",
      "sent_at": "2016-09-07T14:10:53-07:00",
      "status": "scheduled",
      "name": "my message name",
      "is_broadcast": false,
      "recipient_count": 0,
      "success_count": 0,
      "bounces_count": 0,
      "pending_count": 0,
      "clean_count": 0,
      "unsubscribe_count": 0,
      "sms_count": 0,
      "mms_count": 0,
      "send_cost": 0.0,
      "attachment": "https://url-to-your-mms-attachment"
    },
    {
      "id": 14523,
      "content": "AMCE Retail: Go to http://bit.ly/acme to see deals on anvils. Reply STOP to end.",
      "sent_at": "2016-10-07T14:10:53-07:00",
      "status": "scheduled",
      "name": "another message name",
      "is_broadcast": false,
      "recipient_count": 0,
      "success_count": 0,
      "bounces_count": 0,
      "pending_count": 0,
      "clean_count": 0,
      "unsubscribe_count": 0,
      "sms_count": 0,
      "mms_count": 0,
      "send_cost": 0.0,
      "attachment": "https://url-to-your-mms-attachment",
      "message_links": [
        {
          "id": 42,
          "link": "http://bit.ly/acme",
          "count": 0,
          "display_count": 0
        }
      ]
    }
  ]
}
```

This endpoint retrieves all scheduled messages in a list.

### HTTP Request

`GET https://app.tatango.com/api/v2/lists/<ID>/messages/scheduled`

### URL Parameters

| Parameter  | Description                                                                                                             |
| ---------- | ----------------------------------------------------------------------------------------------------------------------- |
| ID         | The ID of the list                                                                                                      |
| start_date | (optional) A date in YYYYMMDD format. Scheduled messages scheduled to send before this date will not be returned (UTC). |
| end_date   | (optional) A date in YYYYMMDD format. Scheduled messages scheduled to send after this date will not be returned (UTC).  |

## Sending Message to Entire List

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID/messages')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Post.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"message":{"content":"Hello, world!"}});
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID/messages" -d '{"message":{"content":"Hello, world!"}}' -X POST \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open("POST", "https://app.tatango.com/api/v2/lists/ID/messages", false);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({ message: { content: "Hello, world!" } });
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "message": {
    "id": 4
  }
}
```

This endpoint sends a message.

### HTTP Request

`POST https://app.tatango.com/api/v2/lists/ID/messages`

### URL Parameters

| Parameter | Description    |
| --------- | -------------- |
| ID        | ID of the list |

### JSON Parameters (JSON Object)

| Parameter        | Description     |
| ---------------- | --------------- |
| message[content] | Message content |

## Querying an Existing Message

Please be aware that it takes some time after a message is sent to receive delivery status notifications from the various carriers. We recommend waiting until at least 10 minutes after a message is sent to query for delivery statistics.

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID/messages/MESSAGE_ID')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Get.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID/messages/MESSAGE_ID" -d '' -X GET \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "GET",
  "https://app.tatango.com/api/v2/lists/ID/messages/MESSAGE_ID",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
request.send(null);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "message": {
    "id": 14523,
    "content": "AMCE Retail: Go to http://bit.ly/acme to see deals on anvils. Reply STOP to end.",
    "sent_at": "2016-09-07T14:10:53-07:00",
    "status": "sent",
    "name": "my message name",
    "is_broadcast": true,
    "recipient_count": 679571,
    "success_count": 675232,
    "bounces_count": 4339,
    "pending_count": 0,
    "clean_count": 2342,
    "unsubscribe_count": 1362,
    "sms_count": 168808,
    "mms_count": 506424,
    "send_cost": 5096.78,
    "attachment": "https://url-to-your-mms-attachment",
    "cancelled_at": null,
    "message_links": [
      {
        "id": 42,
        "link": "http://bit.ly/acme",
        "count": 2356,
        "display_count": 2356
      }
    ],
    "parts": {
      "sum": 679599,
      "minimum": 1,
      "maximum": 2
    }
  }
}
```

This endpoint retrieves a message.

Please note the `message_links` attribute will only be present on messages that have `bit.ly` links in their `content`.

Please note the `parts` attribute will be available 30 minutes after the message was sent.

### HTTP Request

`GET https://app.tatango.com/api/v2/lists/ID/messages/MESSAGE_ID`

### URL Parameters

| Parameter  | Description       |
| ---------- | ----------------- |
| ID         | ID of the list    |
| MESSAGE_ID | ID of the message |

### Responses Explained

| Key               | Description                                                                                                 |
| ----------------- | ----------------------------------------------------------------------------------------------------------- |
| content           | The actual content of the message that was sent to subscribers.                                             |
| id                | A unique ID that identifies this specific message.                                                          |
| name              | An optional name or description for a message.                                                              |
| sent_at           | The date/time this message completed it's send.                                                             |
| status            | The status of the message.                                                                                  |
| is_broadcast      | If true, the message was sent to the whole list. If false, was sent only to the phone_number specified.     |
| phone_number      | The wireless phone number of the subscriber.                                                                |
| recipient_count   | The number of recipients the message was sent to.                                                           |
| success_count     | The number of recipients that succesfully received the message on their mobile phones.                      |
| bounces_count     | The number of recipients that did not receive the message on their mobile phones.                           |
| pending_count     | The number of messages that do not have a delivery status as of the time of the query.                      |
| clean_count       | The number of recipients that Tatango automatically unsubscribed from your list due to our                  |
| unsubscribe_count | The number of recipients that unsubscribed from the list, in response to the message that was sent to them. |

# Message Log (MOMT) Reports

## Creating a New MOMT Report

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/momt_reports')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Post.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"date_from":"2016-08-08T22:10:41+01:00","date_to":"2016-09-07T22:10:41+01:00","webhook_callback_url":"http://requestb.in/1d60vok1"})
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/momt_reports" -d '{"date_from":"2016-08-08T22:10:41+01:00","date_to":"2016-09-07T22:10:41+01:00","webhook_callback_url":"http://requestb.in/1d60vok1"}' -X POST \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open("POST", "https://app.tatango.com/api/v2/momt_reports", false);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({
  date_from: "2016-08-08T22:10:41+01:00",
  date_to: "2016-09-07T22:10:41+01:00",
  webhook_callback_url: "http://requestb.in/1d60vok1",
});
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "momt_report": {
    "id": 3,
    "account_id": 22,
    "s3_url": null,
    "import_started_at": null,
    "import_completed_at": null,
    "total_rows": null,
    "processed_rows": 0,
    "percent_complete": 0,
    "mo_count": 0,
    "mt_count": 0,
    "shortcode": null,
    "date_range": "json",
    "date_from": "2016-08-08T22:10:41+01:00",
    "date_to": "2016-09-07T22:10:41+01:00",
    "campaign": null,
    "carrier": null,
    "phone_number": null,
    "direction": null,
    "status_array": null,
    "created_at": "2016-09-07T14:10:41-07:00",
    "updated_at": "2016-09-07T14:10:41-07:00",
    "counts_calculated": false,
    "type": null,
    "is_csv": false,
    "webhook_callback_url": null,
    "run_errors": null,
    "message_type": null,
    "cancelled": null
  }
}
```

This endpoint creates a new MOMT Report.

### HTTP Request

`POST https://app.tatango.com/api/v2/momt_reports`

### JSON Parameters (JSON Object)

| Parameter            | Description             |
| -------------------- | ----------------------- |
| date_from            | {:scope=>:momt_reports} |
| date_to              | {:scope=>:momt_reports} |
| webhook_callback_url | {:scope=>:momt_reports} |

## Getting Status of a Processed MOMT Report

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/momt_reports/ID')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Get.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/momt_reports/ID" -d '' -X GET \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open("GET", "https://app.tatango.com/api/v2/momt_reports", false);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
request.send(null);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "momt_report": {
    "id": 1,
    "account_id": 20,
    "s3_url": null,
    "import_started_at": null,
    "import_completed_at": null,
    "total_rows": null,
    "processed_rows": 0,
    "percent_complete": 0,
    "mo_count": 0,
    "mt_count": 0,
    "shortcode": null,
    "date_range": "json",
    "date_from": "2016-08-08T22:10:41+01:00",
    "date_to": "2016-09-07T22:10:41+01:00",
    "campaign": null,
    "carrier": null,
    "phone_number": null,
    "direction": null,
    "status_array": null,
    "created_at": "2016-09-07T14:10:41-07:00",
    "updated_at": "2016-09-07T14:10:41-07:00",
    "counts_calculated": true,
    "type": null,
    "is_csv": false,
    "webhook_callback_url": null,
    "run_errors": null,
    "message_type": null,
    "cancelled": null
  }
}
```

This endpoint gets the status of a processed MOMT Report.

### HTTP Request

`GET https://app.tatango.com/api/v2/momt_reports/ID`

### URL Parameters

| Parameter | Description                        |
| --------- | ---------------------------------- |
| ID        | ID of MOMT Report to get status of |

## Getting Status of a Unprocessed MOMT Report

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/momt_reports/ID')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Get.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/momt_reports/ID" -d '' -X GET \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open("GET", "https://app.tatango.com/api/v2/momt_reports", false);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
request.send(null);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "momt_report": {
    "id": 2,
    "account_id": 21,
    "s3_url": null,
    "import_started_at": null,
    "import_completed_at": null,
    "total_rows": null,
    "processed_rows": 0,
    "percent_complete": 0,
    "mo_count": 0,
    "mt_count": 0,
    "shortcode": null,
    "date_range": "json",
    "date_from": "2016-08-08T22:10:41+01:00",
    "date_to": "2016-09-07T22:10:41+01:00",
    "campaign": null,
    "carrier": null,
    "phone_number": null,
    "direction": null,
    "status_array": null,
    "created_at": "2016-09-07T14:10:41-07:00",
    "updated_at": "2016-09-07T14:10:41-07:00",
    "counts_calculated": false,
    "type": null,
    "is_csv": false,
    "webhook_callback_url": null,
    "run_errors": null,
    "message_type": null,
    "cancelled": null
  }
}
```

This endpoint gets the status of an unprocessed MOMT Report.

### HTTP Request

`GET https://app.tatango.com/api/v2/momt_reports/ID`

### URL Parameters

| Parameter | Description                        |
| --------- | ---------------------------------- |
| ID        | ID of MOMT Report to get status of |

# Shortcodes

## Listing Account Short Codes

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/shortcodes')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Get.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/shortcodes" -d '' -X GET \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open("GET", "https://app.tatango.com/api/v2/shortcodes", false);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
request.send(null);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "shortcodes": ["33733"]
}
```

This endpoint gets a list of short codes provisioned on your account.

### HTTP Request

`GET https://app.tatango.com/api/v2/shortcodes`

## Testing Keyword Availability on Short Code

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/shortcodes/ID/test_keyword')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Post.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"keyword_name":"TEST"});
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/shortcodes/ID/test_keyword" -d '{"keyword_name":"TEST"}' -X POST \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "POST",
  "https://app.tatango.com/api/v2/shortcodes/ID/test_keyword",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({ keyword_name: "TEST" });
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "keyword_name": "available"
}
```

This endpoint gets checks the availability of a keyword on the account's short code.

### HTTP Request

`POST https://app.tatango.com/api/v2/shortcodes/ID/test_keyword`

<aside class="error">
<strong>Name is in Use</strong>
<p>
{
  "status":"OK",
  "keyword_name":"unavailable",
  "error":"Name is in use"
}
</p>
</aside>

### URL Parameters

| Parameter | Description         |
| --------- | ------------------- |
| ID        | ID of the shortcode |

### JSON Parameters (JSON Object)

| Parameter    | Description          |
| ------------ | -------------------- |
| keyword_name | Keyword name to test |

<aside class="success">
  FAQs
  <ul>
    <li>
      <em>What are the limitations for a keyword?</em>
      <p>
         <ul>
           <li>A keyword must contain at least two characters and no more than 15 characters.</li>
           <li>Keywords are not case sensitive. FOO will match foo and FOO and Foo.</li>
           <li>You can't use obscene words. We're not going to spell them out here.</li>
         </ul>
      </p>
    </li>
    <li>
       <em>Are keywords case sensitive?</em>
       <p>No. The system checks for duplicate keywords by transforming all keywords to uppercase before performing matching algorithms.</p>
    </li>
    <li>
      <em>What happens if the keyword isn't available?</em>
      <p>The response from the API will be a 422 error with the response body looking like this: {"status":"error","error":"invalid keyword names: EXISTINGKW"}</p>
    </li>
    <li>
      <em>What happens if the keyword isn't available?</em>
      <p>Yes.  By utilizing <a href="#testing-keyword-availability-for-list">this</a> endpoint. The response will either be 200 OK {"status":"OK","keyword_name":"available"} or 200 OK  {"status":"OK","keyword_name":"unavailable","error":"Name is in use"}.</p>
    </li>
  </ul>
</aside>

# Transactional Messages

## Send Transactional SMS Message

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/transactional_messages')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Post.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"transactional_message":{"number":"2835550430","content":"Test me!"}})
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/transactional_messages" -d '{"transactional_message":{"number":"2835550430","content":"Test me!"}}' -X POST \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "POST",
  "https://app.tatango.com/api/v2/transactional_messages",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify(
  '{"transactional_message":{"number":"2835550430","content":"Test me!"}}'
);
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "Message successfully sent.",
  "transactional_message": {
    "id": 1,
    "number": "2835550430",
    "content": "Test me!",
    "status": "pending"
  }
}
```

> An example tatango transactional message reply

```json
{
  "type": "transactional_message_reply",
  "transactional_message_id": 589733,
  "received_at": "2016-08-20T15:12:37-07:00",
  "phone_number": "3474437987",
  "carrier": 383,
  "carrier_name": "AT&T",
  "content": "I replied to transactional"
}
```

This endpoint sends a Transactional SMS Message.

### HTTP Request

`POST https://app.tatango.com/api/v2/transactional_messages`

### JSON Parameters (JSON Object)

| Parameter                                   | Description                                                                                                |
| ------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| transactional_message[number]               | <span class="required">required</span> Phone number (numbers only - no spaces, dashes or other characters) |
| transactional_message[content]              | <span class="required">required</span> Message content                                                     |
| transactional_message[webhook_callback_url] | Webhook url (will send result of send to)                                                                  |

<aside class="success">
Example of webhook payload reply listed to the right.
  <ul>
    <li>
      <em>Can I send an MMS (Image/Video) messages using transactional?</em>
      <p>Yes. You can send MMS Transactional messages. First, go to <a href="https://app.tatango.com/attachments">here</a> and grab the attachment ID (we save all the attachments when you create messages via web the interface). This is the attachment_id parameter in the [example code](#send-transactional-mms-message).</p>
    </li>
  </ul>
</aside>

## Send Transactional MMS Message

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/transactional_messages')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Post.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"transactional_message":{"number":"2835550430","is_mms":true,"subject":"MMS message subject. Optional max-size 40","content":"Message content required. Max-size 5000 if is_mms","fallback_content":"MMS message content (required if is_mms)","attachment_id":42}})
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/transactional_messages" -d '{"transactional_message":{"number":"2835550430","is_mms":true,"subject":"MMS message subject. Optional max-size 40","content":"Message content required. Max-size 5000 if is_mms","fallback_content":"MMS message content (required if is_mms)","attachment_id":42' -X POST \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "POST",
  "https://app.tatango.com/api/v2/transactional_messages",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify(
  '{"transactional_message":{"number":"2835550430","is_mms":true,"subject":"MMS message subject. Optional max-size 40","content":"Message content required. Max-size 5000 if is_mms","fallback_content":"MMS message content (required if is_mms)","attachment_id":42}'
);
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "Message successfully sent.",
  "transactional_message": {
    "id": 1,
    "number": "2835550430",
    "content": "Message content required. Max-size 5000 if is_mms",
    "status": "pending"
  }
}
```

> An example tatango transactional message reply

```json
{
  "type": "transactional_message_reply",
  "transactional_message_id": 589733,
  "received_at": "2016-08-20T15:12:37-07:00",
  "phone_number": "3474437987",
  "carrier": 383,
  "carrier_name": "AT&T",
  "content": "I replied to transactional"
}
```

This endpoint sends a Transactional SMS Message.

### HTTP Request

`POST https://app.tatango.com/api/v2/transactional_messages`

### JSON Parameters (JSON Object)

| Parameter                                   | Description                                                                                                |
| ------------------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| transactional_message[number]               | <span class="required">required</span> Phone number (numbers only - no spaces, dashes or other characters) |
| transactional_message[content]              | <span class="required">required</span> Message content                                                     |
| transactional_message[webhook_callback_url] | Webhook url (will send result of send to)                                                                  |

<aside class="success">
Example of webhook payload reply listed to the right.
  <ul>
    <li>
      <em>Can I send an MMS (Image/Video) messages using transactional?</em>
      <p>Yes. You can send MMS Transactional messages. First, go to <a href="https://app.tatango.com/attachments">here</a> and grab the attachment ID (we save all the attachments when you create messages via web the interface). This is the attachment_id parameter in the example code.</p>
    </li>
  </ul>
</aside>

# Webhooks

Callback URLs configured as a webhook in Tatango are retried 10 times when not reachable. After the 10th time, the system makes no further attempts to reach the callback URL.

## Creating a New Webhook for a List

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID/webhooks')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Post.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"webhook":{"callback_url":"http://localhost.dev/null?api_key=foo_bar_baz","subscribe":true,"unsubscribe":true,"message_sent":false}})
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID/webhooks/WEBHOOK_ID" -d '{"webhook":{"callback_url":"http://localhost.dev/null?api_key=foo_bar_baz","subscribe":true,"unsubscribe":true,"message_sent":false}}' -X POST \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open("POST", "https://app.tatango.com/api/v2/lists/ID/webhooks/WEBHOOK_ID", false);
request.setRequestHeader("Authorization", "Basic " + btoa("emailaddress@mydomain.com:my_api_key"));
var data = JSON.stringify({"webhook":{"callback_url":"http://localhost.dev/null?api_key=foo_bar_baz","subscribe":true,"unsubscribe":true,"message_sent":false}};
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "Webhook created",
  "webhook": {
    "callback_url": "http://localhost.dev/null?api_key=foo_bar_baz",
    "created_at": "2016-09-07T14:11:13-07:00",
    "enabled": true,
    "id": 4,
    "list_id": 29,
    "message_sent": false,
    "subscribe": true,
    "unsubscribe": true,
    "updated_at": "2016-09-07T14:11:13-07:00"
  }
}
```

This endpoint creates a webhook for a list

### HTTP Request

`POST https://app.tatango.com/api/v2/lists/ID/webhooks`

### URL Parameters

| Parameter | Description        |
| --------- | ------------------ |
| ID        | The ID of the list |

## Updating a Webhook

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID/webhooks/WEBHOOK_ID')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Put.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
request.body({"webhook":{"callback_url":"http://mynewapi.com/?ref=tatango","subscribe":true,"unsubscribe":false,"message_sent":false}})
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID/webhooks/WEBHOOK_ID" -d '{"webhook":{"callback_url":"http://mynewapi.com/?ref=tatango","subscribe":true,"unsubscribe":false,"message_sent":false}}' -X PUT \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "PUT",
  "https://app.tatango.com/api/v2/lists/ID/webhooks/WEBHOOK_ID",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
var data = JSON.stringify({
  webhook: {
    callback_url: "http://mynewapi.com/?ref=tatango",
    subscribe: true,
    unsubscribe: false,
    message_sent: false,
  },
});
request.send(data);
```

> The above command returns JSON structured like this:

```json
{
  "status": "Webhook updated",
  "webhook": {
    "callback_url": "http://mynewapi.com/?ref=tatango",
    "created_at": "2016-09-07T14:11:13-07:00",
    "enabled": true,
    "id": 9,
    "list_id": 33,
    "message_sent": false,
    "subscribe": true,
    "unsubscribe": false,
    "updated_at": "2016-09-07T14:11:13-07:00"
  }
}
```

This endpoint updates a webhook

### HTTP Request

`PUT https://app.tatango.com/api/v2/lists/ID/webhooks/WEBHOOK_ID`

### URL Parameters

| Parameter  | Description           |
| ---------- | --------------------- |
| ID         | The ID of the list    |
| WEBHOOK_ID | The ID of the webhook |

## Showing a Webhook

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID/webhooks/WEBHOOK_ID')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Get.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID/webhooks/WEBHOOK_ID" -d '' -X GET \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "GET",
  "https://app.tatango.com/api/v2/lists/ID/webhooks/WEBHOOK_ID",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
request.send(null);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "webhook": {
    "callback_url": "http://localhost/dev/null",
    "created_at": "2016-09-07T14:11:13-07:00",
    "enabled": true,
    "id": 5,
    "list_id": 30,
    "message_sent": false,
    "subscribe": true,
    "unsubscribe": false,
    "updated_at": "2016-09-07T14:11:13-07:00"
  }
}
```

This endpoint shows a webhook.

### HTTP Request

`GET https://app.tatango.com/api/v2/lists/ID/webhooks/WEBHOOK_ID`

### URL Parameters

| Parameter  | Description           |
| ---------- | --------------------- |
| ID         | The ID of the list    |
| WEBHOOK_ID | The ID of the webhook |

<aside class="error">
If the webhook does not exist you will get a 404 response with this body:

{"status":"error","error":"Webhook not found"}

</aside>

## Listing Webhooks

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID/webhooks')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Get.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID/webhooks" -d '' -X GET \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open("GET", "https://app.tatango.com/api/v2/lists/ID/webhooks", false);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
request.send(null);
```

> The above command returns JSON structured like this:

```json
{
  "status": "OK",
  "per_page": 10,
  "count": 3,
  "page": 1,
  "pages_count": 1,
  "webhooks": [
    {
      "callback_url": "http://localhost/dev/null",
      "created_at": "2016-09-07T14:11:13-07:00",
      "enabled": true,
      "id": 6,
      "list_id": 31,
      "message_sent": false,
      "subscribe": true,
      "unsubscribe": false,
      "updated_at": "2016-09-07T14:11:13-07:00"
    },
    {
      "callback_url": "http://localhost/dev/null",
      "created_at": "2016-09-07T14:11:13-07:00",
      "enabled": true,
      "id": 7,
      "list_id": 31,
      "message_sent": false,
      "subscribe": true,
      "unsubscribe": false,
      "updated_at": "2016-09-07T14:11:13-07:00"
    },
    {
      "callback_url": "http://localhost/dev/null",
      "created_at": "2016-09-07T14:11:13-07:00",
      "enabled": true,
      "id": 8,
      "list_id": 31,
      "message_sent": false,
      "subscribe": true,
      "unsubscribe": false,
      "updated_at": "2016-09-07T14:11:13-07:00"
    }
  ]
}
```

This endpoint lists webhooks.

### HTTP Request

`GET https://app.tatango.com/api/v2/lists/ID/webhooks`

### URL Parameters

| Parameter | Description        |
| --------- | ------------------ |
| ID        | The ID of the list |

<aside class="error">
If the list does not exist you will get a 404 response with this body:

{"status":"error","error":"List not found"}

</aside>

## Destroying a Webhook

```ruby
require 'net/http'
require 'uri'

uri = URI.parse('https://app.tatango.com/api/v2/lists/ID/webhooks/WEBHOOK_ID')
http = Net::HTTP.new(uri.host, uri.port)
request = Net:HTTP::Delete.new(uri.request_url)
request.basic_auth("emailaddress@mydomain.com", "my_api_key")
response = http.request(request)
```

```shell
curl "https://app.tatango.com/api/v2/lists/ID/webhooks/WEBHOOK_ID" -d '' -X DELETE \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	-u emailaddress@mydomain.com:my_api_key \
	-H "Host: example.org" \
	-H "Cookie: "
```

```javascript
var request = new XMLHttpRequest();
request.open(
  "DELETE",
  "https://app.tatango.com/api/v2/lists/ID/webhooks/WEBHOOK_ID",
  false
);
request.setRequestHeader(
  "Authorization",
  "Basic " + btoa("emailaddress@mydomain.com:my_api_key")
);
request.send(null);
```

> The above command returns JSON structured like this:

```json
{
  "status": "Webhook destroyed"
}
```

This endpoint destroys a webhook.

### HTTP Request

`DELETE https://app.tatango.com/api/v2/lists/ID/webhooks/WEBHOOK_ID`

### URL Parameters

| Parameter  | Description           |
| ---------- | --------------------- |
| ID         | The ID of the list    |
| WEBHOOK_ID | The ID of the webhook |

# General FAQs

<ul>
  <li>
    <em>Where can I find the "ID of the list"?</em>
    <p>You can find the ID of all of your lists by calling the <a href="#listing-all-lists">Listing all Lists"</a> endpoint.</p>
  </li>
  <li>
    <em>What are the differences between SMS and MMS?</em>
    <p>SMS (short message service) is a text-only message service. MMS (multimedia messaging service) is a service that allows the sender to send a multimedia message.</p>
  </li>
</ul>

# Carrier IDs

This section provides a list of carrier ID and names (US and Canada) for any response that includes `carrier` and `carrierName`

## United States Carriers

| Carrier Name                                 | Carrier ID |
| -------------------------------------------- | ---------- |
| Alaska Communications Systems (ACS)          | 592        |
| ASTAC                                        | 10242      |
| AT&T                                         | 383        |
| Atlantic Tele-Network International (ATNI)   | 10542      |
| bandwidth.com (includes Republic Wireless)   | 766        |
| Blue Wireless                                | 11264      |
| Boost Mobile                                 | 534        |
| Boost-CDMA                                   | 586        |
| Brightlink                                   | 10212      |
| C Spire Wireless (aka Cellular South)        | 386        |
| Carolina West Wireless                       | 564        |
| CellCom                                      | 587        |
| Cellular One of N.E. Arizona                 | 566        |
| Chariton Valley Cellular                     | 701        |
| Chat Mobility                                | 619        |
| Cleartalk (Flat Wireless)                    | 656        |
| Copper Valley Telecom                        | 802        |
| Cordova                                      | 10282      |
| Cross Wireless                               | 618        |
| Duet Wireless                                | 696        |
| East Kentucky Network (Appalachian Wireless) | 570        |
| Enflick                                      | 10262      |
| Fair Point Communications                    | 803        |
| GCI Communications                           | 603        |
| Google Voice                                 | 798        |
| Illinois Valley Cellular                     | 574        |
| Inland Cellular                              | 575        |
| Inteliquent                                  | 10232      |
| Interop All Carriers                         | 697        |
| IWireless                                    | 477        |
| Jasper Wireless                              | 11284      |
| Leaco Rural Telephone Cooperative            | 783        |
| Level 3 (internal only)                      | 801        |
| Ligado Networks                              | 11251      |
| Limitless Mobile                             | 588        |
| MetroPCS (GSM)                               | 788        |
| Mid-Rivers Communications                    | 834        |
| MobileNation/SI Wireless                     | 773        |
| Mosaic Telecom                               | 658        |
| MTA Wireless/Matanuska Kenai                 | 774        |
| MTPCS Cellular One (Cellone Nation)          | 655        |
| Nemont CDMA                                  | 796        |
| Nemont US UMTS                               | 873        |
| NewCore Wireless US                          | 11287      |
| Nex Tech Communications                      | 578        |
| Northwest Missouri Cellular                  | 620        |
| Panhandle Wireless                           | 626        |
| Peoples Wireless                             | 694        |
| Pine Belt                                    | 10352      |
| Pine Cellular                                | 580        |
| Pioneer Cellular                             | 621        |
| Plateau Wireless                             | 651        |
| Rock Wireless                                | 11252      |
| Rural Independent Network Alliance (RINA)    | 567        |
| Shelcomm                                     | 11293      |
| SouthernLINC                                 | 763        |
| Sprint                                       | 34         |
| SRT Communications                           | 780        |
| T-Mobile                                     | 79         |
| Thumb Cellular                               | 604        |
| TracFone (AT&T)                              | 556        |
| Triangle Communications US                   | 11290      |
| Triangle Wireless                            | 10272      |
| Union Telephone                              | 549        |
| Union Wireless                               | 11286      |
| United States Cellular Corp                  | 56         |
| United Wireless                              | 602        |
| Verizon                                      | 77         |
| Viaero US                                    | 11289      |
| Viaero Wireless                              | 650        |
| Virgin Mobile                                | 525        |
| West Central Wireless                        | 559        |

## Canadian Carriers

| Carrier Name      | Carrier ID |
| ----------------- | ---------- |
| Aliant            | 509        |
| Bell Mobility     | 80         |
| Eastlink Wireless | 799        |
| Execulink         | 10573      |
| Fido (Microcell)  | 138        |
| Freedom Canada    | 11292      |
| Mobilicity        | 654        |
| MTS               | 510        |
| NorthernTel       | 512        |
| Rogers            | 75         |
| Sasktel           | 102        |
| Telebec           | 511        |
| Telus             | 70         |
| Videotron         | 615        |
| Virgin Mobile     | 537        |
| WIND              | 653        |

# Automated Reports

## All Replies Report

**Description**: The All Replies Report provides a detailed list of all replies received in response to broadcast or recurring messages sent from your account on the previous [day/week/month]. This report is designed to help users identify actionable replies, allowing them to engage with subscribers effectively and respond to any feedback or inquiries. By analyzing these replies, users can gain valuable insights into subscriber sentiment and the effectiveness of their campaigns.

**Frequency**: Daily/Weekly/Monthly

**Output**: .csv file

**Scope**: Includes data from all lists on the account

**Customization**: Users can request to append subscriber-level custom fields to the report, such as CRM IDs (e.g., cons_id from Blackbaud Luminate Online). These custom fields must be pre-configured within the list in the user's Tatango account to appear in the report.

---

## Broadcast Message Summary Report

**Description**: The Messages Summary Report provides a [daily/weekly/monthly] summary of all broadcast messages sent from your account on the previous day. This report offers insights into message performance, including key metrics related to deliverability and engagement. Users can quickly assess how well their messages reached subscribers and gauge engagement levels, helping to inform future messaging strategies and optimize campaign effectiveness.

**Frequency**: Daily/Weekly/Monthly

**Output**: .csv file

**Scope**: Includes data from all lists on the account

**Customization**: No customization is available for this report.

---

## Clicks Report

**Description**: The Clicks Report provides a comprehensive list of all clicks recorded from the previous [day/week/month]. This includes clicks from any broadcast or recurring message sent from your account. The report helps users track engagement at the subscriber level, providing valuable insights into campaign performance.

**Frequency**: Daily/Weekly/Monthly

**Output**: .csv file

**Scope**: Includes data from all lists on the account

**Customization**: Users can request to append subscriber-level custom fields to the report, such as CRM IDs (e.g., cons_id from Blackbaud Luminate Online). These custom fields must be pre-configured within the list in the user's Tatango account to appear in the report.

---

## Donations Report

**Description**: The Donations Report provides a comprehensive list of all donations received and attributed to Tatango messages from the previous [day/week/month]. This report enables users to assess the direct impact of their messaging campaigns on fundraising efforts, offering insights into which messages prompted donations. By tracking donation performance, customers can better understand campaign effectiveness and refine their messaging strategies to drive further contributions.

**Frequency**: Daily/Weekly/Monthly

**Output**: .csv file

**Scope**: Includes data from all lists on the account

**Customization**: Users can request to append subscriber-level custom fields to the report, such as CRM IDs (e.g., cons_id from Blackbaud Luminate Online). These custom fields must be pre-configured within the list in the user's Tatango account to appear in the report.

---

## Opts Report

**Description**: The Opts Report provides a comprehensive log of all opt-in and opt-out activities that occurred the previous [day/week/month]. This report gives users valuable insights into list growth, churn, and overall list health. By tracking subscriber engagement and list changes, users can better understand their audience dynamics and make informed decisions to improve subscriber retention and acquisition.

**Frequency**: Daily

**Output**: .csv file

**Scope**: Includes data from all lists on the account

**Customization**: Users can request to append subscriber-level custom fields to the report, such as CRM IDs (e.g., cons_id from Blackbaud Luminate Online). These custom fields must be pre-configured within the list in the user's Tatango account to appear in the report.

---

## Recipients Report

**Description**: The Recipients Report provides a detailed record of all messages sent to individual subscribers from the previous day. This includes broadcast, recurring, autoresponder, system, test, and transactional messages. This report enables users to track each message campaign at the individual subscriber level, offering valuable insights into message deliverability, including whether a message was successfully delivered or bounced.

**Frequency**: Daily/Weekly/Monthly

**Output**: .csv file

**Scope**: Includes data from all lists on the account

**Customization**: Users can request to append subscriber-level custom fields to the report, such as CRM IDs (e.g., cons_id from Blackbaud Luminate Online). These custom fields must be pre-configured within the list in the user's Tatango account to appear in the report.

---

## Subscribers Snapshot Report

**Description**: The Subscribers Snapshot Report provides a complete, point-in-time snapshot of all subscribers and their attributes. This report allows users to capture the current state of their subscriber list, including key details such as subscription status, custom fields, and engagement data points. It’s particularly useful for monitoring list health, performing historical comparisons, and tracking changes in subscriber attributes over time.

**Frequency**: Daily/Weekly/Monthly

**Output**: .csv file

**Scope**: Includes data from all lists on the account

**Customization**: No customization is available for this report.

---

## Updated Subscribers Report

**Description**: The Updated Subscribers Report provides a detailed record of all subscribers whose information was updated during the previous [day/week/month]. This report offers valuable insights into changes in subscriber data, helping users monitor list health and track updates in subscription status. Subscribers may be included in the report due to changes in their subscription status (e.g., opt-in or opt-out) or updates to custom field attributes, such as name, email, last gift date or any other attributes configured as a custom field on your Tatango list.

**Frequency**: Daily

**Output**: .csv file

**Scope**: Includes data from all lists on the account

**Customization**: No customization is available for this report.

---

## Delivery Methods

Reports can be automatically delivered to one or more of the following destinations: 
- Amazon S3 (AWS)
- Google Cloud Storage (GCP)
- SFTP (Secure File Transfer Protocol)
- Email: Delivered as an attachment

If you have a delivery method you'd like to see added please reach out to your Customer Success Manager or [support@tatango.com](mailto:support@tatango.com).

---

## Example Use Case

A nonprofit organization wants to track communication data in Salesforce. They log messages sent as activity records in Salesforce using the data provided by our Recipients Report. Each record from the report is logged as an activity record on each contact record in Salesforce.

In order to accurately do so they add Salesforce Contact ID (bbcrm_cons_id) as a custom field on their Tatango list and upload each subscriber's constituent ID in their initial upload.

The nonprofit organization consumes our Recipients Report on a daily basis to an AWS S3 bucket hosted by them. From there, they have a job that runs daily to pick up the .csv file, loop through each record, and create the activity records in Salesforce on each contact. This allows them to have a comprehensive view of texts that their contacts have received in Salesforce.
