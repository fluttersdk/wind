# Background Gradient

Utilities for creating gradient backgrounds.

<x-preview path="backgrounds/gradients" size="md" source="example/lib/pages/backgrounds/gradients.dart"></x-preview>

## Basic Usage

Create gradients using direction, from, and to classes:

```dart
WDiv(className: 'bg-gradient-to-r from-cyan-500 to-blue-500')
WDiv(className: 'bg-gradient-to-b from-yellow-400 to-red-500')
```

## Gradient Directions

| Class | Direction |
| :--- | :--- |
| `bg-gradient-to-t` | To top |
| `bg-gradient-to-tr` | To top right |
| `bg-gradient-to-r` | To right |
| `bg-gradient-to-br` | To bottom right |
| `bg-gradient-to-b` | To bottom |
| `bg-gradient-to-bl` | To bottom left |
| `bg-gradient-to-l` | To left |
| `bg-gradient-to-tl` | To top left |

## Gradient Colors

### From Color (Start)

```dart
WDiv(className: 'bg-gradient-to-r from-cyan-500 to-blue-500')
```

| Class | Description |
| :--- | :--- |
| `from-{color}-{shade}` | Start color |
| `from-[#hex]` | Arbitrary start color |

### Via Color (Middle)

```dart
WDiv(className: 'bg-gradient-to-r from-yellow-400 via-orange-500 to-red-500')
```

| Class | Description |
| :--- | :--- |
| `via-{color}-{shade}` | Middle color |
| `via-[#hex]` | Arbitrary middle color |

### To Color (End)

```dart
WDiv(className: 'bg-gradient-to-r from-cyan-500 to-blue-500')
```

| Class | Description |
| :--- | :--- |
| `to-{color}-{shade}` | End color |
| `to-[#hex]` | Arbitrary end color |

## Examples

### Two-Color Gradient

```dart
WDiv(
  className: 'bg-gradient-to-r from-purple-500 to-pink-500 p-8 rounded-lg',
  child: WText('Purple to Pink', className: 'text-white'),
)
```

### Three-Color Gradient

```dart
WDiv(
  className: 'bg-gradient-to-r from-green-400 via-blue-500 to-purple-600 p-8',
  child: WText('Rainbow', className: 'text-white'),
)
```

## Related Documentation

- [Background Color](./background-color.md) - Solid background colors
