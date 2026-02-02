# Task Completion Checklist for DeepTutor

## Before Submitting Code Changes

### 1. Code Quality Checks (REQUIRED)
```bash
# Run ALL pre-commit hooks
pre-commit run --all-files
```

This runs:
- Ruff (linting + formatting)
- Prettier (frontend files)
- detect-secrets (security)
- pip-audit (dependency vulnerabilities)
- Bandit (security analysis)
- MyPy (type checking)
- Interrogate (docstring coverage)

### 2. Run Tests
```bash
pytest tests/ -v
```

### 3. Type Checking (optional but recommended)
```bash
mypy src/
```

### 4. Manual Testing (if applicable)
- Backend: Test API at http://localhost:8001/docs
- Frontend: Test UI at http://localhost:3782

### 5. Documentation
- Update README.md if adding new features
- Update docstrings for new/modified functions
- Update config/README.md if changing configs

### 6. Git Commit
```bash
# Use proper commit message format
git commit -m "feat: add new feature description"
```

## PR Checklist
- [ ] Branch created from `dev`
- [ ] Pre-commit passes locally
- [ ] Tests pass
- [ ] Documentation updated
- [ ] PR targets `dev` branch
