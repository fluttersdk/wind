# Background Color

Apply background colors to widgets using predefined theme colors or arbitrary hex values.

- [Basic Usage](#basic-usage)
- [Quick Reference](#quick-reference)
- [Arbitrary Values](#arbitrary-values)
- [Responsive Design](#responsive-design)
- [Dark Mode](#dark-mode)
- [Customizing Theme](#customizing-theme)
- [Related Documentation](#related-documentation)

<x-preview path="backgrounds/background_color" size="md" source="example/lib/pages/backgrounds/background_color.dart"></x-preview>

```dart
WContainer(
  className: 'bg-blue-500 w-64 h-64 alignment-center',
  child: WText('Blue Background', className: 'text-white'),
)
```

<a name="basic-usage"></a>
## Basic Usage

Use the `bg-` prefix followed by a color name and optional shade to apply a background color:

```dart
WContainer(
  className: 'bg-blue-500 p-4',
  child: WText('Blue background', className: 'text-white'),
)

WContainer(
  className: 'bg-gray-100 dark:bg-gray-800 p-4',
  child: WText('Light/dark aware', className: 'text-gray-900 dark:text-white'),
)
```

<a name="quick-reference"></a>
## Quick Reference

### Syntax

```text
bg-[color]-[shade]
bg-[color]
```

- `color`: the color name (e.g., `red`, `blue`, `gray`). Omitting the shade defaults to `500`.
- `shade`: the intensity — `50`, `100`, `200`, `300`, `400`, `500`, `600`, `700`, `800`, or `900`.

### Available Colors

| Color | Example Class | Notes |
|:------|:-------------|:------|
| `slate` | `bg-slate-500` | Cool blue-gray |
| `gray` | `bg-gray-500` | Neutral gray |
| `zinc` | `bg-zinc-500` | Slightly warmer gray |
| `neutral` | `bg-neutral-500` | Pure neutral |
| `stone` | `bg-stone-500` | Warm gray |
| `red` | `bg-red-500` | |
| `orange` | `bg-orange-500` | |
| `amber` | `bg-amber-500` | |
| `yellow` | `bg-yellow-500` | |
| `lime` | `bg-lime-500` | |
| `green` | `bg-green-500` | |
| `emerald` | `bg-emerald-500` | |
| `teal` | `bg-teal-500` | |
| `cyan` | `bg-cyan-500` | |
| `sky` | `bg-sky-500` | |
| `blue` | `bg-blue-500` | |
| `indigo` | `bg-indigo-500` | |
| `violet` | `bg-violet-500` | |
| `purple` | `bg-purple-500` | |
| `fuchsia` | `bg-fuchsia-500` | |
| `pink` | `bg-pink-500` | |
| `white` | `bg-white` | |
| `black` | `bg-black` | |
| `primary` | `bg-primary-500` | Alias for `indigo` |
| `secondary` | `bg-secondary-500` | Alias for `slate` |

Each color supports shades: `50`, `100`, `200`, `300`, `400`, `500`, `600`, `700`, `800`, `900`.

<a name="arbitrary-values"></a>
## Arbitrary Values

Apply any color with a hex code using bracket notation:

```text
bg-[#rrggbb]
```

```dart
WContainer(
  className: 'bg-[#1abc9c] w-64 h-64 alignment-center',
  child: WText('Custom Color Background', className: 'text-white'),
)
```

<a name="responsive-design"></a>
## Responsive Design

Prefix any `bg-` class with a breakpoint to apply it only above that screen width:

```dart
WContainer(
  className: 'bg-gray-100 md:bg-blue-500 lg:bg-green-500 p-4',
  child: WText('Responsive background'),
)
```

Available breakpoints: `sm` (640px), `md` (768px), `lg` (1024px), `xl` (1280px), `2xl` (1536px).

<a name="dark-mode"></a>
## Dark Mode

Pair every light background with a `dark:` variant for automatic dark mode support:

```dart
WContainer(
  className: 'bg-white dark:bg-gray-900 p-4',
  child: WText(
    'Dark-mode aware container',
    className: 'text-gray-900 dark:text-white',
  ),
)
```

Wind applies dark-mode variants automatically when `WindTheme.setType(Brightness.dark)` is active.

<a name="customizing-theme"></a>
## Customizing Theme

Add custom colors to the theme with `WindTheme.addColor`:

```dart
WindTheme.addColor('brand', MaterialColor(0xFF6200EE, {
  50: Color(0xFFEDE7F6),
  100: Color(0xFFD1C4E9),
  500: Color(0xFF6200EE),
  900: Color(0xFF311B92),
}));

WContainer(className: 'bg-brand-500 p-4', child: WText('Brand color'))
```

See [Customizing Colors](../customization/colors.md) for the full API.

<a name="related-documentation"></a>
## Related Documentation

- [Customizing Colors](../customization/colors.md) — add and override palette colors.
- [Border Color](../borders/border-color.md) — apply color to widget borders.
- [Text Color](../typography/text-color.md) — color utility for text.
- [Dark Mode](../concepts/dark-mode.md) — how dark-mode inversion works in Wind.
