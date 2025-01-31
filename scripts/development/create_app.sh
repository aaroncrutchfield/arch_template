#!/bin/bash

echo "Creating new Flutter app..."
echo "Please give your new app a name:"
read APP_NAME
APP_NAME=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g')
very_good create flutter_app $APP_NAME \
    --description="A package for $APP_NAME" \
    --org-name=${ORG_NAME:-com.example} \
    --output-directory=./ 