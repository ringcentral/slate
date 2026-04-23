# Portfolios

The portfolio object links policies to a list of risks. It belongs to a client and has a specific line of business.

## Portfolio Object Attributes

| Attribute         | Type                                                                    | Description                                                                                                                                                                                                                                                                              |
|-------------------|-------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `id`              | _UUID_                                                                  | Unique identifier for the object.                                                                                                                                                                                                                                                        |
| `name`            | _string_                                                                | Name of the portfolio.                                                                                                                                                                                                                                                                   |
| `created_at`      | _timestamp_                                                             | Creation date.                                                                                                                                                                                                                                                                           |
| `updated_at`      | _timestamp_                                                             | Last update date.                                                                                                                                                                                                                                                                        |
| `transaction`     | _string_                                                                | Type of transaction: `pre_inward`, `inward`, `selfward`, `outward`.                                                                                                                                                                                                                      |
| `renewal_date`    | _string_                                                                | Next renewal date.                                                                                                                                                                                                                                                                       |
| `cedant`          | _int_                                                                   | Id of the cedant policy.                                                                                                                                                                                                                                                                 |
| `premium`         | _int_                                                                   | Premium in USD.                                                                                                                                                                                                                                                                          |
| `max_exposure`    | _float_                                                                 | Maximum exposure on the portfolio (based on enterd policies).                                                                                                                                                                                                                            |
| `client`          | _int_                                                                   | ID of the client.                                                                                                                                                                                                                                                                        |
| `client_name`     | _string_                                                                | Name of the client                                                                                                                                                                                                                                                                       |
| `timeline`        | _string_                                                                | Status of the portofolio (expired, active, etc...)                                                                                                                                                                                                                                       |
| `renewal`         | _string_                                                                | ID of the next portfolio.                                                                                                                                                                                                                                                                |
| `portfolio_class` | _string_                                                                | Line of business of the portfolio.                                                                                                                                                                                                                                                       |
| `year_of_account` | _int_                                                                   | Year of account.                                                                                                                                                                                                                                                                         |
| `datasources`     | _list[dict]_                                                            | List of all uploaded datasources.                                                                                                                                                                                                                                                        |
|                   | _id_ <br/>_status_<br/>_original_filename_                              | UUID of the datasource<br/>Status of the datasource<br/>Original filename of the datasource                                                                                                                                                                                              |
| `policies`        | _list[dict]_                                                            | List of the policies.                                                                                                                                                                                                                                                                    |
|                   | _id_<br/>_name_<br/>_type_<br/>_start_date_<br/>_end_date_<br/>_status_ | Id of the policy.<br/>Name of the policy.<br/>Type of the policy (`quota_share`, `excess_of_loss`, `direct`)<br/>Start date of the policy<br/>End date of the policy<br/>Status of the policy (`quote`, `written`, `expired`, `declined`, `not_taken_up`, `work_in_progress`, `deleted`) |


## Create a portfolio

### HTTP Request

`POST https://api.allphins.com/api/v1/portfolios/`

### Payload

| Parameter         | Type  | Description                                 |
|-------------------|-------|---------------------------------------------|
| `name`            | _str_ | Name of the portfolio                       |
| `portfolio_class` | _str_ | Line of business of the portfolio           |
| `year_of_account` | _int_ | Year of account                             |
| `client`          | _int_ | Client ID                                   |
| `transaction`     | _str_ | Type of transaction (`inward` or `outward`) |

```shell
curl https://api.allphins.com/api/v1/portfolios/ \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"name":"Client A 2024","portfolio_class":"cyber","transaction":"inward","year_of_account":2024,"client":1234}'
  ````

## Retrieve all portfolios

This endpoint retrieves all portfolios of a given user. This will also return portfolios shared by other users with the current user.

```shell
curl https://api.allphins.com/api/v1/portfolios/?label=in_force \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

> The above command returns JSON structured like this:

```json
[
  {
    "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "name": "Cyber Client 1 2024",
    "created_at": "2024-05-20T07:52:55.491729Z",
    "updated_at": "2024-05-23T14:31:10.591036Z",
    "renewal_date": "2024-12-31T00:00:00Z",
    "premium": 9500,
    "max_exposure": 190000,
    "policies": [
      {
        "id": 1234,
        "name": "Policy 1",
        "type": "excess_of_loss",
        "start_date": "2023-01-01",
        "end_date": "2025-05-19",
        "status": "quote"
      },
      {
        "id": 1235,
        "name": "Policy 2",
        "type": "excess_of_loss",
        "start_date": "2024-01-01",
        "end_date": "2024-12-31",
        "status": "written"
      },
      {
        "id": 1236,
        "name": "Policy 3",
        "type": "",
        "start_date": null,
        "end_date": null,
        "status": "quote"
      }
    ],
    "client": 1,
    "client_name": "Cyber Client 1",
    "timeline": "Active",
    "renewal": null,
    "portfolio_class": "cyber",
    "year_of_account": 2024,
    "transaction": "inward",
    "datasources": [
      {
        "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
        "status": "Ready",
        "original_filename": "Risk_list.xlsx"
      }
    ],
    "main_datasource_status": "Ready"
  }
]
```

### HTTP Request

`GET https://api.allphins.com/api/v1/portfolios/`

### Querry Parameters

| Parameter | Description                                                                                                                      |
| --------- |----------------------------------------------------------------------------------------------------------------------------------|
| `label`   | Shortcut to retreive all actives portfolios, set label to 'in_force' (https://api.allphins.com/api/v1/portfolios?label=in_force) |

## Retrieve a portfolio

This endpoint retrieves a specific portfolio. More fields are available through this endpoint.

```shell
curl https://api.allphins.com/api/v1/portfolios/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

> The above command returns JSON structured like this:

```json
{
  "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "name": "Cyber Client 1 2024",
  "created_at": "2024-05-20T07:52:55.491729Z",
  "updated_at": "2024-05-23T14:31:10.591036Z",
  "renewal_date": "2024-12-31T00:00:00Z",
  "premium": 9500,
  "max_exposure": 190000,
  "policies": [
    {
      "id": 1234,
      "name": "Policy 1",
      "type": "excess_of_loss",
      "start_date": "2023-01-01",
      "end_date": "2025-05-19",
      "status": "quote"
    },
    {
      "id": 1235,
      "name": "Policy 2",
      "type": "excess_of_loss",
      "start_date": "2024-01-01",
      "end_date": "2024-12-31",
      "status": "written"
    },
    {
      "id": 1236,
      "name": "Policy 3",
      "type": "",
      "start_date": null,
      "end_date": null,
      "status": "quote"
    }
  ],
  "client": 1,
  "client_name": "Cyber Client 1",
  "timeline": "Active",
  "renewal": null,
  "portfolio_class": "cyber",
  "year_of_account": 2024,
  "transaction": "inward",
  "datasources": [
    {
      "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "status": "Ready",
      "original_filename": "Risk_list.xlsx"
    }
  ],
  "main_datasource_status": "Ready"
}
```

### HTTP Request

`GET https://api.allphins.com/api/v1/portfolios/:id/`

### Query Parameters

| Parameter | Description                         |
| --------- | ----------------------------------- |
| `id`      | The ID of the portfolio to retrieve |

## Get EDM analytics for a portfolio

This endpoint returns EDM analytics for a portfolio, with an optional comparison against another portfolio. Results can be returned either as a single table or as a multi-dimensional matrix, depending on the `view` parameter.

Each response contains three keys:

- `current`: analytics for the requested portfolio.
- `comparison`: analytics for the `comparison_portfolio_id` (or `null` if not provided).
- `variation`: variation between `current` and `comparison` (or `null` if no comparison).

```shell
curl https://api.allphins.com/api/v1/portfolios/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/edm_analytics/ \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"view":"table","split":"country","filters":[],"comparison_portfolio_id":null}'
```

> Table view response:

```json
{
  "current": {
    "data": [
      {"split": "US", "tiv": 1500000, "count": 120},
      {"split": "FR", "tiv": 500000, "count": 40}
    ]
  },
  "comparison": null,
  "variation": null
}
```

> Matrix view response:

```json
{
  "current": {
    "attachment_point_1": [
      {"split": "US", "tiv": 1000000, "count": 80}
    ],
    "attachment_point_2": [
      {"split": "FR", "tiv": 500000, "count": 40}
    ]
  },
  "comparison": null,
  "variation": null
}
```

### HTTP Request

`POST https://api.allphins.com/api/v1/portfolios/:id/edm_analytics/`

### URL Parameters

| Parameter | Description                      |
|-----------|----------------------------------|
| `id`      | The ID of the portfolio (UUID).  |

### Payload

| Parameter                 | Type         | Required | Description                                                                                 |
|---------------------------|--------------|----------|---------------------------------------------------------------------------------------------|
| `view`                    | _string_     | Yes      | Output format: `table` or `matrix`.                                                         |
| `split`                   | _string_     | Yes      | Dimension used to split rows. Allowed values depend on `view` (see tables below).           |
| `filters`                 | _list[dict]_ | Yes      | List of filters to apply to the analytics query. Pass `[]` for no filter.                   |
| `comparison_portfolio_id` | _UUID_       | No       | Portfolio to compare against. If set, `comparison` and `variation` are populated.           |

### Allowed `split` values for `view=table`

`attachment_point`, `country`, `state`, `county`, `city`, `occupancy`, `geo_resolution`, `distance_to_shore`, `loss_type`, `peril`, `region`, `construction_material_building`, `construction_material_others`, `year_built`, `asset_match`, `exposure_set`.

### Allowed `split` values for `view=matrix`

`attachment_point`, `geo_resolution`, `location_enrichment_details`.

<aside class="notice">
If the user's group is not enabled to read EDM analytics, the endpoint returns empty lists for <code>current</code>, <code>comparison</code> and <code>variation</code>.
</aside>

## Compute aggregation analytics

Cross-portfolio analytics aggregated from the current group's risks. Returns a cedant-level aggregation sliced by a configurable `split` dimension, scoped to the policies supplied in the body.

```shell
curl "https://api.allphins.com/api/v1/analytics/?view=table&split=country&in_force_date=2024-01-01" \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"policies":[1234,1235]}'
```

### HTTP Request

`POST https://api.allphins.com/api/v1/analytics/`

### Query Parameters

| Parameter                 | Type     | Required | Description                                                                 |
|---------------------------|----------|----------|-----------------------------------------------------------------------------|
| `view`                    | _string_ | Yes      | Output view (e.g. `table`, `matrix`).                                       |
| `split`                   | _string_ | No       | Split dimension (default `attachment_point`).                               |
| `in_force_date`           | _string_ | Yes      | In-force date (`YYYY-MM-DD`).                                               |
| `filters`                 | _list_   | No       | Filters applied via attribute filter backend.                               |
| `comparison_portfolio_id` | _UUID_   | No       | Optional portfolio to compare against.                                      |

### Payload

| Parameter  | Type         | Required | Description                                         |
|------------|--------------|----------|-----------------------------------------------------|
| `policies` | _list[int]_  | No       | Policy IDs to scope the aggregation (default `[]`). |

Response shape depends on `view`. See `POST /portfolios/:id/edm_analytics/` above for representative `table` / `matrix` examples.
