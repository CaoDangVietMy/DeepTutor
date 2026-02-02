# DeepTutor API Architecture

## API Overview
Location: `src/api/`

The API is built with FastAPI, providing RESTful endpoints for all DeepTutor features.

## Structure
```
src/api/
├── main.py              # FastAPI app initialization
├── run_server.py        # Server runner
├── routers/             # API route handlers
└── utils/               # API utilities
```

## Endpoints Summary

Based on the frontend pages, the API likely exposes:

### Chat & Solver
- `POST /solve` - Problem solving with multi-agent
- `WebSocket /ws/solve` - Real-time streaming

### Question Generation
- `POST /question/custom` - Custom question generation
- `POST /question/mimic` - Exam mimicking

### Knowledge Base
- `GET /knowledge` - List knowledge bases
- `POST /knowledge` - Create knowledge base
- `POST /knowledge/{kb_name}/upload` - Upload documents
- `DELETE /knowledge/{kb_name}` - Delete knowledge base

### Research
- `POST /research` - Deep research request

### Guide (Guided Learning)
- `POST /guide/session` - Create learning session
- `GET /guide/session/{id}` - Get session state
- `POST /guide/chat` - Chat within session

### Co-Writer
- `POST /co_writer/edit` - AI-assisted editing
- `POST /co_writer/narrate` - TTS generation

### Notebook
- `GET /notebook` - List notebooks
- `POST /notebook` - Create/update notebook

### Settings
- `GET /settings` - Get current settings
- `POST /settings` - Update settings

## Server Configuration

### Default Ports
- Backend: `8001` (configurable via `BACKEND_PORT`)
- Frontend: `3782` (configurable via `FRONTEND_PORT`)

### Running the Server
```bash
# Via script
python src/api/run_server.py

# Via uvicorn directly
uvicorn src.api.main:app --host 0.0.0.0 --port 8001 --reload
```

### API Documentation
- Swagger UI: http://localhost:8001/docs
- ReDoc: http://localhost:8001/redoc
