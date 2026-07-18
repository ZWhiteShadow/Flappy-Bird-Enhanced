#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD="$ROOT/build"
SITE="$ROOT/site"

rm -rf "$BUILD" "$SITE"
mkdir -p "$BUILD/classes" "$BUILD/fat" "$SITE"

javac --release 8 -cp "$ROOT/lib/acm.jar" -d "$BUILD/classes" "$ROOT"/src/*.java

(
  cd "$BUILD/fat"
  jar xf "$ROOT/lib/acm.jar"
)

cp "$BUILD"/classes/*.class "$BUILD/fat/"
cp -R "$ROOT/Images" "$BUILD/fat/Images"
cp -R "$ROOT/Music" "$BUILD/fat/Music"

rm -f "$BUILD/fat/META-INF/MANIFEST.MF"
find "$BUILD/fat/META-INF" -type f \( -name '*.SF' -o -name '*.RSA' -o -name '*.DSA' \) -delete 2>/dev/null || true

jar cfe "$SITE/FlappyBird.jar" GameStarter -C "$BUILD/fat" .
cp "$ROOT/web/index.html" "$SITE/index.html"
touch "$SITE/.nojekyll"

echo "Built $SITE/FlappyBird.jar and $SITE/index.html"
