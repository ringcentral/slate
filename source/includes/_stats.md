# Stats

Summary stats for the current user's active group: number of active clients, number of written inward policies, and total USD premium.

## Retrieve stats

```shell
curl https://api.allphins.com/api/v1/stats/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

> The above command returns JSON structured like this:

```json
{
  "client_number": 12,
  "policy_number": 48,
  "total_premium": 18450000.0
}
```

### HTTP Request

`GET https://api.allphins.com/api/v1/stats/`

### Response Fields

| Field           | Type    | Description                                                                                 |
|-----------------|---------|---------------------------------------------------------------------------------------------|
| `client_number` | _int_   | Distinct clients with at least one active written inward policy.                            |
| `policy_number` | _int_   | Total active written inward policies (line-of-day + risk-attached combined).                |
| `total_premium` | _float_ | Sum of `usd_premium_100 * share` over the same policy set.                                  |
