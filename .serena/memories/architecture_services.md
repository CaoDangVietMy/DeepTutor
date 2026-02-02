# DeepTutor Services Architecture

## Services Overview
Location: `src/services/`

Services provide core functionalities used by agents and the API layer.

## Service Modules

### 1. LLM Service (`src/services/llm/`)
**Purpose**: Unified LLM provider interface

**Supported Providers** (via pyproject.toml):
- OpenAI (default)
- Anthropic
- DashScope (Alibaba)

**Environment Variables**:
- `LLM_MODEL`: Model name (e.g., `gpt-4o`)
- `LLM_API_KEY`: API key
- `LLM_HOST`: API endpoint
- `LLM_API_VERSION`: Optional (for Azure)

### 2. Embedding Service (`src/services/embedding/`)
**Purpose**: Vector embeddings for semantic search

**Environment Variables**:
- `EMBEDDING_MODEL`: Model name
- `EMBEDDING_API_KEY`: API key
- `EMBEDDING_HOST`: API endpoint

### 3. RAG Service (`src/services/rag/`)
**Purpose**: Retrieval-Augmented Generation pipeline

**Features**:
- Naive and hybrid retrieval modes
- Atomic RAG pipeline customization
- Vector store integration

### 4. Search Service (`src/services/search/`)
**Purpose**: External search integration

**Supported Providers** (via env):
- Perplexity (default)
- Tavily
- Serper
- Jina
- Exa
- Baidu

**Environment Variables**:
- `SEARCH_PROVIDER`: Provider name
- `SEARCH_API_KEY`: API key

### 5. TTS Service (`src/services/tts/`)
**Purpose**: Text-to-Speech generation

**Voices Available**:
- Cherry, Stella, Annie, Cally, Eva, Bella

### 6. Prompt Service (`src/services/prompt/`)
**Purpose**: Prompt management across agents

**Features**:
- Unified PromptManager architecture
- Multi-language support (EN, CN)

### 7. Config Service (`src/services/config/`)
**Purpose**: Configuration management

**Config Files**:
- `config/main.yaml`: Main settings
- `config/agents.yaml`: Agent-specific settings (temperature, max_tokens)

### 8. Settings Service (`src/services/settings/`)
**Purpose**: Runtime settings management

### 9. Setup Service (`src/services/setup/`)
**Purpose**: Initial setup and installation

## Data Storage
Location: `data/`

```
data/
├── knowledge_bases/          # Knowledge base storage
└── user/                     # User activity data
    ├── solve/                # Problem solving results
    ├── question/             # Generated questions
    ├── research/             # Research reports
    ├── co-writer/            # Co-writer documents & audio
    ├── notebook/             # Notebook records
    ├── guide/                # Guided learning sessions
    ├── logs/                 # System logs
    └── run_code_workspace/   # Code execution workspace
```
