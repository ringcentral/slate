---
title: RingCentral Connect SDK Reference

language_tabs:
  - javascript: JavaScript
  - php: PHP
  - python: Python
  - shell: cURL

toc_footers:
  - <a href='https://developers.ringcentral.com/sign-up.html'>Sign Up for a Developer Key</a>
  - <a href='http://github.com/tripit/slate'>Documentation Powered by Slate</a>

includes:
  - errors

search: true
---

# How do I get started

## Install the SDK

```shell
# Usually cURL is installed by default
```

```javascript
// Browser
// $ bower install rcsdk

require.config({paths:{rcsdk:'path-to-rcsdk/build/bundle.js'}});

require(['rcsdk'], function(RCSDK) {
    ...
});

// NodeJS
// $ npm install rcsdk

var RCSDK = require('rcsdk');
```

```php
// $ composer require ringcentral/php-sdk
use RC;
```

```python
// $ pip install rcsdk
from rcsdk import RCSDK
```

To install the SDK, follow the online instructions…

- JS: [https://github.com/ringcentral/js-sdk#installation](https://github.com/ringcentral/js-sdk#installation)
- PHP: [https://github.com/ringcentral/php-sdk#installation](https://github.com/ringcentral/php-sdk#installation)
- Python: [https://github.com/ringcentral/python-sdk#installation](https://github.com/ringcentral/python-sdk#installation)

## Instantiate the SDK

```shell
# There is no need to instantiate anything in shell but for convenience you can export your Key:Secret pair
# For more info read http://askubuntu.com/questions/178521/how-can-i-decode-a-base64-string-from-the-command-line
export RC_API_KEY="$(echo -n 'YOUR_APP_KEY:YOUR_APP_SECRET' | base64)"

# Or
export RC_API_KEY="$(echo -n 'YOUR_APP_KEY:YOUR_APP_SECRET' | openssl base64)"

# You also can export your login credentials
export RC_USERNAME="+12223334455"
export RC_EXTENSION=""
export RC_PASSWORD="password"
```

```javascript
var rcsdk = new RCSDK({
    server: 'https://platform.devtest.ringcentral.com',
    appKey: 'yourAppKey',
    appSecret: 'yourAppSecret'
});
```

```php
// If you use composer this should be added once
require('path-to-vendor/autoload.php');

$rcsdk = new RC\SDK('yourAppKey', 'yourAppSecret', 'https://platform.devtest.ringcentral.com');
```

```python
sdk = RCSDK('APP_KEY', 'APP_SECRET', 'SERVER')
```

> For production use 

Once you have the SDK installed, follow the instructions to create a basic web page that instantiates the SDK object,
as follows...

In order to bootstrap the RingCentral JavaScript SDK, you have to first get a reference to the Platform singleton and
then configure it. Before you can do anything using the Platform singleton, you need to configure it with the server URL
(this tells the SDK which server to connect to) and your unique API key (this is provided by RingCentral's developer
relations team).

More complicated scenarios are described in SDK documentation.

# Authentication

> To authorize, use this code:

```shell
# Access token will be captured from returned JSON into $RC_ACCESS_TOKEN variable

export RC_ACCESS_TOKEN=$(
    curl "https://platform.devtest.ringcentral.com/restapi/oauth/token" \
         --data "grant_type=password&username=$RC_USERNAME&extension=$RC_EXTENSION&password=$RC_PASSWORD" \
         -X POST \
         -H "Accept: application/json" \
         -H "Authorization: Basic $RC_API_KEY" \
         | grep -oEi '"access_token" : "([^"]+)"' \
         | cut -d\" -f4 )     
```

```javascript
var platform = rcsdk.getPlatform();

// A Promise is returned, and you can use its `then` method to specify your continuation function, and its `catch`
// method to specify an error handling function
platform.authorize({
    username: 'username',
    extension: 'extension',
    password: 'password'
}).then(function(ajax) {
      // your code here
}).catch(function(e) {
    alert(e.message  || 'Server cannot authorize user');
});
```

```php
$response = $rcsdk->getPlatform()->authorize('username', 'extension', 'password', true);
// change true to false to not remember user
```

```python
response = sdk.get_platform().authorize('username', 'extension', 'password')
```

To log in to RingCentral, get the Platform object and call its authorize method, providing valid `username`,
`extension`, and `password` values.

<aside class="notice">
Phone number should be in **E.164** format.
</aside>

# How the successful authentication response look like

```json
{
  "access_token" : "ACCESS_TOKEN",  
  "token_type" : "bearer",
  "expires_in" : 3599,
  "refresh_token" : "REFRESH_TOKEN",
  "refresh_token_expires_in" : 604799,
  "scope" : "SMS EditPresence ReadCallLog InternalMessages ReadPresence ReadAccounts RingOut Faxes EditMessages ReadMessages",
  "owner_id" : "1234567890"
}
```

After successful authentication or after successful refresh procedures you will get the following JSON structure which
will be remembered by SDK and used for further requests.

<aside class="success">
You can analyze `scope` to understand permissions available for the user.
</aside>

# How should I store authentication between sessions / runs

```shell
# Exported $RC_ACCESS_TOKEN is available between requests
```

```javascript
// Browser does it automatially, in NodeJS you can do:
var fs = require('fs');

// when application is going to be stopped
fs.writeFileSync('./platform.json', JSON.stringify(rcsdk.getPlatform().getAuthData()));

// and then next time during application bootstrap before any authentication checks:
rcsdk.getPlatform().setAuthData(require('./platform.json'));
```

```php
$file = './platform.json';

// when application is going to be stopped
file_put_contents($file, json_encode($platform->getAuthData(), JSON_PRETTY_PRINT));

// and then next time during application bootstrap before any authentication checks:
$rcsdk->getPlatform()->setAuthData(json_decode(file_get_contents($file));
```

```python
cache_dir = os.path.join(os.getcwd(), '_cache')
file_path = os.path.join(cache_dir, 'platform.json')

def get_file_cache():
    try:
        f = open(file_path, 'r')
        data = json.load(f)
        f.close()
        return data if data else {}
    except IOError:
        return {}


def set_file_cache(cache):
    if not os.path.isdir(cache_dir):
        os.mkdir(cache_dir)
    f = open(file_path, 'w')
    json.dump(cache, f, indent=4)
    f.close()

// when application is going to be stopped
set_file_cache(platform.get_auth_data())

// and then next time during application bootstrap before any authentication checks:
platform.set_auth_data(get_file_cache())
```

Application may store authentication data between sessions or runs by retreiving or updating auth data in `Platform`
instance.

# How do I handle access or authentication exceptions while the application is running?

```javascript
platform.on(platform.events.accessViolation, function(e){
    // do something
});
```

```php
// TODO
```

```python
# TODO
```

```shell
# TODO
```

To handle possible access or authentication exceptions that may occur while the application is running (after the user has successfully logged in), you can provide a handler for the accessViolation platform event.

A recommend way to handle access or authentication exceptions is to direct the user to the login page or UI. The login page may attempt to automatically re-authenticate the user using stored authentication data (see below).
