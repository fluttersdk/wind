#!/usr/bin/env bash
# Sync Claude Code rules (.claude/rules/) → GitHub Copilot instructions (.github/instructions/)
# Run from project root: bash .github/scripts/sync-cc-to-copilot.sh

set -euo pipefail

RULES_DIR=".claude/rules"
INSTRUCTIONS_DIR=".github/instructions"

mkdir -p "$INSTRUCTIONS_DIR"

for rule in "$RULES_DIR"/*.md; do
  [ -f "$rule" ] || continue

  name=$(basename "$rule" .md)
  target="$INSTRUCTIONS_DIR/${name}.instructions.md"

  # Extract path: from frontmatter
  path_glob=$(sed -n '/^---$/,/^---$/{ /^path:/{ s/^path: *"*\(.*\)"*/\1/; p; } }' "$rule")

  # Extract body (everything after second ---)
  body=$(awk 'BEGIN{c=0} /^---$/{c++; next} c>=2{print}' "$rule")

  # Generate human-readable name from filename
  display_name=$(echo "$name" | sed 's/-/ /g; s/\b\(.\)/\u\1/g')

  # Write Copilot instruction file
  cat > "$target" <<COPILOT_EOF
---
name: '${display_name} Conventions'
description: 'Conventions for ${name} domain'
applyTo: '${path_glob}'
---

${body}
COPILOT_EOF

  echo "  synced: $rule → $target"
done

echo "Done. ${INSTRUCTIONS_DIR}/ is up to date."
