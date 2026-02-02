# DeepTutor Agents Architecture

## Agent System Overview
Location: `src/agents/`

DeepTutor uses a multi-agent architecture where specialized agents collaborate to handle different learning tasks.

## Base Agent
- `src/agents/base_agent.py` - Base class for all agents

## Agent Modules

### 1. Solve Agent (`src/agents/solve/`)
**Purpose**: Intelligent problem-solving with dual-loop architecture

**Architecture**:
- **Analysis Loop**: InvestigateAgent → NoteAgent
- **Solve Loop**: PlanAgent → ManagerAgent → SolveAgent → CheckAgent → Format

**Features**:
- Multi-agent collaboration
- Real-time streaming via WebSocket
- Tool integration (RAG, Web Search, Code Execution)
- Persistent JSON-based memory
- Citation management

### 2. Question Agent (`src/agents/question/`)
**Purpose**: Dual-mode question generation

**Modes**:
- **Custom Mode**: Background Knowledge → Planning → Generation → Validation
- **Mimic Mode**: PDF Upload → Parsing → Extraction → Style Mimicking

**Features**:
- ReAct engine with autonomous decision-making
- Multiple question types (MCQ, fill-in, calculation, written)
- Batch generation with progress tracking

### 3. Research Agent (`src/agents/research/`)
**Purpose**: Deep Research in Knowledge Graph (DR-in-KG)

**Three-Phase Architecture**:
- **Phase 1 (Planning)**: RephraseAgent + DecomposeAgent
- **Phase 2 (Researching)**: ManagerAgent + ResearchAgent + NoteAgent
- **Phase 3 (Reporting)**: Deduplication → Outline → Report

**Features**:
- Dynamic Topic Queue with TopicBlock state management
- Multi-source integration (RAG, web search, paper databases)

### 4. Guide Agent (`src/agents/guide/`)
**Purpose**: Personalized learning system

**Agent Types**:
- **LocateAgent**: Identifies 3-5 progressive knowledge points
- **InteractiveAgent**: Converts to visual HTML pages
- **ChatAgent**: Contextual Q&A
- **SummaryAgent**: Learning summaries

**Features**:
- Smart knowledge location
- Interactive page generation
- Progress tracking
- Cross-notebook support

### 5. Co-Writer Agent (`src/agents/co_writer/`)
**Purpose**: Intelligent Markdown editor

**Agent Types**:
- **EditAgent**: Rewrite, Shorten, Expand operations
- **NarratorAgent**: TTS script generation

**Features**:
- Rich text editing with Markdown
- Auto-annotation
- Multiple TTS voices
- Context enhancement (RAG/web search)

### 6. IdeaGen Agent (`src/agents/ideagen/`)
**Purpose**: Automated idea generation

**Features**:
- Brainstorming
- Concept synthesis
- Dual-filter workflow

### 7. Chat Agent (`src/agents/chat/`)
**Purpose**: General conversational AI

## Tool Integration
All agents have access to:
- RAG (naive/hybrid retrieval)
- Web Search
- Code Execution
- Query Item Lookup
- PDF Parsing
