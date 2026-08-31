#!/bin/bash
set -euo pipefail

# sync-content.sh — refresh this repo's committed per-app Content/ + icons from a
# local FlyGACA-app monorepo clone, which remains the source of truth for the
# corpus (public/data/) and the pack catalog (src/lib/prepCatalog.ts).
#
#   bash scripts/sync-content.sh                  # monorepo at ../FlyGACA-app
#   bash scripts/sync-content.sh ~/code/FlyGACA-app
#
# This repo OWNS its Swift code and Xcode config (FlyGACAKit, project.yml,
# apple/Scripts, ARCHITECTURE.md, README.md) — they are hand-edited here, NOT
# synced. Only Content/ + Assets.xcassets come from the monorepo, and it now
# generates them straight into this repo (the monorepo's own apple/ mirror was
# retired 2026-08). The generators write per app into <appsDir>/<App>/…, so we
# point them at this repo's apple/Apps.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

MONO="${1:-}"
if [ -z "$MONO" ]; then
  if [ -d "$REPO_ROOT/../FlyGACA" ]; then
    MONO="$REPO_ROOT/../FlyGACA"
  elif [ -d "$REPO_ROOT/../FlyGACA-app" ]; then
    MONO="$REPO_ROOT/../FlyGACA-app"
  else
    MONO="$REPO_ROOT/../FlyGACA"
  fi
fi

RED='\033[0;31m'; GREEN='\033[0;32m'; BLUE='\033[0;34m'; NC='\033[0m'
log_info()    { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_error()   { echo -e "${RED}✗${NC} $1" >&2; }

if [ ! -f "$MONO/scripts/build-ios-content.mjs" ]; then
  log_error "FlyGACA clone not found at: $MONO"
  echo "  Usage: bash scripts/sync-content.sh [path-to-FlyGACA]" >&2
  exit 1
fi

APPS_DIR="$REPO_ROOT/apple/Apps"
FLYGACA_CONTENT="$APPS_DIR/FlyGACA/Content"

log_info "Generating all module content in the monorepo → $APPS_DIR …"
(cd "$MONO" && node scripts/build-ios-content.mjs --out "$APPS_DIR")

log_info "Assembling unified FlyGACA flagship content bundle → $FLYGACA_CONTENT …"
mkdir -p "$FLYGACA_CONTENT/modules"

for mod in "PPL:ppl-exam" "CPL:cpl" "IR:ir" "ATPL:atpl" "ELPT:elp" "AIP:aip"; do
  DIR_NAME="${mod%%:*}"
  MOD_ID="${mod##*:}"
  if [ -d "$APPS_DIR/$DIR_NAME/Content" ]; then
    rm -rf "$FLYGACA_CONTENT/modules/$MOD_ID"
    cp -r "$APPS_DIR/$DIR_NAME/Content" "$FLYGACA_CONTENT/modules/$MOD_ID"
  fi
done

if [ -f "$MONO/public/data/gacar-index.json" ]; then
  cp "$MONO/public/data/gacar-index.json" "$FLYGACA_CONTENT/regulations.json"
fi

if [ -f "$MONO/public/data/airports-shards/sa.json" ]; then
  cp "$MONO/public/data/airports-shards/sa.json" "$FLYGACA_CONTENT/airports.json"
fi

if [ -f "$MONO/scripts/native/gen-app-icons.mjs" ]; then
  log_info "Generating per-app icons in the monorepo → $APPS_DIR …"
  (cd "$MONO" && node scripts/native/gen-app-icons.mjs --out "$APPS_DIR") || true
fi

log_success "Done — Unified FlyGACA content and all modules refreshed successfully."
echo "  Review with: git status && git diff"

