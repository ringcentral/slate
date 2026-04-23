# Attributes

An attribute is a typed key/value pair used to describe risks, claims, and assets (e.g. `country_v2` / `US`, `asset_type` / `wind_farm`). Attributes drive filtering, exposure aggregation, and scenario matching.

## Attribute Object Attributes

| Attribute                    | Type     | Description                                                                                  |
|------------------------------|----------|----------------------------------------------------------------------------------------------|
| `id`                         | _int_    | Unique identifier for the attribute.                                                         |
| `value`                      | _int_    | Duplicate of `id` (legacy alias).                                                            |
| `type`                       | _string_ | Attribute type (e.g. `country_v2`, `asset_type`, `head_of_cover`). See Attribute Types.      |
| `attribute_value`            | _string_ | Raw value of the attribute (e.g. `"US"`, `"wind_farm"`).                                     |
| `label`                      | _string_ | Human-readable label.                                                                        |
| `description`                | _string_ | Optional free-text description.                                                              |
| `group_id`                   | _int_    | Group that owns the attribute, or `null` for Allphins-shared attributes.                     |
| `display_metadata`           | _dict_   | Additional metadata used by the UI.                                                          |
| `portfolio_occurrence_count` | _int_    | Count of risks using this attribute in the portfolio (populated only by `/search/`).         |
| `portfolio_total_risks`      | _int_    | Total risks in the portfolio (populated only by `/search/`).                                 |

## Retrieve all attributes

Returns a paginated list of attributes visible to the current user. Filter by `type` and search across `value`, `label`, and aliases.

```shell
curl "https://api.allphins.com/api/v1/attributes/?type=country_v2&search=united" \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

> The above command returns JSON structured like this:

```json
{
  "count": 2,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": 1001,
      "value": 1001,
      "type": "country_v2",
      "attribute_value": "US",
      "label": "United States",
      "description": null,
      "group_id": null,
      "display_metadata": {},
      "portfolio_occurrence_count": 0,
      "portfolio_total_risks": 0
    }
  ]
}
```

### HTTP Request

`GET https://api.allphins.com/api/v1/attributes/`

### Query Parameters

| Parameter | Description                                    |
|-----------|------------------------------------------------|
| `type`    | Filter by attribute type.                      |
| `search`  | Search across `value`, `label`, and aliases.   |

## Retrieve an attribute

```shell
curl https://api.allphins.com/api/v1/attributes/1001/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`GET https://api.allphins.com/api/v1/attributes/:id/`

### URL Parameters

| Parameter | Description                       |
|-----------|-----------------------------------|
| `id`      | The ID of the attribute to fetch. |

## Search attributes

Full-text search over attributes, scoped to the current group. Optionally scoped to a portfolio; when `portfolio_id` is passed, `portfolio_occurrence_count` and `portfolio_total_risks` are populated in the response.

```shell
curl "https://api.allphins.com/api/v1/attributes/search/?type=asset&search=sleipner&portfolio_id=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx&page=1&page_size=30" \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`GET https://api.allphins.com/api/v1/attributes/search/`

### Query Parameters

| Parameter      | Type   | Required | Description                                                     |
|----------------|--------|----------|-----------------------------------------------------------------|
| `type`         | _string_ | No     | Filter by attribute type.                                       |
| `search`       | _string_ | No     | Free-text search term.                                          |
| `portfolio_id` | _UUID_   | No     | Scope to a portfolio for occurrence counts.                     |
| `source`       | _string_ | No     | Source filter. Validated against `type` (asset/entity sources). |
| `page`         | _int_    | No     | Page number (default `1`).                                      |
| `page_size`    | _int_    | No     | Page size (default `30`, max `100`).                            |

## Suggest related attributes

Returns attributes commonly associated with the given one (e.g. a region given a country). Optionally filtered by line of business.

```shell
curl "https://api.allphins.com/api/v1/attributes/1001/suggest/?line_of_business=cyber" \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`GET https://api.allphins.com/api/v1/attributes/:id/suggest/`

### URL Parameters

| Parameter | Description                    |
|-----------|--------------------------------|
| `id`      | The ID of the source attribute.|

### Query Parameters

| Parameter          | Description                       |
|--------------------|-----------------------------------|
| `line_of_business` | Optional line of business filter. |

## Suggest address attributes

Normalizes and geolocates an address from its components and returns the resulting attribute objects (country, state, county, city, zip, lat/lng).

```shell
curl "https://api.allphins.com/api/v1/attributes/suggest_address/?country_v2=US&state_v2=CA&city_v2=San+Francisco&zip_code_v2=94105" \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`GET https://api.allphins.com/api/v1/attributes/suggest_address/`

### Query Parameters

| Parameter        | Description                |
|------------------|----------------------------|
| `country_v2`     | Country code.              |
| `state_v2`       | State.                     |
| `county_v2`      | County.                    |
| `city_v2`        | City.                      |
| `zip_code_v2`    | ZIP / postal code.         |
| `address_v2`     | Full street address.       |
| `latitude`       | Latitude.                  |
| `longitude`      | Longitude.                 |
| `edm_addrmatch`  | EDM address match level.   |

## Create a customer attribute

Creates a group-owned attribute from a free-form label. The `value` is derived from the label server-side.

### HTTP Request

`POST https://api.allphins.com/api/v1/attributes/create_customer_attribute/`

### Payload

| Parameter | Type     | Required | Description                       |
|-----------|----------|----------|-----------------------------------|
| `label`   | _string_ | Yes      | Display label (non-empty).        |
| `type`    | _string_ | Yes      | Attribute type (see `AttributeType.type`). |

```shell
curl https://api.allphins.com/api/v1/attributes/create_customer_attribute/ \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"label":"North Sea rig","type":"asset"}'
```

# Attribute Types

Attribute types define the domain of `type` values used by attributes (e.g. `country_v2`, `head_of_cover`). Customers can register their own types in their group.

## Attribute Type Object Attributes

| Attribute     | Type     | Description                                                                 |
|---------------|----------|-----------------------------------------------------------------------------|
| `id`          | _int_    | Unique identifier for the attribute type.                                   |
| `type`        | _string_ | Machine name (slug). Auto-generated from `label` on create.                 |
| `label`       | _string_ | Human-readable label.                                                       |
| `description` | _string_ | Optional description.                                                       |
| `group`       | _int_    | Group ID owning the type.                                                   |

## Retrieve all attribute types

Returns all attribute types of the current group.

```shell
curl https://api.allphins.com/api/v1/attribute_types/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`GET https://api.allphins.com/api/v1/attribute_types/`

## Create an attribute type

### HTTP Request

`POST https://api.allphins.com/api/v1/attribute_types/`

### Payload

| Parameter     | Type     | Required | Description                                    |
|---------------|----------|----------|------------------------------------------------|
| `label`       | _string_ | Yes      | Human-readable label.                          |
| `description` | _string_ | No       | Optional description.                          |

```shell
curl https://api.allphins.com/api/v1/attribute_types/ \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"label":"Internal Risk Code","description":"Internal taxonomy"}'
```
