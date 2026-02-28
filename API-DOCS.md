# SIMPLAN API

Base URL: `http://localhost:8080` (set `VITE_API_BASE_URL` in frontend `.env`)

---

## Endpoints

### Health
```
GET /api/health
```
Returns `{ "status": "ok" }`

---

### Login
```
POST /api/auth/login
```
Body: `{ "email": "...", "password": "..." }`

Success: `{ "success": true, "user": { "id", "email", "name" }, "token": "..." }`  
Error: `{ "error": "Invalid email or password" }`

Store the token. Send it on protected requests: `Authorization: Bearer <token>`

---

### Proposals List
```
GET /api/proposals
```
Requires: `Authorization: Bearer <token>`

Query params:
- `status` – all, needs_review, straightforward
- `sortBy` – referenceId, district, use, urban, financial, displacement, status
- `sortOrder` – asc, desc
- `search` – filter by reference ID or district name

Response:
```json
{
  "proposals": [
    {
      "id": "SP 22 10",
      "referenceId": "SP 22 10",
      "applicantDistrict": "Malton / Northeast",
      "district": "Malton / Northeast",
      "use": "General Retail Commercial",
      "date": "2022-01-19",
      "urban": 60,
      "urbanDisplay": "60/100",
      "financial": "Moderate",
      "displacement": "High",
      "status": "Review"
    }
  ],
  "counts": {
    "total": 209,
    "needsReview": 85,
    "straightforward": 124
  }
}
```

---

### Single Proposal (Review Panel)
```
GET /api/proposals/:id
```
Requires: `Authorization: Bearer <token>`
Use encoded ID in URL, e.g. `SP%2022%2010` for "SP 22 10"

Response:
```json
{
  "proposal": { "id", "referenceId", "district", "use", "date", "urban", "financial", "displacement", "status" },
  "topRiskDrivers": ["Zoning Non-Compliance", "Traffic Congestion Index", "Water Main Capacity"],
  "dataSourcesUsed": ["CITY GIS", "STATSCAN 2026", "TRAFFIC API", "ZONING BYLAW 2022-04"]
}
```
topRiskDrivers and dataSourcesUsed are placeholders for now.

---

### Dashboard Metadata
```
GET /api/dashboard
```
Requires: `Authorization: Bearer <token>`
Returns:
```json
{
  "simulationModel": "Mississauga",
  "version": "v1.2",
  "lastUpdated": "2026-01-15",
  "datasetName": "Mississauga Dev Apps",
  "recordCount": 209,
  "simulationStatus": "Live Simulation"
}
```

---

## Field Reference

| Table Column        | API Field         | Values                          |
|---------------------|-------------------|---------------------------------|
| REFERENCE ID        | referenceId       | string                          |
| APPLICANT / DISTRICT| applicantDistrict | string (district only for now)  |
| USE                 | use               | string                          |
| URBAN               | urban             | number 0-100                    |
| URBAN display       | urbanDisplay      | "60/100"                        |
| FINANCIAL           | financial         | Low, Moderate, High             |
| DISPLACEMENT        | displacement      | Low, Moderate, High             |
| STATUS              | status            | Review, Clear to Proceed        |
| Date                | date              | YYYY-MM-DD                      |

Badge colours: Low = green, Moderate = orange, High = red. Status: Clear to Proceed = green, Review = red.

---

## Frontend Usage

Set `VITE_API_BASE_URL=http://localhost:8080/api`

After login, store the token and add it to requests:
```javascript
axios.defaults.headers.common["Authorization"] = `Bearer ${token}`;
```
Or pass headers per request.

- `fetchUpdate("proposals", setProposals)` – proposals list (needs token)
- `fetchUpdate("proposals/SP%2022%2010", setProposal)` – single proposal
- `fetchUpdate("dashboard", setDashboard)` – metadata
- `postUpdate("auth/login", { email, password })` – login

QueueCards: use `counts.total`, `counts.needsReview`, `counts.straightforward` from the proposals response.

---

## Table Data Transform

If your Table expects column headers like "REFERENCE ID", map the API response:

```javascript
const rows = proposals.map(p => ({
  id: p.id,
  "REFERENCE ID": p.referenceId,
  "APPLICANT / DISTRICT": p.district,
  "USE": p.use,
  "URBAN": p.urbanDisplay,
  "FINANCIAL": p.financial,
  "DISPLACEMENT": p.displacement,
  "STATUS": p.status
}));
```
