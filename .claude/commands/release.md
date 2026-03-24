---
description: Prepare a new release — bumps version, updates changelog, syncs docs, waits for CI, creates GitHub Release (which triggers pub.dev publish).
---

## Context

- Current version in pubspec.yaml: !`grep 'version:' pubspec.yaml`
- Current branch: !`git branch --show-current`
- Git tags: !`git tag -l | sort -V | tail -10`
- GitHub releases: !`gh release list --limit 5`
- Unreleased changes: !`sed -n '/## \[Unreleased\]/,/^## \[/p' CHANGELOG.md | head -40`
- Recent commits since last tag: !`git log $(git describe --tags --abbrev=0 2>/dev/null || echo HEAD~20)..HEAD --oneline`
- Test status: !`flutter test 2>&1 | tail -3`
- Analyzer status: !`dart analyze 2>&1 | tail -3`

## Arguments

$ARGUMENTS — The target version to release (e.g. `1.0.0-alpha.5`, `1.0.0-beta.1`, `1.0.0`). If empty, auto-increment the last alpha/beta/patch segment.

## Your task

You are preparing a new release for the **Wind UI** Flutter package. Follow this checklist precisely:

### Phase 1: Validation

1. **Branch check** — Must be on `v1` branch. If not, STOP and warn.
2. **Clean tree** — `git status` must show no uncommitted changes. If dirty, STOP and warn.
3. **Tests** — All tests must pass (see context above). If failing, STOP and report.
4. **Analyzer** — Zero issues required (see context above). If issues, STOP and report.
5. **Version** — Determine the new version from $ARGUMENTS or auto-increment.

### Phase 2: Version Bump

Update the version string in ALL of these files:

| File | What to update |
|------|----------------|
| `pubspec.yaml` | `version:` field |
| `CHANGELOG.md` | Move `[Unreleased]` content → `[{version}] - {YYYY-MM-DD}`, add empty `[Unreleased]` above |
| `CLAUDE.md` | `**Version:**` line |
| `doc/getting-started/installation.md` | `fluttersdk_wind: ^{version}` in the yaml code block |

### Phase 3: Changelog Enhancement

Review the `[Unreleased]` section and the git log since the last tag:

1. **Cross-reference** — Ensure every significant commit is reflected in CHANGELOG.md
2. **Missing entries** — Add any commits that introduced features, fixes, or improvements but were not logged
3. **Categorize** — Use these emoji categories:
   - `### ✨ New Features` — new functionality
   - `### 🐛 Bug Fixes` — bug fixes
   - `### 🔧 Improvements` — DX, CI/CD, docs, refactors
   - `### ⚠️ Breaking Changes` — only if API changed
4. **Entry format** — `- **Short Title**: One-line description`
5. **Date** — Use today's date in `YYYY-MM-DD` format

### Phase 4: README Sync

Check README.md for any version-specific content that needs updating:

1. Version numbers in badges or install examples
2. Any outdated code examples that don't match current API

### Phase 5: Local Verification

1. Run `dart format --set-exit-if-changed .` — must be clean
2. Run `dart analyze` — must be zero issues
3. Run `flutter test` — must all pass
4. Review all changed files with `git diff`

### Phase 6: Commit & Push

1. Stage all modified files
2. Create a single commit: `chore(release): {version}`
3. Push to remote: `git push`

### Phase 7: Wait for CI

The push triggers the **CI & Deploy** workflow (Lint & Test) on GitHub. Wait for it to pass before creating the release.

1. Get the run ID for the push commit:
   ```bash
   gh run list --branch v1 --limit 1 --json databaseId,status,conclusion --jq '.[0]'
   ```

2. Wait for CI to complete:
   ```bash
   gh run watch {run_id} --exit-status
   ```

3. Evaluate:
   - **CI passed** → proceed to Phase 8
   - **CI failed** → STOP. Report the failure. Run `gh run view {run_id} --log-failed` to show the error. Do NOT create the release. The user must fix the issue and re-run `/release`.

### Phase 8: Create GitHub Release

CI is green. Create a GitHub Release using `gh` CLI. This automatically creates a tag, and the tag push triggers `publish.yml` → pub.dev publishing.

Determine if the version is a prerelease:
- Contains `alpha` or `beta` or `rc` → add `--prerelease` flag
- Otherwise → stable release, no flag

Determine the previous version tag for the changelog comparison link.

```bash
gh release create {version} \
  --target v1 \
  --title "v{version}" \
  [--prerelease] \
  --notes "$(cat <<'NOTES'
{changelog content from Phase 3 — same categories and entries}

**Full Changelog**: https://github.com/fluttersdk/wind/compare/{previous_tag}...{version}
NOTES
)"
```

### Output

Present a summary:

```
## Release {version} Published

**GitHub Release:** https://github.com/fluttersdk/wind/releases/tag/{version}

**Changed files:**
- pubspec.yaml
- CHANGELOG.md
- CLAUDE.md
- doc/getting-started/installation.md
- (any others)

**Changelog:** {count} features, {count} fixes, {count} improvements

**CI:** ✅ Lint & Test passed (run #{run_id})
**Local:** ✅ Tests ({count} passed) · ✅ Analyzer (0 issues) · ✅ Format clean

**pub.dev:** Publishing triggered — check status: `gh run list --limit 1`
```
