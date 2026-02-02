# 🔥 Firebase Deployment Feasibility Analysis for DeepTutor

> **Document Version:** 1.0  
> **Date:** 2026-01-26  
> **Status:** Analysis Complete

---

## Executive Summary

| Deployment Option | Feasibility | Effort | Recommendation |
|-------------------|-------------|--------|----------------|
| **Firebase Hosting + Cloud Functions** | ❌ **NOT FEASIBLE** | N/A | WebSocket & dependencies block |
| **Firebase Hybrid** | 🟡 Possible | 2-4 weeks | Complex architecture changes |
| **Google Cloud Run** | ✅ **RECOMMENDED** | 1-2 hours | Deploy Docker as-is |

---

## 🚫 Why Firebase (Pure) Won't Work

### Critical Blockers

| Issue | Details |
|-------|---------|
| **WebSocket Streaming** | Cloud Functions cannot maintain persistent connections. DeepTutor requires real-time streaming for multi-agent problem solving. |
| **Execution Time** | Multi-agent workflows (Solve, Research) can run 2-10 minutes. Cloud Functions max: 540 seconds (gen2), often timeout. |
| **System Dependencies** | `libgl1`, `libglib2.0-0` (OpenCV for PDF parsing) cannot be installed in Cloud Functions. |
| **Package Size** | `llama-index`, `docling`, `raganything` exceed Cloud Functions deployment limits (100MB compressed). |
| **Stateful Architecture** | DeepTutor uses supervisord to manage long-running processes - impossible in serverless. |

### What's Deployable to Firebase?

```
Frontend (Next.js):     ~80% (static export only, lose SSR)
Backend (FastAPI):       0% ❌ (fundamentally incompatible)
Data Layer:             ~40% (Firestore for metadata, not vectors)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Overall:                ~25-30%
```

---

## ✅ The Elegant Solution: Google Cloud Run

### Why Cloud Run?

| Feature | Cloud Run | Cloud Functions |
|---------|-----------|-----------------|
| **WebSocket** | ✅ Supported | ❌ Not supported |
| **Timeout** | Up to 60 minutes | 9 minutes max |
| **Docker** | ✅ Deploy directly | ❌ Must rewrite |
| **System libs** | ✅ Any | ❌ Limited |
| **Persistent** | ✅ Long-running | ❌ Stateless |
| **Memory** | Up to 32GB | Up to 8GB |

### Deployment Commands (1-2 hours total)

```bash
# 1. Build and push to Google Container Registry
gcloud builds submit --tag gcr.io/YOUR_PROJECT/deeptutor

# 2. Deploy to Cloud Run
gcloud run deploy deeptutor \
  --image gcr.io/YOUR_PROJECT/deeptutor \
  --platform managed \
  --region asia-southeast1 \
  --allow-unauthenticated \
  --port 3782 \
  --memory 4Gi \
  --cpu 2 \
  --timeout 3600 \
  --set-env-vars "LLM_API_KEY=xxx,EMBEDDING_API_KEY=xxx,..."
```

---

## 🎯 Hybrid Approach (Optional Enhancement)

If you want Firebase services alongside Cloud Run:

```
┌─────────────────────────────────────────────────────────┐
│                    User Browser                          │
└───────────────┬─────────────────────────────────────────┘
                │
                ▼
┌───────────────────────────┐    ┌────────────────────────┐
│   Firebase Hosting        │    │   Firebase Auth        │
│   (Static Assets CDN)     │    │   (User Authentication)│
└───────────────┬───────────┘    └────────────────────────┘
                │
                ▼
┌───────────────────────────────────────────────────────────┐
│                  Google Cloud Run                          │
│   ┌─────────────────┐    ┌──────────────────────────────┐ │
│   │ Next.js Frontend│◄───│ FastAPI Backend + Agents     │ │
│   │    (Port 3782)  │    │     (Port 8001)              │ │
│   └─────────────────┘    │  • Multi-agent AI            │ │
│                          │  • WebSocket Streaming       │ │
│                          │  • RAG/Vector Search         │ │
│                          │  • Code Execution            │ │
│                          └──────────────────────────────┘ │
└───────────────────────────────────────────────────────────┘
                │                           │
                ▼                           ▼
┌───────────────────────────┐    ┌─────────────────────────┐
│   Firebase Storage        │    │   Firebase Firestore    │
│   (PDFs, Audio files)     │    │   (User data, History)  │
└───────────────────────────┘    └─────────────────────────┘
```

---

## 💡 Final Verdict

> **"The people who are crazy enough to think they can change the world are the ones who do."**

DeepTutor is not a simple web app - it's an **AI orchestration platform** with:
- Multi-agent collaboration
- Real-time streaming
- Heavy computation
- Complex system dependencies

**Firebase was designed for mobile apps. Cloud Run was designed for this.**

### 🚀 Recommendation

1. **Deploy to Cloud Run** with existing Dockerfile (zero code changes)
2. **Add Firebase Auth** if user authentication needed
3. **Add Firestore** for conversation history persistence (optional)
4. **Add Firebase Storage** for file uploads (optional)

---

## Next Steps

- [ ] Set up Google Cloud project
- [ ] Configure Cloud Run deployment
- [ ] Set up custom domain with SSL
- [ ] (Optional) Integrate Firebase Auth
- [ ] (Optional) Set up Firestore for data persistence
