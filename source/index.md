---
title: API Reference

language_tabs:
  - javascript
  - shell
  - ruby
  - python

toc_footers:
  - <a href='http://developers.ringcentral.com' target="_blank">Sign Up</a> for RingCentral for Developers
  - Documentation Powered by <a href='http://github.com/tripit/slate' target="_blank">Slate</a>

includes:
  - errors

search: true
---

# Mockup code for syntax highlighting

A sample JavaScript code block.

```javascript
var RC_SERVER_PRODUCTION = 'http://platform.ringcentral.com';
var RC_SERVER_SANDBOX = 'https://platform.devtest.ringcentral.com';

var rcsdk = new RCSDK({
  server: RC_SERVER_SANDBOX,
  appKey: 'yourAppKey',
  appSecret: 'yourAppSecret'
});
```

# How to deploy RC tutorials to Github

## Fork Slate and build

1. Fork project `slate` from github: https://github.com/tripit/slate
2. Clone to local machine for modifications: `git clone https://github.com/agongdai/slate.git`
3. `cd slate`
4. `bundle install`: here may report error:

> Gem::RemoteFetcher::FetchError: SSL_connect returned=1 errno=0
> state=SSLv3 read server certificate B: certificate verify failed
> (https://rubygems.org/gems/middleman-sprockets-3.4.2.gem) An error occurred while installing middleman-sprockets (3.4.2), and Bundler cannot continue. Make sure that `gem install middleman-sprockets -v '3.4.2'` succeeds before bundling.

That is because the URL `https://rubygems.org` somehow has certificate issue. Change it to `http://rubygems.org`: modify the first line of file `Gemfile` and `Gemfile.lock`.

## `json` gem error

5. When installing `json`, an error may occur:
> ERROR:  Error installing json:
>     The 'json' native gem requires installed build tools.

Follow the answer of this guy: Massimo Fazzolari. If there are multiple version of Ruby installations, uninstall one of them first. 

The version is changed from `1.9.8` to `1.9.6`.

## Local server, build and publish

6. `bundle exec middleman server`: start the local server and visit [http://localhost:4567](http://localhost:4567).
7. `rake build`: make whatever modifications to `source/index.md` and commit. Then build the HTML files to folder `build`. The file `index.html` is the entry point.
8. Copy all files in folder `build` to the `rc-tutorials` folder of project `agongdai.github.io`.
9. Visite http://agongdai.github.io/rc-tutorials.

# Introduction

Modified by Carl.

Welcome to the Kittn API! You can use our API to access Kittn API endpoints, which can get information on various cats, kittens, and breeds in our database.

We have language bindings in Shell, Ruby, and Python! You can view code examples in the dark area to the right, and you can switch the programming language of the examples with the tabs in the top right.

This example API documentation page was created with [Slate](http://github.com/tripit/slate). Feel free to edit it and use it as a base for your own API's documentation.

# Authentication

> To authorize, use this code:

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
```

```shell
# With shell, you can just pass the correct header with each request
curl "api_endpoint_here"
  -H "Authorization: meowmeowmeow"
```

> Make sure to replace `meowmeowmeow` with your API key.

Kittn uses API keys to allow access to the API. You can register a new Kittn API key at our [developer portal](http://example.com/developers).

Kittn expects for the API key to be included in all API requests to the server in a header that looks like the following:

`Authorization: meowmeowmeow`

<aside class="notice">
You must replace <code>meowmeowmeow</code> with your personal API key.
</aside>

# Kittens

## Get All Kittens

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get()
```

```shell
curl "http://example.com/api/kittens"
  -H "Authorization: meowmeowmeow"
```

> The above command returns JSON structured like this:

```json
[
  {
    "id": 1,
    "name": "Fluffums",
    "breed": "calico",
    "fluffiness": 6,
    "cuteness": 7
  },
  {
    "id": 2,
    "name": "Isis",
    "breed": "unknown",
    "fluffiness": 5,
    "cuteness": 10
  }
]
```

This endpoint retrieves all kittens.

### HTTP Request

`GET http://example.com/api/kittens`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
include_cats | false | If set to true, the result will also include cats.
available | true | If set to false, the result will include kittens that have already been adopted.

<aside class="success">
Remember — a happy kitten is an authenticated kitten!
</aside>

## Get a Specific Kitten

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get(2)
```

```shell
curl "http://example.com/api/kittens/2"
  -H "Authorization: meowmeowmeow"
```

> The above command returns JSON structured like this:

```json
{
  "id": 2,
  "name": "Isis",
  "breed": "unknown",
  "fluffiness": 5,
  "cuteness": 10
}
```

This endpoint retrieves a specific kitten.

<aside class="warning">If you're not using an administrator API key, note that some kittens will return 403 Forbidden if they are hidden for admins only.</aside>

### HTTP Request

`GET http://example.com/kittens/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the kitten to retrieve

