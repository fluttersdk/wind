#!/usr/bin/env bash
#
# Stamp a content hash onto the demo gallery's non-content-hashed entry files
# so every deploy busts the browser and CDN cache.
#
# Context: wind-demo.fluttersdk.com is served from CloudPanel nginx, which sends
# .js with `Cache-Control: max-age=315360000` (immutable), and sits behind
# Cloudflare. Flutter's index.html -> flutter_bootstrap.js -> main.dart.js chain
# keeps the same filenames across builds, so an immutable edge copy of
# main.dart.js never refreshes after a new deploy: returning visitors (and the
# Cloudflare edge) keep serving the previous build. The demo is built with
# `--pwa-strategy=none`, so Flutter's own service-worker version-update is gone
# too. We append `?v=<hash>` at each hop: a changing query string is a fresh
# cache key at every layer (browser, nginx, Cloudflare), while nginx still
# resolves the file by its on-disk name.
#
# Usage: stamp-demo-cache-bust.sh <build/web dir>
set -euo pipefail

WEB_DIR="${1:?usage: stamp-demo-cache-bust.sh <build/web dir>}"

INDEX="$WEB_DIR/index.html"
BOOTSTRAP="$WEB_DIR/flutter_bootstrap.js"
MAIN_JS="$WEB_DIR/main.dart.js"

for f in "$INDEX" "$BOOTSTRAP" "$MAIN_JS"; do
    [ -f "$f" ] || { echo "stamp: missing $f" >&2; exit 1; }
done

# Content hash of the compiled app. openssl is present on both macOS and the
# Ubuntu CI runner; md5sum is Linux-only, so avoid it.
HASH=$(openssl dgst -md5 "$MAIN_JS" | awk '{print $NF}' | cut -c1-12)

# index.html: <script src="flutter_bootstrap.js" ...>
sed -i.bak "s#flutter_bootstrap\.js#flutter_bootstrap.js?v=${HASH}#g" "$INDEX"

# flutter_bootstrap.js: the buildConfig entry the loader reads for the main
# entrypoint ("mainJsPath":"main.dart.js"). Stamping this versions the
# main.dart.js fetch the bootstrap issues at runtime.
sed -i.bak "s#\"mainJsPath\":\"main\.dart\.js\"#\"mainJsPath\":\"main.dart.js?v=${HASH}\"#g" "$BOOTSTRAP"

rm -f "$INDEX.bak" "$BOOTSTRAP.bak"

echo "stamp: demo cache-bust v=${HASH}"
