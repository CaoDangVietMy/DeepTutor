# DeepTutor - Google Cloud Run Deployment Guide

> **Last Updated:** 2026-02-02  
> **Author:** DevOps Team  
> **Status:** Production Ready ✅

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Project Information](#project-information)
3. [Environment Variables](#environment-variables)
4. [Deployment Steps](#deployment-steps)
5. [Post-Deployment Configuration](#post-deployment-configuration)
6. [Useful Commands](#useful-commands)
7. [Troubleshooting](#troubleshooting)
8. [Architecture Overview](#architecture-overview)

---

## Prerequisites

### Required Tools
- **Google Cloud SDK** (`gcloud` CLI) - [Install Guide](https://cloud.google.com/sdk/docs/install)
- **Docker** (optional, for local testing)
- **Node.js 22+** (for frontend build)
- **Python 3.12+** (for backend)

### GCP APIs Required
Enable the following APIs in your GCP project:
```bash
gcloud services enable \
  cloudbuild.googleapis.com \
  run.googleapis.com \
  secretmanager.googleapis.com \
  artifactregistry.googleapis.com
```

---

## Project Information

| Setting | Value |
|---------|-------|
| **GCP Project ID** | `caodangvietmy-classroom` |
| **Region** | `asia-southeast1` (Singapore) |
| **Service Name** | `deeptutor` |
| **Artifact Registry** | `asia-southeast1-docker.pkg.dev/caodangvietmy-classroom/deeptutor` |

### Live URLs
- **Production:** https://deeptutor-sc724q4nha-as.a.run.app/
- **API Endpoint:** https://deeptutor-sc724q4nha-as.a.run.app/api/

---

## Environment Variables

### Required Secrets (stored in GCP Secret Manager)

Create the following secrets in Secret Manager before deployment:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `GEMINI_API_KEY` | Google Gemini AI API key | `AIza...` |
| `SERPER_API_KEY` | Serper.dev API key for web search | `abc123...` |
| `OPENWEATHER_API_KEY` | *(Optional)* OpenWeatherMap API | `...` |

### Creating Secrets

```bash
# Create Gemini API Key secret
echo -n "YOUR_GEMINI_API_KEY" | gcloud secrets create GEMINI_API_KEY --data-file=-

# Create Serper API Key secret  
echo -n "YOUR_SERPER_API_KEY" | gcloud secrets create SERPER_API_KEY --data-file=-

# Grant Cloud Run access to secrets
gcloud secrets add-iam-policy-binding GEMINI_API_KEY \
  --member="serviceAccount:886568955910-compute@developer.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"

gcloud secrets add-iam-policy-binding SERPER_API_KEY \
  --member="serviceAccount:886568955910-compute@developer.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"
```

### Application Environment Variables

These are set directly in the Dockerfile/Cloud Run:

| Variable | Value | Description |
|----------|-------|-------------|
| `PORT` | `8080` | Main Nginx port (Cloud Run requirement) |
| `BACKEND_PORT` | `8001` | FastAPI/Uvicorn port |
| `FRONTEND_PORT` | `3782` | Next.js port |
| `NODE_ENV` | `production` | Node environment |
| `PYTHONUNBUFFERED` | `1` | Disable Python output buffering |
| `PYTHONPATH` | `/app` | Python module search path |

---

## Deployment Steps

### Step 1: Clone and Navigate to Project

```bash
cd /path/to/DeepTutor
```

### Step 2: Authenticate with GCP

```bash
gcloud auth login
gcloud config set project caodangvietmy-classroom
```

### Step 3: Build and Deploy

Using Cloud Build (recommended):

```bash
# Submit build and deploy
gcloud builds submit --config cloudbuild.yaml

# Or async (non-blocking)
gcloud builds submit --config cloudbuild.yaml --async
```

### Step 4: Verify Deployment

```bash
# Check service status
gcloud run services describe deeptutor --region=asia-southeast1

# Test API endpoint
curl https://deeptutor-sc724q4nha-as.a.run.app/api/
# Expected: {"message":"Welcome to DeepTutor API"}

# View logs
gcloud run services logs read deeptutor --region=asia-southeast1 --limit=50
```

---

## Post-Deployment Configuration

### Set Minimum Instances (Avoid Cold Start)

The backend takes **~12-15 minutes** to start due to heavy ML model imports. To keep at least 1 instance always running:

```bash
gcloud run services update deeptutor \
  --region=asia-southeast1 \
  --min-instances=1
```

> ⚠️ **Cost:** ~$60-90/month for 1 instance running 24/7 (8GB RAM, 4 vCPU)

To disable (allow scale to zero, accept cold start):
```bash
gcloud run services update deeptutor \
  --region=asia-southeast1 \
  --min-instances=0
```

---

## Useful Commands

### View Build Logs

```bash
# List recent builds
gcloud builds list --limit=10

# View specific build logs
gcloud builds log BUILD_ID

# Stream logs (real-time)
gcloud builds log BUILD_ID --stream
```

### View Service Logs

```bash
# Recent logs
gcloud run services logs read deeptutor --region=asia-southeast1 --limit=100

# Filter by pattern
gcloud run services logs read deeptutor --region=asia-southeast1 --limit=100 | grep -i "error"

# Using Cloud Logging
gcloud logging read 'resource.type="cloud_run_revision" AND resource.labels.service_name="deeptutor"' --limit=50
```

### Update Service Configuration

```bash
# Update memory/CPU
gcloud run services update deeptutor \
  --region=asia-southeast1 \
  --memory=8Gi \
  --cpu=4

# Update timeout
gcloud run services update deeptutor \
  --region=asia-southeast1 \
  --timeout=300

# Update concurrency
gcloud run services update deeptutor \
  --region=asia-southeast1 \
  --concurrency=80
```

### Rollback Deployment

```bash
# List revisions
gcloud run revisions list --service=deeptutor --region=asia-southeast1

# Route traffic to specific revision
gcloud run services update-traffic deeptutor \
  --region=asia-southeast1 \
  --to-revisions=deeptutor-XXXXX-abc=100
```

---

## Troubleshooting

### Issue: 404 Not Found on /api/

**Cause:** Backend not yet started (cold start takes ~15 minutes)

**Solution:**
1. Wait 15-20 minutes for backend to initialize
2. Check logs: `gcloud run services logs read deeptutor --region=asia-southeast1 --limit=50`
3. Look for: `INFO: Uvicorn running on http://127.0.0.1:8001`

### Issue: Connection Refused (111)

**Cause:** Backend process not listening on port 8001

**Check logs for:**
```bash
gcloud run services logs read deeptutor --region=asia-southeast1 --limit=100 | grep -iE "uvicorn|error|exception"
```

**Common causes:**
- Import errors in Python modules
- Missing environment variables
- Memory limit exceeded

### Issue: Build Timeout

**Solution:** Increase Cloud Build timeout in `cloudbuild.yaml`:
```yaml
timeout: 2400s  # 40 minutes
```

### Issue: Memory Errors

**Solution:** Increase Cloud Run memory:
```bash
gcloud run services update deeptutor \
  --region=asia-southeast1 \
  --memory=16Gi
```

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                      Cloud Run Container                     │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                    Supervisor                        │    │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐    │    │
│  │  │   Nginx     │ │   Backend   │ │  Frontend   │    │    │
│  │  │   :8080     │ │   :8001     │ │   :3782     │    │    │
│  │  │  (Reverse   │ │  (FastAPI/  │ │  (Next.js)  │    │    │
│  │  │   Proxy)    │ │  Uvicorn)   │ │             │    │    │
│  │  └─────────────┘ └─────────────┘ └─────────────┘    │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     External Services                        │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │
│  │ Google      │ │   Serper    │ │   Other     │            │
│  │ Gemini API  │ │   API       │ │   APIs      │            │
│  └─────────────┘ └─────────────┘ └─────────────┘            │
└─────────────────────────────────────────────────────────────┘
```

### Port Mapping

| Service | Internal Port | Nginx Route |
|---------|--------------|-------------|
| Nginx (main) | 8080 | - |
| Backend API | 8001 | `/api/*` → `http://127.0.0.1:8001` |
| Frontend | 3782 | `/*` → `http://127.0.0.1:3782` |

---

## Files Reference

| File | Purpose |
|------|---------|
| `Dockerfile.cloudrun` | Multi-stage Docker build for Cloud Run |
| `cloudbuild.yaml` | Cloud Build configuration |
| `scripts/entrypoint.cloudrun.sh` | Container entrypoint script |
| `nginx.cloudrun.conf` | Nginx reverse proxy configuration |
| `.env` | Local environment variables (not deployed) |

---

## Support

For issues or questions, contact the DevOps team or create an issue in the repository.

---

*Document generated for DeepTutor Cloud Run deployment. Keep this document updated with any configuration changes.*
