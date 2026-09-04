# Banner Internal Links — Backend/Admin Reference

Dashboard banners (both the carousel and inline banners) can redirect a user
**inside the app** instead of opening an external URL. To do this, set the
banner's `linkUrl` (a.k.a. `ctaUrl`) field to one of the exact values below.

Tapping a banner checks this value against the list first. If it matches, the
app navigates to that screen. If it doesn't match anything here, the app
falls back to opening it as a normal external URL in the browser — so
existing banners with real URLs (`https://...`) keep working exactly as
before. No other backend change is needed; this is purely a value in the
same `linkUrl` field that already exists.

**Matching is exact** — case-sensitive, no extra spaces, no trailing slash.

## Supported values

| `linkUrl` value | Opens |
|---|---|
| `premium://premium-features` | Premium Features page |
| `one-on-one://one-on-one` | One-on-One Classes page |
| `courses://list` | Courses list |
| `news://list` | News list |
| `shorts://feed` | Shorts feed |
| `community://chat` | Community chat |
| `quiz://topics` | Quiz topics |
| `tools://all` | All Tools page |
| `gallery://home` | Gallery |
| `profile://me` | Profile |
| `journey://import` | Import Journey |
| `journey://export` | Export Journey |
| `consultation://book` | Free counseling / consultation booking |
| `tools://export-price` | Export Price Calculator |
| `tools://import-calc` | Import Calculator |
| `tools://cbm` | CBM Calculator |
| `tools://gst` | GST Calculator |
| `tools://hsn-finder` | HSN Finder |
| `tools://forex` | Forex Converter |
| `tools://forex-rates` | Forex Rates List |
| `tools://gov-benefits` | Government Benefits |
| `tools://incoterms` | Incoterms Guide |
| `tools://product-cert` | Product Certification |

## Not supported (yet)

Pages that need a *specific item* selected — a particular news article,
course, or webinar — aren't wired up yet. Their link shape would be
`news://<newsId>`, `course://<courseId>`, `webinar://<seminarId>`, but the
admin dashboard doesn't have an item-picker for banners to supply that ID.
Until that exists, don't send these — they won't resolve to anything.

## Where this lives in the app

- Client-side resolver: `lib/core/services/internal_link_router.dart`
- Used by: `lib/features/dashboard/presentation/widgets/cta_carasoul.dart`
  (carousel banners) and
  `lib/features/dashboard/presentation/widgets/inline_banner.dart`
  (inline banners)
- Same `scheme://path` convention already used for push-notification
  deep-links (`lib/core/services/notification_router.dart`) — `type: "premium"`,
  `type: "one-on-one"`, etc. — kept consistent so the two systems don't
  diverge.
