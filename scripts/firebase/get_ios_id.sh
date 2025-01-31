#!/bin/bash

# Get iOS bundle ID from project.pbxproj
IOS_ID=$(grep -A1 'PRODUCT_BUNDLE_IDENTIFIER' ios/Runner.xcodeproj/project.pbxproj | grep 'com\.' | head -n1 | tr -d '[:space:];' | cut -d'=' -f2)

if [ -z "$IOS_ID" ]; then
    echo "Error: Could not determine iOS bundle ID" >&2
    exit 1
fi

echo $IOS_ID 