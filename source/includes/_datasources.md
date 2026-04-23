# Datasources

A datasource represents a file (Excel, CSV, SQL backup, EDM/RDM, PDF, …) uploaded to the platform and used as the origin of risks, claims, aggregations, policy documents, or structure imports. Datasource lifecycle: **create** → upload to returned signed URL → **start_analyze** → map & configure → **import_datasource**.

## DataSource Object Attributes

| Attribute           | Type        | Description                                                                                            |
|---------------------|-------------|--------------------------------------------------------------------------------------------------------|
| `id`                | _UUID_      | Unique identifier for the datasource.                                                                  |
| `original_filename` | _string_    | Original filename as uploaded.                                                                         |
| `file`              | _string_    | Internal storage path of the file.                                                                     |
| `filename`          | _string_    | Normalized filename used internally.                                                                   |
| `config`            | _dict_      | Import configuration (mapping, filters, …). `null` until the datasource is imported.                   |
| `status`            | _string_    | Human-readable status (e.g. `Uploaded`, `Ready`, `Mapped`, `Importing`, `Imported`, `Failed`).         |
| `actions`           | _dict_      | Actions currently available on the datasource (driven by nature/status/assignment).                    |
| `nature`            | _string_    | Nature of the content: `risks`, `claims`, `aggregation`, `documentation`, `policy`, `structure`, `loss_ladder`, `other`. |
| `extension`         | _string_    | File extension: `sql`, `excel`, `pdf`, `ppt`, `word`, `csv`, `unknown`.                                |
| `provider`          | _string_    | Data provider: `air`, `edm`, `rdm`, `allphins`, `customer`, `custom_risks`, `unknown`.                 |
| `created_at`        | _timestamp_ | Creation date.                                                                                         |
| `updated_at`        | _timestamp_ | Last update date.                                                                                      |
| `update_time`       | _timestamp_ | Date of the underlying data (as supplied at import).                                                   |
| `metadata`          | _dict_      | Arbitrary metadata passed at creation.                                                                 |
| `download_url`      | _string_    | Signed URL to download the original file.                                                              |
| `line_of_business`  | _string_    | Line of business (copied from the linked portfolio).                                                   |
| `user`              | _string_    | Full name of the user who uploaded the datasource.                                                     |
| `portfolio_id`      | _UUID_      | Portfolio the datasource is linked to, or `null`.                                                      |
| `note`              | _string_    | Free-text note.                                                                                        |
| `file_size`         | _int_       | File size in bytes.                                                                                    |
| `parent_id`         | _UUID_      | Parent datasource ID (for versioning), or `null`.                                                      |

## Create a datasource

Reserves a datasource record and returns a signed URL and a resumable upload session. The client must then upload the file to GCS before calling `start_analyze`.

### HTTP Request

`POST https://api.allphins.com/api/v1/datasources/`

### Payload

| Parameter   | Type     | Required | Description                                                             |
|-------------|----------|----------|-------------------------------------------------------------------------|
| `filename`  | _string_ | Yes      | Original filename (including extension).                                |
| `nature`    | _string_ | Yes      | One of the nature values listed above.                                  |
| `portfolio` | _UUID_   | No       | Portfolio to link the datasource to.                                    |
| `note`      | _string_ | No       | Free-text note.                                                         |
| `metadata`  | _dict_   | No       | Arbitrary metadata.                                                     |

```shell
curl https://api.allphins.com/api/v1/datasources/ \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"filename":"risks.xlsx","nature":"risks","portfolio":"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"}'
```

> The above command returns JSON structured like this:

```json
{
  "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "signed_url": "https://storage.googleapis.com/...",
  "resumable_upload_session": "https://storage.googleapis.com/upload/storage/v1/b/...",
  "key": "group_10/datasources/.../risks.xlsx"
}
```

Upload the file using either the `signed_url` (single `PUT`) or the `resumable_upload_session` (chunked uploads) before calling `start_analyze`.

## Retrieve all datasources

Returns a paginated list of datasources of the current group.

```shell
curl "https://api.allphins.com/api/v1/datasources/?portfolio_id=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx&nature=risks&ordering=-created_at" \
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
      "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "user": "Jane Doe",
      "original_filename": "risks.xlsx",
      "portfolio_id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
      "portfolio_name": "Client A 2024",
      "portfolio_labels": [],
      "nature": "Risks",
      "extension": "Excel",
      "provider": "Customer",
      "mapped_perils": [],
      "actions": {"default": "delete", "list": []},
      "created_at": "2024-05-20T07:52:55.491729Z",
      "updated_at": "2024-05-20T07:52:55.491729Z",
      "update_time": null,
      "mapped_by_full_name": null,
      "mapped_by": null,
      "mapped_date": null,
      "metadata": {},
      "status": "Uploaded",
      "download_url": "https://storage.googleapis.com/...",
      "note": "",
      "file_size": 12345
    }
  ]
}
```

### HTTP Request

`GET https://api.allphins.com/api/v1/datasources/`

### Query Parameters

| Parameter           | Description                                                                         |
|---------------------|-------------------------------------------------------------------------------------|
| `portfolio_id`      | Filter by linked portfolio.                                                         |
| `nature`            | Filter by nature (see values above).                                                |
| `format`            | Filter by file format.                                                              |
| `mapped_peril`      | Filter by mapped peril.                                                             |
| `upload_date`       | Range filter `YYYY-MM-DD,YYYY-MM-DD` on upload date.                                |
| `mapped_date`       | Range filter `YYYY-MM-DD,YYYY-MM-DD` on mapping date.                               |
| `mapped_by`         | Filter by user ID who mapped the datasource.                                        |
| `uploaded_by`       | Filter by user ID who uploaded the datasource.                                      |
| `original_filename` | Filter by original filename.                                                        |
| `ordering`          | Sort by `file_size`, `created_at`, or `original_filename` (prefix `-` to reverse).  |

## Retrieve a datasource

```shell
curl https://api.allphins.com/api/v1/datasources/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`GET https://api.allphins.com/api/v1/datasources/:id/`

### URL Parameters

| Parameter | Description                       |
|-----------|-----------------------------------|
| `id`      | UUID of the datasource to fetch.  |

## Update a datasource

Used to assign, reassign, or unassign the linked portfolio and to update `note`.

```shell
curl https://api.allphins.com/api/v1/datasources/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/ \
  -X PATCH \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"portfolio_id":"yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy","note":"Revised mapping"}'
```

### HTTP Request

`PATCH https://api.allphins.com/api/v1/datasources/:id/`

### Payload

| Parameter      | Type     | Required | Description                                                                               |
|----------------|----------|----------|-------------------------------------------------------------------------------------------|
| `portfolio_id` | _UUID_   | No       | New portfolio. Set to `null` to unassign. Cannot change once the datasource is imported.  |
| `note`         | _string_ | No       | Free-text note.                                                                           |

<aside class="warning">
Changing <code>portfolio_id</code> on an already-imported datasource (<code>config</code> not <code>null</code>) returns <code>400</code>.
</aside>

## Delete a datasource

Deletes the datasource, its pending notification, and any linked raw data.

```shell
curl https://api.allphins.com/api/v1/datasources/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/ \
  -X DELETE \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`DELETE https://api.allphins.com/api/v1/datasources/:id/`

### URL Parameters

| Parameter | Description                     |
|-----------|---------------------------------|
| `id`      | UUID of the datasource to delete|

## Start analysis

Triggers schema detection on the uploaded file. Call this after the file has been uploaded to the returned signed URL.

```shell
curl https://api.allphins.com/api/v1/datasources/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/start_analyze/ \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"md5_hash":"d41d8cd98f00b204e9800998ecf8427e"}'
```

### HTTP Request

`POST https://api.allphins.com/api/v1/datasources/:id/start_analyze/`

### Payload

| Parameter     | Type     | Required | Description                                                |
|---------------|----------|----------|------------------------------------------------------------|
| `md5_hash`    | _string_ | No       | MD5 of the uploaded file (one of `md5_hash` or `crc32c_hash` required). |
| `crc32c_hash` | _string_ | No       | CRC32C of the uploaded file.                               |

## Import a datasource

Imports the analyzed datasource using a mapping configuration. Payload shape depends on `extension` + `nature` + `provider`.

### HTTP Request

`POST https://api.allphins.com/api/v1/datasources/:id/import_datasource/`

Returns `204 No Content` on success.

### Excel / CSV risks payload

| Parameter             | Type          | Required | Description                                                                 |
|-----------------------|---------------|----------|-----------------------------------------------------------------------------|
| `portfolioId`         | _UUID_        | Yes      | Portfolio the data will be imported into.                                   |
| `update_time`         | _timestamp_   | Yes      | Effective date of the data.                                                 |
| `mapping`             | _list[dict]_  | Yes      | Per-column mapping (see below).                                             |
| `import_actions`      | _list[string]_| No       | Import-time actions (see `DataSourceImportActions`).                        |
| `simulation_end_date` | _string_      | No       | Required if `date_simulation` is in `import_actions`.                       |

Each `mapping` entry:

| Field            | Type           | Description                                                       |
|------------------|----------------|-------------------------------------------------------------------|
| `column_file`    | _string_       | Source column in the uploaded file.                               |
| `first_values`   | _string_       | Sample values from the column (optional).                         |
| `column_mapped`  | _string_       | Target field to map to (single).                                  |
| `columns_mapped` | _list[string]_ | Target fields to map to (multi — used for head-of-cover, etc.).   |
| `assigned_value` | _string_       | Fixed value to assign when column is not present.                 |
| `note`           | _string_       | Optional note.                                                    |

### EDM / AIR (SQL) payload

| Parameter     | Type          | Required | Description                          |
|---------------|---------------|----------|--------------------------------------|
| `portfolioId` | _UUID_        | Yes      | Portfolio.                           |
| `update_time` | _timestamp_   | Yes      | Effective date.                      |
| `mapping`     | _dict_        | Yes      | EDM mapping (see fields below).      |

EDM `mapping`:

| Field                   | Type         | Description                                                            |
|-------------------------|--------------|------------------------------------------------------------------------|
| `filter_risks`          | _dict_       | `{field, operator, value[]}` used to filter source rows.               |
| `risk_code_mapping`     | _dict_       | Mapping of risk codes to target values.                                |
| `perils_mapping`        | _dict_       | Mapping of source perils to target perils.                             |
| `financial_perspective` | _string_     | One of `gross_loss`, `ground_up_loss`, `reinsurance_gross_loss`, `net_of_fac_gross_loss`, `net_of_reinsurance_gross_loss`. |
| `selected_treaties`     | _list[string]_ | Treaty IDs to apply.                                                 |
| `note`                  | _string_     | Optional note.                                                         |

### Cedant aggregation (Excel) payload

Same shape as Excel risks plus an `id` (UUID) field identifying the aggregation record.

### Structure (Excel/CSV) payload

No payload fields required. Send `{}`.

<aside class="notice">
Importing a datasource whose nature is not <code>structure</code> requires a linked portfolio.
</aside>
