# Wind (fluttersdk_wind) - AI Agent Rule Set

You are an expert Flutter developer and maintainer of the `fluttersdk_wind` package. Help users build UI or extend functionality by adhering to the architecture below.

## 1. Core Philosophies

- **"Laravel Artisan" Philosophy:** Configuration-driven design via WindThemeData. Utility classes (e.g., `"p-4 bg-red-500"`) provide elegant DX. Layers: **Widgets** → **WindParser** → **Specialist Parsers**.
- **"Tailwind Engine" Philosophy:** Frictionless utility classes. WindParser caches WindStyle by compound key. WDiv dynamically builds Row/Column/GridView/Wrap.

## 2. Architecture

### Parsing Engine
- **WindParser:** Takes `className` + `BuildContext`, builds WindContext (with `activeStates`), resolves prefixed classes (e.g., `hover:`, `dark:`, `loading:`), delegates to sub-parsers. Static cache.
- **WindStyle:** Immutable data object with all resolved style properties.
- **Specialist Parsers** (WindParserInterface, "Last Class Wins"):
  - **DisplayParser:** `block`, `flex`, `grid`, `hidden`
  - **BackgroundParser:** `bg-{color}`, images, gradients
  - **BorderParser:** `border-{n}`, `border-{color}`, `rounded-{size}`
  - **TextParser:** `text-{color}`, `text-{size}`, `font-{weight}`
  - **SizingParser:** `w-`, `h-`, `min/max-`, arbitrary `w-[50%]`
  - **PaddingParser/MarginParser:** `p-`, `m-`, `px-`, `my-`
  - **FlexboxGridParser:** `flex-row`, `items-center`, `grid-cols-3`, `gap-4`
  - **AspectRatioParser:** `aspect-auto`, `aspect-square`, `aspect-video`, `aspect-[4/3]`
  - **OpacityParser:** `opacity-0`, `opacity-100`, `opacity-[0.5]`
  - **ZIndexParser:** `z-10`, `z-50`, `z-[100]`
  - **OverflowParser:** `overflow-hidden`, `overflow-scroll`, `overflow-x-auto`
  - **ShadowParser:** `shadow`, `shadow-md`, `shadow-red-500`
  - **RingParser:** `ring`, `ring-2`, `ring-blue-500/50`, `ring-offset-2`, `ring-inset`
  - **TransitionParser:** `duration-300`, `ease-in`, `ease-out`, `ease-in-out`
  - **DebugParser:** `debug`

### Widgets
- **WDiv:** Builds Column/Row/GridView/Wrap based on displayType. Wraps in DefaultTextStyle.merge.
- **WText:** Builds Text or SelectableText. Handles text transforms.
- **WInput:** Form input with React-style binding (`value`/`onChanged`), `className`/`placeholderClassName`, focus states, validation.
- **WAnchor:** Interactive wrapper for hover/focus/disabled states.

### Theme
- **WindTheme:** InheritedWidget propagating WindThemeData.
- **WindThemeData:** Colors, Screens, Typography, Spacing, borderWidths, borderRadius, ringWidths, ringOffsets.

## 3. Supported Utility Classes

### Layout & Sizing
| Category | Classes |
|:---|:---|
| Display | `block`, `flex`, `grid`, `wrap`, `hidden` |
| Flex | `flex-row`, `flex-col`, `flex-{n}`, `flex-grow` |
| Grid | `grid-cols-{n}`, `gap-{n}` |
| Justify | `justify-start/end/center/between/around/evenly` |
| Align | `items-start/end/center/baseline/stretch` |
| Aspect Ratio | `aspect-auto`, `aspect-square`, `aspect-video`, `aspect-[ratio]` |
| Sizing | `w-{n}`, `h-{n}`, `w-full`, `h-screen`, `w-[n]` |
| Spacing | `p-{n}`, `m-{n}`, `px-{n}`, `my-{n}` |

### Typography
| Category | Classes |
|:---|:---|
| Color | `text-{color}-{shade}`, `text-[#hex]`, `text-{color}/{opacity}` |
| Size | `text-xs/sm/base/lg/xl/2xl/3xl/4xl/5xl/6xl` |
| Family | `font-sans`, `font-serif`, `font-mono`, `font-[family]` |
| Weight | `font-thin/light/normal/medium/semibold/bold/extrabold/black` |
| Transform | `uppercase`, `lowercase`, `capitalize` |
| Overflow | `truncate`, `line-clamp-{n}` |

### Backgrounds & Borders
| Category | Classes |
|:---|:---|
| BG Color | `bg-{color}-{shade}`, `bg-[#hex]`, `bg-{color}/{opacity}` |
| Border Width | `border`, `border-0/2/4/8`, `border-t/r/b/l` |
| Border Color | `border-{color}-{shade}`, `border-[#hex]`, `border-{color}/{opacity}` |
| Radius | `rounded`, `rounded-sm/md/lg/xl/2xl/3xl/full/none` |

### Effects & Filters
| Category | Classes |
|:---|:---|
| Shadow | `shadow`, `shadow-sm/md/lg/xl/2xl`, `shadow-none` |
| Shadow Color | `shadow-{color}-{shade}`, `shadow-[#hex]`, `shadow-{color}/{opacity}` |
| Opacity | `opacity-{n}`, `opacity-[n]` |
| Ring | `ring`, `ring-{n}`, `ring-{color}/{opacity}`, `ring-offset`, `ring-inset` |
| Z-Index | `z-{n}`, `z-auto`, `z-[n]` |
| Transition | `duration-{ms}`, `ease-{curve}` |

### Prefixes
| Category | Prefixes |
|:---|:---|
| Responsive | `sm:`, `md:`, `lg:`, `xl:`, `2xl:` |
| State | `hover:`, `focus:`, `disabled:`, `loading:`, `selected:`, `custom:` |
| Dark Mode | `dark:` |
| Platform | `ios:`, `android:`, `web:`, `mobile:` |

## 4. Project Workflow

### Git
- Use **feature branches** (e.g., `feature/border-parser`)
- Create **PRs to `v1` branch**
- All features go into current **unreleased version**

### Documentation
- Follow **Tailwind CSS documentation** style
- Use `<x-preview path="..." size="md"></x-preview>` for iframe previews
- Each code example → separate page in `example/lib/pages/`
- Docs in `docs/` as markdown

### Tests
- Widget tests: `test/widgets/{widget_name}/{feature}_test.dart`
- Parser tests: `test/parser/parsers/{parser}_test.dart`

### Example Pages
- Location: `example/lib/pages/{category}/{demo_name}.dart`
- Minimal, **iframe-ready** format
- Update `example/lib/routes.dart`

### Theme
- Defaults: `lib/src/theme/defaults/`
- Customizable via `WindThemeData.copyWith()`
- Parsers read from theme, not hardcoded

## 5. Adding New Parser

```dart
// 1. Create: lib/src/parser/parsers/new_parser.dart
class NewParser implements WindParserInterface { ... }

// 2. Register in WindParser._parserMap
// 3. Export from lib/fluttersdk_wind.dart
// 4. Parser tests: test/parser/parsers/new_parser_test.dart
// 5. Widget tests: test/widgets/w_div/new_test.dart  
// 6. Example pages: example/lib/pages/new/
// 7. Docs: docs/new.md with x-preview
```

## 6. Theme Defaults

```
lib/src/theme/defaults/
├── border_radius.dart
├── border_widths.dart
├── box_shadows.dart
├── colors.dart
├── containers.dart
├── font_families.dart
├── font_sizes.dart
├── font_weights.dart
├── leading.dart
├── screens.dart
├── tracking.dart
└── z_index.dart
```

## 7. Developer Rules

1. **Never Hardcode:** Use utility classes or `WindTheme.of(context)`
2. **State:** Wrap in WAnchor, use prefixes (`hover:`, `focus:`)
3. **Extending:** WindParserInterface → Register → Add to WindStyle
