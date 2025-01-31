#!/bin/bash

# Get project ID from our helper script
PROJECT_ID=$(scripts/firebase/get_project_id.sh)

if [ -z "$PROJECT_ID" ]; then
    echo "Error: Could not determine project ID"
    exit 1
fi

# Check if environment is provided
ENVIRONMENT=${1:-"all"}

create_project() {
    local suffix=$1
    local project_name="${PROJECT_ID}${suffix}"
    echo "Creating Firebase project: ${project_name}"
    firebase projects:create ${project_name}
}

# Ensure logged in first
firebase login

case $ENVIRONMENT in
    "development")
        create_project "-dev"
        ;;
    "staging")
        create_project "-stg"
        ;;
    "production")
        create_project ""  # No suffix for production
        ;;
    "all")
        echo "Creating all Firebase projects..."
        create_project "-dev"
        create_project "-stg"
        create_project ""  # Production
        ;;
    *)
        echo "Error: Invalid environment. Use 'development', 'staging', 'production', or 'all'"
        exit 1
        ;;
esac 