#!/bin/bash
# ============================================
# DeepTutor GCP Setup Script
# ============================================
# This script sets up all required GCP resources for DeepTutor deployment
#
# Prerequisites:
#   - gcloud CLI installed and authenticated
#   - Billing enabled for the project
#
# Usage:
#   chmod +x deploy/setup-gcp.sh
#   ./deploy/setup-gcp.sh
# ============================================

set -e

# ===========================================
# Configuration
# ===========================================
PROJECT_ID="${GCP_PROJECT_ID:-caodangvietmy-classroom}"
REGION="${GCP_REGION:-asia-southeast1}"
SERVICE_NAME="deeptutor"
BUCKET_NAME="deeptutor-${PROJECT_ID}-data"
REPOSITORY_NAME="deeptutor-repo"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}🚀 DeepTutor GCP Setup Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo -e "Project ID: ${GREEN}${PROJECT_ID}${NC}"
echo -e "Region: ${GREEN}${REGION}${NC}"
echo -e "Service Name: ${GREEN}${SERVICE_NAME}${NC}"
echo ""

# ===========================================
# Step 1: Set project
# ===========================================
echo -e "${YELLOW}📌 Step 1: Setting GCP project...${NC}"
gcloud config set project ${PROJECT_ID}
echo -e "${GREEN}✅ Project set to ${PROJECT_ID}${NC}"
echo ""

# ===========================================
# Step 2: Enable required APIs
# ===========================================
echo -e "${YELLOW}📌 Step 2: Enabling required APIs...${NC}"
echo "   This may take a few minutes..."

gcloud services enable \
    run.googleapis.com \
    artifactregistry.googleapis.com \
    storage.googleapis.com \
    secretmanager.googleapis.com \
    cloudbuild.googleapis.com \
    containerregistry.googleapis.com

echo -e "${GREEN}✅ APIs enabled${NC}"
echo ""

# ===========================================
# Step 3: Create Artifact Registry repository
# ===========================================
echo -e "${YELLOW}📌 Step 3: Creating Artifact Registry repository...${NC}"

if gcloud artifacts repositories describe ${REPOSITORY_NAME} --location=${REGION} &>/dev/null; then
    echo -e "${GREEN}✅ Repository ${REPOSITORY_NAME} already exists${NC}"
else
    gcloud artifacts repositories create ${REPOSITORY_NAME} \
        --repository-format=docker \
        --location=${REGION} \
        --description="DeepTutor Docker images"
    echo -e "${GREEN}✅ Repository ${REPOSITORY_NAME} created${NC}"
fi
echo ""

# ===========================================
# Step 4: Create Cloud Storage bucket
# ===========================================
echo -e "${YELLOW}📌 Step 4: Creating Cloud Storage bucket...${NC}"

if gsutil ls -b gs://${BUCKET_NAME} &>/dev/null; then
    echo -e "${GREEN}✅ Bucket ${BUCKET_NAME} already exists${NC}"
else
    gsutil mb -l ${REGION} gs://${BUCKET_NAME}
    
    # Create folder structure
    echo "   Creating folder structure..."
    echo "" | gsutil cp - gs://${BUCKET_NAME}/knowledge_bases/.keep
    echo "" | gsutil cp - gs://${BUCKET_NAME}/user/.keep
    
    echo -e "${GREEN}✅ Bucket ${BUCKET_NAME} created${NC}"
fi
echo ""

# ===========================================
# Step 5: Create secrets (interactive)
# ===========================================
echo -e "${YELLOW}📌 Step 5: Setting up secrets...${NC}"
echo ""

create_secret() {
    local secret_name=$1
    local prompt_text=$2
    local default_value=$3
    
    if gcloud secrets describe ${secret_name} --project=${PROJECT_ID} &>/dev/null; then
        echo -e "   ${GREEN}✓${NC} Secret ${secret_name} already exists"
        read -p "   Do you want to update it? (y/N): " update_choice
        if [[ "${update_choice}" =~ ^[Yy]$ ]]; then
            read -sp "   Enter new value for ${secret_name}: " secret_value
            echo ""
            if [ -z "${secret_value}" ] && [ -n "${default_value}" ]; then
                secret_value="${default_value}"
            fi
            echo -n "${secret_value}" | gcloud secrets versions add ${secret_name} --data-file=-
            echo -e "   ${GREEN}✓${NC} Secret ${secret_name} updated"
        fi
    else
        read -sp "   ${prompt_text}: " secret_value
        echo ""
        if [ -z "${secret_value}" ] && [ -n "${default_value}" ]; then
            secret_value="${default_value}"
            echo -e "   Using default value"
        fi
        if [ -n "${secret_value}" ]; then
            echo -n "${secret_value}" | gcloud secrets create ${secret_name} --data-file=-
            echo -e "   ${GREEN}✓${NC} Secret ${secret_name} created"
        else
            echo -e "   ${YELLOW}⚠${NC} Skipped ${secret_name} (empty value)"
        fi
    fi
}

echo "Please enter your API keys (press Enter to skip optional ones):"
echo ""

# Required secrets
create_secret "llm-api-key" "Enter LLM API Key (OpenAI/etc)" ""
create_secret "llm-model" "Enter LLM Model name" "gpt-4o"
create_secret "embedding-api-key" "Enter Embedding API Key" ""
create_secret "embedding-model" "Enter Embedding Model name" "text-embedding-3-small"

# Optional secrets
echo ""
echo "Optional secrets (press Enter to skip):"
create_secret "search-api-key" "Enter Search API Key (Perplexity/Tavily)" ""
create_secret "tts-api-key" "Enter TTS API Key" ""

echo ""
echo -e "${GREEN}✅ Secrets configured${NC}"
echo ""

# ===========================================
# Step 6: Grant permissions
# ===========================================
echo -e "${YELLOW}📌 Step 6: Configuring IAM permissions...${NC}"

# Get the Cloud Run service account
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format='value(projectNumber)')
SERVICE_ACCOUNT="${PROJECT_NUMBER}-compute@developer.gserviceaccount.com"

# Grant Secret Manager access
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT}" \
    --role="roles/secretmanager.secretAccessor" \
    --quiet

# Grant Storage access
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT}" \
    --role="roles/storage.objectAdmin" \
    --quiet

echo -e "${GREEN}✅ IAM permissions configured${NC}"
echo ""

# ===========================================
# Step 7: Summary
# ===========================================
echo -e "${BLUE}============================================${NC}"
echo -e "${GREEN}✅ Setup Complete!${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo "Resources created:"
echo -e "  • Artifact Registry: ${GREEN}${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY_NAME}${NC}"
echo -e "  • Storage Bucket: ${GREEN}gs://${BUCKET_NAME}${NC}"
echo -e "  • Secrets: ${GREEN}llm-api-key, llm-model, embedding-api-key, embedding-model${NC}"
echo ""
echo "Next steps:"
echo -e "  1. Build and deploy with: ${YELLOW}gcloud builds submit --config=cloudbuild.yaml${NC}"
echo -e "  2. Or deploy manually with: ${YELLOW}./deploy/deploy.sh${NC}"
echo ""
echo -e "${BLUE}============================================${NC}"
