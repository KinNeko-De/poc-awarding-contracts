# POC Awarding Contracts

A proof-of-concept application that helps freelance software engineers find
matching public German government IT contracts based on their skill profile.

## Overview

```
Freelancer pastes Markdown CV
        ↓
Flutter Web UI (localhost:3000)
        ↓  POST /api/match
Go Backend (localhost:8080)
        ↓
Keyword extraction (regex) + Scoring (intersection / required × 100)
        ↓
Ranked list of matching contracts returned to UI
```

**What is simulated in this POC**
- _AI matching_ — replaced by keyword intersection scoring
- _Contract data_ — 10 hardcoded mock German public IT contracts embedded in the binary
- _Profile parsing_ — regex scan against a seeded IT-keyword list
- _No database, no authentication, no scraping_

---

## Prerequisites

| Tool | Install |
|------|---------|
| Go ≥ 1.22 | https://go.dev/dl/ |
| Flutter ≥ 3.22 | https://docs.flutter.dev/get-started/install |

---

## Running locally

### 1 — Backend (Go)

```bash
cd backend
go run ./cmd/server
# Listening on http://localhost:8080
```

### 2 — Frontend (Flutter Web)

_First run only — fetch dependencies:_

```bash
cd frontend
flutter pub get
```

_Start the dev server:_

```bash
flutter run -d chrome --web-port 3000
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

---

## API

### `POST /api/match`

**Request**
```json
{ "profile_text": "# My Profile\n\n- Go\n- Docker\n- Kubernetes" }
```

**Response**
```json
{
  "profile": {
    "extracted_skills": ["Go", "Docker", "Kubernetes"]
  },
  "matches": [
    {
      "contract": {
        "id": "contract-008",
        "title": "Go Microservices Platform",
        "authority": "Registermodernisierung – BMI",
        "location": "Berlin",
        "remote_possible": true,
        "required_skills": ["Go", "gRPC", "Docker", "Kubernetes", "Microservices", "REST API", "Linux"],
        "deadline": "2026-05-31",
        "estimated_value": "€ 250,000",
        "duration": "24 months"
      },
      "score": 42.86,
      "matching_skills": ["Go", "Docker", "Kubernetes"]
    }
  ]
}
```

---

## Project structure

```
poc-awarding-contracts/
├── backend/
│   ├── cmd/server/main.go          ← Entry point, chi router, CORS
│   ├── internal/
│   │   ├── handlers/match.go       ← POST /api/match handler
│   │   ├── matcher/matcher.go      ← Scoring + sorting logic
│   │   ├── models/                 ← Profile, Contract, MatchResult
│   │   ├── parser/markdown.go      ← Keyword extraction (regex)
│   │   └── store/                  ← Embedded contracts.json
│   ├── data/contracts.json         ← Source of truth (copied into store/)
│   └── go.mod
└── frontend/
    ├── lib/
    │   ├── main.dart               ← App entry, MaterialApp theme
    │   ├── data/sample_cvs.dart    ← 3 hardcoded sample CV texts
    │   ├── models/                 ← Dart mirrors of Go models
    │   ├── screens/
    │   │   ├── profile_screen.dart ← CV input + sample dropdown
    │   │   └── results_screen.dart ← Ranked contract cards
    │   └── services/api_service.dart
    └── pubspec.yaml
```

---

## Sample CVs (built-in)

Use the **"Load sample"** dropdown on the profile screen to try one of three
pre-built profiles:

| Sample | Purpose | Expected result |
|--------|---------|----------------|
| CV 1 — Go Backend Engineer | Tests strong match | Contract #8 (Go Microservices Platform) ranked #1 |
| CV 2 — Flutter Mobile Developer | Tests different match | Contract #6 (Mobile App) ranked #1 |
| CV 3 — Office Administrator | Tests no-match state | Empty results list |

---

## Next steps (beyond POC)

- Replace regex keyword extraction with an LLM call (e.g. GPT-4o)
- Scrape real contracts from DTVP / evergabe.de and store in PostgreSQL
- Add user accounts and saved searches
- German-language UI (i18n)
- Deploy backend to a cloud provider, host frontend on Vercel / Netlify
