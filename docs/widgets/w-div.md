# WDiv

The fundamental building block of Wind UI. A smart container that dynamically builds `Container`, `Row`, `Column`, `Grid`, or `Wrap` layouts based on utility classes.

<x-preview path="widgets/w_div" size="lg" source="example/lib/pages/widgets/w_div.dart"></x-preview>

## Basic Usage

```dart
WDiv(
  className: 'p-4 bg-white rounded-lg shadow-sm',
  child: Text('I am a card'),
)
```

## Layout Types

WDiv supports multiple layout modes determined by classes:

| Class | Layout Type | Description |
| :--- | :--- | :--- |
| (none) | Block | Default, single child container |
| `flex` | Flexbox | Row/Column layout |
| `grid` | Grid | Grid with columns |
| `wrap` | Wrap | Flowing wrap layout |
| `hidden` | None | Returns SizedBox.shrink() |

## Flex Layout

Use `flex` with `flex-row` or `flex-col` for flexbox layouts:

```dart
// Horizontal row
WDiv(
  className: 'flex flex-row gap-4 items-center',
  children: [
    WDiv(className: 'w-10 h-10 bg-red-500 rounded'),
    WText('User Name'),
  ],
)

// Vertical column
WDiv(
  className: 'flex flex-col gap-2',
  children: [
    WText('Item 1'),
    WText('Item 2'),
  ],
)
```

### Alignment

| Class | Description |
| :--- | :--- |
| `items-start` | Align items to start |
| `items-center` | Center items on cross axis |
| `items-end` | Align items to end |
| `items-baseline` | Align to text baseline |
| `items-stretch` | Stretch items |
| `justify-start` | Justify to start |
| `justify-center` | Center on main axis |
| `justify-end` | Justify to end |
| `justify-between` | Space between |
| `justify-around` | Space around |
| `justify-evenly` | Space evenly |

### Main Axis Size

Control how flex containers size along the main axis:

| Class | Description |
| :--- | :--- |
| `axis-min` | Shrink to fit content (MainAxisSize.min) |
| `axis-max` | Expand to fill available space (MainAxisSize.max) |

### Flex Child Properties

Control how children behave within a flex container:

| Class | Description |
| :--- | :--- |
| `flex-1`, `flex-2`... | Flex grow factor |
| `flex-grow` | Same as flex-1 |
| `flex-auto` | Flexible with loose fit |
| `flex-initial` | Initial size, can shrink |
| `flex-none` | No flex, fixed size |
| `shrink` | Allow shrinking (FlexFit.loose) |
| `shrink-0` | Prevent shrinking (FlexFit.tight) |
| `align-self-start` | Align self to start |
| `align-self-center` | Align self to center |
| `align-self-end` | Align self to end |

## Grid Layout

Use `grid` with `grid-cols-{n}` for grid layouts:

```dart
WDiv(
  className: 'grid grid-cols-3 gap-4',
  children: [
    WDiv(className: 'bg-blue-100 p-4', child: Text('1')),
    WDiv(className: 'bg-blue-200 p-4', child: Text('2')),
    WDiv(className: 'bg-blue-300 p-4', child: Text('3')),
  ],
)
```

| Class | Description |
| :--- | :--- |
| `grid-cols-1` to `grid-cols-12` | Number of columns |

## Wrap Layout

Use `wrap` for flowing layouts:

```dart
WDiv(
  className: 'wrap gap-2',
  children: chips,
)
```

### Align Content (Wrap only)

| Class | Description |
| :--- | :--- |
| `align-content-start` | Align runs to start |
| `align-content-center` | Center runs |
| `align-content-end` | Align runs to end |
| `align-content-between` | Space between runs |
| `align-content-around` | Space around runs |
| `align-content-evenly` | Even spacing |

## Sizing

| Class | Description |
| :--- | :--- |
| `w-{n}` | Fixed width (0-96, rem units) |
| `w-px` | 1px width |
| `w-full` | 100% width |
| `w-screen` | Viewport width |
| `w-1/2`, `w-1/3`, `w-2/3` | Fractional width |
| `w-auto` | Auto width |
| `h-{n}` | Fixed height |
| `h-full`, `h-screen` | Full/viewport height |
| `min-w-{n}`, `max-w-{n}` | Width constraints |
| `min-h-{n}`, `max-h-{n}` | Height constraints |
| `aspect-square`, `aspect-video` | Aspect ratio |

Arbitrary values: `w-[200px]`, `h-[50vh]`

## Spacing

### Padding

| Class | Description |
| :--- | :--- |
| `p-{n}` | All sides |
| `px-{n}` | Horizontal |
| `py-{n}` | Vertical |
| `pt-{n}`, `pb-{n}` | Top/Bottom |
| `pl-{n}`, `pr-{n}` | Left/Right |

### Margin

| Class | Description |
| :--- | :--- |
| `m-{n}` | All sides |
| `mx-{n}` | Horizontal |
| `my-{n}` | Vertical |
| `mx-auto` | Center horizontally |
| `mt-{n}`, `mb-{n}` | Top/Bottom |
| `ml-{n}`, `mr-{n}` | Left/Right |

### Gap

| Class | Description |
| :--- | :--- |
| `gap-{n}` | All directions |
| `gap-x-{n}` | Horizontal gap |
| `gap-y-{n}` | Vertical gap |

## Backgrounds

| Class | Description |
| :--- | :--- |
| `bg-{color}` | Solid color (e.g., `bg-blue-500`) |
| `bg-transparent` | Transparent |
| `bg-gradient-to-r` | Gradient right |
| `bg-gradient-to-b` | Gradient bottom |
| `from-{color}` | Gradient start |
| `to-{color}` | Gradient end |
| `via-{color}` | Gradient middle |
| `bg-opacity-{n}` | Background opacity |

## Borders

| Class | Description |
| :--- | :--- |
| `border` | 1px border |
| `border-{n}` | Border width (0, 2, 4, 8) |
| `border-{color}` | Border color |
| `border-t`, `border-b` | Top/bottom only |
| `border-l`, `border-r` | Left/right only |
| `rounded` | Small radius |
| `rounded-{size}` | none, sm, md, lg, xl, 2xl, 3xl, full |

## Shadows

| Class | Description |
| :--- | :--- |
| `shadow` | Default shadow |
| `shadow-sm` | Small shadow |
| `shadow-md` | Medium shadow |
| `shadow-lg` | Large shadow |
| `shadow-xl` | Extra large |
| `shadow-2xl` | 2x extra large |
| `shadow-none` | No shadow |
| `ring-{n}` | Focus ring |
| `ring-{color}` | Ring color |

## Effects

| Class | Description |
| :--- | :--- |
| `opacity-{n}` | 0-100 in steps of 5 |

## Overflow

| Class | Description |
| :--- | :--- |
| `overflow-hidden` | Clip content |
| `overflow-auto` | Scroll if needed |
| `overflow-scroll` | Always scroll |
| `overflow-x-auto` | Horizontal scroll |
| `overflow-y-auto` | Vertical scroll |

## Animation

| Class | Description |
| :--- | :--- |
| `animate-pulse` | Pulse animation |
| `animate-bounce` | Bounce animation |
| `animate-spin` | Spin animation |
| `animate-ping` | Ping animation |

## Transitions

| Class | Description |
| :--- | :--- |
| `transition-all` | All properties |
| `transition-colors` | Color changes |
| `transition-opacity` | Opacity changes |
| `duration-{n}` | 75, 100, 150, 200, 300, 500, 700, 1000ms |
| `ease-in`, `ease-out` | Timing functions |
| `ease-in-out`, `ease-linear` | More timing |

## Interactive States

> **Note:** States require wrapping with `WAnchor` or use `WButton`.

| Prefix | Description |
| :--- | :--- |
| `hover:` | Mouse hover state |
| `focus:` | Focus state |
| `active:` | Active/pressed state |
| `dark:` | Dark mode |
| `sm:`, `md:`, `lg:`, `xl:` | Responsive breakpoints |

```dart
WAnchor(
  child: WDiv(
    className: 'bg-blue-500 hover:bg-blue-600 transition-colors',
    child: Text('Hover me'),
  ),
)
```

## Child vs Children

WDiv enforces a strict rule:

> **Rule:** Provide either `child` OR `children`, never both.

- `child` - Single widget, block layout
- `children` - Multiple widgets, flex/grid/wrap layout

## Props

| Prop | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `className` | `String?` | - | Utility classes |
| `child` | `Widget?` | - | Single child widget |
| `children` | `List<Widget>?` | - | Multiple children |
| `style` | `WindStyle?` | - | Base WindStyle |
| `states` | `Set<String>?` | - | Custom states |

## All Supported Classes

| Category | Classes | Description |
| :--- | :--- | :--- |
| **Display** | `block`, `flex`, `grid`, `wrap`, `hidden` | Layout mode |
| **Flex Direction** | `flex-row`, `flex-col` | Direction |
| **Alignment** | `items-*`, `justify-*`, `align-content-*` | Axis alignment |
| **Axis Size** | `axis-min`, `axis-max` | Main axis sizing |
| **Flex Children** | `flex-1`, `flex-grow`, `shrink`, `shrink-0`, `align-self-*` | Child behavior |
| **Grid** | `grid-cols-{n}` | Grid columns |
| **Gap** | `gap-*`, `gap-x-*`, `gap-y-*`, `space-x-*`, `space-y-*` | Spacing |
| **Sizing** | `w-*`, `h-*`, `min-*`, `max-*`, `aspect-*` | Dimensions |
| **Spacing** | `p-*`, `m-*`, `mx-auto` | Padding/margin |
| **Background** | `bg-*`, `bg-gradient-*`, `from-*`, `to-*`, `via-*` | Backgrounds |
| **Border** | `border-*`, `rounded-*` | Borders |
| **Shadow** | `shadow-*`, `ring-*` | Shadows |
| **Effects** | `opacity-*` | Visual effects |
| **Overflow** | `overflow-*`, `overflow-x-*`, `overflow-y-*` | Scroll/clip |
| **Animation** | `animate-*` | Animations |
| **Transition** | `transition-*`, `duration-*`, `ease-*` | Transitions |
| **States** | `hover:*`, `focus:*`, `active:*`, `dark:*` | Interactive |
| **Responsive** | `sm:*`, `md:*`, `lg:*`, `xl:*` | Breakpoints |

## Related Documentation

- [WText](./w-text.md) - Text widget
- [WButton](./w-button.md) - Button widget
- [WAnchor](./w-anchor.md) - Interactive wrapper
- [Sizing](../layout/sizing.md) - Width/height utilities
- [Spacing](../layout/spacing.md) - Padding/margin utilities
- [Colors](../effects/colors.md) - Color utilities
