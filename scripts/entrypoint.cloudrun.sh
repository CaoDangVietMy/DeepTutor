#!/bin/bash
set -e

echo "============================================"
echo "🚀 Starting DeepTutor on Cloud Run"
echo "============================================"

# Cloud Run provides PORT env var
export PORT=${PORT:-8080}
export BACKEND_PORT=${BACKEND_PORT:-8001}
export FRONTEND_PORT=${FRONTEND_PORT:-3782}

echo "📌 Nginx Port: ${PORT}"
echo "📌 Backend Port: ${BACKEND_PORT}"
echo "📌 Frontend Port: ${FRONTEND_PORT}"

# Check for required environment variables
if [ -z "$LLM_API_KEY" ]; then
    echo "⚠️  Warning: LLM_API_KEY not set"
fi

if [ -z "$LLM_MODEL" ]; then
    echo "⚠️  Warning: LLM_MODEL not set, defaulting to gemini-2.0-flash"
    export LLM_MODEL="gemini-2.0-flash"
fi

# Update nginx port dynamically (Cloud Run sets PORT)
sed -i "s/listen 8080/listen ${PORT}/" /etc/nginx/nginx.conf

# Initialize user data directories if empty
echo "📁 Checking data directories..."
if [ ! -f "/app/data/user/user_history.json" ]; then
    echo "   Initializing user data directories..."
    python -c "
from pathlib import Path
from src.services.setup import init_user_directories
init_user_directories(Path('/app'))
" 2>/dev/null || echo "   ⚠️ Directory initialization skipped"
fi

echo "============================================"
echo "📦 Starting services via Supervisor..."
echo "============================================"

# Start supervisord
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/deeptutor.conf
