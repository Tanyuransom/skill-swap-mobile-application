#!/bin/bash

# Script to apply database schema to Neon PostgreSQL

echo "🚀 Applying database schema to Neon PostgreSQL..."

# Check if psql is installed
if ! command -v psql &> /dev/null; then
    echo "❌ psql is not installed. Installing..."
    sudo apt update
    sudo apt install -y postgresql-client
fi

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Apply schema
psql "$DATABASE_URL" -f database/schema.sql

if [ $? -eq 0 ]; then
    echo "✅ Database schema applied successfully!"
else
    echo "❌ Failed to apply database schema"
    exit 1
fi
