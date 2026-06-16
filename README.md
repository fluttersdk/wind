<p align="center">
  <img src=".github/wind-logo.svg" width="120" alt="Wind Logo" />
</p>

<h1 align="center">Wind</h1>

<p align="center">
  <strong>Rapidly build modern Flutter apps without ever leaving your widget tree.</strong><br/>
  A utility-first styling framework for Flutter. Tailwind-syntax <code>className</code> strings, 22 W-prefix widgets, dark mode, responsive prefixes, and three AI integration layers shipped with the package.
</p>

<p align="center">
  <a href="https://pub.dev/packages/fluttersdk_wind"><img src="https://img.shields.io/pub/v/fluttersdk_wind.svg" alt="pub package"></a>
  <a href="https://github.com/fluttersdk/wind/actions"><img src="https://img.shields.io/github/actions/workflow/status/fluttersdk/wind/deploy.yml?branch=master&label=CI" alt="CI"></a>
  <a href="https://pub.dev/packages/fluttersdk_wind/score"><img src="https://img.shields.io/pub/points/fluttersdk_wind" alt="pub points"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
</p>

<p align="center">
  <a href="https://fluttersdk.com/wind">Documentation</a> ·
  <a href="https://pub.dev/packages/fluttersdk_wind">pub.dev</a> ·
  <a href="https://github.com/fluttersdk/wind/issues">Issues</a>
</p>

---

> [!NOTE]
> Requires Flutter >= 3.27.0 and Dart >= 3.4.0. Stable since 1.0. Open Source. Tailwind syntax. Flutter native.

## Installation

```bash
flutter pub add fluttersdk_wind
```

Wrap your app in `WindTheme`, then write `className` strings. The full setup walkthrough, all 22 widgets, every parser token, the 24 theme fields, and the three AI integration layers live at the [Getting Started guide](https://fluttersdk.com/wind/getting-started/installation).

## Why Wind?

Do you like using Tailwind CSS to style your UIs? **This helps you do that in Flutter.**

Wind is **not** a widget library. It is a utility-first styling engine that maps Tailwind-syntax `className` strings to optimized Flutter widget trees, with a 24-field theme, 19 parsers, and 22 W-prefix widgets. Flutter's structural styling produces six-widget pyramids for a rounded card with a hover state. The Flutter team itself acknowledged the [verbosity pain](https://github.com/flutter/flutter/issues/161345), ran an experimental Decorators feature, found mixed results, and shelved it. Wind closes that gap.

```dart
// Before: Flutter native (15 lines)
Container(
  padding: EdgeInsets.all(24),
  margin: EdgeInsets.symmetric(horizontal: 16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 4))],
  ),
  child: Text('Hello', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
)

// After: Wind (4 lines)
WDiv(
  className: 'p-6 mx-4 bg-white dark:bg-gray-800 rounded-xl shadow-lg',
  child: WText('Hello', className: 'text-xl font-bold'),
)
```

**If you know Tailwind CSS, you already know Wind.**

| Library | Approach | Wind difference |
|:---|:---|:---|
| **[velocity_x](https://pub.dev/packages/velocity_x)** (1.47k likes) | Dart property chains: `'text'.text.xl4.bold.make()` | Wind uses actual Tailwind className strings, paste-compatible with web Tailwind. Plus dark mode, state prefixes, MCP server. |
| **[getwidget](https://pub.dev/packages/getwidget)** (2.57k likes) | Pre-built component library (1000+ widgets) | Wind is styling system, not components. Composes with getwidget if you want both. |
| **[tailwind_flutter](https://pub.dev/packages/tailwind_flutter)** | Chainable extensions: `.p(TwSpacing.s4)` | Wind uses string className, supports `hover:` / `focus:` / `dark:` / `ios:` prefixes, production-stable since 1.0. |
| **[styled_widget](https://pub.dev/packages/styled_widget)** (917 likes, abandoned 2022) | Method chaining on `Widget` | Wind is actively maintained, ships with MCP + skills + 90% coverage gate. |
| **[shadcn_flutter](https://pub.dev/packages/shadcn_flutter)** | Component catalog (shadcn/ui port) | Wind is the utility-class system that composes WITH shadcn_flutter or any component library. |
| **[mix_tailwinds](https://pub.dev/packages/mix_tailwinds)** | Mix-based stylers, alpha | "Highly experimental proof of concept" per author. Wind is production-stable since 1.0. |

## Features

| | Feature | Description |
|:--|:--------|:------------|
| 🎨 | **Tailwind syntax, natively** | Same utility classes you write on the web: `flex`, `p-4`, `bg-blue-500`, `rounded-lg`, `shadow-md`. Paste classes between web and Flutter; they work unmodified. |
| 🧩 | **22 W-prefix widgets** | `WDiv`, `WText`, `WButton`, `WInput`, `WSelect`, `WPopover`, `WDatePicker`, `WDynamic`, and 5 `FormField` wrappers (`WFormInput`, `WFormSelect`, `WFormMultiSelect`, `WFormCheckbox`, `WFormDatePicker`). |
| 📱 | **Responsive prefixes** | `sm:`, `md:`, `lg:`, `xl:`, `2xl:` breakpoints, plus custom breakpoints via the theme. |
| 🌙 | **First-class dark mode** | `dark:` prefix with runtime toggle and automatic system-brightness sync. Every color token carries its `dark:` pair in the same className. |
| 🎯 | **State prefixes** | `hover:`, `focus:`, `disabled:`, `loading:`, `selected:`, and any custom state. Zero `MouseRegion`, zero `setState`, zero `_isHovered` booleans. |
| 🔌 | **Platform prefixes** | `ios:`, `android:`, `web:`, `mobile:` for conditional styling without a single `if`. Works on all 6 Flutter platforms. |
| 🎭 | **Customizable theme** | 24 configurable `WindThemeData` fields. Override every token scale: colors, spacing, typography, shadows, breakpoints, animations. Defaults match Tailwind v3 / v4. Define `aliases` to create bare-token className shortcuts expanded before parsing. |
| 📡 | **Server-driven UI** | `WDynamic` renders widget trees from JSON. Ship UI updates without ship-blocking releases. Whitelisted 13 Wind widgets + 16 Flutter core widgets. |
| 🤖 | **AI-first** | Canonical `wind-ui` skill at `skills/wind-ui/` and a hosted MCP server at `mcp.fluttersdk.com`, distributed to 8+ agents (Claude Code, Cursor, OpenCode, Gemini CLI, VS Code Copilot, Codex CLI, Cline, Roo Code) via [fluttersdk/ai](https://github.com/fluttersdk/ai). No other Flutter styling library ships this. |

> [!IMPORTANT]
> Every `bg-*`, `text-*`, `border-*`, `ring-*`, `fill-*` token carries a `dark:` pair in the SAME className block. Missing dark pair is a bug. Wind's parser logs a warning in `kDebugMode` when it detects an unpaired color token.

## AI Coding Assistants

Wind ships AI-first. The skill at [`skills/wind-ui/SKILL.md`](skills/wind-ui/SKILL.md) teaches your agent the className grammar, widget surface, dark-mode pairing rules, and anti-patterns. The same skill is distributed through [**fluttersdk/ai**](https://github.com/fluttersdk/ai) for Claude Code, Cursor, OpenCode, Gemini CLI, VS Code Copilot, Codex CLI, Cline, and Roo Code, one command:

```bash
npx skills add fluttersdk/ai --skill wind-ui
```

The hosted MCP server at `mcp.fluttersdk.com` exposes a `search-docs` tool over Streamable HTTP (no auth). For stdio-only clients, the `npx @fluttersdk/mcp` bridge proxies stdio to the upstream HTTP server. The LLM-readable inventory lives at [`llms.txt`](llms.txt). Full multi-client wire-up and the OpenCode registry URL live in the [fluttersdk/ai README](https://github.com/fluttersdk/ai).

## Examples

The [`example/`](example/) directory ships a navigable showcase covering every widget, parser, prefix, and theme pattern. Run locally:

```bash
cd example && flutter pub get
flutter run -d chrome
```

Or browse the docs site, which embeds every page live: [fluttersdk.com/wind](https://fluttersdk.com/wind).

```dart
// One className, dark mode + responsive + state + platform prefixes stacked
WDiv(
  className: '''
    flex flex-col gap-4 p-6
    bg-white dark:bg-gray-800
    rounded-xl shadow-lg
    md:flex-row md:gap-6
    ios:rounded-2xl
    hover:shadow-xl
  ''',
  children: [
    WText('Wind', className: 'text-xl font-bold text-gray-900 dark:text-white'),
    WText('Tailwind for Flutter', className: 'text-base text-gray-600 dark:text-gray-300'),
  ],
)
```

## Documentation

Full docs with live examples at **[fluttersdk.com/wind](https://fluttersdk.com/wind)**: every widget, every parser token, the 24 theme fields, dark mode, responsive design, server-driven UI via `WDynamic`, and the AI integration setup. The internal architecture lives in [`ARCHITECTURE.md`](ARCHITECTURE.md). The LLM-readable inventory lives in [`llms.txt`](llms.txt).

## Contributing

```bash
git clone https://github.com/fluttersdk/wind.git
cd wind && flutter pub get
flutter test && dart analyze
```

CI enforces 90%+ line coverage on `lib/` on every push, zero analyze issues, zero format drift on `lib/`, `test/`, and `example/lib/`. New behavior ships with a failing test first (red, green, refactor).

Before opening a pull request, run the same checks CI runs:

```bash
dart format --output=none --set-exit-if-changed .
dart analyze
flutter test
./tool/coverage.sh 90
dart pub publish --dry-run
```

[Report a bug](https://github.com/fluttersdk/wind/issues/new?template=bug_report.yml) · [Request a feature](https://github.com/fluttersdk/wind/issues/new?template=feature_request.yml)

## License

MIT, see [LICENSE](LICENSE) for details.

---

<p align="center">
  <sub>Built with care by <a href="https://github.com/fluttersdk">FlutterSDK</a></sub><br/>
  <sub>If Wind saved you a <code>Container</code> or two, <a href="https://github.com/fluttersdk/wind">give it a star</a>, it helps others discover it.</sub>
</p>
