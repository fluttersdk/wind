---
name: 'release'
description: 'Prepare a new release — version bump, changelog, GitHub Release which triggers validate + publish to pub.dev'
agent: 'agent'
argument-hint: 'Target version (e.g. 1.0.0-alpha.5, 1.0.0-beta.1, 1.0.0)'
tools: ['read', 'edit', 'run_terminal_cmd', 'search']
---

## Context

Run these commands and use the output:

- `grep 'version:' pubspec.yaml` — current version
- `git branch --show-current` — current branch
- `git tag -l | sort -V | tail -10` — recent git tags
- `gh release list --limit 5` — recent GitHub releases
- `sed -n '/## \[Unreleased\]/,/^## \[/p' CHANGELOG.md | head -40` — unreleased changes
- `git log $(git describe --tags --abbrev=0 2>/dev/null || echo HEAD~20)..HEAD --oneline` — commits since last tag
- `flutter test 2>&1 | tail -3` — test status
- `dart analyze 2>&1 | tail -3` — analyzer status

## Arguments

${input:version:Target version to release (e.g. 1.0.0-alpha.5). Leave empty to auto-increment.}

## Your Task

Prepare a new release for the **Wind UI** Flutter package. Follow this checklist precisely:

### Phase 1: Validation

1. **Branch check** — Must be on `v1` branch. If not, STOP and warn.
2. **Clean tree** — `git status` must show no uncommitted changes. If dirty, STOP and warn.
3. **Tests** — All tests must pass. If failing, STOP and report.
4. **Analyzer** — Zero issues required. If issues, STOP and report.
5. **Version** — Determine the new version from the provided argument or auto-increment.

### Phase 2: Version Bump

Update the version string in ALL of these files:

| File | What to update |
|------|----------------|
| `pubspec.yaml` | `version:` field |
| `CHANGELOG.md` | Move `[Unreleased]` content to `[{version}] - {YYYY-MM-DD}`, add empty `[Unreleased]` above |
| `CLAUDE.md` | `**Version:**` line |
| `doc/getting-started/installation.md` | `fluttersdk_wind: ^{version}` in the yaml code block |

### Phase 3: Changelog Enhancement

Review the `[Unreleased]` section and the git log since the last tag:

1. **Cross-reference** — Ensure every significant commit is reflected in CHANGELOG.md
2. **Missing entries** — Add any commits that introduced features, fixes, or improvements but were not logged
3. **Categorize** using: `### New Features`, `### Bug Fixes`, `### Improvements`, `### Breaking Changes`
4. **Entry format** — `- **Short Title**: One-line description`
5. **Date** — Use today's date in `YYYY-MM-DD` format

### Phase 4: README Sync

Check README.md for version-specific content that needs updating (badges, install examples, outdated code).

### Phase 5: Local Verification

Run all checks locally — ALL must pass:

1. `dart format --set-exit-if-changed .` — must be clean
2. `dart analyze` — must be zero issues
3. `flutter test` — must all pass
4. `dart pub publish --dry-run` — must be zero warnings
5. Review all changed files with `git diff`

If dry-run fails, STOP and fix before proceeding.

### Phase 6: Commit & Push

1. Stage all modified files
2. Create a single commit: `chore(release): {version}`
3. Push to remote: `git push`

### Phase 7: Create GitHub Release

Create a GitHub Release using `gh` CLI:

```bash
gh release create {version} \
  --target v1 \
  --title "v{version}" \
  [--prerelease] \
  --notes "{changelog content}"
```

- Contains `alpha`, `beta`, or `rc` → add `--prerelease` flag
- After creating, watch the publish workflow: `gh run list --workflow=publish.yml --limit 1`

### Output

Present a summary with: GitHub Release URL, changed files, changelog counts, local verification results, pub.dev publish status.
