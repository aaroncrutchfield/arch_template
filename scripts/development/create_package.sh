#!/bin/bash

echo "Creating new Flutter package..."
echo "Please give your new package a name:"
read PACKAGE_NAME
PACKAGE_NAME=$(echo "$PACKAGE_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g')
very_good create flutter_package $PACKAGE_NAME \
    --description="A package for $PACKAGE_NAME" \
    --output-directory=packages 