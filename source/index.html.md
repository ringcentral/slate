---
title: API Reference

toc_footers:
  - <a href='https://publitas.com'>Publitas.com</a>

search: false
---

# Publitas API Documentation

```
    ____        _     _ _ _
   |  _ \ _   _| |__ | (_) |_ __ _ ___
   | |_) | | | | '_ \| | | __/ _` / __|
   |  __/| |_| | |_) | | | || (_| \__ \
   |_|    \__,_|_.__/|_|_|\__\__,_|___/

            API Documentation
```

Welcome to the Publitas API documentation. On Page you can find recipes to get you started with common use cases as well as links to detailed API documentation.

# Recipe: Syncing your product inventory

This quick‑start guide shows how to import a product feed into Publitas and poll for its processing status using simple `curl` commands. Copy‑and‑paste the snippets, replacing the placeholder values with your own.

## Prerequisites

```shell
# Tip: to find your group id, list groups with
curl  https://api.publitas.com/v2/groups \
  -H "Authorization: ApiKey <API_KEY>"
```

1. **Publitas API key** with access to REST API v2.
2. Your **Group ID**.

To follow the example here you will also need `jq` for JSON parsing & a UNIX‑like shell.

The examples use shell commands to be generic, but they are by no means the recommended way to use the API. Feel free to use a language and/or framework of your choice.

## Set up your feed

You will need a publicly reachable **product‑feed** in `.xml` or `.tsv` format.  HTTP/S, (S)FTP are accepted.

You can learn more about setting up a feed [visit our knowledge base](https://support.publitas.com/setting-up-your-product-feed)

## Kick‑off the import

```shell
curl -s "https://api.publitas.com/v2/groups/$GROUP_ID/product_feeds" \
  -X POST \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  --data '{
    "product_feed": {
      "url": "'"$FEED_URL"'"
    }
  }'
```

Create a new product‑feed import with a **POST** request. The call returns a JSON envelope named `product_feed`. Save the returned `id` if you prefer to filter the polling results later.

## Poll the processing status

```shell
while true; do
  resp=$(curl -s -H "Authorization: ApiKey $API_KEY" \
              "https://api.publitas.com/v2/groups/$GROUP_ID/product_feeds")

  state=$(echo "$resp" | jq -r '.product_feeds[] | select(.id == $FEED_ID) | .state')
  echo "Import state: $state"

  [[ $state =~ success|failed ]] && break
  sleep 15
done
```

Publitas processes the feed asynchronously. The simplest approach is to ask for the **last 5 imports** and inspect the most recent one until it leaves the `processing` state. If you have stored the feed id, you can filter for it as illustrated here.

Possible **states** are:

| State        | Meaning                                    |
| ------------ | ------------------------------------------ |
| `processing` | Feed is being parsed & validated           |
| `success`    | All products processed (or minor warnings) |
| `failed`     | Import aborted — see `failed_count`        |

# Recipe: End-to-end publishing via the REST API.

Below is a minimal “recipe” that takes a PDF with product-hotspot annotations all the way to a finished online publication in Publitas, using nothing but standard shell tools ( `gs`, `curl`, and a little `jq` ).

## Prerequisites

```shell
# Tip: to find your group id, list groups with
curl  https://api.publitas.com/v2/groups \
  -H "Authorization: ApiKey <API_KEY>"
```

1. **Publitas API key** with access to REST API v2.
2. Your **Group ID**.
3. Optionally, [GhostScript](https://ghostscript.com) installed on your machine.

To follow the example here you will also need `jq` for JSON parsing & a UNIX‑like shell.

The examples use shell commands to be generic, but they are by no means the recommended way to use the API. Feel free to use a language and/or framework of your choice.

## Optional: Annotate the PDF with Ghostscript

```bash
cat > hotspots.ps <<'EOF'
[/Subtype /Text
 /Rect [150 500 350 450]
 /Contents ({ "type": "product", "icon": true,
              "dynamic": true, "sku": "WP06-29-Black" })
 /ANN pdfmark
EOF

gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite \
   -sOutputFile="annotated.pdf" hotspots.ps "input.pdf"
```

Publitas recognizes standard **PDF annotations** and converts them into hotspots. If you want to automate this part of the process and have a data set with coordinates and product SKUs you can use [GhostScript](https://ghostscript.com) and the **pdfmark syntax** to add these annotation to your original PDF.

For all the supported hotspot types and attributes, check [Hotspot Annotations](hotspot-annotations.html). Otherwise skip to the next step.

## Make the file publicly reachable

The `POST /publications` endpoint only accepts a **URL**, so copy `annotated.pdf` somewhere the API can fetch (S3, Azure Blob, GitHub Release, etc.) and note the link.

## Create the publication

```bash
curl -s "https://api.publitas.com/v2/groups/$GROUP_ID/publications" \
  -H "Authorization: ApiKey $API_KEY" \
  -H "Content-Type: application/json" \
  -X POST \
  --data '{
    "publication": {
      "title": "Publication Title",
      "source_url": "$PDF_URL",
      "schedule_online_at": "2025-09-25T15:17:20.000+02:00"
    }
  }'
```

The call returns a JSON envelope named `publication`; save the `id`, you'll need it for later steps. This assumes you stored the **public PDF URL** from the previous link in `$PDF_URL`.

`schedule_online_at` will make the publication publicly available (**online**) at the given timestamp.

## Optional: Poll the conversion status

```bash
while :; do
  state=$(curl -s \
      -H "Authorization: ApiKey $API_KEY" \
      "https://api.publitas.com/v2/groups/$GROUP_ID/publications/$PUB_ID/conversions/" |
      jq -r '.conversions[0].state')

  echo "Conversion state: $state"
  [[ $state =~ finished|failed|canceled ]] && break
  sleep 15
done
```

Publitas creates an internal **conversion** record every time pages are processed.
We poll until the latest record’s `state` becomes `finished` (or `failed`).

If it finishes, your PDF is now rendered into pages and hotspots. If it fails, inspect `.conversions[0].state_details.error` for a message (e.g. bad URL, corrupted PDF).

## Optional: Manually take the publication online

```shell
curl "https://api.publitas.com/v2/groups/$GROUP_ID/publications/$PUB_ID/online" \
  -H "Authorization: ApiKey <api_key>" \
  -X POST
```

Instead of scheduling the publication via `schedule_online_at` you can also take it **online** immediately using this API call. The conversion has to be finished for this to work.

## Grab the public URL

```shell
curl "https://api.publitas.com/v2/groups/$GROUP_ID/publications/$PUB_ID"  \
  -H "Authorization: ApiKey $API_KEY" |
  jq -r '.publication.public_url'
```

When the conversion is complete and the publication is put online (manually or via `schedule_online_at`), it will be accessible via `public_url`.

You can use this URL to link to this publication or embed it within your website.

# API Overview

## REST API

A REST API for retailers to automate their workflows from creation to. The current version is v2, but v1 is still supported. Please build all new integrations using version 2

[REST API v1 documentation](rest-v1.html) (stops working on [DATE]; see [Migrate from API v1](migrate-from-v1.html))

[REST API v2 documentation](rest-v2.html)

## GraphQL API

A GraphQL API that allows affilates to fetch publication data from different retailers.

[GraphQL documentation](graphql.html)

## Viewer JavaScript API

A JavaScript API to be used in our Viewers via the code injection tool. Can be used for customizing the Viewer, add analytics tracking or even develop new features.

[Viewer JavaScript API v1 documentation](js.html)

## Viewer Message API

A JavaScript API to react to events in the Viewer. Useful for integrating an embedded Viewer with your site, or for triggering custom actions on certain events.

[Viewer Message API documentation](viewer-message-api.html)

## Widgets

Embeddable web components that render an affiliate's content on your own website via a SDK script.

[Widgets documentation](widgets.html)
