# Scenario List Sections

A scenario list section groups scenario lists into a named category. Sections are scoped to the current group.

## Scenario List Section Object Attributes

| Attribute | Type     | Description                                  |
|-----------|----------|----------------------------------------------|
| `id`      | _int_    | Unique identifier for the section.           |
| `name`    | _string_ | Name of the section.                         |

## Create a scenario list section

### HTTP Request

`POST https://api.allphins.com/api/v1/scenario_list_sections/`

### Payload

| Parameter | Type     | Required | Description             |
|-----------|----------|----------|-------------------------|
| `name`    | _string_ | Yes      | Name of the section.    |

```shell
curl https://api.allphins.com/api/v1/scenario_list_sections/ \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"name":"Named storms"}'
```

## Retrieve all scenario list sections

Returns all sections of the current group. No pagination.

```shell
curl https://api.allphins.com/api/v1/scenario_list_sections/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

> The above command returns JSON structured like this:

```json
[
  {"id": 1, "name": "Named storms"},
  {"id": 2, "name": "Earthquakes"}
]
```

### HTTP Request

`GET https://api.allphins.com/api/v1/scenario_list_sections/`

## Delete a scenario list section

```shell
curl https://api.allphins.com/api/v1/scenario_list_sections/1/ \
  -X DELETE \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`DELETE https://api.allphins.com/api/v1/scenario_list_sections/:id/`

### URL Parameters

| Parameter | Description                    |
|-----------|--------------------------------|
| `id`      | The ID of the section to delete|

## Assign a section to scenario lists

Attaches the section to every scenario list whose ID is in `scenario_list_ids`. Replaces any existing section on those lists.

```shell
curl https://api.allphins.com/api/v1/scenario_list_sections/1/assign/ \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"scenario_list_ids":[10,11,12]}'
```

Returns `204 No Content`.

### HTTP Request

`POST https://api.allphins.com/api/v1/scenario_list_sections/:id/assign/`

### URL Parameters

| Parameter | Description              |
|-----------|--------------------------|
| `id`      | The ID of the section.   |

### Payload

| Parameter           | Type        | Required | Description                                                 |
|---------------------|-------------|----------|-------------------------------------------------------------|
| `scenario_list_ids` | _list[int]_ | Yes      | Scenario list IDs to assign to this section.                |
