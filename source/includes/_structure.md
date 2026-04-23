# Structure

The structure endpoints export the current group's portfolio / policy / risk tree as an Excel workbook. The companion template endpoint returns a blank workbook that can be filled in and re-imported via the datasources API (`nature=structure`).

## Export the current structure

Returns an Excel file (`.xlsx`) containing the current group's structure.

```shell
curl https://api.allphins.com/api/v1/structure/export/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  --output structure_export.xlsx
```

### HTTP Request

`GET https://api.allphins.com/api/v1/structure/export/`

Response:

- `Content-Type`: `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`
- `Content-Disposition`: `attachment; filename="structure_export_<YYYY-MM-DD>.xlsx"`

## Download the structure template

Returns an empty structure template (`.xlsx`) ready to be filled in and re-imported.

```shell
curl https://api.allphins.com/api/v1/structure/export/template/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  --output structure_template.xlsx
```

### HTTP Request

`GET https://api.allphins.com/api/v1/structure/export/template/`

Response:

- `Content-Type`: `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`
- `Content-Disposition`: `attachment; filename="structure_export_template.xlsx"`

<aside class="notice">
To re-import a filled structure, upload it via <code>POST /datasources/</code> with <code>nature=structure</code> and then call <code>/datasources/:id/start_analyze/</code> + <code>/datasources/:id/import_datasource/</code>.
</aside>
