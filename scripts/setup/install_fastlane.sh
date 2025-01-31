#!/bin/bash

echo "Installing Fastlane..."
cd android
mkdir -p fastlane
brew install fastlane
fastlane init 