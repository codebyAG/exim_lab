# Frontend Handoff — Premium Features & One-on-One Classes

Two new admin-editable content pages, plus supporting notification/analytics/CTA wiring. This document is split into **3 phases**. Each phase has a **STOP gate** — do not start the next phase until the current one is built, tested, and reported back. At each gate, also re-test everything from prior phases (not just the new work), to catch regressions.

---

## Shared context

- Both pages are pure **content-driven marketing/landing pages**. The backend already stores and serves all text/image/video content via admin-editable APIs — you are only building the rendering layer + a handful of behaviors (deep-links, analytics, WhatsApp CTA, video fallback).
- **Color theme**: white background, black/dark text for readability, use the app's existing accent/brand color for highlights, buttons, and section headings. Not a heavy dark/black theme. You have creative liberty on exact spacing, typography, and component styling — the reference images (shared separately, attach alongside this file) show target content structure and mood, not pixel-exact specs.
- **No payment gateway exists yet.** Every CTA button on both pages opens WhatsApp — that is the only purchase/booking action for now. Do not build or stub any in-app payment flow.
- Auth: `GET` endpoints below require a logged-in user's Bearer token (any authenticated user, not admin-only).

---

# Phase 1 — Static content pages

## 1A. Premium Features page

`GET /api/premium-features/config` →

```json
{
  "success": true,
  "data": {
    "heading": "string", "subheading": "string",
    "ctaText": "string", "ctaWhatsappNumber": "string", "ctaWhatsappMessage": "string",
    "bannerImageUrl": "string", "bannerText": "string",
    "introVideo": { "videoUrl": "string", "thumbnailUrl": "string", "title": "string" },
    "gridColumns": 2,
    "featuresHeading": "string", "instructorsHeading": "string",
    "videosHeading": "string", "testimonialsHeading": "string",
    "features": [{ "id": "", "icon": "", "imageUrl": "", "title": "", "description": "", "order": 1 }],
    "stats": [{ "id": "", "icon": "", "value": "", "label": "", "order": 1 }],
    "videos": [{ "id": "", "videoUrl": "", "thumbnailUrl": "", "duration": "", "title": "", "order": 1 }],
    "testimonials": [{ "id": "", "rating": 5, "quote": "", "name": "", "avatarUrl": "", "order": 1 }],
    "instructors": [{ "id": "", "videoUrl": "", "thumbnailUrl": "", "name": "", "order": 1 }],
    "banners": [{ "id": "", "imageUrl": "", "text": "", "linkUrl": "", "position": "after_hero", "order": 1 }],
    "pricing": {
      "heading": "", "description": "", "benefits": ["string"],
      "offerBadgeText": "", "originalPrice": "", "discountedPrice": "", "priceNote": ""
    }
  }
}
```

All arrays are already **filtered to active items and pre-sorted by `order`** — render as-given, no client-side sorting/filtering needed. Any array can be empty — hide that section entirely when empty (don't show a heading with nothing under it).

**Fixed section order** (not admin-reorderable — build these as fixed zones):

1. Hero — `heading`, `subheading`
2. Hero visual — show `introVideo.thumbnailUrl` if set, else `bannerImageUrl`. If `introVideo.videoUrl` is set, make the image tappable to play it in-app (see Phase 3 video-fallback spec — but basic playback works now). `bannerText` is an optional overlay caption.
3. *(optional banner slot: `banners` where `position === "after_hero"`)*
4. Stats row — `stats[]`, icon + value + label per item
5. *(optional banner slot: `position === "after_stats"`)*
6. Feature grid — heading = `featuresHeading`, items = `features[]`, laid out `gridColumns` per row (2, 3, or 4)
7. *(optional banner slot: `position === "after_features"`)*
8. "Meet Your Teachers" — heading = `instructorsHeading`, items = `instructors[]`, each a **9:16 portrait** video card (thumbnail + tap-to-play + name below), rendered as a horizontally scrollable row (dynamic count, typically 2-4)
9. Videos — heading = `videosHeading`, items = `videos[]`. First item renders large/featured; remaining items in a 2-column grid. Each shows `duration` badge if present.
10. *(optional banner slot: `position === "after_videos"`)*
11. Testimonials — heading = `testimonialsHeading`, items = `testimonials[]` (star rating, quote, name, avatar)
12. *(optional banner slot: `position === "after_testimonials"`)*
13. Pricing/CTA (always last) — `pricing.*` fields, `originalPrice` struck through next to `discountedPrice`, `benefits[]` as a checklist, `offerBadgeText` as a small badge, main button uses `ctaText` as its label (wiring the WhatsApp action is Phase 3 — in this phase the button can just render, non-functional).

**Banner slots**: for each of the 5 named positions, filter `banners` where `position` matches, sort by `order` (already sorted), render all matches (usually 0 or 1, but support multiple). Each banner: `imageUrl` (required), optional `text` overlay, optional `linkUrl` (tap-through — Phase 1 can leave this inert).

## 1B. One-on-One Classes page

`GET /api/one-on-one/config` →

```json
{
  "success": true,
  "data": {
    "heading": "string", "subheading": "string",
    "heroVideo": { "videoUrl": "string", "thumbnailUrl": "string", "ctaText": "string" },
    "benefits": [{ "id": "", "icon": "", "title": "", "description": "", "order": 1 }],
    "journeySteps": [{ "id": "", "icon": "", "title": "", "description": "", "order": 1 }],
    "uniquePoints": [{ "id": "", "icon": "", "title": "", "description": "", "order": 1 }],
    "highlightBanner": {
      "heading": "", "subheading": "",
      "items": [{ "id": "", "icon": "", "label": "", "order": 1 }]
    },
    "experienceVideos": [{ "id": "", "videoUrl": "", "thumbnailUrl": "", "duration": "", "title": "", "order": 1 }],
    "trustBadges": [{ "id": "", "icon": "", "label": "", "order": 1 }],
    "pricing": {
      "heading": "", "description": "", "originalPrice": "", "discountedPrice": "", "priceNote": "",
      "ctaText": "", "ctaWhatsappNumber": "", "ctaWhatsappMessage": "",
      "slotsLeft": 0, "urgencyText": "", "disclaimerText": ""
    }
  }
}
```

**Fixed section order**:

1. Hero — `heading`, `subheading`
2. Hero video — `heroVideo.thumbnailUrl`, tappable to play `heroVideo.videoUrl` if set; `heroVideo.ctaText` is a "Watch" button label below/over it
3. "What You Get" — `benefits[]` (icon + title, no description shown per the reference design — but render `description` if present, small/optional)
4. "Your Journey" — `journeySteps[]`, rendered as **numbered** steps (1, 2, 3…) with title + description
5. "Why 1-on-1 Is Unique" — `uniquePoints[]`, grid of icon + title (+ optional description)
6. Highlight banner — `highlightBanner.heading`/`subheading` + `items[]` (icon + label, small row of 3ish), styled as a colored callout card (no image — solid/gradient background)
7. "Real Experiences" — `experienceVideos[]`, same first-big-then-grid layout as Premium's Videos section
8. Trust badges — `trustBadges[]`, small icon+label row, typically shown near the footer
9. Pricing/Booking card (always last):
   - `pricing.heading`, `pricing.description`
   - `pricing.discountedPrice` prominent, `pricing.originalPrice` struck through next to it
   - `pricing.priceNote` (e.g. "Launch Price")
   - Main button uses `pricing.ctaText` as its label (WhatsApp wiring is Phase 3)
   - **Urgency line**: if `pricing.urgencyText` is set, show it near the CTA in bold/eye-catching style (e.g. "🔥 Only 7 seats left today!"). If empty but `pricing.slotsLeft > 0`, you may synthesize a simple fallback like `"Only {slotsLeft} seats left"` — optional, `urgencyText` should be preferred when present.
   - **Disclaimer**: if `pricing.disclaimerText` is set, show it in small, muted/low-emphasis text below the CTA — deliberately not competing visually with the urgency line or CTA button (this discloses the real course price upfront in fine print; do not make it prominent).

## Phase 1 STOP gate

Before moving to Phase 2:
- [ ] Both pages render every section correctly, in the fixed order above
- [ ] Empty sections (no items in an array) are hidden gracefully — no broken/empty headings
- [ ] Loading state and error/failed-fetch state are both handled (no crash, no blank white screen)
- [ ] Test by changing content in the admin dashboard (`/app/premium-features`, `/app/one-on-one`) and confirming the app reflects it after a refresh/pull-to-refresh
- [ ] Report back with screenshots/screen recording before starting Phase 2

---

# Phase 2 — Notification tap handling

The admin dashboard can send a push notification with an optional **redirect target**: None, Premium, or One-on-One (in addition to the pre-existing News redirect). The `data` payload on the received notification looks like:

```json
{ "title": "string", "body": "string", "type": "news" }
{ "title": "string", "body": "string", "type": "news", "newsId": "string" }
{ "title": "string", "body": "string", "type": "premium" }
{ "title": "string", "body": "string", "type": "one-on-one" }
```

(`type: "news"`/`newsId` is the pre-existing convention — confirm it still works, don't rebuild it.)

**Add handling for `type: "premium"`** → navigate to the Premium Features page (Phase 1A).
**Add handling for `type: "one-on-one"`** → navigate to the One-on-One Classes page (Phase 1B).

This must work in all 3 states a push notification can be received/tapped in:
1. App in foreground, notification tapped
2. App in background, tapped (`onNotificationOpenedApp` or platform equivalent)
3. App fully killed, opened via the notification (`getInitialNotification`/cold-start equivalent)

There is **no `linkUrl`** in the actual push payload — only `data.type` (and `data.newsId` for news). A `linkUrl` field does exist but only inside the in-app notification list (`GET /api/notifications` — if your app has a notification inbox screen, apply the same `data.type` check there too).

## Phase 2 STOP gate

Before moving to Phase 3:
- [ ] From the admin dashboard, send a test notification with each of the 3 redirect options (None / Premium / 1-on-1) to a real device
- [ ] Confirm correct navigation in all 3 app states (foreground / background / killed) for both Premium and One-on-One
- [ ] Confirm the pre-existing News redirect still works (regression check)
- [ ] Regression-check Phase 1 — both pages still render correctly, nothing broke
- [ ] Report back before starting Phase 3

---

# Phase 3 — Analytics logging, WhatsApp CTA, video fallback

## 3A. Analytics event logging

Call the existing endpoint `POST /api/analytics/log-event` (Bearer auth required) with body:

```json
{ "event_name": "premium_page_view" }
```

**Exact event names and when to fire them** (this is the full list — no others needed):

| Event name | Fires when |
|---|---|
| `premium_page_view` | Premium Features page is opened (once per open, not per re-render) |
| `premium_cta_click` | The main CTA button on the Premium page is tapped |
| `one_on_one_page_view` | One-on-One page is opened |
| `one_on_one_cta_click` | The main CTA button on the One-on-One page is tapped |

No response handling needed beyond normal error tolerance (don't block the UI on this call; fire-and-forget is fine).

## 3B. WhatsApp CTA

Both pages' main CTA button — when the config's `ctaWhatsappNumber` (Premium: top-level; One-on-One: `pricing.ctaWhatsappNumber`) is non-empty — should open:

```
https://wa.me/{ctaWhatsappNumber}?text={encodeURIComponent(ctaWhatsappMessage)}
```

using your platform's standard external-link opener (e.g. `Linking.openURL` in React Native). This is the **only** CTA action for now — no in-app payment/booking flow to build. If `ctaWhatsappNumber` is empty, the button can simply do nothing (or show a "coming soon" state) — don't crash.

Also fire the corresponding `*_cta_click` analytics event (3A) right before/alongside opening WhatsApp.

## 3C. Video playback with YouTube fallback

Every `videoUrl` field on both pages is a YouTube link. Requirements:
- Play in-app by default (native/webview YouTube player).
- **On playback error** (video fails to load/play), show the user a clear prompt — e.g. "This video couldn't be played here — tap to watch on YouTube" — and on tap, open the same URL in the YouTube app/browser externally as a fallback.
- This applies to every video slot: Premium's `introVideo`, `videos[]`, `instructors[]`; One-on-One's `heroVideo`, `experienceVideos[]`.

## Phase 3 STOP gate

- [ ] Interact with both pages a few times (open pages, tap CTAs), then confirm the counts appear correctly on the admin dashboard's engagement stat cards (`/app/premium-features` and `/app/one-on-one`, top of page: Views / Unique Viewers / CTA Clicks / Unique Clickers)
- [ ] Confirm WhatsApp opens correctly with the pre-filled message on both Android and iOS
- [ ] Force a video playback error (e.g. temporarily use an invalid video ID) and confirm the fallback prompt appears and correctly opens YouTube
- [ ] Regression-check Phases 1 + 2 together — pages still render, notifications still deep-link correctly
- [ ] Done — report back for final review

---

## Known open items (not blocking, flag if relevant)

- `ctaWhatsappNumber`/`ctaWhatsappMessage` on both pages currently hold **placeholder test values** in the live database — the client will update these to real values before launch; don't hardcode or assume the current values are final.
- `pricing.slotsLeft`/`urgencyText` (One-on-One) are fully **admin-manual** display fields, not a real seat-inventory system — no backend logic decrements them automatically.
