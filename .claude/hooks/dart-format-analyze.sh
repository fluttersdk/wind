#!/bin/sh
# Format, then analyse, the Dart file Claude just wrote, and report a failure instead of hiding it.
#
# One script rather than two registrations: hooks on the same event run in parallel, so a separate
# analyser reads the file while the formatter is still rewriting it. The formatter runs first here.
#
# A PostToolUse hook that exits 0 never shows its stdout to Claude, so a finding is returned as
# additionalContext JSON instead. `set -e` is absent on purpose: the analyser's nonzero exit is the
# case worth reporting. Every condition the hook cannot judge exits 0.

set -u

command -v jq >/dev/null 2>&1 || exit 0
command -v dart >/dev/null 2>&1 || exit 0
payload=$(cat) || exit 0
file=$(printf '%s' "$payload" | jq -r '.tool_input.file_path // empty') || exit 0
[ -n "$file" ] || exit 0

# Resolve both sides the same way (`cd` collapses `..`, `pwd -P` resolves symlinks) so a project
# root behind a symlink still matches, and so a path outside the project is rejected.
root=$(cd "${CLAUDE_PROJECT_DIR:-.}" && pwd -P) || exit 0
dir=$(cd -- "$(dirname -- "$file")" && pwd -P) || exit 0
real="$dir/$(basename -- "$file")"

case "$real" in
    "$root"/*) ;;
    *) exit 0 ;;
esac
# Match the generated-output directories against the path inside the project, so a checkout that
# itself sits under a directory named `build` still gets the hook.
rel=${real#"$root"/}
case "$rel" in
    .dart_tool/*|*/.dart_tool/*|build/*|*/build/*|*.g.dart|*.freezed.dart) exit 0 ;;
    *.dart) ;;
    *) exit 0 ;;
esac
# A symlinked file may point outside the project, and `dart format` writes through it.
[ -f "$real" ] && [ ! -L "$real" ] || exit 0

report() {
    printf '%s' "$2" | head -c 4000 | jq -Rs --arg head "$1" \
        '{hookSpecificOutput: {hookEventName: "PostToolUse", additionalContext: ($head + "\n" + .)}}'
    exit 0
}

output=$(cd "$root" && dart format "$real" 2>&1) || report "dart format failed on $real:" "$output"

# The analyser needs the package config of the nearest package (the repo root or example/).
pkg="$dir"
while [ "$pkg" != "/" ] && [ ! -f "$pkg/pubspec.yaml" ]; do pkg=$(dirname -- "$pkg"); done
if [ ! -f "$pkg/.dart_tool/package_config.json" ]; then
    report "dart analyze skipped on $real: no package config." "Run \`flutter pub get\` in $pkg."
fi

# `dart analyze` exits nonzero on warnings and errors only; infos stay non-fatal by default, which
# matches CI's `flutter analyze --no-fatal-infos`. `dart analyze` has no `--no-fatal-infos` flag.
output=$(cd "$pkg" && dart analyze "$real" 2>&1) && exit 0
report "dart analyze reports on $real:" "$output"
