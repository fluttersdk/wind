<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset=".github/wind-logo.svg">
    <img src=".github/wind-logo.svg" width="120" alt="Wind Logo" />
  </picture>
</p>

<h1 align="center">Wind</h1>

<p align="center">
  <strong>Rapidly build modern Flutter apps without ever leaving your widget tree.</strong><br/>
  A utility-first styling framework for Flutter, packed with classes like <code>flex</code>, <code>p-4</code>, <code>dark:bg-gray-800</code>, <code>hover:scale-105</code>, and <code>md:flex-row</code> that compose into responsive, theme-aware widget trees.
</p>

<p align="center">
  <a href="https://pub.dev/packages/fluttersdk_wind"><img src="https://img.shields.io/pub/v/fluttersdk_wind.svg" alt="pub package"></a>
  <a href="https://github.com/fluttersdk/wind/actions"><img src="https://img.shields.io/github/actions/workflow/status/fluttersdk/wind/deploy.yml?branch=master&label=CI" alt="CI"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
  <a href="https://pub.dev/packages/fluttersdk_wind/score"><img src="https://img.shields.io/pub/points/fluttersdk_wind" alt="pub points"></a>
  <a href="https://pub.dev/packages/fluttersdk_wind/score"><img src="https://img.shields.io/pub/likes/fluttersdk_wind" alt="pub likes"></a>
  <a href="https://github.com/fluttersdk/wind/stargazers"><img src="https://img.shields.io/github/stars/fluttersdk/wind?style=flat" alt="GitHub stars"></a>
  <a href="https://github.com/fluttersdk/wind/blob/master/llms.txt"><img src="https://img.shields.io/badge/llms.txt-available-8A2BE2" alt="llms.txt available"></a>
</p>

<p align="center">
  <a href="#quick-start">Quick Start</a> ·
  <a href="https://fluttersdk.com/wind">Documentation</a> ·
  <a href="https://fluttersdk.com/wind/play">Playground</a> ·
  <a href="https://pub.dev/packages/fluttersdk_wind">pub.dev</a> ·
  <a href="#ai-coding-assistants">AI integrations</a> ·
  <a href="https://github.com/fluttersdk/wind/issues">Issues</a>
</p>

---

> [!NOTE]
> Requires Flutter >= 3.27.0 and Dart >= 3.4.0. Stable since 1.0. Open Source. Tailwind syntax. Flutter native.

## Quick install

```bash
flutter pub add fluttersdk_wind
```

That's it. Wrap your app in `WindTheme` and start writing `className` strings. Full setup at [Quick Start](#quick-start) below.

## Why Wind?

Do you like using Tailwind CSS to style your UIs? **This helps you do that in Flutter.**

Wind is **not** a widget library. It's a utility-first styling engine that maps Tailwind-syntax `className` strings to optimized Flutter widget trees, with a 23-field theme, 17 parsers, and 20 W-prefix widgets.

> *"What would be just two or three nested `<div>`s in HTML+CSS turns into several screens of widgets, making navigation and debugging much harder."*
> — [Hacker News, 2025](https://news.ycombinator.com/item?id=43228794)

Flutter's styling is structural. Padding goes one place, decoration goes another, layout goes a third, each wrapped in its own widget. A simple rounded card with a shadow and a hover state ends up six widgets deep before a single line of business logic. The pattern is so common it has a name: the **Pyramid of Doom**. The Flutter team itself acknowledged the verbosity pain in a public user study, ran a [Decorators experimental feature](https://github.com/flutter/flutter/issues/161345) to reduce nesting, found mixed results, and shelved it. The pain is structural and currently unsolved by the framework, except by Wind.

Wind replaces that pyramid with a single string:

```dart
// Before: Flutter native (15 lines)
Container(
  padding: EdgeInsets.all(24),
  margin: EdgeInsets.symmetric(horizontal: 16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      offset: Offset(0, 4),
    )],
  ),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  ),
)

// After: Wind (4 lines)
WDiv(
  className: 'p-6 mx-4 bg-white dark:bg-gray-800 rounded-xl shadow-lg',
  child: WText('Hello', className: 'text-xl font-bold'),
)
```

**If you know Tailwind CSS, you already know Wind.**

| Without Wind | With Wind |
|---|---|
| Six wrapper widgets per card, inconsistent dark-mode coverage, hover state needs `MouseRegion` + `bool` + `setState`. | One `className` string. Dark mode pairs inline. `hover:` / `focus:` / `disabled:` collapse to single tokens. |
| Edit one widget's color and grep four files for the matching dark-mode override. | `bg-white dark:bg-gray-800`. Pair lives on the same line. Missing dark pair is a bug. |
| Responsive logic via `LayoutBuilder` + breakpoint constants you defined yourself. | `flex-col md:flex-row lg:gap-8` in the `className`. Breakpoints live in the theme. |
| AI coding agents hallucinate `ThemeData` shapes, invent color names that do not exist. | MCP server + Claude Code skill + Cursor rules ship with the package. Agents resolve tokens against the live theme. |

## What you get

### 1. Familiar syntax, zero re-learning

Wind's `className` IS Tailwind CSS syntax. Paste `bg-blue-500 hover:bg-blue-600 dark:bg-blue-800 md:px-8` from your web project into a `WDiv`, and it works. Every other Flutter "Tailwind-inspired" library uses Dart property chaining (`.text.xl4.bold.make()`). Wind is the only one that accepts the original Tailwind className string verbatim.

### 2. Eliminates the Pyramid of Doom

Replace 15-line `Container` / `BoxDecoration` / `EdgeInsets` / `BorderRadius` / `BoxShadow` nesting with a single string. The widget tree stays flat as features pile up. `className` reads top-down, no more "what was this `Container` for?" archaeology six months later.

### 3. Dark mode as a first-class string-syntax citizen

Pair every color token inline. `bg-white dark:bg-gray-800`. No separate light / dark theme files. No `Theme.of(context).colorScheme` lookups.

> *"The moment you build a custom widget with hardcoded colors, dark mode breaks. Search your codebase for `Color(0x` and `Colors.` in widget files. Every instance is a potential dark mode bug."*
> — [flutterstudio.dev, March 2026](https://flutterstudio.dev/blog/flutter-dark-mode-guide.html)

Wind's `dark:` prefix is the only Flutter solution where dark mode lives inline in the className.

### 4. State prefixes as CSS-native primitives

`hover:bg-blue-600 focus:ring-2 active:scale-95 disabled:opacity-50 loading:cursor-wait`. Zero `MouseRegion`. Zero `setState`. Zero `_isHovered` booleans. Stack Overflow hover-state questions for Flutter recur every year from 2021 to 2025, all with the same 3-step boilerplate answer. Wind collapses it to one token.

### 5. AI-ready by design

Wind ships three AI integration layers: a hosted **MCP server** at `mcp.fluttersdk.com/wind`, a bundled **Claude Code skill**, and **Cursor rules**. No other Flutter styling library (`velocity_x`, `getwidget`, `styled_widget`, `tailwind_flutter`, `shadcn_flutter`) ships any of these. Your AI coding agent stops guessing className tokens.

### And

- 📦 **Battle-tested in real apps**: over 2K monthly downloads on [pub.dev](https://pub.dev/packages/fluttersdk_wind), shipping in production Flutter apps today, 1230 tests / 0 analyzer issues / 93.4% line coverage.
- ⚡ **Designs come together faster**: no class names to invent, no separate stylesheets, no switching between theme files and widget code.
- 🛡️ **Changes feel safer**: every utility class is scoped to its widget. Edit one, never accidentally break another.
- 📋 **Code is portable**: copy a `className` string between projects, between files, even between Wind and Tailwind on the web.
- 🌐 **Works on all 6 Flutter platforms**: Android, iOS, web, macOS, Windows, Linux. Use `ios:`, `android:`, `web:`, `mobile:` prefixes to target specific platforms in the same className.

## Quick Start

### 1. Install

```bash
flutter pub add fluttersdk_wind
```

### 2. Wrap with WindTheme

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WindTheme(
      data: WindThemeData(),
      builder: (context, controller) => MaterialApp(
        theme: controller.toThemeData(),
        home: const HomePage(),
      ),
    );
  }
}
```

### 3. Build with className

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WDiv(
        className: 'flex flex-col gap-6 p-6 bg-gray-50 dark:bg-gray-900 min-h-screen',
        children: [
          WText(
            'Welcome to Wind',
            className: 'text-3xl font-bold text-gray-900 dark:text-white',
          ),
          WDiv(
            className: 'bg-white dark:bg-gray-800 rounded-xl shadow-lg p-6',
            child: WText(
              'Utility-first styling, right in Flutter.',
              className: 'text-gray-600 dark:text-gray-300',
            ),
          ),
          WButton(
            onTap: () => print('Wind!'),
            className: 'bg-blue-600 hover:bg-blue-700 text-white px-6 py-3 rounded-lg',
            child: Text('Get Started'),
          ),
        ],
      ),
    );
  }
}
```

### 4. (Debug only) Wire diagnostics

```dart
if (kDebugMode) Wind.installDebugResolver();
```

Exposes Wind state (`className`, `breakpoint`, `brightness`, `platform`, `states`, `bgColor`, `textColor`) to any consumer of `WindDebugRegistry.current` (E2E drivers, runtime inspectors). Idempotent; release builds tree-shake.

## The Wind Surface

| Category | Count | What ships |
|:---|:---:|:---|
| **Widgets** | 20 | `WDiv`, `WText`, `WButton`, `WInput`, `WSelect`, `WCheckbox`, `WDatePicker`, `WIcon`, `WImage`, `WSvg`, `WPopover`, `WAnchor`, `WBreakpoint`, `WSpacer`, `WDynamic`, plus 5 `FormField` wrappers (`WFormInput`, `WFormSelect`, `WFormMultiSelect`, `WFormCheckbox`, `WFormDatePicker`) |
| **Parsers** | 17 | background (color / gradient / image), border, ring, shadow, opacity, padding, margin, sizing, flexbox + grid, position, order, overflow, aspect-ratio, z-index, text, animation, transition, SVG, debug |
| **Theme tokens** | 23 | brightness, colors, screens, containers, fontSizes, fontWeights, tracking, leading, borderWidths, borderRadius, fontFamilies, ringWidths, ringOffsets, applyDefaultFontFamily, syncWithSystem, baseSpacingUnit, ringColor, opacities, zIndices, shadows, transitionDurations, transitionCurves, animations |
| **Prefixes** | All | `hover:` `focus:` `disabled:` `loading:` `selected:` + custom states · `dark:` · `sm:` / `md:` / `lg:` / `xl:` / `2xl:` + custom breakpoints · `ios:` / `android:` / `web:` / `mobile:` |

## Why not [competitor]?

| Library | Approach | Wind difference |
|:---|:---|:---|
| **[velocity_x](https://pub.dev/packages/velocity_x)** (1.47k likes) | Dart property chains: `'text'.text.xl4.bold.make()` | Wind uses **actual Tailwind className strings**, paste-compatible with web Tailwind. Plus dark mode, state prefixes, MCP server. |
| **[getwidget](https://pub.dev/packages/getwidget)** (2.57k likes) | Pre-built component library (1000+ widgets) | Wind is **styling system, not components**, applies anywhere, no opinionated visuals. Composes with getwidget if you want both. |
| **[tailwind_flutter](https://pub.dev/packages/tailwind_flutter)** (4 likes) | Chainable extensions: `.p(TwSpacing.s4)` | Wind uses **string className**, supports `hover:` / `focus:` / `dark:` / `ios:` prefixes, **production-stable since 1.0**. |
| **[styled_widget](https://pub.dev/packages/styled_widget)** (917 likes, abandoned 2022) | Method chaining on `Widget` | Wind is **actively maintained**, ships with MCP + skills + 90% coverage gate. |
| **[shadcn_flutter](https://pub.dev/packages/shadcn_flutter)** (445 likes) | Component catalog (shadcn/ui port) | Wind is **utility-class system**, composes WITH shadcn_flutter or any component library. |
| **[mix_tailwinds](https://pub.dev/packages/mix_tailwinds)** (alpha) | Mix-based stylers, alpha | Author's own README: "highly experimental proof of concept". Wind is **production-stable since 1.0**. |

## Widgets in action

### Layout & Container

```dart
// Flex row with gap
WDiv(
  className: 'flex flex-row gap-4 p-4 bg-white dark:bg-gray-800 rounded-lg shadow',
  children: [sidebar, content],
)

// Responsive grid
WDiv(
  className: 'grid grid-cols-1 md:grid-cols-3 gap-6',
  children: cards,
)

// Scrollable container
WDiv(
  className: 'w-full h-full overflow-y-auto p-4',
  child: longContent,
)
```

### Typography

```dart
WText('Heading', className: 'text-2xl font-bold text-gray-900 dark:text-white')
WText('Body text', className: 'text-base text-gray-600 dark:text-gray-300 leading-relaxed')
WText('LABEL', className: 'text-xs font-semibold uppercase tracking-wider text-gray-500')
```

### Forms

Wind ships two flavors per input. `W*` (e.g. `WInput`, `WSelect`, `WDatePicker`) are raw controlled widgets. `WForm*` variants extend `FormField` for use inside a `Form` with validators and `FormState`.

```dart
// Text input with validation (FormField variant)
WFormInput(
  label: 'Email',
  placeholder: 'you@example.com',
  type: InputType.email,
  className: 'p-3 border rounded-lg focus:ring-2 focus:ring-blue-500',
  validator: (v) => v == null || !v.contains('@') ? 'Invalid email' : null,
)

// Searchable dropdown
WFormSelect<String>(
  label: 'Country',
  initialValue: _country,
  options: countries,
  searchable: true,
  validator: (v) => v == null ? 'Required' : null,
)

// Date picker
WFormDatePicker(
  label: 'Start Date',
  initialValue: DateTime.now(),
  onChanged: (date) => print('Selected: $date'),
)
```

### Interactive

```dart
// Button with hover, focus, and loading states
WButton(
  onTap: _submit,
  isLoading: _isSubmitting,
  className: 'bg-blue-600 hover:bg-blue-700 focus:ring-2 loading:bg-blue-400 text-white px-6 py-3 rounded-lg',
  child: Text('Submit'),
)

// Popover menu
WPopover(
  alignment: PopoverAlignment.bottomRight,
  className: 'w-64 bg-white dark:bg-gray-800 rounded-lg shadow-xl p-2',
  triggerBuilder: (context, isOpen, isHovering) => WButton(
    className: 'bg-gray-100 hover:bg-gray-200 px-4 py-2 rounded-lg',
    child: Text('Menu'),
  ),
  contentBuilder: (context, close) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ListTile(title: Text('Profile'), onTap: close),
      ListTile(title: Text('Settings'), onTap: close),
    ],
  ),
)
```

### Media

```dart
WIcon(Icons.star_outlined, className: 'text-yellow-500 text-3xl')
WImage(src: 'https://example.com/photo.jpg', className: 'w-full aspect-video object-cover rounded-xl')
WSvg(src: 'assets/logo.svg', className: 'fill-blue-600 w-12 h-12')
```

### Server-Driven UI

```dart
// Render UI from JSON, ship UI updates without ship-blocking releases
WDynamic(
  json: serverResponse,
  actions: {
    'submit': (ctx, payload) => api.submit(payload),
  },
  customIcons: {'app-logo': Icons.flutter_dash},
  builders: {
    'chart': (props, children) => MyChartWidget(props),
  },
)
```

## Supported utilities

<details>
<summary><strong>Layout</strong>: flex, grid, positioning, overflow</summary>

`flex` `flex-row` `flex-col` `flex-row-reverse` `flex-col-reverse` `flex-wrap` `flex-1` `grid` `grid-cols-{n}` `gap-{n}` `justify-center` `justify-between` `items-center` `items-start` `self-center` `wrap` `hidden` `overflow-hidden` `overflow-y-auto` `relative` `absolute` `top-{n}` `right-{n}` `bottom-{n}` `left-{n}` `inset-{n}` `inset-x-{n}` `inset-y-{n}` `top-[24px]` `left-[24px]` `-top-{n}` `-inset-{n}` `order-0` through `order-12` `order-first` `order-last`

</details>

<details>
<summary><strong>Sizing</strong>: width, height, constraints</summary>

`w-full` `w-1/2` `w-[200px]` `h-screen` `h-full` `min-h-screen` `max-w-lg` `max-w-[600px]` `aspect-square` `aspect-video`

</details>

<details>
<summary><strong>Spacing</strong>: padding, margin</summary>

`p-{n}` `px-{n}` `py-{n}` `pt-{n}` `m-{n}` `mx-auto` `mt-{n}` `mb-{n}` `-mt-{n}` `space-x-{n}` `gap-{n}`

</details>

<details>
<summary><strong>Typography</strong>: size, weight, style, alignment</summary>

`text-xs` `text-sm` `text-base` `text-lg` `text-xl` `text-2xl` `text-3xl` `text-4xl` `text-5xl` `text-6xl` `font-bold` `font-semibold` `font-medium` `font-light` `italic` `uppercase` `lowercase` `capitalize` `underline` `line-through` `truncate` `text-center` `text-right` `leading-tight` `leading-relaxed` `tracking-wider`

</details>

<details>
<summary><strong>Colors</strong>: background, text, border, opacity</summary>

`bg-{color}-{shade}` `text-{color}-{shade}` `border-{color}-{shade}` `bg-[#hex]` `text-[#hex]` `bg-red-500/50` (opacity modifier) `bg-transparent` `bg-white` `bg-black`

</details>

<details>
<summary><strong>Borders & effects</strong>: radius, shadow, ring, opacity</summary>

`border` `border-2` `border-t` `rounded` `rounded-lg` `rounded-xl` `rounded-full` `shadow` `shadow-md` `shadow-lg` `shadow-xl` `shadow-blue-500/20` `ring-2` `ring-blue-500` `ring-offset-2` `ring-inset` `opacity-50`

</details>

<details>
<summary><strong>Transitions & animations</strong></summary>

`duration-150` `duration-300` `duration-500` `ease-in` `ease-out` `ease-in-out` `animate-spin` `animate-pulse` `animate-bounce` `animate-ping`

</details>

<details>
<summary><strong>Responsive & conditional</strong></summary>

**Breakpoints:** `sm:` `md:` `lg:` `xl:` `2xl:`
**Dark mode:** `dark:`
**Platform:** `ios:` `android:` `web:` `mobile:`
**States:** `hover:` `focus:` `disabled:` `loading:` `checked:` `selected:` + custom

</details>

## Dark mode

```dart
// Pair every color with its dark variant
WDiv(
  className: 'bg-white dark:bg-gray-900 border dark:border-gray-700',
  child: WText(
    'Adapts automatically',
    className: 'text-gray-900 dark:text-white',
  ),
)

// Toggle at runtime
context.windTheme.toggleTheme();

// Reset to system preference
context.windTheme.resetToSystem();
```

> [!IMPORTANT]
> Every `bg-*`, `text-*`, `border-*`, `ring-*`, `fill-*` token carries a `dark:` pair in the SAME className block. Missing dark pair is a bug. Wind's parser logs a warning in `kDebugMode` when it detects an unpaired color token.

## Responsive design

```dart
// Stack on mobile, side-by-side on desktop
WDiv(
  className: 'flex flex-col md:flex-row gap-4',
  children: [
    WDiv(className: 'w-full md:w-1/3', child: sidebar),
    WDiv(className: 'w-full md:w-2/3', child: content),
  ],
)

// Hide on mobile, show on desktop
WDiv(className: 'hidden md:flex', child: desktopNav)

// Different widget tree per breakpoint (escape hatch when className is not enough)
WBreakpoint(
  base: (ctx) => const MobileLayout(),
  md: (ctx) => const TabletLayout(),
  lg: (ctx) => const DesktopLayout(),
)
```

## Custom theme

```dart
WindTheme(
  data: WindThemeData(
    colors: {
      'primary': MaterialColor(0xFF6366F1, {
        50: Color(0xFFEEF2FF),
        500: Color(0xFF6366F1),
        900: Color(0xFF312E81),
      }),
    },
    baseSpacingUnit: 4.0,
  ),
  builder: (context, controller) => MaterialApp(
    theme: controller.toThemeData(),
    home: const App(),
  ),
)
```

Use your custom colors anywhere:

```dart
WDiv(className: 'bg-primary-500 text-white p-4 rounded-lg')
```

## AI Coding Assistants

Wind treats AI coding agents as first-class consumers. The library works the same if you never use an AI coding tool, but if you do, three integration layers ship with the package so your agent generates correct Wind code on the first try, without hallucinating tokens.

> [!TIP]
> The **skill** teaches the agent Wind's className grammar, widget surface, dark-mode pairing rules, and anti-patterns. The **MCP server** lets it verify what it wrote against the live theme. The **Cursor rules** keep Cursor / Copilot suggestions on-pattern as you type.

**Claude Code skill** at [`skills/wind-ui/SKILL.md`](skills/wind-ui/SKILL.md). The skill ships with the package; agents that read `SKILL.md` from the repo (Claude Code, Cursor in agent mode) pick it up automatically. The upstream mirror at [`fluttersdk/ai`](https://github.com/fluttersdk/ai/tree/main/skills/wind-ui) is the registry-friendly location.

**Hosted MCP server** at `https://mcp.fluttersdk.com/wind`. HTTP transport, theme-aware, returns valid className tokens against the live `WindThemeData`.

| Client | Wire-up |
|---|---|
| **Claude Code** | `claude mcp add --transport http wind https://mcp.fluttersdk.com/wind` |
| **Cursor** | Settings → MCP → Add Server → URL `https://mcp.fluttersdk.com/wind` |
| **VS Code (GitHub Copilot)** | Settings → MCP Servers → URL `https://mcp.fluttersdk.com/wind` |
| **`.mcp.json`** | `{"mcpServers":{"wind":{"url":"https://mcp.fluttersdk.com/wind"}}}` |

**Cursor rules** at [`skills/wind-ui/`](skills/wind-ui/) (`.mdc`-compatible). Import via Cursor Settings → Rules → Remote Rule → point at the same directory, or copy locally to `.cursor/rules/`.

For LLM-readable navigation: [`llms.txt`](llms.txt) at the repo root. Full setup and per-client walkthrough at **[fluttersdk.com/wind/ai](https://fluttersdk.com/wind/ai)**.

## Architecture

```
className string
    ↓
WindParser.parse()
    ↓
17 domain parsers (first match wins)
    ↓
WindStyle (immutable value object)
    ↓
Widget.build()
```

Parsed results cache by `className + breakpoint + brightness + platform + sorted(states)`. Cache hit rate is near-100% in production. Internals documented in [ARCHITECTURE.md](ARCHITECTURE.md).

## FAQ

### Is this just inline styles?

No. With Wind, you are not picking magic numbers, you are choosing from a predefined design system. `p-4` always resolves to the same spacing token. `bg-blue-500` always resolves to the same color shade. Inline styles cannot target `hover:`, `focus:`, `dark:`, or media queries. Wind's prefix system can.

### My widget tree will be ugly with all those classes.

The first reaction is always "too many classes". Then ask yourself what you would name this widget if you had to give it a real component name. `card-with-hover-and-dark-mode-and-responsive-padding`? Naming things is hard, and most naming is premature abstraction. Utility-first lets you defer the abstraction until the pattern actually repeats.

### Another AI gimmick?

The agent integrations are just documentation in a format agents can read. The library works the same if you never use an AI coding tool. The `className` API does not change. AI integration is additive, not central.

### What about performance? Strings get parsed every build.

Wind caches every parsed style by `className + breakpoint + brightness + platform + states`. The same widget rendering the same className a thousand times parses exactly once. Cache hit rate is near-100% in production.

### Why not just use VelocityX? It has 1.47k likes.

VelocityX uses Dart property chains: `'text'.text.xl4.bold.make()`. It is *inspired by* Tailwind, but it is not Tailwind. Wind uses **actual Tailwind className strings**, `'text-4xl font-bold text-white'`. If you have copy-pasted Tailwind classes from a web project, they work in Wind unmodified. Plus VelocityX has been community-maintained since 2023; Wind 1.0 is the first production-stable utility-first option with dark-mode prefixes, state prefixes, and an MCP server.

### Does this lock me into your design system?

The token scales are 100% extensible via `WindThemeData`. Define your own `colors`, `fontSizes`, `shadows`, `screens`, and `bg-brand-500` just works. The defaults match Tailwind v3 / v4 exactly, but every scale is overridable. You can also use arbitrary values: `bg-[#FF5733]`, `p-[18px]`, `w-[42%]`.

### What if I only need Flutter web? Or only mobile?

Wind works on all 6 Flutter platforms: Android, iOS, web, macOS, Windows, Linux. Use the `ios:`, `android:`, `web:`, `mobile:` prefixes to target specific platforms in the same className. No conditional rendering, no `Platform.is*` helpers, no platform-detect plumbing.

## Documentation

Full docs with live examples at **[fluttersdk.com/wind](https://fluttersdk.com/wind)**. The internal architecture lives in [`ARCHITECTURE.md`](ARCHITECTURE.md) for contributors. The LLM-readable inventory lives in [`llms.txt`](llms.txt) at the repo root.

## Contributing

```bash
git clone https://github.com/fluttersdk/wind.git
cd wind && flutter pub get
flutter test && dart analyze
```

CI enforces 90%+ line coverage on `lib/` on every push, zero analyze issues, zero format drift. New behavior ships with a failing test first (red, green, refactor). Specifically welcome contributions:

- New widget proposals with a clear utility-first justification.
- Bug reports with a minimal reproducer (failing test preferred).
- Documentation fixes, typos, missing examples in `example/lib/pages/`.
- Translations or framework-specific guides (Riverpod + Wind, Bloc + Wind, etc).

[Report a bug](https://github.com/fluttersdk/wind/issues/new?template=bug_report.yml) · [Request a feature](https://github.com/fluttersdk/wind/issues/new?template=feature_request.yml)

## License

MIT, see [LICENSE](LICENSE) for details.

---

<p align="center">
  <sub>Built with care by <a href="https://github.com/fluttersdk">FlutterSDK</a></sub><br/>
  <sub>If Wind saved you a <code>Container</code> or two, <a href="https://github.com/fluttersdk/wind">give it a star</a>, it helps others discover it.</sub>
</p>
