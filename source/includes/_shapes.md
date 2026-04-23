# Shapes

A shape represents a named geographic polygon (or multi-polygon) used to filter exposure by location. Shapes belong to a group; Allphins also ships shared shapes with no owning group that are visible to every user.

## Shape Object Attributes

| Attribute           | Type        | Description                                                                  |
|---------------------|-------------|------------------------------------------------------------------------------|
| `id`                | _int_       | Unique identifier for the shape.                                             |
| `name`              | _string_    | Name of the shape.                                                           |
| `original_filename` | _string_    | Original filename if uploaded from a file, otherwise `null`.                 |
| `shape_type`        | _string_    | Type of shape: `hurricane`, `typhoon`, or `custom`.                          |
| `polygon`           | _string_    | WKT representation of the stored `MultiPolygon`.                             |
| `shape`             | _list_      | GeoJSON-style `coordinates` array of the `MultiPolygon`.                     |
| `user`              | _int_       | ID of the user who created the shape, or `null` for Allphins-provided shapes.|
| `created_at`        | _timestamp_ | Creation date.                                                               |

## Create a shape

Creates a shape from a GeoJSON `Polygon`, `MultiPolygon`, or `FeatureCollection`.

### HTTP Request

`POST https://api.allphins.com/api/v1/shapes/`

### Payload

| Parameter           | Type     | Required | Description                                                     |
|---------------------|----------|----------|-----------------------------------------------------------------|
| `name`              | _string_ | Yes      | Name of the shape.                                              |
| `polygon`           | _dict_   | Yes      | GeoJSON geometry (`Polygon`, `MultiPolygon`, or `FeatureCollection`). |
| `shape_type`        | _string_ | No       | One of `hurricane`, `typhoon`, `custom`.                        |
| `original_filename` | _string_ | No       | Original filename (for reference).                              |

```shell
curl https://api.allphins.com/api/v1/shapes/ \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"name":"Gulf of Mexico","shape_type":"custom","polygon":{"type":"Polygon","coordinates":[[[-97.5,25.8],[-81.5,25.8],[-81.5,30.5],[-97.5,30.5],[-97.5,25.8]]]}}'
```

<aside class="notice">
Invalid GeoJSON returns <code>400</code> with a <code>PolygonInvalid</code> error code.
</aside>

## Retrieve all shapes

Returns a paginated list of the current group's shapes plus any Allphins-shared shapes.

```shell
curl "https://api.allphins.com/api/v1/shapes/?search=gulf" \
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
      "id": 12,
      "name": "Gulf of Mexico",
      "original_filename": null,
      "shape_type": "custom",
      "polygon": "MULTIPOLYGON (((-97.5 25.8, -81.5 25.8, -81.5 30.5, -97.5 30.5, -97.5 25.8)))",
      "shape": [[[[-97.5, 25.8], [-81.5, 25.8], [-81.5, 30.5], [-97.5, 30.5], [-97.5, 25.8]]]],
      "user": 42,
      "created_at": "2024-05-20T07:52:55.491729Z"
    }
  ]
}
```

### HTTP Request

`GET https://api.allphins.com/api/v1/shapes/`

### Query Parameters

| Parameter  | Description                                     |
|------------|-------------------------------------------------|
| `id`       | Filter by shape ID.                             |
| `id__in`   | Filter by a list of shape IDs.                  |
| `search`   | Search by shape name.                           |
| `ordering` | Order by any field (prefix `-` to reverse).     |

## Retrieve a shape

```shell
curl https://api.allphins.com/api/v1/shapes/12/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`GET https://api.allphins.com/api/v1/shapes/:id/`

### URL Parameters

| Parameter | Description                   |
|-----------|-------------------------------|
| `id`      | The ID of the shape to fetch  |

## Update a shape

```shell
curl https://api.allphins.com/api/v1/shapes/12/ \
  -X PATCH \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"name":"Gulf of Mexico (extended)"}'
```

### HTTP Request

`PATCH https://api.allphins.com/api/v1/shapes/:id/`

### URL Parameters

| Parameter | Description                   |
|-----------|-------------------------------|
| `id`      | The ID of the shape to update |

### Payload

Any writable field from the Create payload. All fields optional on `PATCH`.

## Delete a shape

```shell
curl https://api.allphins.com/api/v1/shapes/12/ \
  -X DELETE \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`DELETE https://api.allphins.com/api/v1/shapes/:id/`

### URL Parameters

| Parameter | Description                   |
|-----------|-------------------------------|
| `id`      | The ID of the shape to delete |

## List all shapes (id + name only)

Returns every shape visible to the user as a lightweight `{id, name}` list. Useful for populating selects.

```shell
curl https://api.allphins.com/api/v1/shapes/all/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

> The above command returns JSON structured like this:

```json
[
  {"id": 12, "name": "Gulf of Mexico"},
  {"id": 13, "name": "North Sea"}
]
```

### HTTP Request

`GET https://api.allphins.com/api/v1/shapes/all/`

## Parse a shape file

Parses a `.geojson` or `.shp` file and returns the `MultiPolygon` coordinates without creating a `Shape`. Use this to preview a file before creating a shape from it. Uploaded files are archived to cloud storage for traceability.

```shell
curl https://api.allphins.com/api/v1/shapes/parse_file/ \
  -X POST \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -F 'file=@/path/to/area.geojson'
```

> The above command returns JSON structured like this:

```json
[[[[-97.5, 25.8], [-81.5, 25.8], [-81.5, 30.5], [-97.5, 30.5], [-97.5, 25.8]]]]
```

### HTTP Request

`POST https://api.allphins.com/api/v1/shapes/parse_file/`

### Payload

Multipart form data.

| Parameter | Type   | Required | Description                            |
|-----------|--------|----------|----------------------------------------|
| `file`    | _file_ | Yes      | `.geojson` or `.shp` file to parse.    |

<aside class="warning">
Only <code>.geojson</code> and <code>.shp</code> extensions are accepted. Other files return <code>400</code>.
</aside>
