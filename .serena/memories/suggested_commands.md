# Suggested Commands for DeepTutor Development

## Installation

### One-click installation (Recommended)
```bash
python scripts/install_all.py
# Or: bash scripts/install_all.sh
```

### Manual installation
```bash
pip install -r requirements.txt
npm install --prefix web
```

### Development dependencies
```bash
pip install -e ".[all]"           # Install with all optional deps
pip install pre-commit            # Install pre-commit
pre-commit install                # Set up git hooks
```

## Running the Application

### Launch full application (frontend + backend)
```bash
python scripts/start_web.py
```

### Launch CLI only
```bash
python scripts/start.py
```

### Run backend separately (FastAPI)
```bash
python src/api/run_server.py
# Or: uvicorn src.api.main:app --host 0.0.0.0 --port 8001 --reload
```

### Run frontend separately (Next.js)
```bash
cd web && npm install && npm run dev -- -p 3782
```

## Docker Deployment
```bash
docker compose up                   # Build and start
docker compose up -d                # Start detached
docker compose down                 # Stop
docker compose logs -f              # View logs
docker compose build --no-cache     # Rebuild after changes
```

## Code Quality & Testing

### Pre-commit checks (REQUIRED before PR)
```bash
pre-commit run --all-files          # Run all checks
pre-commit run --all-files -q       # Run quietly
```

### Linting with Ruff
```bash
ruff check .                        # Lint only
ruff check . --fix                  # Auto-fix issues
ruff format .                       # Format code
```

### Type checking
```bash
mypy src/                           # Type check src
```

### Security scanning
```bash
bandit -r src/                      # Security linting
pip-audit                           # Dependency vulnerabilities
detect-secrets scan > .secrets.baseline  # Update secrets baseline
```

### Running tests
```bash
pytest                              # Run all tests
pytest tests/ -v                    # Verbose
pytest tests/core/ -v               # Specific directory
```

## Utility Scripts
```bash
python scripts/check_install.py     # Check installation
python scripts/migrate_kb.py        # Migrate knowledge bases
python scripts/generate_roster.py   # Generate agent roster
python scripts/audit_prompts.py     # Audit prompts
```

## Access URLs
- **Frontend**: http://localhost:3782
- **API Docs**: http://localhost:8001/docs
