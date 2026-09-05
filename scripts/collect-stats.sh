#!/bin/bash
# Collect live metrics for FlyGACA-ios README auto-update
# Extracts: test count from Package.swift, app bundle sizes, quiz question counts
# Output: .stats.json (git-ignored)

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATS_FILE="$REPO_ROOT/.stats.json"

echo "📊 Collecting FlyGACA-iOS metrics..."

# Extract test count from Package.swift testTargets array
echo "  • Counting test targets..."
if [ -f "$REPO_ROOT/apple/FlyGACAKit/Package.swift" ]; then
  TEST_COUNT=$(grep -c "\.testTarget(" "$REPO_ROOT/apple/FlyGACAKit/Package.swift" || echo "0")
else
  TEST_COUNT=0
fi

# Count quiz.json questions per app
echo "  • Counting quiz questions..."
ELPT_QUESTIONS=0
if [ -f "$REPO_ROOT/apple/Apps/ELPT/Content/quiz.json" ]; then
  ELPT_QUESTIONS=$(grep -c '"q":' "$REPO_ROOT/apple/Apps/ELPT/Content/quiz.json" || echo "0")
fi

AIP_QUESTIONS=0
if [ -f "$REPO_ROOT/apple/Apps/AIP/Content/quiz.json" ]; then
  AIP_QUESTIONS=$(grep -c '"q":' "$REPO_ROOT/apple/Apps/AIP/Content/quiz.json" || echo "0")
fi

TOTAL_QUESTIONS=$((ELPT_QUESTIONS + AIP_QUESTIONS))

# Extract latest git tag (version)
echo "  • Fetching version from git tags..."
LATEST_TAG=$(cd "$REPO_ROOT" && git describe --tags --abbrev=0 2>/dev/null || echo "no-tag")
LATEST_VERSION=$(echo "$LATEST_TAG" | sed 's/^v//')

# Placeholder for bundle size (Phase 3 would extract from CI artifact)
# Would parse ios:build:release:all output or artifact metadata
ELPT_BUNDLE_SIZE="TBD"
AIP_BUNDLE_SIZE="TBD"

# Placeholder for TestFlight beta tester count (Phase 3 would use App Store Connect API)
# Requires APPLE_TEAM_ID and App Store Connect API key credentials
BETA_TESTERS="TBD"

# Write stats JSON
cat > "$STATS_FILE" <<EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "swift_test_targets": $TEST_COUNT,
  "elpt_questions": $ELPT_QUESTIONS,
  "aip_questions": $AIP_QUESTIONS,
  "total_questions": $TOTAL_QUESTIONS,
  "latest_version": "$LATEST_VERSION",
  "elpt_bundle_size_mb": "$ELPT_BUNDLE_SIZE",
  "aip_bundle_size_mb": "$AIP_BUNDLE_SIZE",
  "testflight_beta_testers": "$BETA_TESTERS",
  "source": "scripts/collect-stats.sh"
}
EOF

echo ""
echo "✅ Metrics collected:"
echo "  Swift test targets: $TEST_COUNT"
echo "  ELPT questions: $ELPT_QUESTIONS"
echo "  AIP questions: $AIP_QUESTIONS"
echo "  Total questions: $TOTAL_QUESTIONS"
echo "  Latest version: $LATEST_VERSION"
echo "  ELPT bundle size: $ELPT_BUNDLE_SIZE (Phase 3: from CI artifact)"
echo "  AIP bundle size: $AIP_BUNDLE_SIZE (Phase 3: from CI artifact)"
echo "  TestFlight testers: $BETA_TESTERS (Phase 3: App Store Connect API)"
echo "  Written to: $STATS_FILE"
