# WDiv Widget

The `WDiv` widget is the fundamental building block of the Wind framework. It acts as a smart container that parses utility classes to build `Container`, `Row`, `Column`, `Flex`, `Grid`, or `Wrap` widgets efficiently.

## Intelligent Composition

`WDiv` parses your `className` string and dynamically constructs the widget tree. It avoids unnecessary nesting levels by flattening the structure where possible.

> **Note**
> `WDiv` checks for layout classes like `flex`, `grid`, or `wrap` to determine which Flutter layout widget to use.

## Usage

### Basic Block
For a simple box with styling, use `WDiv` with a single `child`.

```dart
WDiv(
  className: "p-4 bg-white rounded-lg shadow-sm border border-gray-200",
  child: Text("I am a card"),
)
```

### Flex Layout (Row/Column)
When you provide `children`, `WDiv` acts as a layout container. By default, it behaves like a generic block (`Column`), but you can control this with `flex-row` or `flex-col`.

```dart
// Row Layout
WDiv(
  className: "flex flex-row gap-4 items-center",
  children: [
    WDiv(className: "w-10 h-10 bg-red-500 rounded-full"),
    Text("User Name"),
  ],
)
```

### Grid Layout
Use `grid` and `grid-cols-{n}` to create responsive grids.

```dart
WDiv(
  className: "grid grid-cols-2 gap-4",
  children: [
    WDiv(className: "bg-blue-100 p-4", child: Text("Item 1")),
    WDiv(className: "bg-blue-200 p-4", child: Text("Item 2")),
  ],
)
```

## The "Child vs Children" Rule

To prevent ambiguous layouts, `WDiv` enforces a strict rule:

> **Rule:** You must provide either `child` OR `children`, but NEVER both.

- **`child`**: Wraps a single widget.
- **`children`**: Manages a list of widgets (Row, Column, Grid, Wrap).

## Supported Utility Classes

`WDiv` supports a vast range of utility classes. Key categories include:

### Layout
| Class | Description |
| :--- | :--- |
| `block`, `hidden` | Display mode |
| `flex`, `flex-row`, `flex-col` | Flexbox layout |
| `grid`, `grid-cols-{n}` | Grid layout |
| `gap-{n}`, `gap-x-{n}`, `gap-y-{n}` | Spacing between items |
| `items-{start/center/end}` | Cross-axis alignment |
| `justify-{start/center/between}` | Main-axis alignment |
| `wrap` | Wrap layout |

### Sizing & Spacing
| Class | Description |
| :--- | :--- |
| `w-{n}`, `h-{n}`, `w-full`, `h-screen` | Width / Height |
| `min-w-{n}`, `max-w-{n}` | Constraints |
| `p-{n}`, `px-{n}`, `py-{n}` | Padding |
| `m-{n}`, `mx-{n}`, `my-{n}` | Margin |

### Styling
| Class | Description |
| :--- | :--- |
| `bg-{color}`, `bg-gradient-*` | Backgrounds |
| `border`, `border-{n}`, `border-{color}` | Borders |
| `rounded`, `rounded-{size}` | Border Radius |
| `shadow`, `shadow-{size}` | Box Shadow |
| `opacity-{n}` | Opacity |

### Interactivity
| Prefix | Description |
| :--- | :--- |
| `hover:` | Styles applied on mouse hover |
| `focus:` | Styles applied when focused (if `WAnchor`) |
| `dark:` | Styles applied in dark mode |
| `sm:`, `md:`, `lg:` | Responsive breakpoints |
