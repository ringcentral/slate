# Notifications

A notification is a per-user, per-group message surfaced in the UI (e.g. "datasource mapping ready"). Notifications are created by platform workflows, not by the client. The API is limited to listing unseen notifications and flagging them as seen.

## Notification Object Attributes

| Attribute    | Type        | Description                                                                 |
|--------------|-------------|-----------------------------------------------------------------------------|
| `id`         | _UUID_      | Unique identifier for the notification.                                     |
| `title`      | _string_    | Title of the notification.                                                  |
| `content`    | _string_    | Body text.                                                                  |
| `type`       | _string_    | Notification type (e.g. `success`, `warning`, `error`, `info`).             |
| `cta_label`  | _string_    | Label for the call-to-action button, if any.                                |
| `cta_action` | _dict_      | CTA action payload (UI routing information).                                |
| `duration`   | _int_       | Display duration in seconds. `0` means until dismissed.                     |
| `key`        | _string_    | Unique key used to identify related notifications.                          |
| `group`      | _int_       | Group ID.                                                                   |

## Retrieve all unseen notifications

Returns notifications for the current user and active group where `seen=false`, ordered by `created_at` asc.

```shell
curl https://api.allphins.com/api/v1/notifications/ \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN'
```

> The above command returns JSON structured like this:

```json
[
  {
    "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "title": "Datasource mapped",
    "content": "Your file risks.xlsx is ready for import.",
    "type": "success",
    "cta_label": "Open",
    "cta_action": {"route": "/datasources/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"},
    "duration": 0,
    "key": "ds_mapping_xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
    "group": 10
  }
]
```

### HTTP Request

`GET https://api.allphins.com/api/v1/notifications/`

<aside class="notice">
Notifications are not paginated. The endpoint returns only unseen notifications; once marked as seen they disappear from the list.
</aside>

## Mark a notification as seen

```shell
curl https://api.allphins.com/api/v1/notifications/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/ \
  -X PATCH \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_ACCESS_TOKEN' \
  -d '{"seen":true}'
```

### HTTP Request

`PATCH https://api.allphins.com/api/v1/notifications/:id/`

### URL Parameters

| Parameter | Description                          |
|-----------|--------------------------------------|
| `id`      | UUID of the notification to update.  |

### Payload

| Parameter | Type   | Required | Description                  |
|-----------|--------|----------|------------------------------|
| `seen`    | _bool_ | Yes      | Set to `true` to dismiss it. |

# Updates

An update is a platform-wide announcement (release note, feature banner). Updates can be scoped to a specific user, group, or line of business; an update with no scoping is visible to all users.

## Update Object Attributes

| Attribute    | Type        | Description                                                       |
|--------------|-------------|-------------------------------------------------------------------|
| `id`         | _UUID_      | Unique identifier for the update.                                 |
| `title`      | _string_    | Title of the update.                                              |
| `content`    | _string_    | Body text (may contain HTML).                                     |
| `type`       | _string_    | Update type (e.g. `success`, `warning`, `info`).                  |
| `cta_label`  | _string_    | Label for the call-to-action button, if any.                      |
| `cta_action` | _dict_      | CTA action payload.                                               |
| `created_at` | _timestamp_ | Creation date.                                                    |
| `is_pinned`  | _bool_      | Whether the update is pinned at the top of the list.              |
| `key`        | _string_    | Unique key used to identify the update.                           |

## Retrieve all updates

Returns all updates visible to the current user, ordered by `is_pinned` desc, then `created_at` desc.

```shell
curl https://api.allphins.com/api/v1/updates/ \
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
      "title": "New Loss Ladder report available",
      "content": "<p>You can now export Loss Ladder reports...</p>",
      "type": "info",
      "cta_label": "Try it",
      "cta_action": {"route": "/reports"},
      "created_at": "2024-05-20T07:52:55.491729Z",
      "is_pinned": true,
      "key": "release_loss_ladder"
    }
  ]
}
```

### HTTP Request

`GET https://api.allphins.com/api/v1/updates/`
