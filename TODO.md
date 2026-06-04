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

* [ ] Primary logo
* [ ] Monochrome logo
* [ ] Horizontal logo
* [ ] Symbol only logo
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

* [ ] Android launcher icon
* [ ] iOS launcher icon
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

* [ ] Happy
* [ ] Calm
* [ ] Thinking
* [ ] Concerned
* [ ] Success

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

* [ ] Onboarding 1
* [ ] Onboarding 2
* [ ] Onboarding 3
* [ ] Empty Transaction
* [ ] Empty Savings
* [ ] OCR Scanner
* [ ] Goal Success
* [ ] Monthly Insight

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
* [ ] Configure lint
* [ ] Configure analysis options
* [ ] Configure folder structure
* [ ] Setup Riverpod
* [ ] Setup Go Router
* [ ] Setup Drift
* [ ] Setup build_runner

---

## Core Theme

* [ ] Color system
* [ ] Typography
* [ ] Radius system
* [ ] Spacing system
* [ ] Shadow system
* [ ] Light theme
* [ ] Dark theme placeholder

---

## Assets

* [ ] Import logo (backlog)
* [ ] Import launcher icon (backlog)
* [ ] Import mascot assets (backlog)
* [ ] Import illustration assets (backlog)
* [x] Import PNG icons assets

---

# Phase 2 — Database

## Drift

* [ ] Setup database
* [ ] Setup migrations
* [ ] Setup repositories

---

## Tables

* [ ] Users
* [ ] Wallets
* [ ] Categories
* [ ] Transactions
* [ ] Savings Goals
* [ ] Savings Contributions
* [ ] Receipt Scans
* [ ] Monthly Snapshots
* [ ] App Settings

---

## Seed Data

* [ ] Default wallet
* [ ] Default categories
* [ ] Default settings

---

# Phase 3 — Onboarding

## UI

* [ ] Slide 1
* [ ] Slide 2
* [ ] Slide 3

---

## Logic

* [ ] Save onboarding state
* [ ] Skip onboarding
* [ ] Complete onboarding

---

# Phase 4 — Dashboard

## Header

* [ ] Greeting
* [ ] Avatar
* [ ] Mascot state

---

## Balance Card

* [ ] Balance UI
* [ ] Animated counter
* [ ] Dynamic state

---

## Quick Actions

* [ ] Add income
* [ ] Add expense
* [ ] Scan receipt

---

## Recent Transactions

* [ ] List
* [ ] Empty state

---

# Phase 5 — Transaction

## Income

* [ ] Add income
* [ ] Save income
* [ ] Update wallet

---

## Expense

* [ ] Add expense
* [ ] Save expense
* [ ] Update wallet

---

## Shared

* [ ] Category picker
* [ ] Wallet picker
* [ ] Note field
* [ ] Date picker

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
