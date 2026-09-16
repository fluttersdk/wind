<p align="center">
  <img src=".github/wind-logo.svg" width="120" alt="Wind" />
</p>

<p align="center">
  <strong>Tailwind CSS for Flutter.</strong><br/>
  Utility-first styling that turns <code>className</code> strings into optimized Flutter widget trees. If you know Tailwind, you already know Wind.
</p>

<p align="center">
  <a href="https://pub.dev/packages/fluttersdk_wind"><img src="https://img.shields.io/pub/v/fluttersdk_wind.svg" alt="pub package"></a>
  <a href="https://github.com/fluttersdk/wind/actions"><img src="https://img.shields.io/github/actions/workflow/status/fluttersdk/wind/deploy.yml?branch=master&label=CI" alt="CI"></a>
  <a href="https://pub.dev/packages/fluttersdk_wind/score"><img src="https://img.shields.io/pub/points/fluttersdk_wind" alt="pub points"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
</p>

<p align="center">
  <a href="https://fluttersdk.com/wind">Documentation</a> ·
  <a href="https://fluttersdk.com/wind/getting-started/installation">Getting started</a> ·
  <a href="https://pub.dev/packages/fluttersdk_wind">pub.dev</a> ·
  <a href="https://github.com/fluttersdk/wind/issues">Issues</a>
</p>

---

Flutter's structural styling costs you a six widget pyramid for a rounded card with a hover state, and the Flutter team has acknowledged the [verbosity](https://github.com/flutter/flutter/issues/161345) itself. Wind is the styling layer that closes the gap: one string, one widget, the same utility names you already write on the web.

```dart
WDiv(
  className: 'p-6 mx-4 bg-white dark:bg-gray-800 rounded-xl shadow-lg',
  child: WText('Hello', className: 'text-xl font-bold'),
)
```

<details>
<summary>The same thing in raw Flutter (click to show)</summary>

```dart
Container(
  padding: EdgeInsets.all(24),
  margin: EdgeInsets.symmetric(horizontal: 16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 4)),
    ],
  ),
  child: Text('Hello', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
)
```

</details>

Wind is a styling engine, not a widget catalogue. It composes with whatever component library you already use.

## Install

```bash
flutter pub add fluttersdk_wind
```

Wrap the app once, then style everything with strings:

```dart
import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return WindTheme(
      data: WindThemeData(),
      builder: (context, controller) => MaterialApp(
        theme: controller.toThemeData(),
        home: const Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
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
        WButton(
          className: 'px-4 py-2 rounded-lg bg-blue-500 dark:bg-blue-600 hover:bg-blue-600',
          onTap: () {},
          child: const WText('Get started', className: 'text-white font-medium'),
        ),
      ],
    );
  }
}
```

That runs as written. No `MouseRegion`, no `setState`, no `_isHovered` boolean, no `MediaQuery` branch for the tablet layout.

## What you get

- **The Tailwind vocabulary you already know.** `flex`, `p-4`, `bg-blue-500`, `rounded-lg`, `shadow-md`, parsed by 20 token parsers. Classes paste between a web project and a Flutter one unmodified.
- **27 W-prefix widgets.** `WDiv`, `WText`, `WButton`, `WInput`, `WSelect`, `WPopover`, `WDatePicker`, `WCard`, `WTabs`, `WBadge`, `WSwitch`, `WRadio`, `WDynamic`, and five `FormField` wrappers that drop straight into a Flutter `Form`.
- **Prefixes that stack.** `dark:`, `sm:` to `2xl:`, `hover:` / `focus:` / `disabled:` / `loading:` / `selected:`, and `ios:` / `android:` / `web:` / `mobile:` / `macos:` / `windows:` / `linux:` for the cases where one platform genuinely differs.
- **A theme you own.** 24 `WindThemeData` fields covering every token scale: colors, spacing, typography, shadows, breakpoints, animations. Defaults track Tailwind's own. `aliases` let you name a bare token once and use it everywhere.
- **Variant composition.** `WindRecipe` and `WindSlotRecipe` build a className (or a per-slot map) from a base, variant axes, compound variants and a caller override, in a strict emission order with no merge magic to reason about.
- **Forms that behave on a phone.** A focused field lifts the whole input clear of the keyboard and of the keyboard toolbar above it, not just the line the caret sits on. A control with an `onTap` is one traversal stop and activates on Enter, Space, a gamepad A button and a TV remote.
- **Server-driven UI.** `WDynamic` renders a widget tree from JSON against a whitelist of 13 Wind widgets and 16 Flutter core widgets, so a layout change can ship without a store release.
- **Written for agents as much as for people.** A canonical skill, a hosted MCP server and an `llms.txt` inventory, all maintained in this repository.

## className rules worth knowing before the first line

| Rule | What it means |
|:---|:---|
| Prefix order | `<state>:<breakpoint>:<dark>:<platform>:<utility>`, and prefixes stack freely. |
| Conflicts | The last class in a family wins. `p-2 p-6` is padding 6. |
| Dark mode | Every color token carries its `dark:` pair in the SAME className. A missing pair is a bug, and the parser says so once in `kDebugMode`. |
| Unknown tokens | Dropped silently in release, named once in debug. A typo never throws and never renders a red screen. |
| Spacing scale | One step is 4 logical pixels, so `p-4` is 16. Font size and tracking are pixel based too. |
| Caching | A parsed className is cached on `className + breakpoint + brightness + platform + states`, so rebuilds cost a map lookup. |

Wind is not a literal Tailwind port. Transforms, filters, `group-*` / `peer-*`, container queries and `@apply` have no Flutter counterpart and are deliberately out of scope; the full list lives in the [docs](https://fluttersdk.com/wind).

## For coding agents

Wind ships its own agent surface rather than hoping a model guessed right:

```bash
npx skills add fluttersdk/ai --skill wind-ui
```

The skill at [`skills/wind-ui/SKILL.md`](skills/wind-ui/SKILL.md) is the source of truth for the className grammar, the widget surface, the dark-mode pairing rule and the anti-patterns. [fluttersdk/ai](https://github.com/fluttersdk/ai) distributes it to Claude Code, Cursor, OpenCode, Gemini CLI, VS Code Copilot, Codex CLI, Cline and Roo Code. The hosted MCP server at `mcp.fluttersdk.com` exposes a `search-docs` tool over Streamable HTTP with no auth, and `npx @fluttersdk/mcp` bridges it for stdio-only clients. The machine-readable package inventory is [`llms.txt`](llms.txt).

## Documentation and examples

Full documentation with live previews is at [fluttersdk.com/wind](https://fluttersdk.com/wind): every widget, every parser token, the theme fields, dark mode, responsive design, `WDynamic`, and the AI setup. Upgrading from an earlier release? See the [upgrade guide](doc/getting-started/upgrade-guide.md). Internals live in [ARCHITECTURE.md](ARCHITECTURE.md).

The [`example/`](example/) directory is the same gallery the docs site embeds:

```bash
cd example && flutter pub get
flutter run -d chrome
```

Requires Flutter 3.27.0 and Dart 3.4.0 or newer. Stable since 1.0, MIT licensed, and the only runtime dependencies are `flutter_svg` and the diagnostics contracts package.

## Contributing

```bash
git clone https://github.com/fluttersdk/wind.git
cd wind && flutter pub get
```

New behaviour ships with a failing test first. Before opening a pull request, run what CI runs:

```bash
dart format --output=none --set-exit-if-changed .
dart analyze
flutter test
./tool/coverage.sh 90
dart pub publish --dry-run
```

CI enforces 90% line coverage on `lib/`, zero analyzer issues and zero format drift.

[Report a bug](https://github.com/fluttersdk/wind/issues/new?template=bug_report.yml) · [Request a feature](https://github.com/fluttersdk/wind/issues/new?template=feature_request.yml)

## License

MIT, see [LICENSE](LICENSE) for details.

---

<p align="center">
  <sub>Wind is the styling layer of the <a href="https://github.com/fluttersdk">fluttersdk</a> ecosystem, and it works perfectly well on its own.</sub><br/>
  <sub>If Wind saved you a <code>Container</code> or two, <a href="https://github.com/fluttersdk/wind">give it a star</a>, it helps others find it.</sub>
</p>
