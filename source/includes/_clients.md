# Clients

A client represents a named entity (insured, cedant, or counterparty) that portfolios and policies are attributed to.

## Client Object Attributes

| Attribute | Type     | Description                        |
|-----------|----------|------------------------------------|
| `id`      | _int_    | Unique identifier for the client.  |
| `name`    | _string_ | Name of the client.                |

## Create a client

### HTTP Request

`POST https://api.allphins.com/api/v1/clients/`

### Payload

| Parameter | Type     | Description         |
|-----------|----------|---------------------|
| `name`    | _string_ | Name of the client. |

```shell
curl https://api.allphins.com/api/v1/clients/ \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"name":"Acme Corp"}'
```

## Retrieve all clients

Returns a paginated list of clients accessible to the current user's group.

```shell
curl https://api.allphins.com/api/v1/clients/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

> The above command returns JSON structured like this:

```json
{
  "count": 2,
  "next": null,
  "previous": null,
  "results": [
    {"id": 1, "name": "Acme Corp"},
    {"id": 2, "name": "Globex Ltd"}
  ]
}
```

### HTTP Request

`GET https://api.allphins.com/api/v1/clients/`

## Retrieve a client

```shell
curl https://api.allphins.com/api/v1/clients/1/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

> The above command returns JSON structured like this:

```json
{
  "id": 1,
  "name": "Acme Corp"
}
```

### HTTP Request

`GET https://api.allphins.com/api/v1/clients/:id/`

### URL Parameters

| Parameter | Description                      |
|-----------|----------------------------------|
| `id`      | The ID of the client to retrieve |

## Update a client

```shell
curl https://api.allphins.com/api/v1/clients/1/ \
  -X PATCH \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"name":"Acme Holdings"}'
```

### HTTP Request

`PATCH https://api.allphins.com/api/v1/clients/:id/`

### URL Parameters

| Parameter | Description                    |
|-----------|--------------------------------|
| `id`      | The ID of the client to update |

### Payload

| Parameter | Type     | Required | Description         |
|-----------|----------|----------|---------------------|
| `name`    | _string_ | No       | Name of the client. |

## Delete a client

```shell
curl https://api.allphins.com/api/v1/clients/1/ \
  -X DELETE \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`DELETE https://api.allphins.com/api/v1/clients/:id/`

### URL Parameters

| Parameter | Description                    |
|-----------|--------------------------------|
| `id`      | The ID of the client to delete |

<aside class="warning">
Clients are referenced by portfolios and claims. Deleting a client is restricted when dependencies exist.
</aside>
