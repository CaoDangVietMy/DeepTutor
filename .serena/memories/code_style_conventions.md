# Code Style & Conventions for DeepTutor

## Python Guidelines

### General
- **Python Version**: 3.10+
- **Line Length**: 100 characters (configured in Black/Ruff)
- **Type Hints**: Required for all function signatures
- **String Formatting**: Prefer f-strings
- **Style Guide**: Follow PEP 8 (enforced by Ruff/Black)
- **Docstrings**: Google Python Style Guide format

### Tooling Configuration (pyproject.toml)
- **Black**: Code formatter (line-length=100)
- **Ruff**: Linter (E, F, I rules - pycodestyle, pyflakes, isort)
- **MyPy**: Type checking (relaxed mode)
- **Bandit**: Security linting
- **pytest**: Testing framework

### Import Sorting (isort via Ruff)
```python
# Standard library
import os
import sys

# Third-party
import fastapi
import pydantic

# First-party (src, scripts)
from src.agents import BaseAgent
from src.services.llm import LLMProvider
```

### Function/Class Guidelines
- Keep functions small and focused on single responsibility
- Use descriptive names
- Add docstrings to all public functions/classes/modules

### Documentation
- Every new module, class, and public function needs a docstring
- Update README.md for new features or config changes

## Frontend (Next.js/React)

### Configuration
- **Prettier**: Formatting (.prettierrc.json)
- **ESLint**: Linting (eslint.config.mjs)
- **TypeScript**: Strict mode (tsconfig.json)
- **TailwindCSS**: Styling

### Files
- React components: PascalCase (e.g., `SolverPage.tsx`)
- Utilities/hooks: camelCase (e.g., `useChatContext.ts`)
- Types: `.d.ts` or in `types/` directory

## Git Workflow

### Branch Strategy
- All contributions must branch from `dev`
- PR target: `dev` branch (not `main`)

### Commit Message Format
```
<type>: <short description>

[optional body]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Adding/fixing tests
- `chore`: Routine tasks

## Security Best Practices
- File uploads: 100MB general, 50MB PDFs
- Subprocesses: Always use `shell=False`
- Pathing: Use `pathlib.Path` for cross-platform
- Line endings: LF (Unix) enforced via `.gitattributes`
