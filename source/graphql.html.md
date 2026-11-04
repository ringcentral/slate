---
title: GraphQL Reference

toc_footers:
  - <a href='../'>API Overview</a>
  - <a href='https://publitas.com'>Publitas.com</a>
---

# GraphQL

You can use the GraphQL API as an affiliate partner to ingest publication data for all retailers that have subscribed to your reach channel.

Retailers can also use it to read their own publications, for example when moving from REST API v1. See [Migrate from API v1](migrate-from-v1.html).

# Getting Started

## The GraphQL endpoint

With GraphQL there is only a single endpoint, which is

`https://affiliate.publitas.com/graphql`

## Get an API key

To use the GraphQL API you need to an API key. Contact our [support team](mailto:support@publitas.com) to request an API key.

API keys are passed via the `x-api-key` header.

## Overview

Here is an example of a publication by slug query containing all the supported fields. References for each field, type, and object can be found below in [GraphQL References](#graphql-references).

```text
query {
  publication(slug: "foo", groupSlug: "bar") {
    id
    slug
    groupSlug
    title
    description
    layout
    language
    downloadPdfUrl
    currency
    customCurrency
    sizes {
      at
      width
      height
    }
    spreads {
      edges {
        cursor
        node {
          pages {
            images {
              size
              url
            }
          }
          hotspots {
            height
            left
            top
            tabIndex
            width
            zIndex
            __typename
            ... on Hotspot {
              height
              left
              top
              tabIndex
              width
              zIndex
            }
            ... on ProductHotspot {
              products {
                id
                title
                availability
                price
                description
                position
                discountedPrice
                webshopUrl
                webshopIdentifier
                productType
                brand
                gtin
                mpn
                customLabel0
                customLabel1
                customLabel2
                customLabel3
                customLabel4
                customLabels {
                  customLabel0
                  customLabel19
                }
                itemGroupId
                videoId
                videoProvider
                photoUrls {
                  thumb
                  full
                }
              }
            }
            ... on ExternalLinkHotspot {
              url
            }
            ... on ImageHotspot {
              url
              imageAltText
              imageShowLightbox
              contentFitMode
            }
            ... on PageReferenceHotspot {
              pageNumber
            }
            ... on SlideshowHotspot {
              autoplay
              backgroundColor
              slideshowItems {
                url
              }
            }
            ... on VideoHotspot {
              videoId
              videoUrl
              videoProvider
              videoOverlayContent
              videoAutoplay
              videoShowPreview
              videoLoop
            }
          }
        }
      }
    }
  }
}
```

## Understanding Pagination

```text
query {
  publication(id: 1000) {
    spreads {
      edges {
        cursor
        node {
          hotspots {
            left
            top
          }
        }
      }
    }
  }
}
```

Entities having a related Edge object are paginated using cursors. Each page returns a cursor that points to the next batch of items. For the time being, only Spreads are paginated. The maximum number of items per page is 50.

For more details on how to use cursor-based pagination, read the [official GraphQL docs](https://graphql.org/learn/pagination/).

Here is a simple query showing how to fetch paginated items (in this case, spreads).

## Pagination response

```json
{
  "data": {
    "publication": {
      "spreads": {
        "edges": [
          {
            "cursor": "MQ",
            "node": {
              "hotspots": [
                {
                  "left": 0.2181974544203647,
                  "top": 0.28071539657853817
                },
                {
                  "left": 0.7932750947750123,
                  "top": 0.9113263785394933
                },
                {
                  "left": 0.10825773919372027,
                  "top": 0.060517038777908344
                }
              ]
            }
          },
          {
            "cursor": "Mg",
            "node": {
              "hotspots": [
                {
                  "left": 0.5865075571525111,
                  "top": 0.4807445442875482
                },
                {
                  "left": 0.05432514161591209,
                  "top": 0.09948652118100128
                },
                {
                  "left": 0.14557201958101892,
                  "top": 0.589418777943368
                },
                {
                  "left": 0.5865075571525111,
                  "top": 0.2749627421758569
                }
              ]
            }
          },
          {
            "cursor": "Mw",
            "node": {
              "hotspots": [
                {
                  "left": 0.11709053748908045,
                  "top": 0.6162444113263785
                },
                {
                  "left": 0.7531604885365332,
                  "top": 0.3211624441132638
                }
              ]
            }
          }
        ]
      }
    }
  }
}
```

The above query returns the following result.

## Using the pagination cursor

```text
query {
  publication(id: 1000) {
    spreads(after: "Mw") {
      edges {
        cursor
        node {
          hotspots {
            left
            top
          }
        }
      }
    }
  }
}
```

To get the next batch of items after the last one, the next query should include an `after` argument for the `spreads` block, passing the last cursor as value.

When there are no more items, the `edges` object array will be empty.

## Filtering publications

```text
query {
  publications(groupSlug: "acme", first: 25) {
    edges {
      cursor
      node {
        id
        slug
        title
        groupSlug
      }
    }
  }
}
```

The `publications` query accepts three optional filters that narrow the result set server-side:

- `groupId` — restrict to publications in a given group
- `groupSlug` — restrict to publications in the group with this slug
- `accountId` — restrict to publications whose group belongs to this account

Filters can be combined and are AND-ed together. They only ever narrow results within your affiliate scope and never widen visibility. Filtering by an invalid integer ID (`groupId`, `accountId`) or an empty `groupSlug` returns an empty list rather than an error.

# GraphQL References

Below are the specifications for each supported field and object.

<!-- START graphql-markdown -->


## Query
<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="query.publication">publication</strong></td>
<td valign="top"><a href="#publication">Publication</a></td>
<td>

Finds a publication by ID or by both slug and the group slug

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">id</td>
<td valign="top"><a href="#id">ID</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">groupSlug</td>
<td valign="top"><a href="#string">String</a></td>
<td>

The group's URL slug. Consists of lowercase letters, numbers, hyphens, and underscores.

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">slug</td>
<td valign="top"><a href="#string">String</a></td>
<td>

The publication's URL slug. Consists of lowercase letters, numbers, hyphens, and underscores.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="query.publicationbyurl">publicationByUrl</strong></td>
<td valign="top"><a href="#publication">Publication</a></td>
<td>

Finds a publication by URL

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">url</td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="query.publications">publications</strong></td>
<td valign="top"><a href="#publicationlistitemconnection">PublicationListItemConnection</a></td>
<td>

Lists publications with pagination

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">after</td>
<td valign="top"><a href="#string">String</a></td>
<td>

Returns the elements in the list that come after the specified cursor.

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">before</td>
<td valign="top"><a href="#string">String</a></td>
<td>

Returns the elements in the list that come before the specified cursor.

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">first</td>
<td valign="top"><a href="#int">Int</a></td>
<td>

Returns the first _n_ elements from the list.

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">last</td>
<td valign="top"><a href="#int">Int</a></td>
<td>

Returns the last _n_ elements from the list.

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">groupId</td>
<td valign="top"><a href="#id">ID</a></td>
<td>

Filter to publications belonging to this group

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">groupSlug</td>
<td valign="top"><a href="#string">String</a></td>
<td>

Filter to publications belonging to the group with this slug. Consists of lowercase letters, numbers, hyphens, and underscores.

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">accountId</td>
<td valign="top"><a href="#id">ID</a></td>
<td>

Filter to publications whose group belongs to this account

</td>
</tr>
</tbody>
</table>

## Objects

### CustomLabel

The custom labels of a product, keyed by their feed attribute name

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel0">customLabel0</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 0

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel1">customLabel1</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 1

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel10">customLabel10</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 10

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel11">customLabel11</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 11

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel12">customLabel12</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 12

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel13">customLabel13</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 13

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel14">customLabel14</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 14

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel15">customLabel15</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 15

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel16">customLabel16</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 16

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel17">customLabel17</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 17

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel18">customLabel18</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 18

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel19">customLabel19</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 19

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel2">customLabel2</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 2

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel3">customLabel3</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 3

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel4">customLabel4</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 4

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel5">customLabel5</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 5

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel6">customLabel6</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 6

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel7">customLabel7</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 7

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel8">customLabel8</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 8

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="customlabel.customlabel9">customLabel9</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 9

</td>
</tr>
</tbody>
</table>

### ExternalLinkHotspot

A hotspot with an external link

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="externallinkhotspot.height">height</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="externallinkhotspot.id">id</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="externallinkhotspot.left">left</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="externallinkhotspot.tabindex">tabIndex</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="externallinkhotspot.top">top</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="externallinkhotspot.url">url</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="externallinkhotspot.width">width</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="externallinkhotspot.zindex">zIndex</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
</tbody>
</table>

### Image

An image from a page

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="image.size">size</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="image.url">url</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
</tbody>
</table>

### ImageHotspot

An image hotspot

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="imagehotspot.contentfitmode">contentFitMode</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="imagehotspot.height">height</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="imagehotspot.id">id</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="imagehotspot.imagealttext">imageAltText</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="imagehotspot.imageshowlightbox">imageShowLightbox</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="imagehotspot.left">left</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="imagehotspot.tabindex">tabIndex</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="imagehotspot.top">top</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="imagehotspot.url">url</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="imagehotspot.width">width</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="imagehotspot.zindex">zIndex</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
</tbody>
</table>

### ImageSize

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="imagesize.at">at</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="imagesize.height">height</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="imagesize.width">width</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
</tbody>
</table>

### Page

A publication page

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="page.height">height</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="page.id">id</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="page.images">images</strong></td>
<td valign="top">[<a href="#image">Image</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">options</td>
<td valign="top">[<a href="#imageoptions">ImageOptions</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="page.position">position</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="page.text">text</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="page.width">width</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
</tbody>
</table>

### PageInfo

Information about pagination in a connection.

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="pageinfo.endcursor">endCursor</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

When paginating forwards, the cursor to continue.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="pageinfo.hasnextpage">hasNextPage</strong></td>
<td valign="top"><a href="#boolean">Boolean</a>!</td>
<td>

When paginating forwards, are there more items?

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="pageinfo.haspreviouspage">hasPreviousPage</strong></td>
<td valign="top"><a href="#boolean">Boolean</a>!</td>
<td>

When paginating backwards, are there more items?

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="pageinfo.startcursor">startCursor</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td>

When paginating backwards, the cursor to continue.

</td>
</tr>
</tbody>
</table>

### PageReferenceHotspot

A hotspot with a reference to another page

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="pagereferencehotspot.height">height</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="pagereferencehotspot.id">id</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="pagereferencehotspot.left">left</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="pagereferencehotspot.pagenumber">pageNumber</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="pagereferencehotspot.tabindex">tabIndex</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="pagereferencehotspot.top">top</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="pagereferencehotspot.width">width</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="pagereferencehotspot.zindex">zIndex</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
</tbody>
</table>

### PhotoUrl

Photo data with thumb and full URLs

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="photourl.full">full</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="photourl.thumb">thumb</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
</tbody>
</table>

### Product

A product from a hotspot

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="product.availability">availability</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.brand">brand</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.customlabel0">customLabel0</strong> ⚠️</td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 0

<p>⚠️ <strong>DEPRECATED</strong></p>
<blockquote>

Legacy, prefer customLabels field

</blockquote>
</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.customlabel1">customLabel1</strong> ⚠️</td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 1

<p>⚠️ <strong>DEPRECATED</strong></p>
<blockquote>

Legacy, prefer customLabels field

</blockquote>
</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.customlabel2">customLabel2</strong> ⚠️</td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 2

<p>⚠️ <strong>DEPRECATED</strong></p>
<blockquote>

Legacy, prefer customLabels field

</blockquote>
</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.customlabel3">customLabel3</strong> ⚠️</td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 3

<p>⚠️ <strong>DEPRECATED</strong></p>
<blockquote>

Legacy, prefer customLabels field

</blockquote>
</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.customlabel4">customLabel4</strong> ⚠️</td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 4

<p>⚠️ <strong>DEPRECATED</strong></p>
<blockquote>

Legacy, prefer customLabels field

</blockquote>
</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.customlabel5">customLabel5</strong> ⚠️</td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 5

<p>⚠️ <strong>DEPRECATED</strong></p>
<blockquote>

Legacy, prefer customLabels field

</blockquote>
</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.customlabel6">customLabel6</strong> ⚠️</td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 6

<p>⚠️ <strong>DEPRECATED</strong></p>
<blockquote>

Legacy, prefer customLabels field

</blockquote>
</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.customlabel7">customLabel7</strong> ⚠️</td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 7

<p>⚠️ <strong>DEPRECATED</strong></p>
<blockquote>

Legacy, prefer customLabels field

</blockquote>
</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.customlabel8">customLabel8</strong> ⚠️</td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 8

<p>⚠️ <strong>DEPRECATED</strong></p>
<blockquote>

Legacy, prefer customLabels field

</blockquote>
</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.customlabel9">customLabel9</strong> ⚠️</td>
<td valign="top"><a href="#string">String</a></td>
<td>

The product's custom label 9

<p>⚠️ <strong>DEPRECATED</strong></p>
<blockquote>

Legacy, prefer customLabels field

</blockquote>
</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.customlabels">customLabels</strong></td>
<td valign="top"><a href="#customlabel">CustomLabel</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.description">description</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.discountedprice">discountedPrice</strong></td>
<td valign="top"><a href="#float">Float</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.googleproductcategory">googleProductCategory</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.gtin">gtin</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.id">id</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.itemgroupid">itemGroupId</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.mpn">mpn</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.photourls">photoUrls</strong></td>
<td valign="top">[<a href="#photourl">PhotoUrl</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.position">position</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.price">price</strong></td>
<td valign="top"><a href="#float">Float</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.producttype">productType</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.promotionallabel">promotionalLabel</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.title">title</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.videoid">videoId</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.videoprovider">videoProvider</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.webshopidentifier">webshopIdentifier</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="product.webshopurl">webshopUrl</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
</tbody>
</table>

### ProductHotspot

A hotspot containing products

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="producthotspot.dynamic">dynamic</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="producthotspot.height">height</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="producthotspot.id">id</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="producthotspot.left">left</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="producthotspot.products">products</strong></td>
<td valign="top">[<a href="#product">Product</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="producthotspot.tabindex">tabIndex</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="producthotspot.top">top</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="producthotspot.width">width</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="producthotspot.zindex">zIndex</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
</tbody>
</table>

### Publication

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="publication.accountid">accountId</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.cachehash">cacheHash</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.currency">currency</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.customcurrency">customCurrency</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.description">description</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.downloadpdfurl">downloadPdfUrl</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.groupid">groupId</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.groupslug">groupSlug</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td>

The group's URL slug. Consists of lowercase letters, numbers, hyphens, and underscores.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.grouptitle">groupTitle</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.id">id</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.language">language</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.layout">layout</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.offlineat">offlineAt</strong></td>
<td valign="top"><a href="#iso8601datetime">ISO8601DateTime</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.onlineat">onlineAt</strong></td>
<td valign="top"><a href="#iso8601datetime">ISO8601DateTime</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.publicationslug">publicationSlug</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td>

The publication's URL slug. Consists of lowercase letters, numbers, hyphens, and underscores.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.publicationtitle">publicationTitle</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.scheduleofflineat">scheduleOfflineAt</strong></td>
<td valign="top"><a href="#iso8601datetime">ISO8601DateTime</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.scheduleonlineat">scheduleOnlineAt</strong></td>
<td valign="top"><a href="#iso8601datetime">ISO8601DateTime</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.sizes">sizes</strong></td>
<td valign="top">[<a href="#imagesize">ImageSize</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.slug">slug</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td>

The publication's URL slug. Consists of lowercase letters, numbers, hyphens, and underscores.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.spreads">spreads</strong></td>
<td valign="top"><a href="#spreadconnection">SpreadConnection</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">after</td>
<td valign="top"><a href="#string">String</a></td>
<td>

Returns the elements in the list that come after the specified cursor.

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">before</td>
<td valign="top"><a href="#string">String</a></td>
<td>

Returns the elements in the list that come before the specified cursor.

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">first</td>
<td valign="top"><a href="#int">Int</a></td>
<td>

Returns the first _n_ elements from the list.

</td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">last</td>
<td valign="top"><a href="#int">Int</a></td>
<td>

Returns the last _n_ elements from the list.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.title">title</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publication.validfrom">validFrom</strong></td>
<td valign="top"><a href="#iso8601date">ISO8601Date</a></td>
<td></td>
</tr>
</tbody>
</table>

### PublicationListItem

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="publicationlistitem.accountid">accountId</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publicationlistitem.cachehash">cacheHash</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publicationlistitem.groupid">groupId</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publicationlistitem.groupslug">groupSlug</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td>

The group's URL slug. Consists of lowercase letters, numbers, hyphens, and underscores.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publicationlistitem.grouptitle">groupTitle</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publicationlistitem.id">id</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publicationlistitem.publicationslug">publicationSlug</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td>

The publication's URL slug. Consists of lowercase letters, numbers, hyphens, and underscores.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publicationlistitem.publicationtitle">publicationTitle</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publicationlistitem.scheduleofflineat">scheduleOfflineAt</strong></td>
<td valign="top"><a href="#iso8601datetime">ISO8601DateTime</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publicationlistitem.scheduleonlineat">scheduleOnlineAt</strong></td>
<td valign="top"><a href="#iso8601datetime">ISO8601DateTime</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publicationlistitem.validfrom">validFrom</strong></td>
<td valign="top"><a href="#iso8601date">ISO8601Date</a></td>
<td></td>
</tr>
</tbody>
</table>

### PublicationListItemConnection

The connection type for PublicationListItem.

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="publicationlistitemconnection.edges">edges</strong></td>
<td valign="top">[<a href="#publicationlistitemedge">PublicationListItemEdge</a>]</td>
<td>

A list of edges.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publicationlistitemconnection.nodes">nodes</strong></td>
<td valign="top">[<a href="#publicationlistitem">PublicationListItem</a>]</td>
<td>

A list of nodes.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publicationlistitemconnection.pageinfo">pageInfo</strong></td>
<td valign="top"><a href="#pageinfo">PageInfo</a>!</td>
<td>

Information to aid in pagination.

</td>
</tr>
</tbody>
</table>

### PublicationListItemEdge

An edge in a connection.

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="publicationlistitemedge.cursor">cursor</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td>

A cursor for use in pagination.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="publicationlistitemedge.node">node</strong></td>
<td valign="top"><a href="#publicationlistitem">PublicationListItem</a></td>
<td>

The item at the end of the edge.

</td>
</tr>
</tbody>
</table>

### SlideshowHotspot

A hotspot with a slideshow of images

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="slideshowhotspot.autoplay">autoplay</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="slideshowhotspot.backgroundcolor">backgroundColor</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="slideshowhotspot.height">height</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="slideshowhotspot.id">id</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="slideshowhotspot.left">left</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="slideshowhotspot.slideshowitems">slideshowItems</strong></td>
<td valign="top">[<a href="#slideshowitem">SlideshowItem</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="slideshowhotspot.tabindex">tabIndex</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="slideshowhotspot.top">top</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="slideshowhotspot.width">width</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="slideshowhotspot.zindex">zIndex</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
</tbody>
</table>

### SlideshowItem

A slideshow item from a slideshow hotspot

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="slideshowitem.url">url</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td></td>
</tr>
</tbody>
</table>

### Spread

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="spread.hotspots">hotspots</strong></td>
<td valign="top">[<a href="#hotspot">Hotspot</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" align="right" valign="top">types</td>
<td valign="top">[<a href="#hotspotcategory">HotspotCategory</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="spread.id">id</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="spread.pages">pages</strong></td>
<td valign="top">[<a href="#page">Page</a>!]</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="spread.position">position</strong></td>
<td valign="top"><a href="#int">Int</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="spread.publicationid">publicationId</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
</tbody>
</table>

### SpreadConnection

The connection type for Spread.

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="spreadconnection.edges">edges</strong></td>
<td valign="top">[<a href="#spreadedge">SpreadEdge</a>]</td>
<td>

A list of edges.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="spreadconnection.nodes">nodes</strong></td>
<td valign="top">[<a href="#spread">Spread</a>]</td>
<td>

A list of nodes.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="spreadconnection.pageinfo">pageInfo</strong></td>
<td valign="top"><a href="#pageinfo">PageInfo</a>!</td>
<td>

Information to aid in pagination.

</td>
</tr>
</tbody>
</table>

### SpreadEdge

An edge in a connection.

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="spreadedge.cursor">cursor</strong></td>
<td valign="top"><a href="#string">String</a>!</td>
<td>

A cursor for use in pagination.

</td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="spreadedge.node">node</strong></td>
<td valign="top"><a href="#spread">Spread</a></td>
<td>

The item at the end of the edge.

</td>
</tr>
</tbody>
</table>

### VideoHotspot

A hotspot with an embedded video

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="videohotspot.height">height</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="videohotspot.id">id</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="videohotspot.left">left</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="videohotspot.tabindex">tabIndex</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="videohotspot.top">top</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="videohotspot.videoautoplay">videoAutoplay</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="videohotspot.videoid">videoId</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="videohotspot.videoloop">videoLoop</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="videohotspot.videooverlaycontent">videoOverlayContent</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="videohotspot.videoprovider">videoProvider</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="videohotspot.videoshowaccessibilitycontrols">videoShowAccessibilityControls</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="videohotspot.videoshowpreview">videoShowPreview</strong></td>
<td valign="top"><a href="#boolean">Boolean</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="videohotspot.videotype">videoType</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="videohotspot.videourl">videoUrl</strong></td>
<td valign="top"><a href="#string">String</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="videohotspot.width">width</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="videohotspot.zindex">zIndex</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
</tbody>
</table>

## Enums

### HotspotCategory

<table>
<thead>
<tr>
<th align="left">Value</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td valign="top"><strong>PRODUCT</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>EXTERNAL_LINK</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>PAGE_REFERENCE</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>VIDEO</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>IMAGE</strong></td>
<td></td>
</tr>
<tr>
<td valign="top"><strong>SLIDESHOW</strong></td>
<td></td>
</tr>
</tbody>
</table>

### ImageOptions

<table>
<thead>
<tr>
<th align="left">Value</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td valign="top"><strong>EXCLUDE_GIFS</strong></td>
<td></td>
</tr>
</tbody>
</table>

## Scalars

### Boolean

Represents `true` or `false` values.

### Float

Represents signed double-precision fractional values as specified by [IEEE 754](https://en.wikipedia.org/wiki/IEEE_floating_point).

### ID

Represents a unique identifier that is Base64 obfuscated. It is often used to refetch an object or as key for a cache. The ID type appears in a JSON response as a String; however, it is not intended to be human-readable. When expected as an input type, any string (such as `"VXNlci0xMA=="`) or integer (such as `4`) input value will be accepted as an ID.

### ISO8601Date

An ISO 8601-encoded date

### ISO8601DateTime

An ISO 8601-encoded datetime

### Int

Represents non-fractional signed whole numeric values. Int can represent values between -(2^31) and 2^31 - 1.

### String

Represents textual data as UTF-8 character sequences. This type is most often used by GraphQL to represent free-form human-readable text.


## Interfaces


### Hotspot

A hotspot that may be of several types

<table>
<thead>
<tr>
<th align="left">Field</th>
<th align="right">Argument</th>
<th align="left">Type</th>
<th align="left">Description</th>
</tr>
</thead>
<tbody>
<tr>
<td colspan="2" valign="top"><strong id="hotspot.height">height</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="hotspot.id">id</strong></td>
<td valign="top"><a href="#id">ID</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="hotspot.left">left</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="hotspot.tabindex">tabIndex</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="hotspot.top">top</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="hotspot.width">width</strong></td>
<td valign="top"><a href="#float">Float</a>!</td>
<td></td>
</tr>
<tr>
<td colspan="2" valign="top"><strong id="hotspot.zindex">zIndex</strong></td>
<td valign="top"><a href="#int">Int</a></td>
<td></td>
</tr>
</tbody>
</table>

**Possible Types:** [ExternalLinkHotspot](#externallinkhotspot), [ImageHotspot](#imagehotspot), [PageReferenceHotspot](#pagereferencehotspot), [ProductHotspot](#producthotspot), [SlideshowHotspot](#slideshowhotspot), [VideoHotspot](#videohotspot)

<!-- END graphql-markdown -->
