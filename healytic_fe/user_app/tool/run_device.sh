#!/bin/bash

PLATFORM=$1
ENV=$2

if [ -z "$PLATFORM" ] || [ -z "$ENV" ]; then
  echo "Usage: $0 <platform> <env>"
  exit 1
fi

DEVICE_ID=$(flutter devices | awk -F'•' -v plat="$PLATFORM" 'tolower($0) ~ plat && !found {gsub(/ /, "", $2); print $2; found=1}')

if [ -z "$DEVICE_ID" ]; then
  echo "No $PLATFORM device found."
  echo "Please start an emulator or connect a device."
  exit 1
fi

echo "Running on $PLATFORM device: $DEVICE_ID (ENV=$ENV)"
flutter run -d "$DEVICE_ID" --dart-define=ENV="$ENV"
