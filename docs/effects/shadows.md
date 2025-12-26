# Shadows

Utilities for specifying the box shadow of an element.

## Box Shadow
Control the shadow of an element.

<x-preview path="effects/shadows_basic" size="md"></x-preview>

```dart
WDiv(className: "shadow-md p-4 bg-white rounded-lg")
WDiv(className: "shadow-lg p-4 bg-white rounded-lg")
WDiv(className: "shadow-xl p-4 bg-white rounded-lg")
WDiv(className: "shadow-2xl p-4 bg-white rounded-lg")
```

| Class | Properties |
| :--- | :--- |
| `shadow-sm` | BoxShadow(blur: 2, offset: 0,1) |
| `shadow` | BoxShadow(blur: 3, offset: 0,1) |
| `shadow-md` | BoxShadow(blur: 6, offset: 0,4) |
| `shadow-lg` | BoxShadow(blur: 15, offset: 0,10) |
| `shadow-xl` | BoxShadow(blur: 25, offset: 0,20) |
| `shadow-2xl` | BoxShadow(blur: 50, offset: 0,25) |
| `shadow-none` | No shadow |

## Shadow Color
Control the color of the box shadow.

<x-preview path="effects/shadows_colored" size="md"></x-preview>

```dart
WDiv(className: "shadow-xl shadow-blue-500")
WDiv(className: "shadow-xl shadow-[#1da1f2]")
```

| Class | Behavior |
| :--- | :--- |
| `shadow-{color}` | Sets the shadow color (preserving opacity stops) |
| `shadow-[#hex]` | Sets arbitrary shadow color |

### Opacity

You can control the opacity of the shadow color using the color opacity modifier.

| Class | Behavior |
| :--- | :--- |
| `shadow-red-500/50` | Shadow color with 50% opacity |
| `shadow-blue-500/[0.25]` | Shadow color with 25% opacity |

```dart
WDiv(className: "shadow-xl shadow-red-500/50")
WDiv(className: "shadow-xl shadow-blue-500/25")
```

## Customizing Theme

You can customize the available shadows in your `WindThemeData`.

```dart
WindTheme(
  theme: WindThemeData(
    shadows: {
      'custom': [
         BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
      ],
      'deep': [
         BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, spreadRadius: 5),
      ],
    },
  ),
  child: MyApp(),
)
```

Now you can use these custom shadow keys:

```dart
WDiv(className: "shadow-custom")
WDiv(className: "shadow-deep")
```
