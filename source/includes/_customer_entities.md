# Customer Entities

A customer entity is a user-created legal entity (insured, obligor, counterparty) owned by the current group. Customer entities are stored behind an `EntityManager` record shared with the GLEIF, D&B, and Allphins entity registries.

## Customer Entity Object Attributes

| Attribute        | Type         | Description                                                       |
|------------------|--------------|-------------------------------------------------------------------|
| `id`             | _int_        | Unique identifier for the customer entity.                        |
| `name`           | _string_     | Name of the entity.                                               |
| `country`        | _string_     | ISO 2-letter country code.                                        |
| `group`          | _int_        | Owning group ID.                                                  |
| `manager`        | _int_        | ID of the `EntityManager` representing this entity.               |
| `agg_fields`     | _list[dict]_ | Additional attribute fields (`{type, value}` pairs).              |
| `display_fields` | _dict_       | Fields to display in the UI.                                      |

## Create a customer entity

Creates a customer entity and its `EntityManager` record. An optional parent entity can be linked.

### HTTP Request

`POST https://api.allphins.com/api/v1/customer_entity/`

### Payload

| Parameter        | Type         | Required | Description                                                        |
|------------------|--------------|----------|--------------------------------------------------------------------|
| `name`           | _string_     | Yes      | Name of the entity.                                                |
| `country`        | _string_     | No       | ISO 2-letter country code.                                         |
| `agg_fields`     | _list[dict]_ | No       | Additional fields as `{type, value}` pairs.                        |
| `display_fields` | _dict_       | No       | UI display configuration.                                          |
| `parent_id`      | _string_     | No       | ID of the parent `EntityManager`.                                  |

```shell
curl https://api.allphins.com/api/v1/customer_entity/ \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"name":"Acme Holdings Ltd","country":"GB","agg_fields":[{"type":"industry","value":"energy"}]}'
```

<aside class="notice">
Database constraint violations return <code>400</code> with a <code>non_field_errors</code> message.
</aside>

# Entity Managers

An `EntityManager` is the shared identity behind every entity variant in the platform (GLEIF, D&B, Allphins, custom, customer). The entity managers endpoint provides a unified search + retrieve over all sources.

## Search entity managers

Returns a paginated list of entity managers matching a search term.

```shell
curl "https://api.allphins.com/api/v1/entity_managers/?search=acme&source=gleif&page=1&page_size=30" \
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
      "id": 42,
      "name": "Acme Holdings Ltd",
      "country": "GB",
      "parent_name": null
    }
  ]
}
```

### HTTP Request

`GET https://api.allphins.com/api/v1/entity_managers/`

### Query Parameters

| Parameter   | Type     | Required | Description                                                         |
|-------------|----------|----------|---------------------------------------------------------------------|
| `search`    | _string_ | No       | Search term for name and aliases.                                   |
| `source`    | _string_ | No       | One of `custom`, `gleif`, `d_and_b`, `allphins`, `customer`.        |
| `page`      | _int_    | No       | Page number (default `1`).                                          |
| `page_size` | _int_    | No       | Page size (default `30`, max `100`).                                |

## Retrieve an entity manager

Returns the associated entity record with `parent_name` populated.

```shell
curl https://api.allphins.com/api/v1/entity_managers/42/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`GET https://api.allphins.com/api/v1/entity_managers/:id/`

### URL Parameters

| Parameter | Description                               |
|-----------|-------------------------------------------|
| `id`      | The ID of the entity manager to retrieve. |
