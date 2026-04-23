# Claims

A claim records a loss reported against a portfolio. Claims can be linked to an event and carry a monetary loss, optional attributes, and metadata from the source datasource.

## Claim Object Attributes

| Attribute         | Type         | Description                                                                  |
|-------------------|--------------|------------------------------------------------------------------------------|
| `id`              | _int_        | Unique identifier for the claim.                                             |
| `description`     | _string_     | Free-text description of the claim.                                          |
| `mapped_data`     | _dict_       | Parsed data extracted from the source datasource.                            |
| `reference`       | _string_     | Reference code (read from `mapped_data.reference`).                          |
| `event_id`        | _int_        | ID of the event this claim is matched to, or `null`.                         |
| `currency`        | _string_     | ISO currency code of the loss amount (default `USD`).                        |
| `loss_date`       | _string_     | Date of loss (`YYYY-MM-DD`).                                                 |
| `loss`            | _float_      | Loss amount in the original currency.                                        |
| `loss_usd`        | _float_      | Loss amount converted to USD using the group rate at save time.              |
| `portfolio`       | _dict_       | Portfolio the claim belongs to (read-only).                                  |
|                   | _id_<br/>_name_<br/>_policies_ | UUID of the portfolio.<br/>Name of the portfolio.<br/>List of non-cedant policies of the portfolio. |
| `portfolio_id`    | _UUID_       | Portfolio ID (write-only input when creating / updating).                    |
| `portfolio_class` | _string_     | Line of business of the portfolio (read-only).                               |
| `attributes`      | _list[dict]_ | Attributes attached to the claim.                                            |
|                   | _value_<br/>_label_<br/>_type_<br/>_id_<br/>_attribute_value_<br/>_description_ | Attribute id.<br/>Attribute label.<br/>Attribute type.<br/>Attribute id.<br/>Attribute value.<br/>Attribute description. |
| `group_id`        | _int_        | ID of the group owning the claim.                                            |

## Create a claim

### HTTP Request

`POST https://api.allphins.com/api/v1/claims/`

### Payload

| Parameter      | Type     | Required | Description                                                             |
|----------------|----------|----------|-------------------------------------------------------------------------|
| `portfolio_id` | _UUID_   | Yes      | Portfolio the claim belongs to.                                         |
| `description`  | _string_ | No       | Free-text description.                                                  |
| `currency`     | _string_ | No       | ISO currency code. Defaults to `USD`.                                   |
| `loss_date`    | _string_ | No       | Date of loss (`YYYY-MM-DD`).                                            |
| `loss`         | _float_  | No       | Loss amount in the original currency.                                   |
| `mapped_data`  | _dict_   | No       | Parsed data from a datasource.                                          |
| `attributes`   | _list[int]_ | No    | List of attribute IDs to attach to the claim.                           |

```shell
curl https://api.allphins.com/api/v1/claims/ \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"portfolio_id":"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx","description":"Hull damage","currency":"USD","loss_date":"2024-03-01","loss":250000,"attributes":[12,34]}'
```

<aside class="notice">
Creating a claim triggers claim-to-event matching for the user's group.
</aside>

## Retrieve all claims

Returns a paginated list of claims for the current user's group.

```shell
curl "https://api.allphins.com/api/v1/claims/?client=1&loss_date__gte=2024-01-01" \
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
      "description": "Hull damage",
      "mapped_data": {"reference": "CL-2024-0001"},
      "reference": "CL-2024-0001",
      "event_id": 7,
      "currency": "USD",
      "loss_date": "2024-03-01",
      "loss": 250000.0,
      "loss_usd": 250000.0,
      "portfolio": {
        "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
        "name": "Marine Client 2024",
        "policies": [
          {"id": 1234, "name": "Policy 1", "type": "excess_of_loss"}
        ]
      },
      "attributes": [],
      "portfolio_class": "marine",
      "group_id": 10
    }
  ]
}
```

### HTTP Request

`GET https://api.allphins.com/api/v1/claims/`

### Query Parameters

| Parameter          | Description                                              |
|--------------------|----------------------------------------------------------|
| `client`           | Filter by client ID.                                     |
| `loss_date`        | Exact loss date (`YYYY-MM-DD`).                          |
| `loss_date__gte`   | Loss date greater than or equal to.                      |
| `loss_date__lte`   | Loss date less than or equal to.                         |
| `ordering`         | Order by `loss_date` or `client` (prefix `-` to reverse).|

## Retrieve a claim

```shell
curl https://api.allphins.com/api/v1/claims/42/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`GET https://api.allphins.com/api/v1/claims/:id/`

### URL Parameters

| Parameter | Description                   |
|-----------|-------------------------------|
| `id`      | The ID of the claim to fetch  |

## Update a claim

```shell
curl https://api.allphins.com/api/v1/claims/42/ \
  -X PATCH \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"loss":275000,"attributes":[12,34,56]}'
```

### HTTP Request

`PATCH https://api.allphins.com/api/v1/claims/:id/`

### URL Parameters

| Parameter | Description                   |
|-----------|-------------------------------|
| `id`      | The ID of the claim to update |

### Payload

Any writable field from the Create payload. All fields optional on `PATCH`.

## Delete a claim

Deletes the claim. If no other claim references the same event, the event is deleted as well.

```shell
curl https://api.allphins.com/api/v1/claims/42/ \
  -X DELETE \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`DELETE https://api.allphins.com/api/v1/claims/:id/`

### URL Parameters

| Parameter | Description                   |
|-----------|-------------------------------|
| `id`      | The ID of the claim to delete |

## List claims with filters (POST)

Returns a paginated list of claims filtered by a JSON body. Use this endpoint when the filter set is too large to fit in a query string.

```shell
curl https://api.allphins.com/api/v1/claims/list_details/ \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"events":[7,8],"portfolios":["xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"],"loss_date":"2024-03-01","search_query":"hull"}'
```

### HTTP Request

`POST https://api.allphins.com/api/v1/claims/list_details/`

### Payload

| Parameter      | Type           | Required | Description                                    |
|----------------|----------------|----------|------------------------------------------------|
| `events`       | _list[int]_    | No       | Filter by matched event IDs.                   |
| `portfolios`   | _list[UUID]_   | No       | Filter by portfolio IDs.                       |
| `loss_date`    | _string_       | No       | Exact loss date (`YYYY-MM-DD`).                |
| `search_query` | _string_       | No       | Free-text search across claim fields.          |
| `filters`      | _list[dict]_   | No       | Attribute filters (same format as risks).      |
