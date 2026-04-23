# Currency

The currency endpoint lists supported currencies and their latest conversion rate to USD. The most recent rate for the user's group is used if set; otherwise the Allphins default rate is returned.

## Currency Object Attributes

| Attribute         | Type     | Description                                                                 |
|-------------------|----------|-----------------------------------------------------------------------------|
| `currency_code`   | _string_ | ISO 4217 currency code (primary key).                                       |
| `currency_symbol` | _string_ | Currency symbol (e.g. `$`, `€`).                                            |
| `currency_name`   | _string_ | Human-readable name.                                                        |
| `country_name`    | _string_ | Country the currency is primarily associated with.                          |
| `separator`       | _bool_   | Whether the symbol is separated from the amount with a space.               |
| `is_prefix`       | _bool_   | Whether the symbol is displayed before the amount.                          |
| `last_rate`       | _float_  | Most recent rate from `currency_code` to USD. `null` if no rate exists.     |
| `date`            | _string_ | Effective date of `last_rate`.                                              |
| `is_group_rate`   | _bool_   | `true` if `last_rate` comes from a group-specific rate, `false` if default. |

## Retrieve all currencies

```shell
curl https://api.allphins.com/api/v1/currency/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

> The above command returns JSON structured like this:

```json
{
  "count": 2,
  "next": null,
  "previous": null,
  "results": [
    {
      "currency_code": "EUR",
      "currency_symbol": "€",
      "currency_name": "Euro",
      "country_name": "Eurozone",
      "separator": true,
      "is_prefix": false,
      "last_rate": 1.08,
      "date": "2024-05-20T00:00:00Z",
      "is_group_rate": false
    }
  ]
}
```

### HTTP Request

`GET https://api.allphins.com/api/v1/currency/`

## Retrieve a currency

```shell
curl https://api.allphins.com/api/v1/currency/EUR/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`GET https://api.allphins.com/api/v1/currency/:currency_code/`

### URL Parameters

| Parameter       | Description                             |
|-----------------|-----------------------------------------|
| `currency_code` | ISO 4217 currency code of the currency. |

## Create a currency

Register a new currency. Usually not needed — the supported set is seeded by Allphins.

### HTTP Request

`POST https://api.allphins.com/api/v1/currency/`

### Payload

| Parameter         | Type     | Required | Description              |
|-------------------|----------|----------|--------------------------|
| `currency_code`   | _string_ | Yes      | ISO 4217 code.           |
| `currency_symbol` | _string_ | No       | Display symbol.          |
| `currency_name`   | _string_ | No       | Human-readable name.     |
| `country_name`    | _string_ | No       | Country name.            |
| `separator`       | _bool_   | No       | Symbol/amount separator. |
| `is_prefix`       | _bool_   | No       | Symbol before amount.    |

# Rates

A rate is a `currency → USD` conversion value effective on a given date. Rates are scoped to the current group; users can override the default Allphins rate with a group-specific rate.

## Rate Object Attributes

| Attribute        | Type        | Description                                                        |
|------------------|-------------|--------------------------------------------------------------------|
| `id`             | _int_       | Unique identifier for the rate.                                    |
| `effective_date` | _timestamp_ | Date the rate is effective from.                                   |
| `currency`       | _string_    | `currency_code` of the currency this rate applies to.              |
| `value`          | _float_     | Conversion multiplier from the currency to USD.                    |

<aside class="notice">
The API accepts and returns the rate as <em>currency → USD</em>. Internally Allphins stores the inverse (<em>USD → currency</em>), inverted transparently on input and output.
</aside>

## Retrieve all rates

Returns a paginated list of rates of the current group.

```shell
curl https://api.allphins.com/api/v1/rates/ \
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
      "id": 101,
      "effective_date": "2024-05-20T00:00:00Z",
      "currency": "EUR",
      "value": 1.08
    }
  ]
}
```

### HTTP Request

`GET https://api.allphins.com/api/v1/rates/`

## Retrieve a rate

```shell
curl https://api.allphins.com/api/v1/rates/101/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`GET https://api.allphins.com/api/v1/rates/:id/`

### URL Parameters

| Parameter | Description                 |
|-----------|-----------------------------|
| `id`      | The ID of the rate to fetch |

## Create a rate

Creates a group-specific rate. Overrides the default Allphins rate for the same currency + effective date.

### HTTP Request

`POST https://api.allphins.com/api/v1/rates/`

### Payload

| Parameter        | Type        | Required | Description                                      |
|------------------|-------------|----------|--------------------------------------------------|
| `effective_date` | _timestamp_ | Yes      | Date the rate is effective from.                 |
| `currency`       | _string_    | Yes      | `currency_code` of the currency.                 |
| `value`          | _float_     | Yes      | Conversion multiplier (currency → USD, non-zero).|

```shell
curl https://api.allphins.com/api/v1/rates/ \
  -X POST \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"effective_date":"2024-05-20T00:00:00Z","currency":"EUR","value":1.08}'
```

## Update a rate

```shell
curl https://api.allphins.com/api/v1/rates/101/ \
  -X PATCH \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"value":1.09}'
```

### HTTP Request

`PATCH https://api.allphins.com/api/v1/rates/:id/`

## Delete a rate

```shell
curl https://api.allphins.com/api/v1/rates/101/ \
  -X DELETE \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

### HTTP Request

`DELETE https://api.allphins.com/api/v1/rates/:id/`
