<p align="center">
  <img src=".github/wind-logo.svg" width="120" alt="Wind Logo" />
</p>

<h1 align="center">Wind</h1>

<p align="center">
  <strong>Tailwind CSS for Flutter.</strong><br/>
  Utility classes like <code>flex</code>, <code>p-4</code>, <code>dark:bg-gray-800</code>, and <code>hover:shadow-lg</code> compose into widget trees — without ever leaving your <code>className</code> string.
</p>

<p align="center">
  <a href="https://pub.dev/packages/fluttersdk_wind"><img src="https://img.shields.io/pub/v/fluttersdk_wind.svg" alt="pub package"></a>
  <a href="https://github.com/fluttersdk/wind/actions"><img src="https://img.shields.io/github/actions/workflow/status/fluttersdk/wind/deploy.yml?branch=v1&label=CI" alt="CI"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"></a>
  <a href="https://pub.dev/packages/fluttersdk_wind/score"><img src="https://img.shields.io/pub/points/fluttersdk_wind" alt="pub points"></a>
  <a href="https://github.com/fluttersdk/wind/stargazers"><img src="https://img.shields.io/github/stars/fluttersdk/wind?style=flat" alt="GitHub stars"></a>
</p>

<p align="center">
  <a href="https://fluttersdk.com/wind">Documentation</a> ·
  <a href="https://fluttersdk.com/wind/play">Playground</a> ·
  <a href="https://pub.dev/packages/fluttersdk_wind">pub.dev</a> ·
  <a href="https://github.com/fluttersdk/wind/issues">Issues</a>
</p>

---

## Why Wind?

**Stop nesting six widgets to round a corner.**

Flutter's styling is powerful but verbose. A simple card with padding, rounded corners, and a shadow requires deeply nested `Container`, `BoxDecoration`, `EdgeInsets`, and `BorderRadius` objects — the kind of widget-tree pyramid that the Flutter team itself ran a user study to confirm is painful.

Wind replaces that pyramid with the syntax web developers already know:

```dart
// Before — Flutter way
Container(
  padding: EdgeInsets.all(24),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
  ),
  child: Text('Hello', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
)

// After — Wind way
WDiv(
  className: 'bg-white rounded-xl shadow-lg p-6',
  child: WText('Hello', className: 'text-xl font-bold'),
)
```

**If you know Tailwind CSS, you already know Wind.**

### What you get

- ⚡ **Designs come together faster** — no class names to invent, no separate stylesheets, no switching between theme files and widget code
- 🛡️ **Making changes feels safer** — every utility class is scoped to its widget. Edit one, never accidentally break another.
- 🧹 **Maintaining old code is easier** — `className` reads top-down. No more "what was this `Container` for?" archaeology six months later.
- 📋 **Code is portable** — copy a `className` string between projects, between files, even between Wind and Tailwind on the web
- 📉 **Your widget tree stops growing** — utility classes compose; the nesting stays flat as features pile up

## Features

| | Feature | Description |
|:--|:--------|:------------|
| 🎨 | **Tailwind syntax, natively** | The same utility classes you write on the web: `flex`, `p-4`, `bg-blue-500`, `rounded-lg`, `shadow-md` |
| 🧩 | **W-prefix widget set** | `WDiv`, `WText`, `WButton`, `WInput`, `WSelect`, `WPopover`, `WDynamic`, and the rest of the surface |
| 📱 | **Responsive prefixes** | `sm:`, `md:`, `lg:`, `xl:`, `2xl:` breakpoints — plus custom breakpoints via your theme |
| 🌙 | **Dark mode** | `dark:` prefix with a runtime toggle and automatic system-brightness sync |
| 🎯 | **State styling** | `hover:`, `focus:`, `disabled:`, `loading:`, `selected:`, and any custom state you define |
| 🔌 | **Platform prefixes** | `ios:`, `android:`, `web:`, `mobile:` — conditional styling without a single `if` |
| 🎭 | **Customizable theme** | Override every token scale: colors, spacing, typography, shadows, breakpoints, animations |
| 📡 | **Server-driven UI** | `WDynamic` renders widget trees from JSON — ship UI updates without ship-blocking releases |
| 🤖 | **AI-ready** | Hosted MCP server + Claude Code skill + Cursor rules — your agent never hallucinates a className token |

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

## Widgets

### Layout & Container

```dart
// Flex row with gap
WDiv(
  className: 'flex flex-row gap-4 p-4 bg-white rounded-lg shadow',
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
WText('Body text', className: 'text-base text-gray-600 leading-relaxed')
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
// Button with loading state
WButton(
  onTap: _submit,
  isLoading: _isSubmitting,
  className: 'bg-blue-600 hover:bg-blue-700 loading:bg-blue-400 text-white px-6 py-3 rounded-lg',
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
// Render UI from JSON - no app update needed
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

## Supported Utilities

<details>
<summary><strong>Layout</strong> — flex, grid, positioning, overflow</summary>

`flex` `flex-row` `flex-col` `flex-wrap` `flex-1` `grid` `grid-cols-{n}` `gap-{n}` `justify-center` `justify-between` `items-center` `items-start` `self-center` `wrap` `hidden` `overflow-hidden` `overflow-y-auto` `relative` `absolute` `top-{n}` `right-{n}` `bottom-{n}` `left-{n}` `inset-{n}` `inset-x-{n}` `inset-y-{n}` `top-[24px]` `left-[24px]` `-top-{n}` `-inset-{n}`

</details>

<details>
<summary><strong>Sizing</strong> — width, height, constraints</summary>

`w-full` `w-1/2` `w-[200px]` `h-screen` `h-full` `min-h-screen` `max-w-lg` `max-w-[600px]` `aspect-square` `aspect-video`

</details>

<details>
<summary><strong>Spacing</strong> — padding, margin</summary>

`p-{n}` `px-{n}` `py-{n}` `pt-{n}` `m-{n}` `mx-auto` `mt-{n}` `mb-{n}` `-mt-{n}` `space-x-{n}` `gap-{n}`

</details>

<details>
<summary><strong>Typography</strong> — size, weight, style, alignment</summary>

`text-xs` `text-sm` `text-base` `text-lg` `text-xl` `text-2xl` `text-3xl` `font-bold` `font-semibold` `font-medium` `font-light` `italic` `uppercase` `lowercase` `capitalize` `underline` `line-through` `truncate` `text-center` `text-right` `leading-tight` `leading-relaxed` `tracking-wider`

</details>

<details>
<summary><strong>Colors</strong> — background, text, border, opacity</summary>

`bg-{color}-{shade}` `text-{color}-{shade}` `border-{color}-{shade}` `bg-[#hex]` `text-[#hex]` `bg-red-500/50` (opacity modifier) `bg-transparent` `bg-white` `bg-black`

</details>

<details>
<summary><strong>Borders & Effects</strong> — radius, shadow, ring, opacity</summary>

`border` `border-2` `border-t` `rounded` `rounded-lg` `rounded-xl` `rounded-full` `shadow` `shadow-md` `shadow-lg` `shadow-xl` `shadow-blue-500/20` `ring-2` `ring-blue-500` `ring-offset-2` `ring-inset` `opacity-50`

</details>

<details>
<summary><strong>Transitions & Animations</strong></summary>

`duration-150` `duration-300` `duration-500` `ease-in` `ease-out` `ease-in-out` `animate-spin` `animate-pulse` `animate-bounce` `animate-ping`

</details>

<details>
<summary><strong>Responsive & Conditional</strong></summary>

**Breakpoints:** `sm:` `md:` `lg:` `xl:` `2xl:`
**Dark mode:** `dark:`
**Platform:** `ios:` `android:` `web:` `mobile:`
**States:** `hover:` `focus:` `disabled:` `loading:` `checked:` `selected:` + custom

</details>

## Dark Mode

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

## Responsive Design

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

// Different widget tree per breakpoint (escape hatch when className isn't enough)
WBreakpoint(
  base: (ctx) => const MobileLayout(),
  md: (ctx) => const TabletLayout(),
  lg: (ctx) => const DesktopLayout(),
)
```

## Custom Theme

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

## Architecture

Wind uses a modular parsing architecture — each utility domain has its own parser:

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

**Parsers:** background, border, display, effect, flex, font, grid, margin, opacity, overflow, padding, position, shadow, sizing, spacing, text, transition

**Cache:** Parsed results are cached by `className + breakpoint + brightness + platform + states` for zero-cost re-renders.

## AI Coding Assistants

Wind is the first Flutter UI framework that treats AI coding agents as first-class consumers. Three integration layers ship in-box, so Claude Code, Cursor, GitHub Copilot, and any other LLM-backed assistant generate correct Wind code on the first try — no hallucinated className tokens, no invented prefixes, no APIs the library does not actually expose.

### MCP server — `mcp.fluttersdk.com/wind`

Live, hosted Model Context Protocol server. Your agent queries valid utility classes, supported prefixes, and widget APIs on demand. Add the endpoint once and the integration works across every MCP-compatible client.

```jsonc
// ~/.cursor/mcp.json (or Claude Code mcp config)
{
  "mcpServers": {
    "wind-ui": { "url": "https://mcp.fluttersdk.com/wind" }
  }
}
```

### Claude Code skill — `wind-ui`

A bundled, version-controlled skill that teaches Wind's className grammar, widget hierarchy, dark-mode conventions, and common anti-patterns. Loaded on demand, scoped to relevant files.

### Cursor rules — `.cursor/rules/*.mdc`

Path-scoped rules that auto-activate when editing `.dart` files. Inject Wind's state prefixes, token names, and gotchas into every suggestion.

> The skill and rules teach your agent how to *write* Wind. The MCP server lets it *verify* what it wrote.

**Setup**: a single repo, one command per assistant. **[fluttersdk/ai](https://github.com/fluttersdk/ai)**

## FAQ

### Isn't this just inline styles?

No. With Wind, you're not picking magic numbers — you're choosing from a predefined design system. `p-4` always resolves to the same spacing token, `bg-blue-500` always resolves to the same color shade. Inline styles can't target `hover:`, `focus:`, `dark:`, or media queries — Wind's prefix system can.

### My widget tree will be ugly with all those classes.

The first reaction is always "too many classes." Then ask yourself: what would you name this widget if you had to give it a "real" component name? `card-with-hover-and-dark-mode-and-responsive-padding`? Naming things is hard, and most naming is premature abstraction. Utility-first lets you defer the abstraction until the pattern actually repeats.

### Why not just use VelocityX?

VelocityX uses Dart property chains: `'text'.text.xl4.bold.make()`. It's *inspired by* Tailwind, but it's not Tailwind. Wind uses **actual Tailwind className strings** — `'text-4xl font-bold text-white'`. If you have copy-pasted Tailwind classes from a web project, they work in Wind unmodified.

### What about performance? Strings get parsed every build.

Wind caches every parsed style by `className + breakpoint + brightness + platform + states`. The same widget rendering the same className a thousand times parses exactly once. Cache hit rate is near-100% in production.

### Doesn't this lock me into your design system?

The token scales are 100% extensible. Define your own colors, font sizes, shadows, breakpoints via `WindThemeData`. The defaults match Tailwind v3/v4 exactly, but every scale is overridable. Plus arbitrary values for one-offs: `bg-[#FF5733]`, `p-[18px]`, `w-[42%]`.

### Another AI gimmick?

The MCP server and skill are just documentation in a format agents can read. The library works identically without them. The AI layers are additive — never use a coding assistant and Wind is still Wind. Use one and your agent stops guessing className tokens.

## Documentation

Full docs with live examples at **[fluttersdk.com/wind](https://fluttersdk.com/wind)**.

## Contributing

```bash
git clone https://github.com/fluttersdk/wind.git
cd wind && git checkout v1 && flutter pub get
flutter test && dart analyze
```

[Report a bug](https://github.com/fluttersdk/wind/issues/new?template=bug_report.yml) · [Request a feature](https://github.com/fluttersdk/wind/issues/new?template=feature_request.yml)

## License

MIT — see [LICENSE](LICENSE) for details.

---

<p align="center">
  <strong>Try Wind in your project</strong><br/>
  <code>flutter pub add fluttersdk_wind</code>
</p>

<p align="center">
  <sub>Built with care by <a href="https://github.com/fluttersdk">FlutterSDK</a> · <a href="https://github.com/fluttersdk/wind">Star on GitHub</a> if Wind saved you a Container or two.</sub>
</p>
