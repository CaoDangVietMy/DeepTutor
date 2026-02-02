# DeepTutor Frontend Architecture

## Frontend Overview
Location: `web/`

The frontend is built with Next.js 16, React 19, and TailwindCSS 3.4.

## Tech Stack
- **Framework**: Next.js 16 (App Router)
- **UI**: React 19
- **Styling**: TailwindCSS 3.4
- **Language**: TypeScript
- **State**: React Context
- **i18n**: Multi-language support (EN, CN)

## Directory Structure
```
web/
├── app/                  # Next.js App Router pages
│   ├── page.tsx          # Home page
│   ├── layout.tsx        # Root layout
│   ├── globals.css       # Global styles
│   ├── solver/           # Problem Solver page
│   ├── question/         # Question Generator page
│   ├── research/         # Deep Research page
│   ├── guide/            # Guided Learning page
│   ├── co_writer/        # Co-Writer page
│   ├── ideagen/          # Idea Generation page
│   ├── notebook/         # Notebook page
│   ├── knowledge/        # Knowledge Base management
│   ├── history/          # Session history
│   └── settings/         # Settings page
├── components/           # Reusable React components
├── context/              # React Context providers
├── hooks/                # Custom React hooks
├── lib/                  # Utility libraries
├── types/                # TypeScript type definitions
├── locales/              # i18n translation files
└── public/               # Static assets
```

## Pages Overview

| Route | Page | Purpose |
|-------|------|---------|
| `/` | Home | Landing page |
| `/solver` | Solver | Problem solving with AI |
| `/question` | Question | Question generation |
| `/research` | Research | Deep research |
| `/guide` | Guide | Guided learning |
| `/co_writer` | Co-Writer | AI-assisted editor |
| `/ideagen` | IdeaGen | Idea generation |
| `/notebook` | Notebook | Personal notes |
| `/knowledge` | Knowledge | KB management |
| `/history` | History | Session history |
| `/settings` | Settings | Configuration |

## Configuration

### Package.json Scripts
```bash
npm run dev        # Development server
npm run build      # Production build
npm run start      # Start production server
npm run lint       # Run ESLint
```

### Environment Variables (web/.env.local)
```env
NEXT_PUBLIC_API_BASE=http://localhost:8001
```

### For Remote/LAN Access
Set in parent `.env`:
```env
NEXT_PUBLIC_API_BASE=http://192.168.x.x:8001
```

## Testing
- Playwright for E2E testing
- Config: `playwright.config.ts`
- Tests: `web/tests/`
