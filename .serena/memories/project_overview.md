# DeepTutor Project Overview

## Purpose
DeepTutor is an **AI-Powered Personalized Learning Assistant** developed by HKUDS (HKU Data Science Lab). It's an intelligent learning companion with multi-agent collaboration and RAG (Retrieval-Augmented Generation) capabilities.

## Key Features
1. **📚 Massive Document Knowledge Q&A** - Multi-agent problem solving with exact citations
2. **🎨 Interactive Learning Visualization** - Step-by-step visual explanations
3. **🎯 Knowledge Reinforcement** - Auto-generated quizzes & exam mimicking
4. **🔍 Deep Research & Idea Generation** - Literature review & concept synthesis
5. **✏️ Interactive IdeaGen (Co-Writer)** - AI-assisted markdown editor with TTS

## Tech Stack
- **Backend**: Python 3.10+ / FastAPI
- **Frontend**: Next.js 16 / React 19 / TailwindCSS 3.4
- **Deployment**: Docker / Docker Compose
- **Database**: Vector stores for embeddings, JSON-based memory persistence

## Version
- Current: v0.5.0 (as per pyproject.toml)
- License: AGPL-3.0

## Repository Structure
```
DeepTutor/
├── src/                    # Python backend
│   ├── agents/             # Multi-agent AI system
│   ├── api/                # FastAPI REST API
│   ├── services/           # LLM, embedding, RAG services
│   ├── tools/              # RAG, web search, code execution
│   ├── knowledge/          # Knowledge base management
│   └── utils/              # Utility functions
├── web/                    # Next.js frontend
├── config/                 # YAML configurations
├── scripts/                # Utility scripts
├── tests/                  # Test suites
├── data/                   # Knowledge bases & user data
└── docs/                   # VitePress documentation
```
