# Wind UI

Utility-first Flutter styling. Translates Tailwind-syntax `className` strings into Flutter widget trees through a modular parsing pipeline.

**Stack:** Flutter >=3.27.0 · Dart >=3.4.0 · Runtime deps: `flutter_svg`, `fluttersdk_wind_diagnostics_contracts`. No `mockito`, no state management library, no router.
**Branch:** `master` is the active 1.x stable line (formerly `v1`). The legacy v0 line lives on the `v0` branch.

For architecture / internals, see [ARCHITECTURE.md](ARCHITECTURE.md).
For the user-facing surface, see [README.md](README.md).
For the LLM-agent inventory, see [llms.txt](llms.txt).

## Definition of done

A code change is not finished until ALL of these hold for the touched scope. The agent self-checks before reporting work complete:

1. `dart analyze` reports zero issues, zero warnings on the touched files.
2. `dart format .` produces no diff.
3. `flutter test` reports zero failures (pre-existing skips noted, never new).
4. `./tool/coverage.sh 90` exits 0 — total line coverage stays at or above 90%. If the change drops coverage, add tests in the same change set, do not lower the threshold.
5. Every code change triggers the **post-change sync** below — skipping any of the four sub-surfaces is not optional.

The PostToolUse hooks in `.claude/settings.json` auto-run format + analyze after `.dart` edits, so steps 1-2 are mostly automatic in the edit loop. CI re-runs all four gates on push; they are not negotiable there.

## Post-change sync (five surfaces, every code change)

When source under `lib/` changes, the agent updates each of these in the same change set, BEFORE reporting the work done. Each surface has its own format and acceptance criterion — comply with all five; skipping is a bug.

**1. `doc/`** — the user-facing markdown reference.

- New or changed widget / parser / token / theme field: locate the matching file under `doc/widgets/`, `doc/layout/`, `doc/styling/`, etc. Format details live in `.claude/rules/docs.md`.
- New widget: create `doc/widgets/<w-name>.md` mirroring the format of the nearest neighbor file (one `#` title, ToC, `<x-preview>` tag, Props table with `Required`/default/description columns, Constructor signature, Styling Examples, Related Documentation).
- Removed surface: delete the doc file or mark deprecated; never leave a stale doc pointing at a removed API.
- Acceptance: the doc file's `<x-preview source="...">` path matches a real `example/lib/pages/` file (sync surface #2 below).

**2. `example/lib/pages/`** — the demo gallery (consumed by `fluttersdk.com` via per-page iframes; see `example/CLAUDE.md`).

- New widget / token / pattern: add `example/lib/pages/<category>/<feature>_basic.dart` (or extend an existing demo). Page shape rules live in `.claude/rules/example-pages.md`.
- `<x-preview source="..." path="...">` in any `doc/` file points to a real example page. If you add a doc x-preview, you add or extend the example page. If you delete an example page, you remove the doc x-preview.
- Acceptance: `cd example && flutter run -d chrome` boots without errors; new pages render with realistic content (no Lorem ipsum); every color token carries its `dark:` pair.

**3. `skills/wind-ui/`** — the LLM-facing skill (source-of-truth lives here).

- This directory is the canonical source for the `wind-ui` skill. The [`fluttersdk/ai`](https://github.com/fluttersdk/ai) distribution repository mirrors `skills/wind-ui/` from here and exposes it to 8+ AI clients (Claude Code, Cursor, OpenCode, Gemini CLI, VS Code Copilot, Codex CLI, Cline, Roo Code) via `npx skills add fluttersdk/ai --skill wind-ui`. End users never install from this repo directly; they install from `fluttersdk/ai`.
- New widget, parser token family, theme field, or breaking change to className semantics: update `skills/wind-ui/SKILL.md` (trigger keywords, Core Laws, Layout Reality) AND any matching `skills/wind-ui/references/<topic>.md`.
- Acceptance: `SKILL.md` frontmatter version bumps when API surface changes; references stay self-consistent.
- Downstream distribution to `fluttersdk/ai` runs through an automated sync; no manual mirror step is required after a commit touching `skills/wind-ui/**`.

**4. `CHANGELOG.md`** — versioned change log.

- Every behavior-changing source change gets an entry under the right semantic-version section:
  - `[Unreleased]` during normal development.
  - The currently-prepping version section during release prep (e.g., `[1.0.0]`).
- Entries land under one of the subsections: `Added`, `Changed`, `Fixed`, `Removed` (BREAKING), `Quality` (test/coverage/CI infra), `Security`. Pick the one closest to user impact, not internal scope.
- Format: one-line bullet per change, with backticked code identifiers and GitHub issue numbers (`(#61)`) when relevant. Match the surrounding entries' tone; no emojis unless adjacent entries use them.
- Acceptance: `grep -A 5 "^## \[" CHANGELOG.md | head -20` shows the new entry in the correct section.

**5. `README.md`** — overview-level only.

- Update only when the change is overview-worthy: a new widget added to the public roster, a new top-level feature (theme field, parser token family, integration entry point), a public API addition or removal.
- Internal refactors, test additions, doc fixes, dependency tweaks: NO README update needed — the noise harms more than the precision helps.
- Acceptance: README's "What you get" / "The Wind Surface" sections reflect the v1 roster (22 widgets, 19 parsers, 24 theme fields) accurately.

**One change set, all five surfaces.** Do not split "code now, docs later" — the next session loses context and the docs rot.

## Commands

Standard Flutter package commands (`flutter test`, `dart analyze`, `dart format .`, `flutter pub get`) work as expected. Non-obvious ones:

| Command | Purpose |
|---------|---------|
| `./tool/coverage.sh 90` | Run tests with coverage + enforce 90% line threshold (the CI gate). Plain `./tool/coverage.sh` just reports. |
| `cd example && flutter run -d chrome` | Demo app (`example/lib/main.dart`) |

`.claude/settings.json` PostToolUse hooks auto-run `dart format` and `dart analyze` after every `.dart` edit. CI runs `flutter analyze` + `dart format --set-exit-if-changed` + `./tool/coverage.sh 90` on push.

## Coverage policy (binding)

The 90% line-coverage gate is the floor, not the target.

- Adding code drops coverage? Add tests in the SAME change set to land back at ≥ 90%. Never lower the gate.
- `// coverage:ignore-line` only for lines structurally unreachable from `flutter test` (kDebugMode-only branches, dart:io `Platform.is*` branches not matching the CI host). Pragma must be on the SAME line as the statement; add a one-line WHY comment immediately above.
- Use `./tool/coverage.sh 90` locally before pushing — same gate CI enforces. CI fails the PR if you skip it.
- Pre-existing skipped tests are noted in the report; never add new `skip:` tags without an explicit reason in the test's nearby comment.

## Testing rule that catches everyone

Parser tests MUST call `WindParser.clearCache()` in `setUp()` — the cache persists between tests and produces false positives if not cleared. Widget tests that pump className-styled widgets also need it. See `.claude/rules/tests.md` for the full test discipline.

## Branching

GitHub Flow. One long-lived release branch, every task on its own branch, every change lands via PR.

- **`master`** is the single long-lived branch. Direct pushes are blocked; everything lands via PR. Matches the flutter, dart-lang/sdk, dart-lang/pub, and Anthropic-ecosystem convention. `master` is what pub.dev resolves.
- **`v0`** is the legacy-frozen branch for the 0.x line. Read-only as far as new development is concerned; cut nothing from it and merge nothing into it.
- **Task branches** are cut from `master` with short kebab-case names: `feat/<topic>`, `fix/<topic>`, `docs/<topic>`, `chore/<topic>` (e.g., `feat/w-tabs`, `fix/parser-cache-stale-after-theme-toggle`, `docs/skill-section-15`). One topic per branch; multi-topic branches get split. PR back into `master`. Squash or merge per the PR's commit shape.
- **Release** opens a `release: X.Y.Z` PR from a topic branch that (a) bumps `pubspec.yaml` `version:`, (b) promotes `## [Unreleased]` in `CHANGELOG.md` to `## [X.Y.Z] - YYYY-MM-DD` with the trailing link reference, (c) runs the full Definition of done gate. Merge the PR, then `git tag X.Y.Z && git push origin X.Y.Z`. The tag triggers `.github/workflows/publish.yml` to push to pub.dev. No accumulator branch; no `develop`.
- **External contributors** fork the repo and PR against `master` using the same shape.

CI gates apply per PR, not per push to a feature branch in isolation: the Definition of done (`dart analyze`, `dart format`, `flutter test`, `./tool/coverage.sh 90`) plus the post-change sync (five surfaces) must pass before a PR is mergeable.
