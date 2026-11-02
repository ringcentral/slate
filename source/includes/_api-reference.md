# API Reference

The Intelex API is organized around REST. Our API has predictable, resource-oriented URLs, and uses HTTP response codes to indicate API errors. We use built-in HTTP features, like HTTP authentication and HTTP verbs, which are understood by off-the-shelf HTTP clients. JSON is returned by all API responses, including errors.

## Getting Started

> API Endpoint - replace **intelex_url** with the full URL path to your Intelex system

```
https://intelex_url/api/v2/
```

To begin using the Intelex API you will need:

* Your own instance of the Intelex platform with the REST API enabled
* A valid Intelex system user account
* The full URL to your Intelex system
* A basic understanding of the [Intelex Application model](https://community.intelex.com/library/knowledgebase/help/Content/Getting%20Started/Application%20Builder.htm). 

## Authentication

> Example Requests:

```javascript
// Basic Authentication
var request = require("request");

var options = {
  headers: { Authorization: "Basic [insert credentials here]" }
  };


//ApiKey Authentication
var request = require("request");

var options = {
  headers: { Authorization: "ApiKey [insert key here]" }
  };


// Secure Access Token Authentication
var request = require("request");

var options = {
  headers: { Authorization: "Bearer [insert Access token here]" }
  };
```

```csharp

// Basic Authentication
var request = new RestRequest(Method.GET);

request.AddHeader("Authorization", "Basic [insert credentials here]");


// ApiKey Authentication
var request = new RestRequest(Method.GET);

request.AddHeader("Authorization", "ApiKey [insert key here]");


// Secure Access Token Authentication
var request = new RestRequest(Method.GET);
 
request.AddHeader("Authorization", "Bearer [insert Access token here]");
```

The Intelex API supports three methods for authentication: Basic, ApiKey, and Secure. All API requests must be made over HTTPS and API requests without authentication will fail. Only Admin and Full Access users can use ApiKey and Secure authentication. 

Security on data for all types of authentication is managed by the platform security configuration. API requests will maintain the security settings configured for the user on the Intelex platform.

Basic authentication is performed via HTTP Basic Auth with your Intelex user credentials (Username:Password). The credentials are verified by Intelex and access granted or denied accordingly.

ApiKey authentication can be performed by generating API access key(s) from the Intelex User Profile menu (note that this page is only accessible to full-access and admin users). The unique generated key can then be used to authenticate with the Intelex REST API.

Starting at Platform Version 6.6.7, secure token based authentication is supported by the V6 API. This form of authentication needs to be enabled by Intelex. During the authentication process, the client provides the ‘client id’ and ‘client secret’ to the authentication endpoint, along with the audience and grant type, as shown in the example. In response, the API furnishes an access token that comes with a specified expiration. After successful authentication, clients gain access to V6 API endpoints.

>Example Requests:

```CSharp 
Body for Authentication Endpoint
{"client_id":"Client ID Data",
"client_secret":"Client Secret Data",
"audience":"https://api.intelex.com/v6/",
"grant_type":"client_credentials"}
```

>Example Response:

```json
{
    "access_token": "Generated Bearer Access Token Used For Validation",
    "expires_in": "Token Expiry Time In Seconds",
    "token_type": "Bearer"
}
```

### Get endpoint, secured client id and client secret

Login to the V6 application. Navigate to System Administration, User Administration, and then Navigate to API Access.
Select the secured API from the API Access page; the endpoint, client id and client secret will be displayed on the details page. Use these to obtain an access token via API end point.

## Data Format

The Intelex API only supports [JSON](http://www.json.org/) as the data format for requests and responses.

## Response Codes

> Example error response

```json
{
  "error": {
    "code": "string",
    "message": "string"
  }
}
```

The Intelex REST API will respond with the following HTTP status codes:

Response Code | Meaning
---------- | -------
200 | Success -- Enjoy your data!
201 | Created -- We created the record!
204 | No Content -- Your request was successful, but we don't have anything more to tell you
400 | Bad Request -- Something is wrong with your request
401 | Unauthorized -- Your credentials are wrong
403 | Forbidden -- You do not have permission to access the resource
404 | Not Found -- The object or navigation property you are trying to access doesn't exist
405 | Method Not Allowed -- We won't let you do that
429 | Too Many Requests -- You have sent too many requests and have to wait till you can send more
500 | Internal Server Error -- We had a problem with our server. Try again later
501 | Not Implemented -- What you are trying to do doesn't work...yet.

## Versioning

When we make backwards-incompatible changes to the API, we release new versions. The current version is **v2** and can be determined with our API base path **/api/v2/**. Read our [Intelex platform release notes](https://community.intelex.com/library/knowledgebase/release-notes) to see our API changelog.

## Intended Use

The Intelex API is designed for system integrations that operate at the pace of human activity, such as syncing records between systems, pulling reports, and connecting workflows.

It is not designed for AI chatbots, autonomous agents, or automated systems that generate records at high volume. One example is a computer-vision feed that continuously creates observations.

This matters for two reasons:

* **Platform performance.** High-volume automated traffic can affect performance for every user on the platform.
* **Data quality.** Records created at machine scale can distort the reporting and analytics your programme relies on. A single event captured hundreds of times by a camera looks very different in your data from the same event reported once by a person.

If you have, or are planning, an integration that involves AI agents, automated record creation, or high-volume data extraction, see [AI Agents and Automated Integrations](#ai-agents-and-automated-integrations) and talk to us before you build it.

## API Rate Limiting / Quotas
To keep the Intelex Platform reliable and performing as expected for all users, we limit the number of API calls that can be made within a given time period. If a limit is exceeded, subsequent requests are rejected with HTTP response code 429 Too Many Requests. The client application is responsible for implementing retry logic for requests that are rejected due to rate limiting.

### Limits

Limits are applied by operation type. Each operation type has a rate limit and a daily cap.

Operation | Rate limit | Daily cap
---------- | ------- | -------
Read (GET) | 20 per second | 20,000
Update (PATCH) | 4 per second | 4,000
Create (POST) | 2 per second | 2,000
Delete (DELETE) | 2 per second | 2,000
Workflow actions | 2 per second | 2,000
Attachments (file upload) | 12 per minute | 200
Reports (per page of results) | 6 per minute | 100

Daily caps reset every 24 hours.

<aside class="notice">
The per-second rate limits are a shared budget, not separate allowances. You can make <b>20 reads or 2 creates</b> in a second, not 20 reads and 2 creates. Combining operations uses up the same budget: for example, 10 reads and 1 create in the same second reaches the limit.
</aside>

### How requests are counted

* **Per tenant.** Limits apply to your whole Intelex tenant, whether you run one integration or several. All integrations and users in the tenant share the same limits.
* **Batch requests.** Each operation inside a [batch request](#object-batch-requests) counts against the limits individually. A `$batch` request that contains 10 creates counts as 10 creates, not 1 request.
* **Reports.** Each page of report results counts as one report request.

### Integration users

Use a dedicated integration user for integrations, not an individual user's account. Lower limits apply to requests made with individual user accounts, for example a person connecting an AI assistant such as Claude or ChatGPT to the API with their own credentials.

### Exceptions

The following are not counted towards these limits:

* **Officially supported integrations.** Integrations that Intelex officially supports, such as 3E and Enhesa.
* **Initial data import.** The initial import of data for new customers. Talk to your Intelex contact to plan your import.

### Quota headers
Quota details may be passed back to the API user/application via response headers.

Header | Description
---------- | -------
Retry-After	| Time in seconds to wait before retrying the request after a rate limit or daily cap is exceeded. The value is set dynamically based on current usage, so always read it from the response rather than using a fixed wait time.

### Best Practices

* Use HTTP clients that support automatic retries with an exponential back-off strategy when receiving 429 (Too Many Requests) responses.
* Avoid spikes of traffic by spreading out API calls over time wherever possible.
* Request only the data you need. Use filtering and field selection rather than repeatedly reading full record sets.
* Track your daily usage so that scheduled jobs do not reach a daily cap partway through a run.

## AI Agents and Automated Integrations

The Intelex API was built for system integrations operating at the pace of human activity. It was not designed for AI chatbots, autonomous agents, or automated systems that create records at high volume, such as computer-vision feeds that create observations continuously.

High-volume automated traffic can affect platform performance for everyone. Records created at machine scale can also distort your reporting and analytics: a single event captured hundreds of times by a camera looks very different in your data from the same event reported once by a person.

If you have, or are planning, an integration that involves AI agents, automated record creation, or high-volume data extraction:

* **Talk to us before you build it.** We want to support these use cases, and we can help you design them so they work reliably and keep your data meaningful. Your Customer Success Manager is the best starting point.
* **Use an integration user.** Do not connect AI assistants or agents using an individual user's credentials. Lower limits apply to individual user accounts.
* **Stay within the limits.** AI agents and automated systems are subject to the same [rate limits and daily caps](#api-rate-limiting-quotas) as any other integration.

<aside class="notice">
Intelex is working on a Model Context Protocol (MCP) server for connecting AI assistants and agents to the Intelex Platform. It is not available today.
</aside>
