# Labels

A label is a colored tag that can be attached to a policy. Labels are scoped to the current group.

## Label Object Attributes

| Attribute          | Type     | Description                                  |
|--------------------|----------|----------------------------------------------|
| `id`               | _int_    | Unique identifier for the label.             |
| `name`             | _string_ | Name of the label.                           |
| `color_background` | _string_ | Background color (hex, e.g. `#F0F5FF`).      |
| `color_font`       | _string_ | Font color (hex, e.g. `#2F54EB`).            |

## Create a label

Creates a label. If a label with the same `name` already exists in the group, the existing label is returned with status `200` instead of `201`.

### HTTP Request

`POST https://api.allphins.com/api/v1/labels/`

### Payload

| Parameter          | Type     | Required | Description                  |
|--------------------|----------|----------|------------------------------|
| `name`             | _string_ | Yes      | Name of the label.           |
| `color_background` | _string_ | No       | Background color (hex).      |
| `color_font`       | _string_ | No       | Font color (hex).            |

```shell
curl https://api.allphins.com/api/v1/labels/ \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"name":"in_force","color_background":"#F0F5FF","color_font":"#2F54EB"}'
```

## Retrieve all labels

Returns all labels of the current group. No pagination.

```shell
curl https://api.allphins.com/api/v1/labels/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

> The above command returns JSON structured like this:

```json
[
  {
    "id": 1,
    "name": "in_force",
    "color_background": "#F0F5FF",
    "color_font": "#2F54EB"
  }
]
```

### HTTP Request

`GET https://api.allphins.com/api/v1/labels/`

## Retrieve a label

```shell
curl https://api.allphins.com/api/v1/labels/1/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`GET https://api.allphins.com/api/v1/labels/:id/`

### URL Parameters

| Parameter | Description                  |
|-----------|------------------------------|
| `id`      | The ID of the label to fetch |

## Update a label

```shell
curl https://api.allphins.com/api/v1/labels/1/ \
  -X PATCH \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"color_background":"#FFF1F0"}'
```

### HTTP Request

`PATCH https://api.allphins.com/api/v1/labels/:id/`

### URL Parameters

| Parameter | Description                   |
|-----------|-------------------------------|
| `id`      | The ID of the label to update |

### Payload

Any writable field from the Create payload. All fields optional on `PATCH`.

## Delete a label

```shell
curl https://api.allphins.com/api/v1/labels/1/ \
  -X DELETE \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`DELETE https://api.allphins.com/api/v1/labels/:id/`

### URL Parameters

| Parameter | Description                   |
|-----------|-------------------------------|
| `id`      | The ID of the label to delete |
