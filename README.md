<p align="center">
  <img src="https://raw.githubusercontent.com/anilcancakir/wind_kit/master/.github/wind-kit-logo.svg" width="120" alt="wind_kit logo" />
</p>

<h1 align="center">wind_kit</h1>

<p align="center">
  <strong>Tailwind CSS for Flutter.</strong><br/>
  Utility-first <code>className</code> styling: <code>'flex p-4 dark:bg-gray-800'</code> becomes an optimised widget tree, with dark mode, responsive breakpoints, hover states and theming built in. No codegen.
</p>

<p align="center">
  <a href="https://pub.dev/packages/wind_kit"><img src="https://img.shields.io/pub/v/wind_kit.svg" alt="pub package"></a>
  <a href="https://github.com/anilcancakir/wind_kit/actions/workflows/ci.yml"><img src="https://img.shields.io/github/actions/workflow/status/anilcancakir/wind_kit/ci.yml?branch=master&label=CI" alt="CI"></a>
  <a href="https://codecov.io/gh/anilcancakir/wind_kit"><img src="https://codecov.io/gh/anilcancakir/wind_kit/graph/badge.svg" alt="codecov"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
  <a href="https://pub.dev/packages/wind_kit/score"><img src="https://img.shields.io/pub/points/wind_kit" alt="pub points"></a>
</p>

<p align="center">
  <a href="https://anilcancakir.com/wind_kit">Documentation</a> ·
  <a href="https://anilcancakir.com/wind_kit/docs/getting-started/installation">Getting started</a> ·
  <a href="https://pub.dev/packages/wind_kit">pub.dev</a> ·
  <a href="https://github.com/anilcancakir/wind_kit/issues">Issues</a>
</p>

## At a glance

| Fact | Value |
|---|---|
| Package | [`wind_kit`](https://pub.dev/packages/wind_kit) |
| Install | `flutter pub add wind_kit` |
| Import | `package:wind_kit/wind_kit.dart` (the only barrel) |
| Entry points | `WindTheme` and `WindThemeData`, the W-prefix widgets (`WDiv`, `WText`, `WButton`, `WInput`, `WSelect`, ...), `WindRecipe`, `WDynamic` |
| Platforms | Android, iOS, web, macOS, Windows and Linux; web builds compile to WebAssembly |
| Requires | Dart >=3.4, Flutter >=3.27 |
| Dependencies | `flutter_svg`, `wind_kit_diagnostics_contracts` |
| License | MIT |

## Why wind_kit

A rounded card with a dark theme, a shadow and a hover state costs a pyramid of widgets in plain Flutter, and the Flutter team has acknowledged the [verbosity](https://github.com/flutter/flutter/issues/161345) itself. wind_kit closes the gap with the utility names you already write on the web: one string, one widget.

```dart
WDiv(
  className: 'p-6 mx-4 bg-white dark:bg-gray-800 rounded-xl shadow-lg hover:shadow-xl',
  child: WText('Hello', className: 'text-xl font-bold'),
)
```

<details>
<summary>The same card in plain Flutter (click to show)</summary>

```dart
Widget card(BuildContext context) {
  final bool dark = Theme.of(context).brightness == Brightness.dark;

  return Container(
    padding: const EdgeInsets.all(24),
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: dark ? const Color(0xFF1F2937) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), blurRadius: 15, offset: Offset(0, 10), spreadRadius: -3),
        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.05), blurRadius: 6, offset: Offset(0, 4), spreadRadius: -2),
      ],
    ),
    child: const Text('Hello', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  );
}
```

That is before the hover state, which needs a `StatefulWidget`, a `MouseRegion` and a second set of shadows.

</details>

wind_kit is a styling engine, not a widget catalogue. It composes with whatever component library you already use.

## Install

```bash
flutter pub add wind_kit
```

Wrap the app once, then style everything with strings:

```dart
import 'package:flutter/material.dart';
import 'package:wind_kit/wind_kit.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return WindTheme(
      data: WindThemeData(),
      builder: (context, controller) => MaterialApp(
        theme: controller.toThemeData(),
        home: const Scaffold(body: Center(child: Home())),
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
        flex flex-col gap-4 p-6 w-full max-w-md
        bg-white dark:bg-gray-800
        rounded-xl shadow-lg
        md:flex-row md:gap-6
        ios:rounded-2xl
        hover:shadow-xl
      ''',
      children: [
        WText('wind_kit', className: 'text-xl font-bold text-gray-900 dark:text-white'),
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

## The className language

wind_kit reads Tailwind's vocabulary (`flex`, `p-4`, `bg-blue-500`, `rounded-lg`, `shadow-md`) through a set of token parsers, and the W-prefix widgets that style themselves accept it: `WDiv`, `WText`, `WButton`, `WInput`, `WSelect`, `WPopover`, `WDatePicker`, `WCard`, `WTabs`, `WBadge`, `WSwitch`, `WRadio` and the `WForm*` wrappers that drop straight into a Flutter `Form`.

| Rule | What it means |
|:---|:---|
| Prefixes | `dark:`, `sm:` to `2xl:`, `hover:` / `focus:` / `disabled:` / `loading:` / `selected:` and `ios:` / `android:` / `web:` / `mobile:` / `macos:` / `windows:` / `linux:` stack freely. By convention `<state>:<breakpoint>:<dark>:<platform>:<utility>` reads best, but order does not matter. |
| Conflicts | The last class in a family wins. `p-2 p-6` is padding 6. |
| Dark mode | Every colour token carries its `dark:` pair in the SAME className. Nothing checks it for you, so review it: `bg-white` alone stays white in dark mode. |
| Unknown tokens | An unknown family (`ps-4`) is dropped with a one-time `kDebugMode` hint. A known family with a bad value (`text-7xl`, `bg-blu-500`) or a mistyped prefix (`hovr:`) drops silently. A typo never throws and never renders a red screen. |
| Spacing scale | One step is 4 logical pixels, so `p-4` is 16. Font size is pixel based too; tracking is em, as in Tailwind, so `tracking-tight` on 14px text is -0.35. |
| Press state | `active:` is not wired to the pointer. Track the press in your own state and pass `states: {'pressed'}` with `pressed:` classes. |
| Caching | A parsed className is cached on `className + breakpoint + brightness + platform + states`, so rebuilds cost a map lookup. |

wind_kit is not a literal Tailwind port: most classes paste between a web project and a Flutter one, and the gaps are listed. Transforms, filters, `group-*` / `peer-*`, container queries and `@apply` have no Flutter counterpart and are deliberately out of scope.

## Theming

A `WindThemeData` holds the token scales (colours, spacing, typography, shadows, breakpoints, animations) and `aliases`. Defaults track Tailwind's own, and an alias names a bare token once for every widget.

```dart
WindTheme(
  data: WindThemeData(
    aliases: {'btn-primary': 'bg-blue-600 dark:bg-blue-500 text-white px-4 py-2 rounded-lg'},
  ),
  builder: (context, controller) => MaterialApp(
    theme: controller.toThemeData(),
    home: Scaffold(
      body: WButton(
        className: 'btn-primary',
        onTap: controller.toggleTheme,
        child: const WText('Toggle theme'),
      ),
    ),
  ),
)
```

| Member | Meaning |
|:---|:---|
| `WindThemeData(colors:, screens:, fontSizes:, aliases:, baseSpacingUnit: ...)` | Merged over the defaults, so you pass only what you change. |
| `controller.toggleTheme()` / `resetToSystem()` | Flip light and dark by hand, or follow the OS again. |
| `context.windTheme`, `context.windIsDark`, `context.wActiveBreakpoint` | Read the theme, the brightness and the breakpoint from any `BuildContext`. |

Failure modes: a widget outside a `WindTheme` fails an assertion in debug, and a colour name the theme does not define drops silently.

## Responsive and dark mode

```dart
WDiv(
  className: 'flex flex-col md:flex-row gap-4 p-4 bg-white dark:bg-gray-900',
  children: [
    WDiv(className: 'flex-1 p-4 rounded-lg bg-gray-100 dark:bg-gray-800', child: WText('Left', className: 'text-gray-900 dark:text-white')),
    WDiv(className: 'flex-1 p-4 rounded-lg bg-gray-100 dark:bg-gray-800', child: WText('Right', className: 'text-gray-900 dark:text-white')),
  ],
)
```

| Prefix | Active when |
|:---|:---|
| `sm:` `md:` `lg:` `xl:` `2xl:` | The window is at least 640, 768, 1024, 1280 or 1536 px wide (the theme's `screens`, mobile first). |
| `dark:` | The theme brightness is dark, from the OS or from `toggleTheme()`. |
| `ios:` `android:` `web:` `mobile:` `macos:` `windows:` `linux:` | The app runs on that platform. |

Failure modes: inside a `Row` a child needs `flex-1` to fill the row, and `h-full` inside a scrollable parent throws an unbounded height assertion; give the scrolling child `flex-1 overflow-y-auto` inside a bounded column.

## Variants

`WindRecipe` and `WindSlotRecipe` build a className from a base, variant axes, compound variants and a caller override, in a strict emission order with no merge magic to reason about.

```dart
final button = WindRecipe(
  base: 'flex flex-row items-center rounded-lg font-medium',
  variants: {
    'intent': {
      'primary': 'bg-blue-600 dark:bg-blue-500 text-white',
      'ghost': 'bg-transparent text-blue-600 dark:text-blue-400',
    },
    'size': {'sm': 'px-3 py-1.5 text-sm', 'md': 'px-4 py-2 text-base'},
  },
  defaultVariants: {'intent': 'primary', 'size': 'md'},
);

final String className = button(variants: {'intent': 'ghost'});
```

| Member | Meaning |
|:---|:---|
| `WindRecipe(base:, variants:, compoundVariants:, defaultVariants:)` | One component's classNames. Calling it returns the className string. |
| `recipe(variants: {...}, className: '...')` | Override axes per call (`null` clears a default); the caller className is appended last. |
| `WindCompoundVariant(conditions:, className:)` | Classes that apply only when every condition matches. |
| `WindSlotRecipe` | The same for components with several parts: returns a map of slot to className. |

Failure modes: the recipe appends the caller's className last and never dedupes (there is no `twMerge`), and a variant that overrides a border width or radius of the base must name every side or corner, because those families do not compose per side.

## Server-driven UI

`WDynamic` renders a widget tree from JSON against an allowlist of wind_kit and Flutter core widgets, so a layout change can ship without a store release.

```dart
WDynamic(
  json: const {
    'type': 'WDiv',
    'props': {'className': 'p-6 bg-white dark:bg-gray-800 rounded-xl'},
    'children': [
      {
        'type': 'WText',
        'props': {'text': 'Hello from JSON', 'className': 'text-xl font-bold text-gray-900 dark:text-white'},
      },
    ],
  },
)
```

| Member | Meaning |
|:---|:---|
| `json:` | The node tree: `type`, optional `props` and `children`. |
| `denyWidgets:` / `builders:` | Block types from the allowlist, or add your own. |
| `actions:` / `controller:` | Named callbacks for `onTap` and friends, and the shared state the value widgets bind to by `id`. |
| `maxDepth:` / `onUnknownWidget:` / `onError:` | The recursion limit (default 50) and the stand-ins for a blocked type or a failed build. |

Failure modes: a type outside the allowlist is not built, and `className` and image `src` values in untrusted JSON can load network and file images. A `className` such as `bg-[/path/to/file.png]` reads a local file on any allowed widget, `WDiv` included, and `WImage` fetches its `src` from the network, so denying `WImage` stops only the `src` fetch: sanitise every `className` and `src` from untrusted JSON either way. See the [security policy](SECURITY.md).

## Forms

The `WForm*` wrappers (`WFormInput`, `WFormSelect`, `WFormMultiSelect`, `WFormCheckbox`, `WFormDatePicker`) extend Flutter's `FormField`, so `Form` validation just works and a failed validator switches on the `error:` state.

```dart
WFormInput(
  label: 'Email',
  type: InputType.email,
  autovalidateMode: AutovalidateMode.onUserInteraction,
  className: 'rounded-lg p-3 border border-gray-300 dark:border-gray-600 error:border-red-500',
  validator: (value) => (value == null || !value.contains('@')) ? 'Invalid email' : null,
)
```

| Member | Meaning |
|:---|:---|
| `validator:` / `onSaved:` / `autovalidateMode:` | The standard `FormField` hooks. |
| `className:` with `error:` | Styles the field while the validator reports a message. |
| `label:` / `hint:` / `showError:` | The label, the hint and the error line around the field. |
| `WInput`, `WSelect`, `WCheckbox`, `WDatePicker` | The raw controls, for forms you manage yourself. |

A focused field lifts the whole input clear of the keyboard and of the keyboard toolbar above it, and a control with an `onTap` is one traversal stop that activates on Enter, Space, a gamepad A button and a TV remote. Failure modes: a `FormField` validator is synchronous, so server-side errors go through your own state and a second `validate()` call.

## For AI coding agents

Rules for an agent writing wind_kit code. Each one is a mistake the maintainers already made once.

| Do | Because |
|----|---------|
| Import only `package:wind_kit/wind_kit.dart` | There is one barrel and no sub-barrels. |
| Pair every colour token (`bg-`, `text-` colour, `border-`, `ring-`, `shadow-`, `fill-`) with its `dark:` peer in the same className | A missing pair is a bug and nothing reports it. |
| Route conditions through `states:` and prefixed classes, never Dart interpolation inside a className | An interpolated token hides from the dark-pair review and from grep, and every distinct string adds a cache entry. |
| Give a Row child `flex-1`; give a scrolling child of a bounded Column `flex-1 overflow-y-auto` | `h-full` inside a scrollable parent throws an unbounded height assertion. |
| Pass `child` or `children`, never both | Both fail an assertion at construction. |
| Spell-check token values by hand | A known family with an unsupported value (`text-7xl`) drops silently; only an unknown family prints the one-time debug hint. |
| Give an icon-only `WButton` a `semanticLabel` | Without it the control is nameless to screen readers. |
| Call `WindParser.clearCache()` in test `setUp` | The parser cache persists between tests and gives false positives. |
| Call `Wind.installDebugResolver()` once in `main`, behind `!kReleaseMode` | It exposes widget state to tools such as tapir and is tree-shaken from release builds; do not add it per screen. |

Install the skill, which is the source of truth for the className grammar, the widget surface and the anti-patterns:

```bash
npx skills add anilcancakir/wind_kit
```

It is also distributed through the [skill registry](https://github.com/anilcancakir/ai) (`npx skills add anilcancakir/ai --skill wind-ui`) to OpenCode, Claude Code, Cursor, Gemini CLI, Codex CLI, Antigravity CLI, Cline and Roo Code. The docs MCP server of anilcancakir.com (`https://mcp.anilcancakir.com/`, Streamable HTTP, no auth) exposes `list_packages`, `list_docs`, `search_docs` and `read_doc` over every package's documentation. The machine-readable inventory is [`llms.txt`](llms.txt), and internals are in [ARCHITECTURE.md](ARCHITECTURE.md).

## Dependencies

`flutter_svg` for `WSvg` and [`wind_kit_diagnostics_contracts`](https://pub.dev/packages/wind_kit_diagnostics_contracts), the neutral bridge through which debug tools read widget state without depending on wind_kit. That is the whole runtime surface: no state management library, no router, no mocking library.

## Links

- [Documentation](https://anilcancakir.com/wind_kit/docs/getting-started/installation): every widget, parser token, theme field, dark mode, responsive design and `WDynamic`, with live previews
- [Upgrade guide](https://anilcancakir.com/wind_kit/docs/getting-started/upgrade-guide)
- [API reference](https://pub.dev/documentation/wind_kit/latest/)
- [llms.txt](llms.txt) and the [agent skill](skills/wind-ui/SKILL.md): `npx skills add anilcancakir/wind_kit`
- [Changelog](CHANGELOG.md)
- [Contributing](CLAUDE.md): the commands CI runs, the post-change checklist and the release steps
- [Report a bug](https://github.com/anilcancakir/wind_kit/issues/new?template=bug_report.yml) · [Request a feature](https://github.com/anilcancakir/wind_kit/issues/new?template=feature_request.yml)
- [Security policy](SECURITY.md)

## License

MIT, see [LICENSE](LICENSE). Built by [Anılcan Çakır](https://anilcancakir.com).
