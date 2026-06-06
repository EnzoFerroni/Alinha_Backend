<div align="center">

# Alinha · Backend

### The Swift (Vapor) REST API that powers the [Alinha](https://github.com/EnzoFerroni/Alinha-Project) mentorship queue. 🗓️

The server-side half of **Alinha** — a full-stack mentorship queue system built by a
~30-person team. Students join the queue from **iOS**, mentors manage sessions on
**macOS**, and a **tvOS** display shows the live queue — all talking to this single
**Vapor** backend, backed by **PostgreSQL** and **APNs** push notifications.

<br/>

[![Swift](https://img.shields.io/badge/Swift_6-FA7343?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org)
[![Vapor](https://img.shields.io/badge/Vapor_4-0D0D0D?style=for-the-badge&logo=vapor&logoColor=white)](https://vapor.codes)
[![Fluent](https://img.shields.io/badge/Fluent_ORM-2B9348?style=for-the-badge&logo=swift&logoColor=white)](https://docs.vapor.codes/fluent/overview/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com)
[![License](https://img.shields.io/badge/License-MIT-3DA639?style=for-the-badge)](LICENSE)

**Part of the full project → [EnzoFerroni/Alinha-Project](https://github.com/EnzoFerroni/Alinha-Project) (backend + iOS · macOS · tvOS frontend together).**

</div>

---

## 📑 Table of Contents

- [About](#-about)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Environment Variables](#-environment-variables)
- [API Reference](#-api-reference)
  - [Users](#users)
  - [Appointments](#appointments)
- [Authentication & Roles](#-authentication--roles)
- [My Role](#-my-role)
- [Team](#-team)
- [License](#-license)

---

## ✨ About

**Alinha** records and manages mentorship appointments inside institutions (built in
the context of the **Apple Developer Academy | Mackenzie**). It coordinates three
roles — **admin**, **mentor** and **student** — around a live queue: a student
requests help, the request enters a queue, a mentor picks it up, and the whole flow is
tracked end to end.

This repository holds the **backend** only. For the full product — including the iOS,
macOS and tvOS clients — see the consolidated repo:
**[EnzoFerroni/Alinha-Project](https://github.com/EnzoFerroni/Alinha-Project)**.

---

## 🏗️ Architecture

A single Vapor backend exposes a REST API consumed by every platform client:

```
      iOS (student)        macOS (mentor)        tvOS (queue display)
           │                     │                       │
           └─────────────────────┼───────────────────────┘
                                 │  REST (JSON over HTTP)
                         ┌───────▼────────┐
                         │  Vapor backend │   Swift · Fluent ORM   ← this repo
                         └───────┬────────┘
                                 │
                   ┌─────────────┴─────────────┐
                   │  PostgreSQL        APNs    │
                   │  (data)            (push)  │
                   └────────────────────────────┘
```

**Class diagram (backend domain):**

<img width="100%" src="https://github.com/user-attachments/assets/196ca5de-320e-4cbd-aded-bc0693807afe" alt="Alinha class diagram"/>

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Language** | Swift 6 (`swift-tools-version:6.0`) |
| **Web framework** | [Vapor 4](https://vapor.codes) |
| **ORM** | [Fluent](https://docs.vapor.codes/fluent/overview/) + [`fluent-postgres-driver`](https://github.com/vapor/fluent-postgres-driver) |
| **Database** | PostgreSQL 16 |
| **Push** | [APNs](https://github.com/vapor/apns) (`VaporAPNS`) |
| **Networking** | [SwiftNIO](https://github.com/apple/swift-nio) |
| **Containers** | Docker · docker-compose |

---

## 📦 Project Structure

```
Alinha_Backend/
├── Sources/Challenge7_Backend/
│   ├── entrypoint.swift          # app bootstrap
│   ├── configure.swift           # DB, migrations, middleware wiring
│   ├── routes.swift              # route registration
│   ├── Controllers/              # UserController · AppointmentController
│   ├── Models/                   # User · Appointment (Fluent models)
│   ├── DTOs/                     # UserDTO · AppointmentDTO
│   ├── Migrations/               # UserMigration · CreateAppointment
│   ├── Middlewares/              # AdminOnlyMiddleware · AdmMentorMiddleware
│   └── Enum/                     # UserRole · TypeAppointment · PathAppointment
├── Tests/Challenge7_BackendTests/
├── Public/                       # static files
├── Dockerfile
├── docker-compose.yml            # Vapor app + PostgreSQL + migrate/revert
└── Package.swift
```

---

## 🚀 Getting Started

### Run with Docker (recommended)

Spins up the Vapor API **and** PostgreSQL together:

```bash
docker compose build          # build the app image
docker compose run migrate    # run database migrations
docker compose up app         # start the API on http://localhost:8080
```

Tear everything down (add `-v` to also wipe the database volume):

```bash
docker compose down
```

### Run locally with Swift

Requires Swift 6 and a running PostgreSQL instance:

```bash
swift run App migrate --yes   # apply migrations
swift run                     # start the server
```

Quick smoke test once it's up:

```bash
curl http://localhost:8080/        # → "It works!"
```

---

## 🔑 Environment Variables

Secrets are read from the environment — **nothing is hardcoded**. Copy the example
file and fill in your own values:

```bash
cp .env.example .env
```

| Variable | Required | Description |
|---|:---:|---|
| `DATABASE_HOST` / `DATABASE_PORT` | ⚪ | Postgres host/port (defaults to `localhost` / `5432`) |
| `DATABASE_NAME` / `DATABASE_USERNAME` / `DATABASE_PASSWORD` | ⚪ | Postgres credentials (dev defaults in `docker-compose.yml`) |
| `APNS_TOPIC` | 🔔 | App bundle id targeted by push notifications |
| `APNS_PRIVATE_KEY` | 🔔 | Contents of your APNs Auth Key `.p8` (only to enable push) |
| `APNS_KEY_ID` | 🔔 | 10-char Key ID of that key |
| `APNS_TEAM_ID` | 🔔 | Your 10-char Apple Team ID |

> Push notifications are **optional** — if the `APNS_*` variables aren't set, the app
> runs with APNs disabled. **Never commit your `.p8` or these values.**

---

## 🔌 API Reference

Base URL: `http://localhost:8080`. All bodies are JSON. Roles: `adm` · `mentor` · `student`.

### Users

| Method | Path | Auth | Description |
|---|---|:---:|---|
| `GET` | `/users` | — | List all users |
| `GET` | `/users/:id` | — | Fetch one user by id |
| `POST` | `/users` | — | Create a user |
| `POST` | `/users/login` | Basic | Log in (HTTP Basic) and return the user |
| `PATCH` | `/users/updateName` | — | Update a user's name |
| `PATCH` | `/users/updateUserAvailable` | — | Toggle a mentor's availability |
| `PATCH` | `/users/updateRole` | 🔒 admin | Change a user's role |
| `DELETE` | `/users/:id` | 🔒 admin | Delete a user |

<details>
<summary><b>Create user — request / response</b></summary>

```jsonc
// POST /users
{
  "name": "",
  "email": "",
  "password": "",
  "confirmedPassword": "",
  "role": "adm | mentor | student"
}
```
```jsonc
// 200 OK
{ "id": "UUID", "email": "" }
```
Returns `400 Bad Request` if the password confirmation doesn't match.
</details>

### Appointments

| Method | Path | Auth | Description |
|---|---|:---:|---|
| `GET` | `/appointments` | — | List all appointments |
| `GET` | `/appointments/:id` | — | Fetch one appointment by id |
| `POST` | `/appointments` | — | Create an appointment |
| `PATCH` | `/appointments/place` | 🔒 adm/mentor | Update the appointment place |
| `PATCH` | `/appointments/isScheduled` | 🔒 adm/mentor | Update scheduled status |
| `PATCH` | `/appointments/callStudent` | 🔒 adm/mentor | Call/uncall the student |
| `PATCH` | `/appointments/isDone` | 🔒 adm/mentor | Mark as done |
| `PATCH` | `/appointments/mentor` | 🔒 adm/mentor | Reassign the mentor |
| `DELETE` | `/appointments/:id` | 🔒 adm/mentor | Delete an appointment |

<details>
<summary><b>Create appointment — request / response</b></summary>

```jsonc
// POST /appointments
{
  "mentor": "",
  "appointmentPlace": "",
  "description": "",
  "studentID": "UUID",
  "isScheduled": false,
  "callStudent": false,
  "isDone": false,
  "type": "doubt | problem",
  "path": "code | design"
}
```
```jsonc
// 200 OK
{
  "id": "UUID",
  "mentor": "String",
  "studentID": "UUID",
  "description": "String",
  "appointmentPlace": "String",
  "isScheduled": false,
  "callStudent": false,
  "isDone": false,
  "createdAt": "Date",
  "type": "TypeAppointment",
  "path": "PathAppointment"
}
```
</details>

> Success returns `200 OK`. A missing id returns `400 Bad Request`.

---

## 🔐 Authentication & Roles

Protected routes use **HTTP Basic authentication** (Vapor's `User.authenticator()`)
plus a role middleware:

- **`AdminOnlyMiddleware`** — only `adm` users (e.g. change roles, delete users).
- **`AdmMentorMiddleware`** — `adm` **or** `mentor` users (manage appointments).

Open routes (listing, creating users/appointments, login) require no auth.

---

## 🙋 My Role

I was part of the **initial backend team** (Enzo, Rafael, Pedro Tessaro and João
Vitor). I focused mainly on the **Docker setup** — the `Dockerfile` and
`docker-compose` orchestrating the Vapor app with PostgreSQL — and on building the
**REST routes** (users & appointments endpoints with Fluent). Later I moved to the
frontend (macOS, then iOS) and finally to backend integration. See the
[full project README](https://github.com/EnzoFerroni/Alinha-Project) for the complete
story.

---

## 👥 Team

Backend squad — it started as Enzo, Rafael, Pedro Tessaro and João Vitor; later Enzo
and Pedro Tessaro moved to the frontend, and Carolina and Dayô joined, so all six
contributed across the project.

<table>
  <tr>
    <td align="center" width="16%">
      <a href="https://github.com/carolssun"><img src="https://github.com/carolssun.png" width="80" alt="Carolina Sun"/></a>
      <br/><sub><b>Carolina Sun</b></sub><br/>
      <a href="https://github.com/carolssun"><img src="https://skillicons.dev/icons?i=github" alt="GitHub"/></a>
      <a href="https://www.linkedin.com/in/carolina-sun/"><img src="https://skillicons.dev/icons?i=linkedin" alt="LinkedIn"/></a>
    </td>
    <td align="center" width="16%">
      <a href="https://github.com/dayoleal"><img src="https://github.com/dayoleal.png" width="80" alt="Dayô Araújo"/></a>
      <br/><sub><b>Dayô Araújo</b></sub><br/>
      <a href="https://github.com/dayoleal"><img src="https://skillicons.dev/icons?i=github" alt="GitHub"/></a>
      <a href="https://www.linkedin.com/in/dayo-araujo/"><img src="https://skillicons.dev/icons?i=linkedin" alt="LinkedIn"/></a>
    </td>
    <td align="center" width="16%">
      <a href="https://github.com/EnzoFerroni"><img src="https://github.com/EnzoFerroni.png" width="80" alt="Enzo Ferroni"/></a>
      <br/><sub><b>Enzo Ferroni</b></sub><br/>
      <a href="https://github.com/EnzoFerroni"><img src="https://skillicons.dev/icons?i=github" alt="GitHub"/></a>
      <a href="https://www.linkedin.com/in/enzoferroni/"><img src="https://skillicons.dev/icons?i=linkedin" alt="LinkedIn"/></a>
    </td>
    <td align="center" width="16%">
      <a href="https://github.com/J040VRM"><img src="https://github.com/J040VRM.png" width="80" alt="João Vitor Miranda"/></a>
      <br/><sub><b>João Vitor Miranda</b></sub><br/>
      <a href="https://github.com/J040VRM"><img src="https://skillicons.dev/icons?i=github" alt="GitHub"/></a>
      <a href="https://www.linkedin.com/in/jo%C3%A3o-vitor-rocha-miranda-/"><img src="https://skillicons.dev/icons?i=linkedin" alt="LinkedIn"/></a>
    </td>
    <td align="center" width="16%">
      <a href="https://github.com/PedroTessaro"><img src="https://github.com/PedroTessaro.png" width="80" alt="Pedro Tessaro"/></a>
      <br/><sub><b>Pedro Tessaro</b></sub><br/>
      <a href="https://github.com/PedroTessaro"><img src="https://skillicons.dev/icons?i=github" alt="GitHub"/></a>
      <a href="https://www.linkedin.com/in/pedrotessaro/"><img src="https://skillicons.dev/icons?i=linkedin" alt="LinkedIn"/></a>
    </td>
    <td align="center" width="16%">
      <a href="https://github.com/OliveiraRNeves"><img src="https://github.com/OliveiraRNeves.png" width="80" alt="Rafael Neves"/></a>
      <br/><sub><b>Rafael Neves</b></sub><br/>
      <a href="https://github.com/OliveiraRNeves"><img src="https://skillicons.dev/icons?i=github" alt="GitHub"/></a>
      <a href="https://www.linkedin.com/in/rafael-oneves/"><img src="https://skillicons.dev/icons?i=linkedin" alt="LinkedIn"/></a>
    </td>
  </tr>
</table>

<sub>Built by a ~30-person team at the <b>Apple Developer Academy | Mackenzie</b>. 💛</sub>

---

## 📄 License

Released under the [MIT License](LICENSE). © 2025 the Alinha team — Apple Developer
Academy | Mackenzie.

<div align="center">
<br/>
<sub>Built with ☕, Swift and a lot of agile ceremonies.</sub>
</div>
