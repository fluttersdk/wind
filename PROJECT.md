# wind_kit

## What this is

wind_kit is a Flutter package that turns Tailwind-syntax `className` strings into widget trees through W-prefix widgets (`WDiv`, `WText`, `WInput` and the rest of the roster), one parser per token family and a `WindThemeData` of token scales. Flutter app developers use it directly, and debug tools such as `tapir` read its widget state through `wind_kit_diagnostics_contracts`.

## Core value

A className resolves to the widget tree its tokens describe, in light and dark mode, at every breakpoint and state, with no code generation.

## Scope

### Active

- The W-prefix widgets, including the form widgets and the selection, popover and keyboard-toolbar widgets
- One parser per token family, with arbitrary values and the `dark:`, breakpoint, state and platform prefixes
- `WindThemeData` token scales, className aliases and `WindThemeController`
- `WindRecipe` and `WindSlotRecipe` variant maps, and `WDynamic` (JSON to widgets behind an allowlist)
- The diagnostics bridge: `Wind.installDebugResolver()` and `Wind.installPerfResolver()`
- The demo gallery (`example/`), the user docs (`doc/`) and the `wind-ui` agent skill, all shipped from this repository

### Out of scope

- CSS filters and transforms (`blur-*`, `backdrop-blur-*`, `scale-*`, `rotate-*`, `translate-*`): unsupported; `skills/wind-ui/references/tailwind-divergence.md` lists both as entire families absent.
- `!important`, container queries, `group-*` and `peer-*`, `@apply`: unsupported, because Flutter's layout model does not allow the same thing (`ARCHITECTURE.md`, Where Wind differs from Tailwind; `!important` is listed in `skills/wind-ui/references/tailwind-divergence.md`). That catalogue names the substitutes: `states:` for `group-*` and `peer-*`, viewport breakpoints for container queries, `WindThemeData.aliases` for reusable class sets.
- Tailwind v4 renames (`shadow-xs`, `rounded-xs`, `bg-linear-*`): unsupported; Wind keeps the v3 names (`skills/wind-ui/references/tailwind-divergence.md`, section 5).
- State management, routing and mocking: the runtime surface is `flutter_svg`, `material_ui` and `wind_kit_diagnostics_contracts`, and nothing else is added for them (`pubspec.yaml`; the README's Dependencies section).

## Constraints

- **Platforms**: Android, iOS, web (including WebAssembly), macOS, Windows and Linux. Why: the README promises them, and the release gate needs pana at 160/160 with its wasm-ready check, which a `dart:io` import in the library graph breaks (`ARCHITECTURE.md`, Invariants).

## Context

- A rename or removal of a key in the `wind_kit_diagnostics_contracts` maps is a major bump across wind_kit and `tapir` (`CLAUDE.md`, Key Gotchas).
- An app must not depend on both `fluttersdk_wind` and `wind_kit`: each has its own `WindTheme` and `WindDebugRegistry`, so a `WDiv` from one finds no theme from the other. `fluttersdk_wind` 1.11.x is the last release under the old name.

## Decisions

| Decision | Why | Rejected alternatives | Status |
|----------|-----|-----------------------|--------|
| Build on `material_ui` and import `package:material_ui/material_ui.dart` | Flutter 3.50 deprecates `package:flutter/material.dart` and `package:flutter/cupertino.dart`, and pana takes 10 static-analysis points off a package that imports them | Keeping the deprecated barrels: every import is flagged and they are slated for removal | Active |
| The package is named `wind_kit` | 1.12.0 renamed it from `fluttersdk_wind` to `wind_kit` (`CHANGELOG.md`) | Keeping the `fluttersdk_wind` name | Active |
| The SDK floor follows `material_ui` | `material_ui` 1.11 and `cupertino_ui` 1.1 require Dart 3.13 and Flutter 3.47 | Staying on Dart 3.4 and Flutter 3.27: they no longer resolve with those packages | Active |
| The gallery depends on wind_kit by `path: ../` | The docs site embeds the gallery as the live demo of the current code | Pinning a hosted release: it lags every change until a publish | Active |
| The docs site builds and serves the gallery; this repository does not deploy it | The docs site builds the gallery and serves it itself (`wind-demo.anilcancakir.com`) | A second deploy job here: it would publish a stale copy | Active |
| The lockfile is not tracked | A library's consumers resolve their own dependency graph | Tracking it: CI would pin versions no consumer resolves and hide a breaking upper bound | Active |
| `WInput` draws its own selection handles and toolbar | The package no longer imports `cupertino_ui`, and a bare `WidgetsApp` root still gets handles and a menu | The Cupertino handles and toolbar, which were the only use of `cupertino_ui` | Active |
| Shadow, radius, ring and gradient names follow Tailwind v3 | Wind 1.0 is anchored to Tailwind v3 semantics (`skills/wind-ui/references/tailwind-divergence.md`) | Adopting the v4 renames | Active |

## Where to look

- Architecture: `ARCHITECTURE.md`
- Commands, conventions and the release steps: `CLAUDE.md`
- Shipped history and the reasoning behind each change: `CHANGELOG.md`
- User docs: `doc/`; agent skill: `skills/wind-ui/`

Last reviewed: 2026-11-14, claims checked against the repository after the 1.12.0 release.
