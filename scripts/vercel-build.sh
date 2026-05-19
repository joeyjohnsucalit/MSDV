#!/usr/bin/env bash
set -euo pipefail

FLUTTER_ROOT="$PWD/.flutter_sdk"
export PATH="$FLUTTER_ROOT/bin:$PATH"

if [ ! -d "$FLUTTER_ROOT" ]; then
  echo "Installing Flutter SDK into $FLUTTER_ROOT..."
  git clone --depth 1 -b stable https://github.com/flutter/flutter.git "$FLUTTER_ROOT"
fi

echo "Using Flutter from $(which flutter)"
flutter doctor -v
flutter precache web
flutter pub get
flutter build web --release
