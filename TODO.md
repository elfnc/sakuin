# TODO.md

# Sakuin MVP Roadmap

Status Legend

```txt
[ ] Not Started
[/] In Progress
[x] Completed
```

---

# Phase 0 — Brand Foundation

## Brand Identity

* [ ] Finalisasi nama brand
* [ ] Finalisasi tagline
* [ ] Finalisasi color palette
* [ ] Finalisasi typography
* [ ] Finalisasi mascot direction
* [ ] Finalisasi icon style
* [ ] Finalisasi motion style

---

# Brand Rules

## Brand Structure

```txt
Brand Name
Sakuin

Logo
S Wallet

Mascot
Momo
```

Rules:

* Logo bukan mascot
* Mascot bukan logo
* App icon berasal dari logo
* Semua ilustrasi menggunakan mascot Momo

---

# Logo System

## Logo Direction

```txt
Dompet rounded minimal dengan senyum kecil
```

---

## Logo Checklist

* [x] Primary logo
* [x] Monochrome logo
* [x] Horizontal logo
* [x] Symbol only logo
* [ ] Dark version
* [ ] Light version

---

## Master Brand Prompt

```txt
Create a modern vector brand identity for "Sakuin".

The brand symbol is a friendly rounded wallet character subtly forming the letter S.

Style:
- minimal
- clean
- memorable
- app-first
- playful but mature
- finance companion, not fintech corporate

Visual traits:
- rounded geometry
- soft corners
- highly recognizable silhouette
- no excessive details

Color palette:
- Coral #F38181
- Mint #95E1D3
- Soft Yellow #FCE38A
- Off White #FFFDF8

Avoid:
- bank logos
- fintech corporate style
- gradients
- 3D renders
- complex mascots

Output:
- primary logo
- monochrome logo
- app icon version
- vector flat design
```

---

# App Icon

Rules:

```txt
Logo
↓
Symbol Only
↓
Launcher Icon
```

Checklist:

* [x] Android launcher icon
* [x] iOS launcher icon
* [ ] Adaptive icon background
* [ ] Adaptive icon foreground

---

# Mascot System

## Mascot Name

```txt
Momo
```

---

## Mascot Checklist

* [x] Happy
* [x] Calm
* [x] Thinking
* [x] Concerned
* [x] Success

---

## Mascot Prompt

### Happy

```txt
Cute wallet mascot named Momo, happy expression, holding gold coin, clean vector illustration, rounded shapes, playful finance companion
```

### Calm

```txt
Cute wallet mascot named Momo, calm expression, sitting beside coins, clean vector illustration
```

### Thinking

```txt
Cute wallet mascot named Momo, thinking expression, looking at receipt, clean vector illustration
```

### Concerned

```txt
Cute wallet mascot named Momo, concerned but friendly expression, looking at spending summary, clean vector illustration
```

### Success

```txt
Cute wallet mascot named Momo, celebrating savings goal, holding trophy and coins, clean vector illustration
```

---

# Illustration Assets

## Checklist

* [x] Onboarding 1
* [x] Onboarding 2
* [x] Onboarding 3
* [x] Empty Transaction
* [x] Empty Savings
* [x] OCR Scanner
* [x] Goal Success
* [x] Monthly Insight

---

## Onboarding 1

```txt
Momo with floating coins and wallet, onboarding finance illustration
```

## Onboarding 2

```txt
Momo scanning receipt using smartphone camera, OCR illustration
```

## Onboarding 3

```txt
Momo sitting beside piggy bank and savings goal illustration
```

## Empty Transaction

```txt
Momo sleeping beside empty notebook
```

## OCR

```txt
Momo holding receipt and magnifying glass
```

## Savings

```txt
Momo carrying coins into piggy bank
```

## Insight

```txt
Momo analyzing spending chart
```

---

# Phase 1 — Foundation

## Flutter Setup

* [x] Create Flutter project
* [x] Configure lint
* [x] Configure analysis options
* [x] Configure folder structure
* [x] Setup Riverpod
* [x] Setup Go Router
* [x] Setup Drift
* [x] Setup build_runner

---

## Core Theme

* [x] Color system
* [x] Typography
* [x] Radius system
* [x] Spacing system
* [x] Shadow system
* [x] Light theme
* [x] Dark theme placeholder

---

## Assets

* [x] Import logo (backlog)
* [x] Import launcher icon (backlog)
* [x] Import mascot assets (backlog)
* [x] Import illustration assets (backlog)
* [x] Import PNG icons assets

---

# Phase 2 — Database

## Drift

* [x] Setup database
* [x] Setup migrations
* [x] Setup repositories

---

## Tables

* [x] Drift setup
* [x] `Wallets` table
* [x] `Categories` table
* [x] `Transactions` table
* [x] `SavingsGoals` table
* [x] `SavingsContributions` table
* [x] `ReceiptScans` table
* [x] `MonthlySnapshots` table
* [x] `AppSettings` table
* [x] Seed initial data (default wallet, category)
* [x] Default categories
* [x] Default settings

---

# Phase 3 — Onboarding

## UI

* [x] UI implementation (3 slides)
* [x] Mascot illustration (placeholder)
* [x] Logic (save onboarding state to `AppSettings`)
* [x] Skip onboarding
* [x] Complete onboarding

---

# Phase 4 — Navigation & Dashboard

## App Navigation

* [x] Bottom Navigation Bar
* [x] Floating Quick Action (FAB)
* [x] Routing implementation

---

## Dashboard Header

* [x] Greeting
* [x] Avatar
* [x] Mascot state

---

## Balance Card

* [x] Balance UI
* [x] Animated counter
* [x] Dynamic state

---

## Dashboard Quick Actions Card

* [x] Income shortcut
* [x] Expense shortcut
* [x] OCR shortcut

---

## Recent Transactions

* [x] List
* [x] Empty state

---

# Phase 5 — Transaction

## Income

* [x] Add income
* [x] Save income
* [x] Update wallet

---

## Expense

* [x] Add expense
* [x] Save expense
* [x] Update wallet

---

## Shared

* [x] Category picker
* [x] Wallet picker
* [x] Note field
* [x] Date picker

---

# Phase 6 — Transaction History

## History

* [ ] Search
* [ ] Filters
* [ ] Pagination

---

## Filters

* [ ] Today
* [ ] Week
* [ ] Month
* [ ] Income
* [ ] Expense
* [ ] Savings

---

# Phase 7 — Savings Goal

## Goal

* [ ] Create goal
* [ ] Update goal
* [ ] Complete goal
* [ ] Archive goal

---

## Contribution

* [ ] Add contribution
* [ ] Progress update
* [ ] Goal validation

---

## Animation

* [ ] Progress fill
* [ ] Success state
* [ ] Celebration state

---

# Phase 8 — OCR

## OCR Engine

* [ ] Camera picker
* [ ] Gallery picker
* [ ] ML Kit setup

---

## OCR Parsing

* [ ] Parse amount
* [ ] Parse merchant
* [ ] Parse receipt date
* [ ] Confidence score

---

## OCR Review

* [ ] Bottom sheet
* [ ] Edit result
* [ ] Save transaction

---

# Phase 9 — Monthly Insight

## Summary

* [ ] Total income
* [ ] Total expense
* [ ] Total savings

---

## Charts

* [ ] Expense donut chart
* [ ] Weekly chart

---

## Insights

* [ ] Top category
* [ ] Monthly insight card

---

# Phase 10 — Motion

## Animation

* [ ] Page transition
* [ ] Card reveal
* [ ] Button interaction
* [ ] Success animation
* [ ] Savings animation
* [ ] OCR scan animation

---

# Phase 11 — Empty States

* [ ] Dashboard empty
* [ ] History empty
* [ ] Savings empty
* [ ] OCR empty
* [ ] Insight empty

---

# Phase 12 — Security

* [ ] App lock
* [ ] Biometric auth
* [ ] Secure storage

---

# Phase 13 — Testing

## Unit Test

* [ ] Currency formatter
* [ ] Receipt parser
* [ ] Transaction use case
* [ ] Savings use case

---

## Widget Test

* [ ] Dashboard card
* [ ] Transaction form
* [ ] Savings card

---

## Integration Test

* [ ] Add transaction flow
* [ ] OCR flow
* [ ] Savings flow

---

# Phase 14 — Release

## Android

* [ ] Launcher icon
* [ ] Splash screen
* [ ] Release build

---

## Store Assets

* [ ] Screenshots
* [ ] Feature graphic
* [ ] Description
* [ ] Privacy policy

---

# Future (V2)

* [ ] Cloud sync
* [ ] Multi-device sync
* [ ] Export PDF
* [ ] Export Excel
* [ ] Shared wallet
* [ ] Budget challenge
* [ ] Recurring transaction
* [ ] Home widget
* [ ] Dark mode
* [ ] Smart spending insight
