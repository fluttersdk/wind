# wind_kit

Utility-first Flutter styling: Tailwind-syntax `className` strings become Flutter widget trees through a modular parsing pipeline (W-prefix widgets, token parsers, a `WindThemeData` of token scales).

**Version:** 1.11.1 · **Dart:** >=3.13 · **Flutter:** >=3.47 · Runtime deps: `flutter_svg`, `material_ui`, `cupertino_ui`, `wind_kit_diagnostics_contracts` (no mocking library, no state management library, no router).

Before changing structure, read [ARCHITECTURE.md](ARCHITECTURE.md). The user-facing surface is [README.md](README.md); the agent inventory is [llms.txt](llms.txt).

## Commands

| Command | Description |
|---------|-------------|
| `flutter test` | Run all tests |
| `./tool/coverage.sh 90` | Tests with coverage, fails below 90% line coverage (the CI gate); without the argument it only reports |
| `flutter analyze --no-fatal-infos` | Static analysis (the example is analysed from its own `analysis_options.yaml` with `cd example && flutter analyze --no-fatal-infos`) |
| `dart format .` | Format all code |
| `flutter pub publish --dry-run` | Pre-publish check |
| `python3 tool/check-docs.py` | Docs structure, links, fragments, ToC anchors and `<x-preview>` tags; run it after any `doc/` or example-page change |
| `cd example && flutter run -d chrome` | The demo gallery |

`.claude/settings.json` PostToolUse hooks run `dart format` and `dart analyze` after every `.dart` edit.

## Architecture

```
lib/
├── wind_kit.dart       # The only barrel: no sub-barrels
└── src/
    ├── widgets/        # W-prefix widgets
    ├── parser/         # WindParser, WindStyle, WindContext, parsers/ (one parser per token family)
    ├── theme/          # WindTheme, WindThemeData, defaults/ (the default token scales)
    ├── dynamic/        # WDynamic: JSON to widgets behind an allowlist
    ├── recipe/         # WindRecipe, WindSlotRecipe
    ├── state/          # Anchor state and flex-overflow scopes
    ├── utils/          # Colour helpers, WindLogger, WindPerfCounters, extensions
    ├── core/           # platform_service
    ├── debug_resolver.dart   # Implements the contracts package's resolvers
    └── wind_facade.dart      # Wind.installDebugResolver(), Wind.installPerfResolver()
test/                   # Mirrors lib/src/
example/                # The demo gallery; its pages are embedded by the docs site by path
doc/                    # User docs, published by the docs site (topical sections)
skills/wind-ui/         # Agent skill with references/
tool/                   # check-docs.py and coverage.sh
```

## Post-Change Checklist

After ANY change under `lib/`, update every surface in the same change set, before reporting done. A change is not done while one of these is stale; "docs later" rots.

1. **`CHANGELOG.md`**: an entry under `[Unreleased]` in `Added`, `Changed`, `Fixed`, `Removed` (breaking), `Quality` or `Security`. Open with what a reader now gets, in bold, then what it cost to find out: the defect, what it was measured against, the alternative rejected and why. Close with the files touched in backticks, backtick every identifier and name the PR `(#207)`. One line is right where the change is one line.
2. **`doc/`**: the matching page under `doc/widgets/`, `doc/layout/`, `doc/styling/` and so on, in the shape `.claude/rules/docs.md` describes. A new widget gets `doc/widgets/<w-name>.md` mirroring its nearest neighbour. Delete the page of a removed surface. `python3 tool/check-docs.py` must exit 0.
3. **`example/lib/pages/`**: every `<x-preview source path>` in `doc/` points at a real example page and a route in `example/lib/routes.dart`. Page shape rules are in `.claude/rules/example-pages.md`. Keep page paths stable: the docs site embeds the gallery by path, and an unregistered route renders an empty frame with no error.
4. **`skills/wind-ui/`**: `SKILL.md` and the matching `references/<topic>.md` when a widget, token family, theme field or className semantic changes. The skill keeps its own `version:`, bumped when the surface changes; the registry (`anilcancakir/ai`) mirrors it after each release.
5. **`README.md` and `llms.txt`**: only for overview-level changes (a widget added to the roster, a top-level feature, a public API added or removed). They state no counts on purpose, because a count goes stale the next time a widget or parser is added.
6. **`CLAUDE.md` and `ARCHITECTURE.md`**: update the tree when files move.

## Development Flow (TDD)

1. **Red**: a failing test describes the expected behaviour.
2. **Green**: the minimum code to pass.
3. **Refactor**: clean up while the tests stay green.

No production code without a failing test first. Zero analyzer issues, no format diff, no new skipped tests (a `skip:` needs a reason in a nearby comment).

## Testing

- Parser tests, and widget tests that pump className-styled widgets, call `WindParser.clearCache()` in `setUp()`: the cache persists between tests and gives false positives. The full discipline is in `.claude/rules/tests.md`.
- The 90% line-coverage gate is the floor, not the target. A change that drops it adds tests in the same change set; the threshold never moves.
- `// coverage:ignore-line` only for lines unreachable from `flutter test` (kDebugMode-only branches, `Platform.is*` branches that do not match the CI host), on the same line as the statement with a one-line why above it.

## Key Gotchas

| Mistake | Fix |
|---------|-----|
| A colour token without its `dark:` pair | Every `bg-` / `text-` / `border-` / `ring-` / `shadow-` / `fill-` carries its `dark:` peer in the same className |
| Interpolating Dart into a className | Route conditions through `states:` and prefixed classes; interpolation breaks the parser cache |
| A new sub-barrel | The package has one barrel, `wind_kit.dart` |
| Renaming a `doc/` page or an example route | The docs site embeds the gallery and links pages by path; keep them stable |
| Adding a runtime dependency | `flutter_svg`, `material_ui`, `cupertino_ui` and the contracts package are the whole surface |
| Changing a key of the contracts package's maps from this repo | The contract lives in `wind_kit_diagnostics_contracts`; a rename or removal there is a major bump across wind_kit and tapir |
| Relative paths in `pubspec_overrides.yaml` | Use absolute ones; the file is never committed |

## Release

1. Open a `release:` PR that bumps `pubspec.yaml`, the `Version:` line above and the tag in `dartdoc_options.yaml` (`blob/X.Y.Z`), and promotes `[Unreleased]` in `CHANGELOG.md` to `## [X.Y.Z] - YYYY-MM-DD`. The skill's own `version:` moves when its content changed.
2. After it merges, tag the merge commit with the bare version (`git tag 1.12.1 && git push origin 1.12.1`, no `v`). `publish.yml` runs from the tag; the pub.dev Admin tab holds repository `anilcancakir/wind_kit`, tag pattern `{{version}}` and push events only.
3. A failed `Validate` is fixed forward: delete the tag (`git push --delete origin <tag>` and `git tag -d <tag>`), fix it on a PR and tag the new merge commit, because a re-run builds the same commit. If only `GitHub Release` fails after pub.dev accepted the version, use "Re-run failed jobs" (never "Re-run all jobs", where `publish` is rejected as a duplicate) or run `gh release create <tag> --title <tag> --latest --verify-tag --notes-file <file>`.

The first publish under this name (1.12.0) is manual, since tag-triggered OIDC cannot create a package, so run the `Validate` gates yourself first (format, analyze, `./tool/coverage.sh 90`, dry-run, and pana 0.23.19 with `--exit-code-threshold 0`, which must score 160/160 on the merged master). Then:

1. `flutter pub publish --force` from a clean checkout of the merge commit.
2. Push the tag, cancel the doomed `publish.yml` run (OIDC rejects a version pub.dev already has, so `github-release` never runs) and create the release by hand with `gh release create 1.12.0 --title 1.12.0 --latest --verify-tag --notes-file <section>`.
3. Run the registry sync the cancelled run skipped: `gh workflow run dispatch-to-registry.yml --ref 1.12.0`.
4. In the pub.dev Admin tab set the repository and tag pattern above, move the package to the `anilcancakir.com` publisher and disable manual publishing.

## Branching

`master` is the only long-lived branch and everything lands through a PR, with a merge commit or a rebase, never a squash (Dependabot's auto-merge is the one squash). Task branches use short kebab-case names (`feat/<topic>`, `fix/<topic>`, `docs/<topic>`, `chore/<topic>`), one topic each, and `delete_branch_on_merge` removes them. `v0` is the frozen 0.x line: cut nothing from it and merge nothing into it.

## CI

- `ci.yml`: workflow lint (actionlint), then `Lint & Test` (format, analyze, `./tool/coverage.sh 90`, codecov upload, publish dry-run, the wasm-ready check with pana 0.23.19), then a web build of the gallery on pushes and PRs that touch it
- `changelog.yml`: a PR that changes `lib/` must also change `CHANGELOG.md`; Dependabot, `release:` PRs and the `skip-changelog` label are exempt
- `docs-link-check.yml`: every PR runs `python3 tool/check-docs.py` and an offline lychee pass (`Internal Links`); Mondays an external-link pass
- `publish.yml`: tag on master → version stamps (tag, `pubspec.yaml`, `dartdoc_options.yaml`) → format, analyze, coverage, dry-run, pana 0.23.19 (the version pub.dev runs; 0.23.13 reports flutter_svg as web-incompatible) → changelog section → OIDC publish → GitHub Release → registry sync (`dispatch-to-registry.yml`)
- `dependabot-auto-merge.yml`: arms auto-merge for minor and patch Dependabot PRs
- `scorecard.yml`, `zizmor.yml`, `dependency-review.yml`: supply-chain checks; `zizmor` is not a required check because it never reports on a PR that touches no workflow
