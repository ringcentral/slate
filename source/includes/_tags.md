# Tags

Tags are free-form string labels attached to policies via the `tags` field. This endpoint returns the aggregated list of tags currently in use across the group's policies.

## Retrieve all tags

Returns the sorted, deduplicated list of tag strings used on the current group's policies.

```shell
curl https://api.allphins.com/api/v1/tags/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

> The above command returns JSON structured like this:

```json
[
  "binding",
  "facultative",
  "treaty"
]
```

### HTTP Request

`GET https://api.allphins.com/api/v1/tags/`

<aside class="notice">
Tags are set on a policy through the <code>tags</code> field of <code>POST /policies/</code> or <code>PATCH /policies/:id/</code>. There is no endpoint to create or delete a tag directly.
</aside>
