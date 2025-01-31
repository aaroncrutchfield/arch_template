#!/bin/bash

# Get Android package name from build.gradle
ANDROID_ID=$(grep -A1 'namespace' android/app/build.gradle | grep '".*"' | cut -d'"' -f2)

if [ -z "$ANDROID_ID" ]; then
    echo "Error: Could not determine Android package name" >&2
    exit 1
fi

echo $ANDROID_ID 