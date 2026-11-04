---
title: API Reference

language_tabs:
  - shell

toc_footers:
  - <a href='../'>API Overview</a>
  - <a href='https://publitas.com'>Publitas.com</a>

search: false
---

# REST API v1

<aside class="warning">API v1 stops working on [DATE]. Move to the GraphQL API before then: the <a href="migrate-from-v1.html">migration guide</a> shows the query that replaces each call.</aside>

This API can be used to retrieve publication data for usage in mobile apps, sites and other integrations.

### Authentication

Our public API doesn't require authentication.

### Formats

Currently we only support JSON requests.

### Paths

The base path of an API request is: `https://api.publitas.com/v1/`

An example of a complete path is:

`https://api.publitas.com/v1/groups/example-blokker/publications.json`

### Images

```json
{
  "photoUrl": "/1230/10323/photos/22js92ksasfhhj2l"
}
```

Images and other assets are served from: `https://view.publitas.com`. Image paths returned from the API are all relative to this base path and all images are returned as `jpg` files.

A photoUrl returned from the API has to be concatenated to

`https://view.publitas.com/1230/10323/photos/22js92ksasfhhj2l-within1000.jpg`

where `-within1000.jpg` is dependent on the type of image.

<aside class="notice">
Instances where size attributes have to be added to the URL are documented accordingly.
</aside>

# Publications

```shell
# This will retrieve all publications for a group:
curl "https://api.publitas.com/v1/groups/example-blokker/publications.json"
```

> The above command returns JSON structured like this:

```json
[
  {
    "id": 1,
    "slug": "example_publication",
    "title": "Blokker example publication",
    "browserTitle": "Custom title",
    "onlineAt": "2013-09-11T10:19:41.000+02:00",
    "url": "https://api.publitas.com/v1/groups/example-blokker/publications/blokker-example.json"
  }
]
```

The URL for a publication is (appended to the base path)

`/groups/<group_slug>/publications.json`

A complete path looks like:

`https://api.publitas.com/v1/groups/example-blokker/publications.json`

The JSON response returns a list of publications with the following attributes.

| Field        | Type    | Description                                       |
| ------------ | ------- | ------------------------------------------------- |
| id           | Integer | Publication ID                                    |
| slug         | String  | Publication slug (used in path for API)           |
| title        | String  | Publication title                                 |
| browserTitle | String  | Publication browser title (can differ from title) |
| onlineAt     | String  | Timestamp of moment publication was published     |
| url          | String  | URL to the publication data json                  |

# Publication

```shell
# This will retrieve a single publication for a group:
curl "https://api.publitas.com/v1/groups/example-blokker/publications/blokker-example.json"
```

> The above command returns JSON structured like this:

```json
{
  "sizes": {},
  "config": {},
  "spreads": [],
  "translations": {}
}
```

The URL for a publication is (appended to the base path)

`/groups/<group_slug>/publications/<publication_slug>.json`

A complete path looks like:

`https://api.publitas.com/v1/groups/example-blokker/publications/blokker-example.json`

This endpoint returns a JSON object, we'll go into the details of this response below.

## Sizes

```json
{
  "sizes": {
    "at200": {
      "width": 183.0,
      "height": 218.0
    },
    "at600": {
      "width": 549.0,
      "height": 654.0
    },
    "at800": {
      "width": 732.0,
      "height": 873.0
    },
    "at1000": {
      "width": 916.0,
      "height": 1091.0
    },
    "at1200": {
      "width": 1099.0,
      "height": 1309.0
    },
    "at1600": {
      "width": 1465.0,
      "height": 1746.0
    },
    "at2000": {
      "width": 1832.0,
      "height": 2182.0
    },
    "at2400": {
      "width": 2198.0,
      "height": 2618.0
    }
  }
}
```

Contains a hash of the resolutions we have images for. Each resolution contains the width and height of that image.

| Field  | Type    | Description      |
| ------ | ------- | ---------------- |
| width  | Integer | Width in pixels  |
| height | Integer | Height in pixels |

## Config

```json
{
  "config": {
    "publicationId": 10323,
    "publicationTitle": "Example - Blokker - Blokker Example",
    "customerName": "Publitas - Marketing afd",
    "relativeSize": 0.935774,
    "locale": "en",
    "language": "en",
    "downloadPdfUrl": "/1230/10323/pdfs/1d9c2a58af4317ab870f8d4e125c8d664c7369a1.pdf",
    "disableFeedback": false,
    "disableBranding": false,
    "showPrintButton": false,
    "currencySymbol": "€",
    "currency": "EUR",
    "styling": {
      "call_to_action_button_background_color": "#51a8d6",
      "call_to_action_button_text_color": "#f0f9ff"
    }
  }
}
```

This contains the configuration of the reader.

| Field            | Type    | Description                                                                                                                                             |
| ---------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| publicationId    | Integer | Unique ID of the publication                                                                                                                            |
| publicationTitle | String  | Title of the publication                                                                                                                                |
| customerName     | String  | Customer / Company name                                                                                                                                 |
| relativeSize     | Float   | Indicating the relative size between the width/height of the images                                                                                     |
| locale           | String  | Locale of the publication, used for the translation hash                                                                                                |
| language         | String  | Language of the publication                                                                                                                             |
| downloadPdfUrl   | String  | Relative URL to the PDF, can be null if download is disabled                                                                                            |
| disableFeedback  | Boolean | Disable feedback tab                                                                                                                                    |
| disableBranding  | Boolean | Disable Publitas.com branding                                                                                                                           |
| showPrintButton  | Boolean | Show print button                                                                                                                                       |
| currencySymbol   | String  | Custom currency symbol value set in the Publication Reader configuration. For legacy reasons, this field defaults to €                                  |
| currency         | String  | Currency set in the Publication Reader configuration. This field is specified using an [ISO 4217 currency code](https://en.wikipedia.org/wiki/ISO_4217) |
| styling          | Hash    | Hash containing Call To Action (CTA) button styling, described below                                                                                    |

Styling:

| Field                                    | Type    | Description                        |
| ---------------------------------------- | ------- | ---------------------------------- |
| `call_to_action_button_background_color` | CSS/Hex | Color of the cta button background |
| `call_to_action_button_text_color`       | CSS/Hex | Color of the cta button text       |

<aside class="notice">
  Additional fields could be added to the configuration, they are meant to influcence our HTML reader, but can also be used in your implementation. These fields will not be removed without incrementing the API version.
</aside>
## Spreads

```json
{
  "spreads": [
    {
      "pages": [
        "/1230/10323/pages/d02b493028db893d159038587a6ed2c792aa0545"
      ],
      "hotspots": [...]
    },
    {
      "pages": [
        "/1230/10323/pages/b6d66056b3c9bab5332033ce401ec1f9549b5e8a",
        "/1230/10323/pages/461fbe1e5cd35d99f13ab501b256f155205db094"
      ]
    },
    {
      "pages": [
        "/1230/10323/pages/b6d66056b3c9bab5332033ce401ec1f9549b5e8a"
      ]
    }
  ]
}
```

Spreads are the core of a Publitas publication. They contain information about the page images and hotspots.

In general all spreads contain two pages, but there are two exceptions.

- The first spread always contains a single page and should ideally be displayed on the right side.
- The last spread can contain one or two pages. If only one page is returned, it should ideally be displayed on the left side.

If hotspots are present for a page the `"hotspots"` attribute is set. Otherwise the spread doesn't contain a `"hotspots"` attribute.

See [Hotspots](#hotspots) for more information.

### Images

The photos pages array contains 1 or 2 paths to page images. After the base path and this path, a number of options are available for the complete link.

- -at200.jpg
- -at600.jpg
- -at800.jpg
- -at1000.jpg
- -at1200.jpg
- -at1600.jpg
- -at2000.jpg
- -at2400.jpg

A full page image path would look like: `https://view.publitas.com/1230/10323/pages/b6d66056b3c9bab5332033ce401ec1f9549b5e8a-at200.jpg`

## Translations

```json
"translations": {
  "loading": "loading...",
  "pages": {
    "zero": "No pages",
    "one": "{count} page",
    "other": "{count} pages"
  },
  "page": "Page",
  "menu": "Menu",
  "hotspot": {
    "tooltip": {
      "external": "Go to website",
      "page": "Go to page {page}"
    }
  },
  "cta": {
    "video": "Watch video"
  },
  "products": {
    "cta_webshop": "Go to webshop",
    "cta_add_to_cart": "Add to cart",
    "more_info": "More info",
    "amount_in_cart": "{items} in your cart.",
    "video": "Video",
    "photos": "Extra images",
    "description": "Description"
  },
  "share": {
    "message": "Share this on Facebook,\nTwitter or via email."
  },
  "feedback": {
    "label": "Give us feedback",
    "placeholder": "Type feedback here...",
    "submit_button": "Send feedback",
    "submit_button_short": "Send",
    "success_message": "Feedback successfully sent.",
    "error_message": "Unable to send feedback at this moment.",
    "greetings_message": "Thank you!",
    "email_placeholder": "Email address (optional)",
    "email_label": "We will only use your email address to contact you if we have any questions about your feedback. We promise not to spam you or share your email address with anyone else."
  },
  "spread_overview": {
    "label": "Page overview"
  },
  "pdf_download": {
    "label": "Download PDF"
  },
  "leave_iframe": {
    "label": "Open in new window"
  },
  "shopping_cart": {
    "adding_item": "Item added to cart.",
    "checkout": "Proceed to Checkout",
    "label": "Shopping cart",
    "no_image": "no image",
    "title": {
      "zero": "Your cart is empty.",
      "one": "{count} item in your cart.",
      "other": "{count} items in your cart."
    }
  },
  "zoom_in": "Zoom in",
  "zoom_out": "Zoom out",
  "print": "Print"
}
```

Depending on the chosen language in the publication edit and group "localisation and branding" forms, translation strings for the reader are included at the end of the data json.

# Hotspots

Hotspots are generated in the hotspot editor.
Currently we support four kinds of hotspots:

- Product
- Link
- Page link
- Video

## Generic hotspot data:

```json
{
  "id": 138622,
  "title": null,
  "type": "product",
  "showIndication": true,
  "position": {
    "left": 0.02933,
    "top": 0.31527,
    "width": 0.48241,
    "height": 0.31035,
    "iconLeft": 0.85627,
    "iconTop": 0.28
  }
}
```

Hotspots of all types return at least this data.
It contains the hotspot id, title and type. But also data on where the hotspot is positioned on the page.

### Fields

| Field          | Type              | Description                                         |
| -------------- | ----------------- | --------------------------------------------------- |
| id             | Integer           | Specific hotspot ID                                 |
| title          | String (optional) | Hotspot title                                       |
| type           | String            | Hotspot type                                        |
| showIndication | Boolean           | If set to true, hotspot indication should be shown, |
| position       | Hash              | Hash containing position information,               |

### Position information

Position of the hotspots is calculated from the top-left of a spread.
The value is a float from 0 to 1, where 0 is left and 1 is the right side of the spread. The same goes for top where 0 is top and 1 is bottom of the spread.

| Field    | Type  | Description                                         |
| -------- | ----- | --------------------------------------------------- |
| left     | Float | Left position of the hotspot within the spread      |
| top      | Float | Top position of the hotspot within the spread       |
| width    | Float | Width of the hotspot                                |
| height   | Float | Height of the hotspot                               |
| iconLeft | Float | Left position (within the hotspot) of the indicator |
| iconTop  | Float | Top position (within the hotspot) of the indicator  |

For each hotspot we add additional data to the hotspot hash, here's an overview of all types.

## Product (product)

```json
{
  "id": 138622,
  "title": null,
  "type": "product",
  "showIndication": true,
  "position": {
    "left": 0.02933,
    "top": 0.31527,
    "width": 0.48241,
    "height": 0.31035,
    "iconLeft": 0.85627,
    "iconTop": 0.28
  },
  "products": [
    {
      "id": 49821,
      "stub": "true"
    }
  ]
}
```

This hotspot type contains an array called `products` containing one or more products.

The `"stub": "true"` flag means this is a "stub" product and more information about this product has to be retrieved from the [products API](#product). For now only "stubbed" products are supported.

| Field | Type | Description                                                                   |
| ----- | ---- | ----------------------------------------------------------------------------- |
| id    | Int  | ID of the product, can be used to retrieve additional information             |
| stub  | Bool | Wether more information has to be retrieved, currently only true is supported |

## Link (externalLink)

```json
{
  "id": 173114,
  "title": "Visit Google",
  "type": "externalLink",
  "showIndication": true,
  "position": {
    "left": 0.04874,
    "top": 0.27657,
    "width": 0.37184,
    "height": 0.32779,
    "iconLeft": 0.5,
    "iconTop": 0.5
  },
  "url": "http://google.com"
}
```

Link to an (external) URL. Can also be used for custom application schemes on mobile devices.

Internal link to a page, page numbers start at 1.

| Field | Type   | Description                                     |
| ----- | ------ | ----------------------------------------------- |
| url   | String | Can be an URL to a site or **app** (appName://) |

## Page link (pageReference)

```json
{
  "id": 173113,
  "title": "Go to page 2",
  "type": "pageReference",
  "showIndication": false,
  "position": {
    "left": 0.42419,
    "top": 0.03329,
    "width": 0.34657,
    "height": 0.18566,
    "iconLeft": 0.5,
    "iconTop": 0.5
  },
  "pageNumber": "2"
}
```

Internal link to a page, page numbers start at 1.

| Field      | Type | Description                                 |
| ---------- | ---- | ------------------------------------------- |
| pageNumber | Int  | Reference to page number in the publication |

## Video (video)

```json
{
  "id": 173115,
  "title": "Watch this video!",
  "type": "video",
  "showIndication": true,
  "position": {
    "left": 0.52708,
    "top": 0.28297,
    "width": 0.38989,
    "height": 0.31754,
    "iconLeft": 0.5,
    "iconTop": 0.5
  },
  "youtubeId": "gLDYtH1RH-U"
}
```

For now only YouTube is supported, the `youtubeId` can be used in embed code, or to generate a link to YouTube.

| Field     | Type   | Description      |
| --------- | ------ | ---------------- |
| youtubeId | String | YouTube video ID |

# Product

```shell
# This will retrieve a single product for a publication:
curl "https://api.publitas.com/v1/groups/example-blokker/publications/blokker-example/products/49836.json"
```

> The above command returns JSON structured like this:

```json
{
  "id": 49836,
  "hotspotId": 138648,
  "title": "Sola wok Ø 28 cm Luna Green & Healthy",
  "description": "Deze duurzaam geproduceerde wok heeft een keramische krasvaste bodem.",
  "price": 24.99,
  "discountedPrice": 19.99,
  "webshopIdentifier": "2104282",
  "webshopUrl": "http://webshop.com/product/2104282",
  "photos": [
    {
      "photoUrl": "/1230/10323/photos/22js92ksasfhhj2l"
    }
  ]
}
```

The URL for a product is (appended to the base path)

`/groups/<group_slug>/publications/<publication_slug>/products/<product_id>.json`

A complete path looks like:

`https://api.publitas.com/v1/groups/example-blokker/publications/blokker-example/products/49836.json`

The JSON response returns a product with the following attributes.

Where `id` is the product ID from the `data.json`

| Field             | Type    | Description                                     |
| ----------------- | ------- | ----------------------------------------------- |
| id                | Integer | Product ID                                      |
| hotspotId         | Integer | Id of the related hotspot                       |
| title             | String  | Product title                                   |
| description       | String  | Product description                             |
| price             | Float   | Product price                                   |
| discountedPrice   | Float   | Product price with discount                     |
| webshopIdentifier | String  | Product ID from the webshop                     |
| webshopUrl        | String  | Direct link to the product on the webshop       |
| photos            | Array   | Array of product photos containing 0 - 6 photos |

The photos array contains 0 to 6 photos with a `photoUrl` attribute. The `photoUrl` field refers to a relative base path to the image. After this base path two options are available for the complete link.

- -at200.jpg - a thumbnail of 200x200 px
- -within1000.jpg - image with a _maximum_ width/height of 1000 px.

In the example below the full photo URL will become:

`https://view.publitas.com/1230/10323/photos/22js92ksasfhhj2l-at200.png`

| Field    | Type   | Description                                |
| -------- | ------ | ------------------------------------------ |
| photoUrl | String | (Relative) link to product image base path |
