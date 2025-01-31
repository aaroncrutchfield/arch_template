#!/bin/bash

# Get Android package name from our helper script
ANDROID_ID=$(scripts/firebase/get_android_id.sh)

if [ -z "$ANDROID_ID" ]; then
    echo "Error: Could not determine Android package name" >&2
    exit 1
fi

# First try full name
PROJECT_ID=$(echo $ANDROID_ID | cut -d'.' -f2- | tr '.' '-' | tr '_' '-')

# If too long, create shorter version by abbreviating 'fluttermasterclass' to 'fm'
if [ ${#PROJECT_ID} -gt 30 ]; then
    echo "Warning: Project ID too long, shortening 'fluttermasterclass' to 'fm'" >&2
    PROJECT_ID=$(echo $ANDROID_ID | cut -d'.' -f2- | sed 's/fluttermasterclass/fm/' | tr '.' '-' | tr '_' '-')
    
    # Verify shortened version isn't still too long
    if [ ${#PROJECT_ID} -gt 30 ]; then
        echo "Error: Project ID still too long (max 30 chars): $PROJECT_ID" >&2
        exit 1
    fi
fi

echo $PROJECT_ID 