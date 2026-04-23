# Events

An event groups together claims that refer to the same underlying incident (e.g. a named storm). Events are created automatically from the claim matching pipeline or manually when claims are confirmed by the user.

## Event Object Attributes

| Attribute               | Type          | Description                                                                    |
|-------------------------|---------------|--------------------------------------------------------------------------------|
| `id`                    | _int_         | Unique identifier for the event.                                               |
| `name`                  | _string_      | Name of the event.                                                             |
| `start_date`            | _string_      | Start date (`YYYY-MM-DD`).                                                     |
| `end_date`              | _string_      | End date (`YYYY-MM-DD`).                                                       |
| `claims_count`          | _int_         | Number of claims linked to the event.                                          |
| `loss_usd`              | _float_       | Sum of `loss_usd` across linked claims.                                        |
| `automatic_name`        | _string_      | Name suggested by the matching pipeline.                                       |
| `automatic_description` | _string_      | Description suggested by the matching pipeline.                                |
| `portfolio_names`       | _list[string]_| Unique names of portfolios referenced by the linked claims.                    |
| `tags`                  | _list[string]_| Free-form tags attached to the event.                                          |
| `event_type`            | _string_      | Event type (free-form string).                                                 |

## Retrieve all events

Returns events that have at least one claim in the current user's group. Ordered by `claims_count` desc, then `loss_usd` desc.

```shell
curl https://api.allphins.com/api/v1/events/ \
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
      "id": 7,
      "name": "Hurricane Milton",
      "start_date": "2024-10-05",
      "end_date": "2024-10-10",
      "claims_count": 12,
      "loss_usd": 4250000.0,
      "automatic_name": "Milton 2024",
      "automatic_description": "Atlantic hurricane, landfall on Florida",
      "portfolio_names": ["Marine Client 1 2024", "Property Client 2 2024"],
      "tags": ["windstorm", "NA"],
      "event_type": "hurricane"
    }
  ]
}
```

### HTTP Request

`GET https://api.allphins.com/api/v1/events/`

## Retrieve an event

```shell
curl https://api.allphins.com/api/v1/events/7/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`GET https://api.allphins.com/api/v1/events/:id/`

### URL Parameters

| Parameter | Description                  |
|-----------|------------------------------|
| `id`      | The ID of the event to fetch |

<aside class="notice">
Events are read-only through this API. They are created and maintained automatically from claims via the matching pipeline.
</aside>
