# Reports

A report is an asynchronously generated export (Excel, CSV, JSON, …). Creating a report triggers generation in the background; poll the retrieve endpoint until `status` is `ready`, then download via `file`.

## Report Object Attributes

| Attribute            | Type        | Description                                                                 |
|----------------------|-------------|-----------------------------------------------------------------------------|
| `id`                 | _int_       | Unique identifier for the report.                                           |
| `name`               | _string_    | Name of the report.                                                         |
| `description`        | _string_    | Free-text description.                                                      |
| `config`             | _dict_      | Type-specific generation config (see below).                                |
| `type`               | _string_    | Report type (see values below).                                             |
| `status`             | _string_    | `created`, `computing`, `ready`, `error`, or `deleted` (read-only).         |

Additional fields returned by the list endpoint:

| Attribute            | Type        | Description                                                              |
|----------------------|-------------|--------------------------------------------------------------------------|
| `user`               | _string_    | Full name of the user who created the report.                            |
| `created_at`         | _timestamp_ | Creation date.                                                           |
| `updated_at`         | _timestamp_ | Last update date.                                                        |
| `ready`              | _bool_      | Whether the report is ready for download.                                |
| `file`               | _string_    | URL of the generated file.                                               |
| `file_name`          | _string_    | Filename derived from `file`.                                            |
| `file_size`          | _int_       | File size in bytes.                                                      |
| `is_new`             | _bool_      | `true` if the report was created within the last 3 days.                 |
| `exposure_map`       | _UUID_      | Linked exposure map, if any.                                             |
| `scenario_id`        | _UUID_      | Scenario ID (for `scenario_computation` reports).                        |
| `scenario_name`      | _string_    | Scenario name (for `scenario_computation` reports).                      |
| `scenario_list_id`   | _UUID_      | Scenario list ID (for `scenario_computation` reports).                   |
| `scenario_list_name` | _string_    | Scenario list name (for `scenario_computation` reports).                 |

### Report types

`top_zone`, `scenario_list`, `cedant_agg`, `portfolio_list`, `claim_list`, `risk_list`, `policy_list`, `scenario_risks`, `scenario_computation`, `analytics`, `loss_ladder`, `fixed_grid`, `air_input`.

## Create a report

Triggers asynchronous generation. Response returns the report in `created` / `computing` status.

### HTTP Request

`POST https://api.allphins.com/api/v1/reports/`

### Payload

| Parameter     | Type     | Required | Description                                                                 |
|---------------|----------|----------|-----------------------------------------------------------------------------|
| `name`        | _string_ | No       | Name of the report.                                                         |
| `description` | _string_ | No       | Free-text description.                                                      |
| `type`        | _string_ | Yes      | One of the report types listed above.                                       |
| `config`      | _dict_   | No       | Type-specific configuration (e.g. `scenario_list_id`, `scenario_id`, …).    |

```shell
curl https://api.allphins.com/api/v1/reports/ \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"name":"Q1 Loss Ladder","type":"loss_ladder","config":{"scenario_list_id":"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"}}'
```

> The above command returns JSON structured like this:

```json
{
  "id": 501,
  "name": "Q1 Loss Ladder",
  "description": null,
  "config": {"scenario_list_id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"},
  "type": "loss_ladder",
  "status": "computing"
}
```

<aside class="notice">
If <code>config</code> includes a <code>date</code> field, it is silently ignored.
</aside>

## Retrieve all reports

Returns a paginated list of the current group's reports, ordered by `created_at` desc. Reports whose file is missing from cloud storage are filtered out.

```shell
curl "https://api.allphins.com/api/v1/reports/?type=loss_ladder&created_at__gte=2024-01-01" \
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
      "id": 501,
      "user": "Jane Doe",
      "created_at": "2024-05-20T07:52:55.491729Z",
      "updated_at": "2024-05-20T08:02:41.000000Z",
      "ready": true,
      "name": "Q1 Loss Ladder",
      "description": null,
      "type": "loss_ladder",
      "file": "https://storage.googleapis.com/.../q1_loss_ladder.xlsx",
      "file_name": "q1_loss_ladder.xlsx",
      "file_size": 48291,
      "is_new": true,
      "exposure_map": null,
      "status": "ready",
      "scenario_id": null,
      "scenario_name": null,
      "scenario_list_id": null,
      "scenario_list_name": null
    }
  ]
}
```

### HTTP Request

`GET https://api.allphins.com/api/v1/reports/`

### Query Parameters

| Parameter              | Description                                                         |
|------------------------|---------------------------------------------------------------------|
| `id`                   | Filter by report ID (supports `__in`).                              |
| `type`                 | Filter by report type (supports `__in`).                            |
| `created_at`           | Exact creation date.                                                |
| `created_at__gte`      | Created on or after (`YYYY-MM-DD`).                                 |
| `created_at__lte`      | Created on or before.                                               |
| `created_at__gt`       | Created strictly after.                                             |
| `created_at__lt`       | Created strictly before.                                            |
| `created_at__range`    | Range filter `YYYY-MM-DD,YYYY-MM-DD`.                               |

## Retrieve a report

```shell
curl https://api.allphins.com/api/v1/reports/501/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`GET https://api.allphins.com/api/v1/reports/:id/`

### URL Parameters

| Parameter | Description                    |
|-----------|--------------------------------|
| `id`      | The ID of the report to fetch. |

## Update a report

```shell
curl https://api.allphins.com/api/v1/reports/501/ \
  -X PATCH \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"name":"Q1 Loss Ladder (final)"}'
```

### HTTP Request

`PATCH https://api.allphins.com/api/v1/reports/:id/`

### Payload

Any writable field from Create. All optional on `PATCH`.

## Delete a report

```shell
curl https://api.allphins.com/api/v1/reports/501/ \
  -X DELETE \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`DELETE https://api.allphins.com/api/v1/reports/:id/`

<aside class="warning">
Read-only users cannot delete reports. <code>DELETE</code> requires write permission.
</aside>
