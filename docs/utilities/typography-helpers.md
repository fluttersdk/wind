# Typography Helpers

Programmatic access to theme typography values.

## wFontSize Function

Get font sizes by name:

```dart
double lg = wFontSize(context, 'lg')!;    // 18.0
double xl = wFontSize(context, 'xl')!;    // 20.0
double xxl = wFontSize(context, '2xl')!;  // 24.0
```

### Available Sizes

| Name | Default Size |
| :--- | :--- |
| `xs` | 12.0 |
| `sm` | 14.0 |
| `base` | 16.0 |
| `lg` | 18.0 |
| `xl` | 20.0 |
| `2xl` | 24.0 |
| `3xl` | 30.0 |
| `4xl` | 36.0 |

## wFontWeight Function

Get font weights by name:

```dart
FontWeight bold = wFontWeight(context, 'bold')!;      // w700
FontWeight semi = wFontWeight(context, 'semibold')!;  // w600
FontWeight medium = wFontWeight(context, 'medium')!;  // w500
```

### Available Weights

| Name | Weight |
| :--- | :--- |
| `thin` | w100 |
| `extralight` | w200 |
| `light` | w300 |
| `normal` | w400 |
| `medium` | w500 |
| `semibold` | w600 |
| `bold` | w700 |
| `extrabold` | w800 |
| `black` | w900 |

## Context Extensions

Use the shortcut extensions:

```dart
double? size = context.wFontSizeExt('lg');
FontWeight? weight = context.wFontWeightExt('bold');
```

## Function Reference

| Function | Description |
| :--- | :--- |
| `wFontSize(context, name)` | Returns font size |
| `wFontWeight(context, name)` | Returns font weight |
| `context.wFontSizeExt(name)` | Extension shortcut |
| `context.wFontWeightExt(name)` | Extension shortcut |

## Related

- [Color Helpers](./color-helpers.md)
- [Responsive Helpers](./responsive-helpers.md)
