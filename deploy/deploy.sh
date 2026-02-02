#!/bin/bash
# ============================================
# DeepTutor Manual Deploy Script
# ============================================
# Deploy DeepTutor to Cloud Run manually
# (Alternative to cloudbuild.yaml for local builds)
#
# Usage:
#   chmod +x deploy/deploy.sh
#   ./deploy/deploy.sh
# ============================================

set -e

# ===========================================
# Configuration
# ===========================================
PROJECT_ID="${GCP_PROJECT_ID:-caodangvietmy-classroom}"
REGION="${GCP_REGION:-asia-southeast1}"
SERVICE_NAME="deeptutor"
REPOSITORY_NAME="deeptutor-repo"
IMAGE_TAG="${IMAGE_TAG:-latest}"

# Full image path
IMAGE="${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY_NAME}/${SERVICE_NAME}:${IMAGE_TAG}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}🚀 DeepTutor Deploy Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# ===========================================
# Step 1: Configure Docker for Artifact Registry
# ===========================================
echo -e "${YELLOW}📌 Step 1: Configuring Docker authentication...${NC}"
gcloud auth configure-docker ${REGION}-docker.pkg.dev --quiet
echo -e "${GREEN}✅ Docker configured${NC}"
echo ""

# ===========================================
# Step 2: Build Docker image
# ===========================================
echo -e "${YELLOW}📌 Step 2: Building Docker image...${NC}"
echo "   Image: ${IMAGE}"
echo "   This may take 10-15 minutes..."
echo ""

docker build \
    -t ${IMAGE} \
    -f Dockerfile.cloudrun \
    .

echo ""
echo -e "${GREEN}✅ Docker image built${NC}"
echo ""

# ===========================================
# Step 3: Push to Artifact Registry
# ===========================================
echo -e "${YELLOW}📌 Step 3: Pushing to Artifact Registry...${NC}"
docker push ${IMAGE}
echo -e "${GREEN}✅ Image pushed${NC}"
echo ""

# ===========================================
# Step 4: Deploy to Cloud Run
# ===========================================
echo -e "${YELLOW}📌 Step 4: Deploying to Cloud Run...${NC}"

gcloud run deploy ${SERVICE_NAME} \
    --image ${IMAGE} \
    --region ${REGION} \
    --platform managed \
    --memory 4Gi \
    --cpu 2 \
    --min-instances 0 \
    --max-instances 3 \
    --concurrency 80 \
    --timeout 300 \
    --port 8080 \
    --allow-unauthenticated \
    --set-env-vars "LLM_BINDING=gemini,LLM_HOST=https://generativelanguage.googleapis.com/v1beta/openai/,EMBEDDING_BINDING=google,EMBEDDING_HOST=https://generativelanguage.googleapis.com/v1beta/openai/,EMBEDDING_DIMENSION=768" \
    --set-secrets "LLM_API_KEY=llm-api-key:latest,LLM_MODEL=llm-model:latest,EMBEDDING_API_KEY=embedding-api-key:latest,EMBEDDING_MODEL=embedding-model:latest" \
    --execution-environment gen2

echo ""
echo -e "${GREEN}✅ Deployed to Cloud Run${NC}"
echo ""

# ===========================================
# Step 5: Get service URL
# ===========================================
echo -e "${YELLOW}📌 Step 5: Getting service URL...${NC}"
SERVICE_URL=$(gcloud run services describe ${SERVICE_NAME} --region ${REGION} --format='value(status.url)')

echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${GREEN}✅ Deployment Complete!${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo -e "Service URL: ${GREEN}${SERVICE_URL}${NC}"
echo ""
echo "Test endpoints:"
echo -e "  • Frontend: ${YELLOW}${SERVICE_URL}/${NC}"
echo -e "  • API Health: ${YELLOW}${SERVICE_URL}/health${NC}"
echo -e "  • API Docs: ${YELLOW}${SERVICE_URL}/docs${NC}"
echo ""
echo -e "${BLUE}============================================${NC}"
