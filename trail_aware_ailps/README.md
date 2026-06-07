# TrailAware AIlps

AI-powered trail hazard reporting app built for the **EUSALP Alpine AI-Hackathon 2026 — Destination Resilience** challenge.

## What it does

Hikers and mountain bikers can report trail hazards (rockfalls, landslides, fallen trees, flooding, bridge damage) directly from their phone camera. Claude Vision AI classifies the hazard, assigns a priority (high / medium / low), and geo-routes the report to the responsible Alpine authority. Authorities receive a structured dashboard and are notified immediately. Closed trail data is published via an open API so apps like Komoot can reroute users automatically.

## Tech stack

- **Flutter** (iOS-first, also Android)
- **Claude Vision API** — hazard classification from camera frames
- **flutter_map + OpenStreetMap** — live map with hazard pins
- **Riverpod** — state management
- **go_router** — navigation

## Design system

Alpine Modernism — glassmorphism surfaces, deep forest green palette (`#012d1d`), SF Pro typography, staggered entrance animations. Reference designs in `stitch_ui_drafts/v2/`.

## Running the app

```bash
cd trail_aware_ailps
flutter pub get
flutter run          # simulator (uses mock camera + mock AI result)
```

For real AI classification on a physical device, add your key to `.env`:

```
CLAUDE_API_KEY=your-key-here
```

> `.env` is gitignored — never commit it.
