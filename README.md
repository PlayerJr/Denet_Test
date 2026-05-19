# Task Management API

REST API for managing tasks — test assignment for Junior DevOps Engineer.

**Stack:** Python, FastAPI, PostgreSQL, Redis, Loki, Grafana Alloy, Grafana.

---

## Quick Start

### Prerequisites

- Docker Engine 24+ with Compose plugin
- Git (optional)

### 1. Clone and enter the project

```bash
git clone <repo-url> task-manager
cd task-manager
```

### 2. Configure environment

```bash
cp .env.example .env
# Edit .env if needed (defaults work for local development)
```

### 3. Start the full stack

```bash
docker compose up -d
```

### 4. Verify

| Service     | URL                          |
|-------------|------------------------------|
| API         | http://localhost:8000        |
| API Docs    | http://localhost:8000/docs   |
| Grafana     | http://localhost:3000        |
| Loki (HTTP) | http://localhost:3100        |

### 5. Run tests

```bash
docker compose exec app pytest
```

---

## Project Structure

```
├── Dockerfile              # Multi-stage production image
├── docker-compose.yml      # Full stack orchestration
├── .gitlab-ci.yml          # CI/CD pipeline (test → build → publish → deploy)
├── .env.example            # Environment variable template
├── requirements.txt        # Python dependencies
├── pytest.ini              # Pytest configuration
├── app/                    # Application source code
│   ├── main.py
│   ├── config.py
│   ├── database.py
│   ├── models.py
│   ├── schemas.py
│   ├── routes.py
│   └── redis_client.py
├── tests/                  # Test suite
│   ├── conftest.py
│   └── test_api.py
└── config/                 # Infrastructure configuration
    ├── loki/loki-config.yml
    ├── alloy/config.alloy
    └── grafana/datasources.yml
```

---

## CI/CD Pipeline

The `.gitlab-ci.yml` defines four stages:

1. **test** — runs `pytest` in a Python container
2. **build** — builds the Docker image
3. **publish** — pushes the image to GitLab Container Registry
4. **deploy** — copies config and redeploys on the target server (main branch only)

### Required CI/CD Variables

| Variable         | Description                          |
|------------------|--------------------------------------|
| `SSH_USER`       | SSH user for deploy target           |
| `SSH_HOST`       | Deploy server hostname/IP            |
| `SSH_PRIVATE_KEY`| SSH private key (base64 or PEM)      |
| `SSH_KNOWN_HOSTS`| Server public key for host checking  |

---

## Logging

All containers use the `json-file` log driver. Logs are collected by
**Grafana Alloy** and forwarded to **Loki**. View logs in **Grafana**
(Explore → Loki datasource) at http://localhost:3000.
