# Lord of the Rings Characters — CAP Node.js App

A minimal SAP CAP (Cloud Application Programming Model) Node.js service for browsing and managing Lord of the Rings characters.

## Structure

```
lotr-chars/
├── db/
│   ├── schema.cds           # Domain model: Characters & Weapons
│   └── data/
│       ├── lotr-Characters.csv
│       └── lotr-Weapons.csv
├── srv/
│   ├── lotr-service.cds     # OData service definition
│   └── lotr-service.js      # Custom handler (race validation)
└── package.json
```

## Getting Started

```bash
npm install
npm run dev          # starts cds watch with live reload
```

## Endpoints (running on http://localhost:4004)

| Path | Description |
|------|-------------|
| `/lotr/Characters` | All characters (CRUD) |
| `/lotr/Characters?$filter=fellowship eq true` | Fellowship members |
| `/lotr/FellowshipMembers` | Read-only Fellowship view |
| `/lotr/Weapons` | All weapons (CRUD) |
| `/$metadata` | OData metadata document |
