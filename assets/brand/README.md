# 6060live brand kit

Goal: premium, calm, internet-native identity for a minimalist meditation timer. No spiritual cliches, clean geometry, high contrast.

## Display name (iOS)
- Preferred: `6060live` (full brand, memorable, still short)
- Fallback if truncation happens: `6060`

## Color palette
Primary accent (mint): `#2CF1B0`

Dark-first theme:
- Background: `#0B0F0E`
- Surface: `#111615`
- Text: `#F5F7F6`
- Muted text: `#6F7C78`

Light theme:
- Background: `#F6F5F2`
- Surface: `#FFFFFF`
- Text: `#1B1F1E`
- Muted text: `#7A8683`

## Typography (Google Fonts)
Pairing 1 (used in SVGs):
- Primary sans: Space Grotesk (600-700)
- Tech accent: IBM Plex Mono (500-600)

Pairing 2 (alternative):
- Primary sans: Sora (600-700)
- Tech accent: JetBrains Mono (500-600)

## Spacing + corner radius
- 8pt grid: 8, 16, 24, 32, 48, 64
- Button radius: 20-24
- Card radius: 28-32
- Chips/toggles: 12-16
- Icon safe area: keep key shapes inside 80-84% of the square

## Theme guidance
- Dark-first UI with mint accent and off-white text.
- Light theme uses the same mint accent and charcoal text for continuity.
- Keep gradients minimal; prefer flat fills with subtle contrast shifts.

## Concepts (4 options)

### Option A: 60|60 monogram
Two stacked 60 pairs with a clean divider. The inner bars in the left rings hint the 6.

Assets:
- Icons: `assets/brand/icons/icon-option-a-dark-1024.png`, `assets/brand/icons/icon-option-a-light-1024.png`
- Mark: `assets/brand/logos/option-a-mark.svg`
- Wordmark (horizontal): `assets/brand/logos/option-a-wordmark-horizontal.svg`
- Wordmark (stacked): `assets/brand/logos/option-a-wordmark-stacked.svg`
- Usage mock: `assets/brand/mocks/option-a-usage.svg`

### Option B: 6060 loop (infinity)
Two continuous loops suggest continuity and streaks.

Assets:
- Icons: `assets/brand/icons/icon-option-b-dark-1024.png`, `assets/brand/icons/icon-option-b-light-1024.png`
- Mark: `assets/brand/logos/option-b-mark.svg`
- Wordmark (horizontal): `assets/brand/logos/option-b-wordmark-horizontal.svg`
- Wordmark (stacked): `assets/brand/logos/option-b-wordmark-stacked.svg`
- Usage mock: `assets/brand/mocks/option-b-usage.svg`

### Option C: 60x60 micro-typography
A bold typographic treatment of 60x60 with a geometric x mark.

Assets:
- Icons: `assets/brand/icons/icon-option-c-dark-1024.png`, `assets/brand/icons/icon-option-c-light-1024.png`
- Mark: `assets/brand/logos/option-c-mark.svg`
- Wordmark (horizontal): `assets/brand/logos/option-c-wordmark-horizontal.svg`
- Wordmark (stacked): `assets/brand/logos/option-c-wordmark-stacked.svg`
- Usage mock: `assets/brand/mocks/option-c-usage.svg`

### Option D: pause / silence
A single loop with two quiet bars implies stillness without meditation cliches.

Assets:
- Icons: `assets/brand/icons/icon-option-d-dark-1024.png`, `assets/brand/icons/icon-option-d-light-1024.png`
- Mark: `assets/brand/logos/option-d-mark.svg`
- Wordmark (horizontal): `assets/brand/logos/option-d-wordmark-horizontal.svg`
- Wordmark (stacked): `assets/brand/logos/option-d-wordmark-stacked.svg`
- Usage mock: `assets/brand/mocks/option-d-usage.svg`

## Recommendation
Option B is the cleanest and most memorable. The loop reads as 6060 while feeling calm and modern.

## Optional: iOS export sizes
These icons are 1024x1024 PNGs. To generate additional sizes, use any image tool. Example:

```bash
sips -Z 180 assets/brand/icons/icon-option-b-dark-1024.png --out /tmp/icon-180.png
```

## Regeneration
If you want to tweak colors or geometry, regenerate icons via:

```bash
python3 tools/brand/gen_brand_assets.py
```
