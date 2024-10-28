---
title: API Reference

language_tabs: # must be one of https://github.com/rouge-ruby/rouge/wiki/List-of-supported-languages-and-lexers
  - shell

toc_footers:
  - <a href='https://www.filmmakers.eu'>&larr; back to Filmmakers</a>

search: true

code_clipboard: true

meta:
  - name: description
    content: Documentation for the Filmmakers API
---

# Introduction

Filmmakers provides a RESTful JSON API with OAuth and token-based authentication. You can request an API key with [our support](https://www.filmmakers.eu/contact/new). The permission scope of the API key varies depending on the use case, so when contacting us be sure to specify the desired use case (e.g. you plan on using Filmmakers data for a website).

# API updates and backwards compatibility

While we won't be introducing any major changes, we do plan to add new features and endpoints over time. This is a list of changes that we consider to be backwards compatible:

* Adding new fields or links to responses
* Adding new resources or endpoints
* Adding of new (optional) query parameters
* Changes to the default page length for paginated resources
* Changes to the attributes of individual fields (including adding/removing/modifying values). Updated lists can be retrieved via the attributes endpoint (see dedicated section).

Please bear this in mind when programming against our API, and try to ensure that these non-breaking changes don't break your code.

If we do introduce a breaking change, we will create new endpoints with a new version prefix in the URI.

# Authentication

## Token-based

Once you have been issued an API key you can use the following code to authorize requests:

```shell
curl "api_endpoint_here" \
  -H "Authorization: Token token=API_KEY"
```

Filmmakers expects the API key to be included in all API requests to the server in a header that looks like the following:

`Authorization: Token token=API_KEY`

<aside class="notice">
You must replace <code>API_KEY</code> with your personal API key.
</aside>

## OAuth

Filmmakers API supports the OAuth flow with refresh tokens.

### Setting up OAuth Access

Once you have been issued an API key with OAuth Authorization enabled, you can use the following configuration from your client code:

[Filmmakers OpenID Configuration](https://www.filmmakers.eu/.well-known/openid-configuration)

See example on how to fetch the OAuth Access Token with curl.

```shell
export CLIENT_ID="your-client-id-goes-here"
export CLIENT_SECRET="your-client-secret-goes-here"
curl -s -X POST "http://filmmakers.test/oauth/token" \
           -H "Content-Type: application/x-www-form-urlencoded" \
           --data-urlencode "grant_type=client_credentials" \
           --data-urlencode "client_id=$CLIENT_ID" \
           --data-urlencode "client_secret=$CLIENT_SECRET" \
           --data-urlencode "scope=public"
```

```json
{"access_token":"Uvm37RVcZano399REpMXh837fDT-jtSc0lTvmEexpKI","token_type":"Bearer","expires_in":7200,"scope":"public","created_at":1730119409}
```

<aside class="notice">
You must replace <code>CLIENT_ID</code> and <code>CLIENT_SECRET</code> with your credentials.
</aside>

### Using OAuth Access Tokens

Filmmakers expects the OAuth Access Token to be included in all API requests to the server in a header that looks like the following:

`Authorization: Bearer ACCESS_TOKEN`

OAuth Access Tokens expire in 120 minutes and have to be refreshed, your client software is responsible for automating the OAuth flow.


```shell
curl -I https://www.filmmakers.eu/api/v1/actor_profiles -H "Authorization: Bearer $ACCESS_TOKEN" -H "Accept: application/json"
```

```text
HTTP/1.1 200 OK
```
<aside class="notice">
You must replace <code>ACCESS_TOKEN</code> with a non-expired OAuth Access Token.
</aside>

# Cross origin resource sharing

The API supports Cross Origin Resource Sharing (CORS) for AJAX requests from any origin.

Here's a sample request sent from a browser hitting [https://www.example.com/](https://www.example.com/):

```
$ curl -I https://www.filmmakers.eu/api/v1/actor_profiles -H "Origin: https://www.example.com"
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET
```

# Rate limits

Rate limits are enforced on a per IP address basis. Currently Filmmakers allows up to 300 requests within a 5 minute period. If this quota is exceeded your IP will be throttled for the remainder of this period. In this case the API will return an error responses that shows up as status code `429`.

Along with the status code the following `RateLimit` response header fields will be returned:

```
Ratelimit-Limit: 300
Ratelimit-Remaining: 0
Ratelimit-Reset: 1597048500
```

* `Ratelimit-Limit`: the request-quota associated to your client (defaults to 300)
* `Ratelimit-Reset`: the timestamp when the quota resets

# Pagination

This API supports pagination, following the proposed [RFC-8288](https://tools.ietf.org/html/rfc8288) standard for Web linking.

The pagination information is included in response HTTP headers, namely `Total` (total entries), `Per-Page` (entries per page) and `Link` (containing links to corresponding pages).

The current page can be set using the `page` parameter, and the number of entries per page can be specified with the optional `per_page` parameter. The default value for `per_page` is 250, and the maximum allowed value for `per_page` is 1000. If this limit is exceeded, a `400 Bad Request` error code will be returned.

# Webhooks

A webhook is an endpoint on your server that receives requests from Filmmakers, notifying you about events for actor profiles such as a profile edit. This requires a new endpoint on your server such as <https://www.example.com/webhooks/filmmakers> which should be publicly accessible and allow unauthenticated POST requests. Note that HTTPS URLs are required for all webhook endpoints.

**Read the event data**

Filmmakers sends the event data in the request body. Each event is structured as an Event object with a type, timestamp, and related Filmmakers resource nested under data (currently only an actor profile id - see example on the right)

```json
{
  "type": "actor_profile.updated"
  "created": 1633887337,
  "data": {
    "id": 123
  }
}
```

There are currently two event types: `actor_profile.updated` and `actor_profile.deleted`. Note that update events are grouped if they occur within a reasonable timeframe, e.g. you might only receive 1 webhook if an actor profile is updated several times within a short timeframe.

**Return a 200 response**

Send a successful 200 response to Filmmakers as quickly as possible because the event is retried with an exponential back off if a response isn't sent within a reasonable time. This means that you should write any long-running processes as code that can run asynchronously outside the webhook endpoint.

**Verify requests are sent by Filmmakers**

```
X-Signature: t=1492774577, v1=5257a869e7ecebeda32affa62cdca3fa51cad7e77a0e56ff536d0ce8e108d8bd
```

All webhook events are signed by including a signature in each event's header. This allows you to verify that the events were sent by Filmmakers, not by a third party. The Api key is used as secret to sign webhook events. Signatures are generated using a hash-based message authentication code (HMAC) with SHA-256.

The `X-Signature` header included in each signed event contains a timestamp and one signature. The timestamp is prefixed by `t=`, and the signature is prefixed by a scheme. Schemes start with `v`, followed by an integer. Currently, the only signature scheme is `v1`.

You can verify the signature on your side as follows (see example on the right in Ruby):

```ruby
# Step 1: Extract the timestamp and signatures from the header
signature = request.headers["X-Signature"]
  .split(",")
  .map { |part| part.split("=") }
  .to_h
# (this returns a hash like { "t" => 1492774577, "v1" => "5257a86..." })

# Step 2: Prepare the signed_payload string
payload = request.body.read
signed_payload = "#{signature['t']}.#{payload}"

# Step 3: Determine the expected signature
expected_signature = OpenSSL::HMAC.hexdigest(
  OpenSSL::Digest.new("sha256"),
  "YOUR_FILMMAKERS_API_KEY",
  signed_payload
)

# Step 4: Compare the signatures
expected_signature == signature["v1"]
```

**⚠ Webhooks are not yet generally available. If you are interested in using them please contact our support**


# Error codes

Filmmakers uses conventional HTTP response codes to indicate the success or failure of an API request. In general: Codes in the `2xx` range indicate success. Codes in the `4xx` range indicate an error that failed given the information provided (e.g., a required parameter is missing, the request lacks valid authentication credentials, etc.). Codes in the `5xx` range indicate an error with our servers (these should rarely happen).

Certain `4xx` errors, notably the `410` Gone status, indicate that a requested resource (such as an actor_profile or a talent_agency) has been merged with another and is no longer available at the original URL. The response will include the ID of the new resource, and clients should use this ID to access the merged resource.

# Changelog
- (2024-10-28) **API**: Optional OAuth Authorization added to all endpoints<br>
- (2024-09-26) **ActorProfile#show**: Add new fields `ethnic_background`, `ethnic_background_details` and `ethnic_background_custom`<br>
- (2024-08-16) **ActorProfile#show**: Expose `talent_agency_connections`, which includes more details about the agency connections of a profile
- (2024-07-01) **ActorProfile#show**: Add new field `gender_description`
- (2024-05-20) **ActorProfile#show**: Add new field `gender_searchability`
- (2024-05-16) **ActorProfile#index**: Add new field `gender_new`, which replaces 'diverse' value with a larger range of gender values.
- (2024-04-26) **ActorProfile#show**: Add new field `in_development` to Vita<br>
- (2024-04-12) **ActorProfile#show**: Add new fields `main_profession` and `specializations`<br>
**ActorProfile#index**: Add new field `main_profession`
- (2024-03-19) **ActorProfile#show**: Add new field `episode_name` to Vita
- (2023-08-17) **ActorProfile#index**: Added possibility to filter by `updated_at`
- (2023-05-31) **ActorProfile#index**:
  - Also emit `picture_copyright` if `include_picture` is specified
  - Add query field `representative`
- (2023-04-26) **ActorProfile#show**: Add `filmmakers_url` and `filmmakers_cd_url` (formerly `castupload_url` and `castupload_professional_url`)
- (2022-12-06) **ActorProfile#show**: Add `unions`
- (2022-09-09) **ActorProfile#index**: Add `updated_at` as selectable field
- (2022-01-26) **ActorProfile#show**: Add `pitches`, `figures`, `native_dialects`, `sport_skills`, `special_skills`
- (2022-01-12) **ActorProfile#show**: Add new fields `station` / `theatre` / `writer` to Vita

# Actor profiles

## Get all actor profiles

```shell
curl "https://www.filmmakers.eu/api/v1/actor_profiles" \
  -H "Authorization: Token token=API_KEY"
```

> The above command returns JSON structured like this:

```json
[
  {
    "id": 1,
    "name": "John Doe",
    "gender": "m"
  },
  {
    "id": 2,
    "name": "Jane Doe",
    "gender": "f"
  }
]
```

This endpoint retrieves all actor profiles available with the access rights of the API key. Most of the time it is scoped to a talent agency.

### HTTP Request

`GET https://www.filmmakers.eu/api/v1/actor_profiles`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
page | 1 | Page to display - see "Pagination" section
per_page | 250 | Items per page - see "Pagination" section
include_picture | false | If set to true, the result will include the profile picture thumbnail in a field named `main_picture_url_tile`.
picture_version | null | Can be set to `original`, `large` or `thumb` to change the included picture version. The picture will be included in a field named `picture_url`. _(Only applies if `include_picture` is true)_
fields | name,gender | Can be used to modify the fields included in the response. Possible values are: `age`, `gender`, `gender_new`, `first_name`, `last_name`, `name`, `main_profession`, `professions`, `languages`, `representative`, `updated_at`.
order | id | Changes the order of returned results. Possible values are: `id`, `name`, `last_name`
gender | null | Allows filtering by gender values. Possible values are: `male`, `female`, `transgender_female`, `transgender_male`, `non_binary`, `custom`.
updated_at[gte] | null | Allows filtering for profiles updated since the passed timestamp. Passed as an integer Unix timestamp.
q | null | Allows filtering by name. Uses trigram, so allows fuzzy & partial matches

### Response fields

Field | Type | Description
--------- | ------- | -----------
id | number | Unique ID of the actor profile
age | number |
gender | string | `f` for female, `m` for male, `i` for diverse
gender_new | string | `female` for female, `male` for male, `transgender_male` for transgender male, `transgender_female` for transgender female, `non_binary` for non binary, `custom` for custom set gender
gender_description | string | Custom information actors can enter about their gender identity (free text, max 75 characters)
gender_searchability | array of strings | list of genders actor profile can be found under, e.g. `["female", "non_binary"]` _this always at least includes the gender of the actor profile if visible_
name | string | Full name (ie. first & last name) _name can be retrieved separately by using the fields parameter_
first_name | string |
last_name | string |
main_profession | string | main profession of the actor profile
professions | array of strings | list of professions, eg. `["schauspieler", "synchronsprecher"]` _this includes the main_profession "schauspieler" or "nachwuchsdarsteller" when given_
languages | JSON Object | format `{ "language": "skill level" }`
updated_at | string | format ISO 8601
main_picture_url_tile | string | profile picture url (thumbnail version)
picture_url | string | profile picture url of specified version
picture_copyright | string | copyright information for the profile picture
representative | JSON Object | "id" and "name" of the agent representing the actor

## Get a specific actor profile

```shell
curl "https://www.filmmakers.eu/api/v1/actor_profiles/123" \
  -H "Authorization: Token token=API_KEY"
```

> The above command returns JSON structured like this:

```json
{
  "id": 162,
  "first_name": "John",
  "last_name": "Doe",
  "filmmakers_url": "https://www.filmmakers.eu/actors/john-doe",
  "filmmakers_cd_url": "https://cd.filmmakers.eu/profil/castupload/162",
  "acting_age_from": 35,
  "acting_age_to": 45,
  "year_of_birth": 1980,
  "age": 41,
  "height": 170,
  "weight": 60,
  "state_code": "DE-RP",
  "accommodation_options": [
    "Berlin",
    "Frankfurt",
    "Köln"
  ],
  "homepage_url": "www.example.com",
  "imdb_link": "https://www.imdb.com/name/nm0000001",
  "imdb_id": "nm0000001",
  "facebook_page": "Filmmakers",
  "twitter_handle": "Filmmakers",
  "instagram_username": "Filmmakers",
  "filmmakers_url": null,
  "sv_url": null,
  "wikipedia_url": "https://de.wikipedia.org/wiki/My_Page",
  "agency_profile_url": "https://www.my-agency/my-profile",
  "talent_agency_id": 1,
  "representative": {
    "id": 123,
    "name": "Jane Roe"
  },
  "profile_visibility": "public",
  "attribute_visibility": {
    "age": "public",
    "acting_age": "public",
    "gender": "public",
    "ethnic_appearances": "private",
    "figures": "private"
  },
  "talent_agency_connections": [
    {
      "talent_agency_id": 1,
      "talent_agency_employee_id": 123,
      "agency_profile_url": "https://www.my-agency/my-profile",
      "talent_agency_name": "My primary agency",
      "categories": [
        "acting_agency"
      ],
      "connection_type": "primary_agency"
    },
    {
      "talent_agency_id": 2,
      "talent_agency_employee_id": 321,
      "agency_profile_url": null,
      "talent_agency_name": "My PR agency",
      "categories": [
        "pr"
      ],
      "connection_type": "secondary_agency"
    }
  ],
  "updated_at": "2021-06-22T16:14:11.519+02:00",
  "native_dialect": "rheinisch",
  "place_of_birth": "Darmstadt",
  "city": "Mainz",
  "gender": "m",
  "gender_new": "male",
  "gender_description": "genderfluid",
  "gender_searchability": [
    "male"
  ],
  "eye_color": "braun",
  "hair_color": "braun",
  "hair_length": "mittel",
  "ethnic_appearances": [
    "mitteleuropaisch"
  ],
  "ethnic_background": [
    "6471"
  ],
  "ethnic_background_details": [
    "6473"
  ],
  "ethnic_background_custom": "My custom description",
  "figure": "normal",
  "pitch": "bariton",
  "nationalities": [
    "DE"
  ],
  "languages": {
    "deutsch": "muttersprachlich",
    "englisch": "fliessend"
  },
  "dialects": {
    "hessisch": "kann",
    "rheinisch": "kann"
  },
  "accents": {
    "osterreichisch": "kann"
  },
  "instruments": {
    "gitarre": "gut"
  },
  "sports": [
    "buhnenkampf"
  ],
  "dances": {
    "freestyle": "gut"
  },
  "main_profession": "actor",
  "specializations": [
    "synchronsprecher"
  ],
  "professions": [
    "schauspieler",
    "synchronsprecher"
  ],
  "singing": {
    "jazz": "grundkenntnisse"
  },
  "drivers_licenses": [
    "pkw-klasse-b-be"
  ],
  "licenses": [
    "fallschirmspringer-lizenz"
  ],
  "country": "DE",
  "state": "DE-RP",
  "special_skills": {
    "403": "gut"
  },
  "unions": [
    "bffs"
  ],
  "locations": [
    {
      "name": "Gdańsk",
      "latitude": 54.35202520000001,
      "longitude": 18.6466384,
      "place_id": "ChIJb_rUFBxz_UYRjb63Y_H7uZs",
      "type": "accommodation"
    },
    {
      "name": "Munich",
      "latitude": 48.1351253,
      "longitude": 11.5819806,
      "place_id": "ChIJ2V-Mo_l1nkcRfZixfUq4DAE",
      "type": "accommodation"
    },
    {
      "name": "Hamburg",
      "latitude": 53.5510846,
      "longitude": 9.9936818,
      "place_id": "ChIJuRMYfoNhsUcRoDrWe_I9JgQ",
      "type": "accommodation"
    },
    {
      "name": "Cologne",
      "latitude": 50.937531,
      "longitude": 6.9602786,
      "place_id": "ChIJ5S-raZElv0cR8HcqSvxgJwQ",
      "type": "accommodation"
    },
    {
      "name": "Berlin",
      "latitude": 52.52000659999999,
      "longitude": 13.404954,
      "place_id": "ChIJAVkDPzdOqEcRcDteW0YgIQQ",
      "type": "accommodation"
    },
    {
      "name": "Berlin",
      "latitude": 52.52000659999999,
      "longitude": 13.404954,
      "place_id": "ChIJAVkDPzdOqEcRcDteW0YgIQQ",
      "type": "place"
    }
  ],
  "pictures": [
    {
      "id": 140,
      "copyright": "Jane Doe",
      "created_at": "2021-06-21T16:18:41.087+02:00",
      "url": "https://imgproxy.filmmakers.eu/production/b6ac24ef-7bbc-4486-bfc9-89fdce3a9fde.jpg",
      "versions": {
        "original": "https://imgproxy.filmmakers.eu/gqz46mqnA/rt:fit/w:3840/h:2160/f:jpg/ZS5qcGVn",
        "large": "https://imgproxy.filmmakers.eu/gqz46mqnA/rt:fit/w:1200/h:1200/f:jpg/ZS5qcGVn",
        "thumb": "https://imgproxy.filmmakers.eu/gqz46mqnA/rt:fill/el:1/c:528:528:nowe:250:0/w:190/h:190/g:no/f:jpg/ZS5qcGVn"
      },
      "orientation": "square",
      "dimensions": [
        370,
        370
      ],
      "crop_coordinates": {
        "x": 0,
        "y": 0,
        "w": 500,
        "h": 500
      },
      "main_picture": true,
      "year": 2021,
      "recorded_at": "2020-06-22T11:51:51.363+02:00"
    },
    {
      "id": 141,
      "copyright": "",
      "created_at": "2021-06-21T16:18:47.460+02:00",
      "url": "https://imgproxy.filmmakers.eu/production/5c5a1832-3ee4-495d-bfb0-03694dab0bd2.jpg",
      "versions": {
        "original": "https://imgproxy.filmmakers.eu/gqz46mqnA/rt:fit/w:3840/h:2160/f:jpg/ZS5qcGVn",
        "large": "https://imgproxy.filmmakers.eu/gqz46mqnA/rt:fit/w:1200/h:1200/f:jpg/ZS5qcGVn",
        "thumb": "https://imgproxy.filmmakers.eu/gqz46mqnA/rt:fill/el:1/c:528:528:nowe:250:0/w:190/h:190/g:no/f:jpg/ZS5qcGVn"
      },
      "orientation": "landscape",
      "dimensions": [
        365,
        360
      ],
      "main_picture": false,
      "year": 2021,
      "recorded_at": null
    }
  ],
  "external_showreel": "https://www.youtube.com/watch?v=xxxx",
  "external_showreels": [
    "https://www.youtube.com/watch?v=xxxx",
    "https://vimeo.com/xxxx"
  ],
  "showreels": [
    {
      "name": "Showreel 2021",
      "url": "https://www.filmmakers.eu/actors/john-doe/showreels/15",
      "type": "video"
    },
    {
      "name": "Showreel 2020",
      "url": "https://www.filmmakers.eu/actors/john-doe/showreels/16",
      "type": "video"
    },
    {
      "name":"Audioreel 2021",
      "url":"https://www.filmmakers.eu/actors/john-doe/showreels/17",
      "type":"audio"
    }
  ],
  "showreel_ids": [
    12345,
    12346
  ],
  "showreel_medium_ids": [
    123456,
    123457,
    123458,
    123459,
    123460
  ],
  "vita": {
    "primary_education": [
      {
        "name": "ABC School",
        "year_from": 2012
      }
    ],
    "award": [
      {
        "info": null,
        "name": "Avanca Film Festival - Best Performance",
        "year_from": 2017,
        "year_to": 2017,
        "award_nominated": true
      }
    ],
    "education": [
      {
        "info": null,
        "name": "123 School",
        "year_from": 2013,
        "year_to": 2014
      }
    ],
    "film": [
      {
        "info": null,
        "name": "Schneeflöckchen",
        "year_from": 2019,
        "year_to": 2020,
        "in_development": false,
        "role": "Jack",
        "role_type": "supporting",
        "distributor": null,
        "director": "Adolfo Kolmerer",
        "producer": null,
        "caster": null,
        "picture": {
          "url": "https://imgproxy.filmmakers.eu/gqz46mqnA"
        }
      },
      {
        "info": null,
        "name": "The Harmonica ",
        "year_from": 2018,
        "year_to": 2018,
        "in_development": false,
        "role": "Felix",
        "role_type": "leading",
        "distributor": null,
        "director": null,
        "producer": "Deutsche Film- und Fernsehakademie Berlin",
        "caster": null,
        "picture": {
          "url": null
        }
      }
    ],
    "television": [
      {
        "info": null,
        "name": "Mord mit Aussicht",
        "episode_name": "Sophie kommet doch all",
        "year_from": 2015,
        "year_to": 2016,
        "in_development": false,
        "type_genre": "series",
        "role": "Robert",
        "role_type": "episode_featured_part",
        "distributor": null,
        "director": null,
        "producer": null,
        "caster": null,
        "picture": {
          "url": null
        }
      }
    ],
    "theatre": [
      {
        "info": null,
        "name":"Das Dschungelbuch (Jungle Book)",
        "year_from":2001,
        "year_to":2002,
        "in_development": false,
        "type_genre": null,
        "favorite":false,
        "role":"Mowgli",
        "role_type": null,
        "director":"Robert Persche",
        "producer": null,
        "caster": null,
        "writer": null,
        "theater_name":"Stadttheater Klagenfurt",
        "theater_engagement_type": null,
        "picture": {
          "url": null
        },
        "distributor":"Stadttheater Klagenfurt"
      }
    ],
    "audio": [],
    "other": [],
    "internet": [],
    "commercial": []
  }
}
```

This endpoint retrieves a specific actor profile.

### HTTP Request

`GET https://www.filmmakers.eu/api/v1/actor_profiles/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the actor profile to retrieve

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
enum | null | If set to `translate` attributes are translated if possible (e.g. gender will be `male` or `männlich` instead of `m`). _Note that hash and array attributes (eg. dances / sports) will be joined to a comma-separated string when translating attributes._
locale | en | Translates attributes with closed lists, free text fields are only available in the entry language. Possible values are: `en`, `de`, `fr`, `it`, `es`, `pl`, `ro`, `ru`, `tr`. _This parameter only has an effect when `enum` is set to `translate`._

### Response fields

See example response to the right for an overview of included fields. Please note:

- **Deprecation**: `external_showreel` is deprecated. Use `external_showreels` instead.
- **Deprecation**: `pitch` is deprecated. Use `pitches` instead.
- **Deprecation**: `figure` is deprecated. Use `figures` instead.
- **Deprecation**: `native_dialect` is deprecated. Use `native_dialects` instead.
- **Deprecation**: `castupload_url` is deprecated. Use `filmmakers_url` instead.
- **Deprecation**: `castupload_professional_url` is deprecated. Use `filmmakers_cd_url` instead.
- **Deprecation**: `professions` is deprecated. Use `main_profession` and `specializations` instead.
- **Deprecation**: `ethnic_appearances` is deprecated. Use `ethnic_background`, `ethnic_background_details` and `ethnic_background_custom` instead.

It is not guaranteed that the exemplary JSON structure shown is complete. Additional fields may be added without notice. The following table provides additional context for the individual fields visible in the exemplary JSON structure:

Field | Type | Description
--------- | ------- | -----------
talent_agency_connections[].talent_agency_id | integer | id of the talent agency
talent_agency_connections[].talent_agency_employee_id | integer | id of the talent agency employee
talent_agency_connections[].agency_profile_url | string | actor profile url on the website of their agency
talent_agency_connections[].talent_agency_name | string | name of the agency
talent_agency_connections[].categories | Array | indicates the areas in which the agency represents the client, possible values are "acting_agency", "advertising", "artist_management", "model_agency", "people_agency", "pr", "voice_agency", or "young_talent_agency".
talent_agency_connections[].connection_type	 | string |indicates the type of agency connection, which can be either "primary_agency" (the main agency) or "secondary_agency". There can be multiple secondary agencies.
agency_profile_url | string | actor profile url on the website of their agency **Note** Please use talent_agency_connections[].agency_profile_url instead
talent_agency_id | integer | id of the talent agency **Note** Please use talent_agency_connections[].talent_agency_id instead
representative.id | integer | id of the talent agency employee **Note** Please use talent_agency_connections[].talent_agency_employee_id instead
representative.name | string | name of the talent agency employee **Note** Please use talent_agency#employees.first_name/last_name instead
attribute_visibility | hash | Indicates per attribute `age`, `acting_age`, `gender`, `ethnic_appearances` and `figures` whether these are publicly visible on Filmmakers (`public`) or only visible to verified casting professionals (`private`)
profile_visibility | string | Visibility of the profile on Filmmakers (`public` or `private`)
showreel_ids | Array | Ids of showreels (see `showreels` endpoint)
showreel_medium_ids | Array | Ids of showreel media that are either connected to a showreel or credits/skills (see also `showreel_media` endpoint)
vita | hash | A collection of credits, where each entry contains structured data related to a specific credit. The entries are sorted by the following criteria: `in_development` (entries with `true` are prioritized), `year_to`/`year_from` (in descending chronological order), `position` (manually sorted by the user), and `id`. The credits are grouped by type, such as `education`, `television`, `theatre`, etc.
vita.x[].in_development | boolean | indicates film projects that are still in development, meaning it has not been completed or released yet
ethnic_background | Array | Contains general ethnicities or heritages of the actor. Visibility depends on the setting for `ethnic_appearances` (as described above under _attribute_visibility_).
ethnic_background_details | Array | Contains specific ethnicities or heritages of the actor, e.g. specific countries.
ethnic_background_custom | string | Contains a custom description of ethnicities or heritages entered by the actor.

# Talent agencies

## Get talent agency data

```shell
curl "https://www.filmmakers.eu/api/v1/talent_agencies/123" \
  -H "Authorization: Token token=API_KEY"
```

> The above command returns JSON structured like this:

```json
{
  "id": 1,
  "name": "Example agency",
  "short_name": "Agency",
  "homepage_url": "https://www.example.com",
  "filmmakers_url": "https://www.filmmakers.eu/agents/example-agency",
  "imdb_link": "https://pro.imdb.com/company/co0000001",
  "imdb_id": "co0000001",
  "showreel_url": "https://www.example.com/showreel",
  "twitter_handle": "@example_agency",
  "public_email": "info@example.com",
  "picture_url": "https://imgproxy.filmmakers.eu/bf042068-c6ac-11ee-b970-a34dadd10171.jpg",
  "address": {
    "city": "Mainz",
    "country": "DE",
    "fax": null,
    "line1": "Wallstr. 11",
    "line2": "",
    "phone": "49613163691950",
    "zipcode": "55122"
  },
  "employees": [
    {
      "id": 1,
      "first_name": "John",
      "last_name": "Doe",
      "phone": "49613163691950",
      "email": "info@example.com",
      "role": "role",
      "picture_url": "https://imgproxy.filmmakers.eu/bfa9eb4c-c6ac-11ee-9015-f30db07efa43.jpg"
    }
  ]
}
```

This endpoint retrieves a specific talent agency.

### HTTP Request

`GET https://www.filmmakers.eu/api/v1/talent_agencies/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the talent agency to retrieve

### Response fields

See example response to the right for an overview of included fields.

# Blog posts

## Get all blog posts

```shell
curl "https://www.filmmakers.eu/api/v1/blog_posts" \
  -H "Authorization: Token token=API_KEY"
```

> The above command returns JSON structured like this:

```json
[
  {
    "id": 36,
    "title": "Blog post title"
  },
  {
    "id": 35,
    "title": "Blog post title"
  }
]

```

This endpoint retrieves all blog posts available with the access rights of the API key.

### HTTP Request

`GET https://www.filmmakers.eu/api/v1/blog_posts`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
blog_id | id | Limit blog posts to specific blog id (e.g. `blog_id` from actor profile)
page | 1 | Page to display - see "Pagination" section
per_page | 250 | Items per page - see "Pagination" section
tags[id] | null | Filter items by tags - allows passing multiple tag ids using array form of the param eg. `tags[id][]=1&tags[id][]=5`

### Response fields

Field | Type | Description
--------- | ------- | -----------
id | number | Unique ID of the blog post
title | string | Title of the blog post

## Get a specific blog post

```shell
curl "https://www.filmmakers.eu/api/v1/blog_posts/123" \
  -H "Authorization: Token token=API_KEY"
```

> The above command returns JSON structured like this:

```json
{
  "id": 123,
  "title": "Blog post title",
  "note": "Blog post note",
  "publication_date": "2019-09-02T12:44:19.776+02:00",
  "source": null,
  "tags": [
    {
      "id": 3,
      "name": "News"
    },
    {
      "id": 4,
      "name": "Premiere"
    }
  ],
  "body": "Blog post body",
  "body_html": "<div>Blog post body<figure class=\"attachment attachment--preview attachment--jpg\"><div class=\"image-wrapper\"><img src=\"https://imgproxy.filmmakers.eu/83570365-9d0f-4165-85c6-df1dd48adb1f.jpg\"><div class=\"image-caption\"><span title=\"© Acme inc\">© Acme inc</span></div></div></figure></div>",
  "images": [
    {
      "url": "https://imgproxy.filmmakers.eu/83570365-9d0f-4165-85c6-df1dd48adb1f.jpg",
      "copyright": "Acme inc"
    },
    {
      "url": "https://imgproxy.filmmakers.eu/83570365-9d0f-4165-85c6-df1dd48adb1f.jpg",
      "copyright": "Abc inc"
    }
  ]
}

```

This endpoint retrieves a specific blog post.

### HTTP Request

`GET https://www.filmmakers.eu/api/v1/blog_posts/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the blog post to retrieve

### Response fields

See example response to the right for an overview of included fields

Field | Type | Description
--------- | ------- | -----------
title | string | title of the blog post
note | string | optional comment on the post
body | string | plain text representation of the blog post body with line breaks, **but no HTML markup**
body_html | string |  blog post body with **HTML markup**, includes images with copyright information. Allowed HTML tags are `a, br, div, em, figcaption, figure, h1, img, li, ol, strong, ul`. Following example CSS can be used to show copyright over the image at the top left corner: `.image-wrapper { position: relative; } .image-caption { position: absolute; top: 0; left: 0; z-index: 1; }`
publication_date | datetime | publication date of this post
source | string | original source of the post - e.g. a newspaper in case an article was shared from an external url. Will be null in case of internal posts, i.e. posts written by the entity themselves.
source.url | string | url of the source article
source.publication_date | datetime | date of publication of original (may be null if source date cannot be determined)
tags | array | array of tags applied to the blog post, each containing two key-value pairs: "id" and "name". Available tag names are: "News", "Premiere", "Awards", and "Press"
images[].url | string | image url
images[].cover | boolean | true if image is a cover image; default: `false`
images[].copyright | string | image copyright


# Showreels

## Get a specific showreel

```shell
curl "https://www.filmmakers.eu/api/v1/showreels/100" \
  -H "Authorization: Token token=API_KEY"
```

> The above command returns JSON structured like this:

```json
{
  "id": 100,
  "showreel_type": "video",
  "name": "Showreel 2024",
  "position": 1,
  "poster_copyright": "Photographer XYZ",
  "download": true,
  "showreel_medium_ids": [
    123456,
    123457,
    123458,
    123459,
    123460
  ],
  "poster": "https://imgproxy.filmmakers.eu/8f7c74be-c696-11ee-85a8-4781e0bae8b1.jpg"
}

```

This endpoint retrieves a specific showreel.

### HTTP Request

`GET https://www.filmmakers.eu/api/v1/showreels/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the showreel to retrieve (refer to the `showreel_ids` array field from actor_profiles endpoint to obtain these ids)

### Response fields

See example response to the right for an overview of included fields

Field | Type | Description
--------- | ------- | -----------
id | integer | ID of the showreel
showreel_type | string | either `video` or `audio`
name | string | name of the showreel
position | integer | The position of the showreel on Filmmakers
poster | string | Image url to the showreel poster/thumb
poster_copyright | string | Copyright for the showreel poster/thumb
download | boolean | Whether the download option is active on Filmmakers
showreel_medium_ids| array | IDs of showreel media contained in the showreel (see `showreel_media` endpoint below)

# Showreel Media

## Get specific showreel media

```shell
curl "https://www.filmmakers.eu/api/v1/showreel_media/123456" \
  -H "Authorization: Token token=API_KEY"
```

> The above command returns JSON structured like this:

```json
{
  "id": 123456,
  "type": "ShowreelVideo",
  "name": "Faking Bullshit",
  "director": "Alexander Schubert",
  "role": "Rocky",
  "year": 2019,
  "download": true,
  "duration": "171.6",
  "skills": [
    "languages/deutsch"
  ],
  "vita_entry_id": 300,
  "skill": "languages/deutsch",
  "picture": "https://imgproxy.filmmakers.eu/8f7c74be-c696-11ee-85a8-4781e0bae8b1.jpg",
  "asset": null,
  "proxies": {
    "sd": "https://static.filmmakers.eu/production/0fd099dc-c698-11ee-93cb-cb381089a4e7.mp4",
    "hd": "https://static.filmmakers.eu/production/107a9e6e-c698-11ee-8895-f34d7095f1f5.mp4",
    "full_hd": "https://static.filmmakers.eu/production/109d0832-c698-11ee-b7b8-fb95fd1a375c.mp4"
  }
}

```

This endpoint retrieves specific showreel media.

### HTTP Request

`GET https://www.filmmakers.eu/api/v1/showreel_media/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the showreel media to retrieve (refer to the `showreel_medium_ids` array field from showreels endpoint to obtain these ids)

### Response fields

See example response to the right for an overview of included fields

Field | Type | Description
--------- | ------- | -----------
id | integer | ID of the video or audio
type | string | either `ShowreelVideo` (for videos) or `ShowreelAudio` (for audios)
name | string | Name of the video or audio
director | string | Name of the director linked to the medium (if any)
role | string| Name of the role linked to the medium (if any)
year | integer | Year of the medium (if any)
download | boolean | Whether the download option is active on Filmmakers
duration | float | Duration in seconds
skills | array | Links to skills from actor profile attributes, in the format of `NAME#VALUE`, e.g. `languages#deutsch` or `dialects#berlinerisch`
skill | string | Deprecated, please use `skills`
vita_entry_id | integer | ID of vita entry (credit) if any
picture | string | Image url to the thumb
asset | string | Only filled in for type `ShowreelAudio`, may contain codecs `AAC` or `MP3`
proxies | array | For the type `ShowreelVideo`, provide links to transcoded proxies in MP4 format (H.264). These proxies may include the following quality options:<br>- **sd**: 480p<br>- **hd**: 720p<br>- **full_hd**: 1080p<br><br>Note that depending on the quality of the source file, `full_hd` and/or `hd` might not be available. Additionally, there might be two legacy proxies:<br>- **web_quality**: Roughly equivalent to 720p<br>- **portrait**: Media in portrait mode

# Attributes

## Get all attributes

```shell
curl "https://www.filmmakers.eu/api/v1/attributes/" \
  -H "Authorization: Token token=API_KEY"
```

> The above command returns an Array structured like this:

```json
[
  "accent_skill",
  "accents",
  "dances",
  "dialect_skill",
  "dialects",
  "drivers_licenses",
  ...
]
```

This endpoint retrieves all possible profile attributes that are closed lists like languages or nationalities as well as attributes for credits/vita.

For countries ISO 3166-1 alpha-2 codes are used <https://en.wikipedia.org/wiki/ISO_3166-2>. For federal states (states/subdivisions) ISO 3166-2 are used, e.g. for Germany: <https://en.wikipedia.org/wiki/ISO_3166-2:DE>. Since the ISO lists are standardized (and extensive), they are not present in this endpoint for the time being.

## Get key/value pairs for attributes

```shell
curl "https://www.filmmakers.eu/api/v1/attributes/xxx" \
  -H "Authorization: Token token=API_KEY"
```

> The above command returns JSON structured like this (e.g. for nationalities):

```json
{
  "AD":"Andorran",
  "AE":"United Arab Emirates",
  "AF":"Afghan",
  "AG":"Antigua and Barbuda",
  "AL":"Albanian",
  "AM":"Armenian",
  "AO":"Angolan",
  "AR":"Argentinean",
  "AT":"Austrian",
  "AU":"Australian",
  ...
}
```

This endpoint retrieves all possible key/value pair for one of the attributes. Pass one of the supported locales (see above) as param to retrieve localized values.


