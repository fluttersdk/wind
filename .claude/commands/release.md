---
description: Prepare a new release version — bumps version, updates changelog, syncs all docs, runs checks, commits and tags.
---

## Context

- Current version in pubspec.yaml: !`grep 'version:' pubspec.yaml`
- Current branch: !`git branch --show-current`
- Git tags: !`git tag -l | sort -V | tail -10`
- Unreleased changes: !`sed -n '/## \[Unreleased\]/,/^## \[/p' CHANGELOG.md | head -40`
- Recent commits since last tag: !`git log $(git describe --tags --abbrev=0 2>/dev/null || echo HEAD~20)..HEAD --oneline`
- Test status: !`flutter test 2>&1 | tail -3`
- Analyzer status: !`dart analyze 2>&1 | tail -3`

## Arguments

$ARGUMENTS — The target version to release (e.g. `1.0.0-alpha.4`, `1.0.0-beta.1`, `1.0.0`). If empty, auto-increment the last alpha/beta/patch segment.

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
2. Feature counts (widget count, test count, doc count) — verify against actual codebase
3. Any outdated code examples that don't match current API

### Phase 5: Final Verification

1. Run `dart analyze` — must be zero issues
2. Run `flutter test` — must all pass
3. Run `dart format --set-exit-if-changed .` — must be clean
4. Review all changed files with `git diff`

### Phase 6: Commit & Tag

1. Stage all modified files
2. Create a single commit: `chore(release): {version}`
3. Create an annotated git tag: `git tag -a {version} -m "Release {version}"`
4. Show the result: `git log --oneline -3` and `git tag -l | tail -5`

**DO NOT push** — present the result and ask the user if they want to push. Pushing the tag triggers automatic pub.dev publishing via GitHub Actions.

### Output

Present a summary:

```
## Release {version} Ready

**Changed files:**
- pubspec.yaml
- CHANGELOG.md
- CLAUDE.md
- doc/getting-started/installation.md
- (any others)

**Changelog entries:** {count} features, {count} fixes, {count} improvements

**Verification:** ✅ Tests ({count} passed) · ✅ Analyzer (0 issues) · ✅ Format clean

**Next step:** `git push && git push --tags` to publish to pub.dev
```
