# DeepTutor Tools

## Tools Overview
Location: `src/tools/`

Tools provide core functionalities that agents use for problem-solving and research.

## Available Tools

### 1. RAG Tool (`rag_tool.py`)
**Purpose**: Retrieval-Augmented Generation for knowledge base queries

**Features**:
- Naive retrieval mode
- Hybrid retrieval mode
- Vector similarity search

### 2. Web Search Tool (`web_search.py`)
**Purpose**: External web search integration

**Supported Providers** (via `SEARCH_PROVIDER` env):
- Perplexity (default)
- Tavily
- Serper
- Jina
- Exa
- Baidu

### 3. Code Executor (`code_executor.py`)
**Purpose**: Execute Python code for calculations and analysis

**Features**:
- Sandboxed execution
- Workspace at `data/user/run_code_workspace/`
- Artifact storage

### 4. Paper Search Tool (`paper_search_tool.py`)
**Purpose**: Academic paper search

**Features**:
- Search academic databases
- Semantic Scholar integration

### 5. Query Item Tool (`query_item_tool.py`)
**Purpose**: Lookup specific items from knowledge base

### 6. TeX Chunker (`tex_chunker.py`)
**Purpose**: Parse and chunk LaTeX documents

### 7. TeX Downloader (`tex_downloader.py`)
**Purpose**: Download TeX files from academic sources

### 8. Question Tools (`tools/question/`)
**Purpose**: Question-specific utilities

---

# Knowledge Base System

## Knowledge Overview
Location: `src/knowledge/`

## Key Files

| File | Purpose |
|------|---------|
| `kb.py` | Knowledge base core class |
| `manager.py` | KB lifecycle management |
| `initializer.py` | KB initialization |
| `add_documents.py` | Document ingestion |
| `config.py` | KB configuration |
| `progress_tracker.py` | Processing progress |
| `start_kb.py` | KB startup |
| `extract_numbered_items.py` | Item extraction |

## Knowledge Base Storage
```
data/knowledge_bases/
└── {kb_name}/
    ├── vector_store/    # Embeddings
    ├── documents/       # Source files
    └── metadata/        # KB metadata
```

## Supported Document Types
- PDF
- TXT
- MD (Markdown)
- Video/Audio (mentioned in TODO)

## Creating a Knowledge Base
1. Navigate to http://localhost:3782/knowledge
2. Click "New Knowledge Base"
3. Enter name
4. Upload PDF/TXT/MD files
5. Monitor progress in terminal
