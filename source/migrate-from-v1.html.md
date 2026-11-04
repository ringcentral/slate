---
title: Migrate from API v1

toc_footers:
  - <a href='../'>API Overview</a>
  - <a href='https://publitas.com'>Publitas.com</a>

search: false
---

# Migrate from API v1 to GraphQL

API v1 stops working on [DATE]. This guide shows the GraphQL query that replaces each API v1 call.

## What changes

| | API v1 | GraphQL |
| --- | --- | --- |
| Address | `https://api.publitas.com/v1/...` (one address per call) | `https://affiliate.publitas.com/graphql` (one address for everything) |
| Method | `GET` | `POST`, JSON body with `query` and `variables` |
| Authentication | none | `x-api-key` header; request a key from support@publitas.com |
| Spreads | all in one response | 50 per page; follow `pageInfo` |
| Products | one call per product | included in each product hotspot |
| Images | paths to complete yourself | full URLs per size |

## Calls

| API v1 call | GraphQL replacement |
| --- | --- |
| `GET /v1/groups/:group/publications.json` | `publications(groupSlug:)` |
| `GET /v1/groups/:group/publications/:slug.json` | `publication(groupSlug:, slug:)` |
| `GET /v1/groups/:group/publications/:slug/products/:id.json` | `publication(groupSlug:, slug:)`, then the product in its product hotspot |

You can also find a publication by its ID (`publication(id:)`) or by its viewer address (`publicationByUrl(url:)`).

### List a group's publications

```graphql
query ($groupSlug: String!, $after: String) {
  publications(groupSlug: $groupSlug, first: 50, after: $after) {
    pageInfo { hasNextPage endCursor }
    edges { node { id publicationSlug publicationTitle onlineAt } }
  }
}
```

```bash
curl https://affiliate.publitas.com/graphql \
  -H "x-api-key: YOUR_KEY" -H "Content-Type: application/json" \
  -d '{"query":"query ($groupSlug: String!) { publications(groupSlug: $groupSlug) { edges { node { id publicationSlug publicationTitle onlineAt } } } }","variables":{"groupSlug":"your-group"}}'
```

The list only includes groups your key is linked to. If it comes back empty, ask support to link your groups to your key. Unlisted publications are not included.

### Get one publication, with pages, hotspots and products

```graphql
query ($groupSlug: String!, $slug: String!, $after: String) {
  publication(groupSlug: $groupSlug, slug: $slug) {
    id slug title description language currency customCurrency downloadPdfUrl
    sizes { at width height }
    spreads(first: 50, after: $after) {
      pageInfo { hasNextPage endCursor }
      edges { node {
        position
        pages { position width height images { size url } }
        hotspots {
          __typename id left top width height
          ... on PageReferenceHotspot { pageNumber }
          ... on ExternalLinkHotspot { url }
          ... on VideoHotspot { videoId videoProvider }
          ... on ProductHotspot { products {
            id title description price discountedPrice
            webshopIdentifier webshopUrl promotionalLabel videoId
            photoUrls { thumb full }
          } }
        }
      } }
    }
  }
}
```

If `pageInfo.hasNextPage` is true, send the query again with `after` set to `pageInfo.endCursor`.

### Get one product

There is no single-product query. Fetch the publication (above) and find the product in `ProductHotspot.products`. This returns more data than the API v1 call did, so cache the publication rather than fetching it per product.

## Field names

| API v1 | GraphQL |
| --- | --- |
| `config.publicationId` | `publication.id` |
| `config.publicationTitle` | `publication.title` |
| `config.locale`, `config.language` | `publication.language` |
| `config.currencySymbol` | `publication.customCurrency` |
| `config.downloadPdfUrl` (a path) | `publication.downloadPdfUrl` (a full URL) |
| `spreads[].pages[]` (paths) | `spreads.pages.images { size url }` |
| `hotspots[].type` | `hotspots.__typename` |
| `hotspots[].position.left/top/width/height` | `hotspots.left/top/width/height` |
| `video.youtubeId` | `VideoHotspot.videoId` |
| list `slug`, `title` | `publicationSlug`, `publicationTitle` |
| product `photos[].photoUrl` | product `photoUrls { full }` |
| product `video[].youtubeId` | product `videoId` |
| product `hotspotId` | the `id` of the hotspot that contains it |

## What's gone

- **Viewer settings:** `customerName`, `relativeSize`, `websiteUrl`, `webshopCheckoutUrl`, `disableSharing`, `showPrintButton`, `enableSearch`, `searchHost`, `callToActionButtonText`, `styling`.
- **Viewer translations** (`translations`).
- **Unit prices** on products: `basePricePerUnit`, `baseMeasureQuantity`, `baseMeasureUnit`.
- **On hotspots:** `title`, `showIndication`, `showTooltip`, `position.iconLeft`, `position.iconTop`.
- **In the publications list:** `browserTitle` (use `publication.title`) and the `url` link.
