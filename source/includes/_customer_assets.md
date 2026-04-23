# Customer Assets

A customer asset is a user-created asset record (e.g. a plant, rig, or vessel) owned by the current group. Customer assets are stored behind an `AssetManager` record shared with the Allphins, Clarkson, GEM, and custom asset registries.

## Customer Asset Object Attributes

| Attribute        | Type         | Description                                                          |
|------------------|--------------|----------------------------------------------------------------------|
| `id`             | _UUID_       | Unique identifier for the customer asset.                            |
| `name`           | _string_     | Name of the asset.                                                   |
| `asset_category` | _string_     | Asset category (derived from `agg_fields` if not set explicitly).    |
| `status`         | _string_     | Status of the asset.                                                 |
| `latitude`       | _float_      | Latitude.                                                            |
| `longitude`      | _float_      | Longitude.                                                           |
| `country`        | _string_     | ISO 2-letter country code (mapped to `country_code`).                |
| `group`          | _int_        | Owning group ID.                                                     |
| `manager`        | _UUID_       | ID of the `AssetManager` representing this asset.                    |
| `agg_fields`     | _list[dict]_ | Additional attribute fields (`{type, value}` pairs).                 |
| `display_fields` | _dict_       | Fields to display in the UI.                                         |

## Create a customer asset

Creates a customer asset and its `AssetManager` record. An optional parent asset (from any registry) can be linked.

### HTTP Request

`POST https://api.allphins.com/api/v1/customer_asset/`

### Payload

| Parameter        | Type         | Required | Description                                                                                     |
|------------------|--------------|----------|-------------------------------------------------------------------------------------------------|
| `name`           | _string_     | Yes      | Name of the asset.                                                                              |
| `asset_category` | _string_     | No       | Asset category.                                                                                 |
| `status`         | _string_     | No       | Asset status.                                                                                   |
| `latitude`       | _float_      | No       | Latitude.                                                                                       |
| `longitude`      | _float_      | No       | Longitude.                                                                                      |
| `country`        | _string_     | No       | ISO 2-letter country code.                                                                      |
| `agg_fields`     | _list[dict]_ | No       | Additional fields as `{type, value}` pairs. Recognized types include `asset_category`, `asset_status`, `location`. |
| `display_fields` | _dict_       | No       | UI display configuration.                                                                       |
| `parent_id`     | _string_     | No       | ID of the parent asset (auto-detects `parent_source` if omitted).                               |
| `parent_source`  | _string_     | No       | Source of the parent asset: `Custom`, `Allphins`, `Clarksons`, `GEM`, `Customer`.               |

```shell
curl https://api.allphins.com/api/v1/customer_asset/ \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"name":"North Sea Rig 12","country":"NO","latitude":58.4,"longitude":1.9,"agg_fields":[{"type":"asset_category","value":"offshore"}]}'
```

<aside class="notice">
Database constraint violations return <code>400</code> with a <code>non_field_errors</code> message.
</aside>

# Asset Managers

An `AssetManager` is the shared identity behind every asset variant in the platform (Allphins, Clarkson, GEM, custom, customer). The asset managers endpoint provides a unified search + retrieve over all sources.

## Search asset managers

Returns a paginated list of asset managers matching a search term, ordered by relevance. Alternatively, pass `asset_id` to resolve an asset by any source-specific ID and return the associated asset record.

```shell
curl "https://api.allphins.com/api/v1/asset_managers/?search=sleipner&source=Allphins&page=1&page_size=30" \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

> The above command returns JSON structured like this:

```json
{
  "count": 1,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": "1234",
      "name": "Sleipner A",
      "country": "NO",
      "asset_category": "offshore",
      "status": "active",
      "parent_name": "Sleipner Group"
    }
  ]
}
```

### HTTP Request

`GET https://api.allphins.com/api/v1/asset_managers/`

### Query Parameters

| Parameter   | Type     | Required | Description                                                                 |
|-------------|----------|----------|-----------------------------------------------------------------------------|
| `search`    | _string_ | No       | Search term for name and aliases.                                           |
| `source`    | _string_ | No       | One of `Custom`, `Allphins`, `Clarksons`, `GEM`, `Customer`.                |
| `page`      | _int_    | No       | Page number (default `1`).                                                  |
| `page_size` | _int_    | No       | Page size (default `30`, max `100`).                                        |
| `asset_id`  | _string_ | No       | If set, resolves an asset by source-specific ID and returns the asset record (not a paginated search). |

## Retrieve an asset manager

Returns the associated asset record (with `parent_name` and `parent_id` populated) for a given asset manager ID.

```shell
curl https://api.allphins.com/api/v1/asset_managers/1234/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`GET https://api.allphins.com/api/v1/asset_managers/:id/`

### URL Parameters

| Parameter | Description                              |
|-----------|------------------------------------------|
| `id`      | The ID of the asset manager to retrieve. |

# Asset Matching

Matches free-form asset names to Allphins asset IDs. Typically used to enrich an external inventory with Allphins references.

## Match assets (synchronous)

Sends a batch of `{id, raw_asset}` items and receives the matched Allphins asset IDs for each. Throttled per user.

```shell
curl https://api.allphins.com/api/v1/asset_matching/match/ \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '[{"id":"row-1","raw_asset":"Sleipner A"},{"id":"row-2","raw_asset":"Johan Sverdrup"}]'
```

> The above command returns JSON structured like this:

```json
[
  {
    "id": "row-1",
    "matched_assets": [
      {
        "asset_id": "abc123",
        "asset_name": "Sleipner A",
        "asset_category": "offshore",
        "asset_type": "platform",
        "asset_subtype": "production",
        "country_code": "NO",
        "group": {"group_asset_id": "grp-1", "group_asset_name": "Sleipner Group"}
      }
    ]
  },
  {"id": "row-2", "matched_assets": []}
]
```

### HTTP Request

`POST https://api.allphins.com/api/v1/asset_matching/match/`

### Payload

JSON array. Each item:

| Field       | Type     | Required | Description                                 |
|-------------|----------|----------|---------------------------------------------|
| `id`        | _string_ | Yes      | Caller-provided ID echoed back in response. |
| `raw_asset` | _string_ | Yes      | Free-form asset name to match.              |

<aside class="warning">
Rate-limited per user (<code>MatchUserRateThrottle</code>). Send smaller batches for interactive use; use async flows for larger imports.
</aside>
