#!/bin/bash

function build_flutter_bundle() {
  echo "Creating directory for app version: $APP_VERSION"
  mkdir -p "$APP_VERSION"

  echo "Cleaning flutter project"
  flutter pub get
  flutter build appbundle --release --no-shrink --build-name=$APP_VERSION --build-number=$BUILD_NUMBER

  echo "Checking if build was successful"
  if [ ! -f build/app/outputs/bundle/release/app-release.aab ]; then
    echo "Build failed: app-release.aab not found"
    exit 1
  fi

  mv build/app/outputs/bundle/release/app-release.aab "$APP_VERSION/"
  if [ $? -eq 0 ]; then
    echo "Move successful"
  else
    echo "Move failed"
    exit 1
  fi
}

build_flutter_bundle
