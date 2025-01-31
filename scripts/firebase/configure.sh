#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "Error: No environment specified. Use 'development', 'staging', 'production', or 'all'."
  exit 1
fi

# Get base IDs
PROJECT_ID=$(scripts/firebase/get_project_id.sh)
ANDROID_ID=$(scripts/firebase/get_android_id.sh)
IOS_ID=$(scripts/firebase/get_ios_id.sh)

if [ -z "$PROJECT_ID" ] || [ -z "$ANDROID_ID" ] || [ -z "$IOS_ID" ]; then
    echo "Error: Could not determine one or more IDs"
    echo "PROJECT_ID: $PROJECT_ID"
    echo "ANDROID_ID: $ANDROID_ID"
    echo "IOS_ID: $IOS_ID"
    exit 1
fi

configure_firebase() {
    local env=$1
    local bundle_suffix
    local project_suffix
    local file_suffix
    case $env in
        "development")
            bundle_suffix=".dev"
            project_suffix="-dev"
            file_suffix="_dev"
            ;;
        "staging")
            bundle_suffix=".stg"
            project_suffix="-stg"
            file_suffix="_stg"
            ;;
        "production")
            bundle_suffix=""
            project_suffix=""
            file_suffix=""
            ;;
    esac

    echo "Configuring Firebase for $env environment..."
    flutterfire config \
      --project=${PROJECT_ID}${project_suffix} \
      --out=lib/firebase/firebase_options${file_suffix}.dart \
      --ios-bundle-id=${IOS_ID}${bundle_suffix} \
      --macos-bundle-id=${IOS_ID}${bundle_suffix} \
      --ios-out=ios/${env}/GoogleService-Info.plist \
      --macos-out=macos/${env}/GoogleService-Info.plist \
      --android-package-name=${ANDROID_ID}${bundle_suffix} \
      --android-out=android/app/src/${env}/google-services.json
}

case $1 in
  development|staging|production)
    configure_firebase $1
    ;;
  all)
    echo "Configuring all Firebase environments..."
    configure_firebase "development"
    configure_firebase "staging"
    configure_firebase "production"
    ;;
  *)
    echo "Error: Invalid environment specified. Use 'development', 'staging', 'production', or 'all'."
    exit 1
    ;;
esac 