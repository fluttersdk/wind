# Font Family Customization

Customize the body and display fonts of your application through `WindTheme`, backed by the Google Fonts library.

- [Default Font](#default-font)
- [Customizing Fonts](#customizing-fonts)
- [Binding Fonts to the Flutter Theme](#binding-fonts-to-the-flutter-theme)
- [Related Documentation](#related-documentation)

```dart
WindTheme.setBodyFontString('Roboto');
WindTheme.setDisplayFontString('Lobster');
```

<a name="default-font"></a>
## Default Font

When you start a new application with wind, the default font family is **Inter**, a versatile sans-serif face. You can replace it with any font supported by Google Fonts to match your design.

<a name="customizing-fonts"></a>
## Customizing Fonts

`WindTheme` configures two fonts: the body font for general text content and the display font for large, prominent text such as headings.

### Body Font

The body font is the primary font used for general text content.

```dart
// Set the body font
WindTheme.setBodyFontString('Roboto');
```

After this call, all text styled with the body font defaults to **Roboto**.

```dart
// Retrieve the current body font
String currentBodyFont = WindTheme.getBodyFontString();
print('Current body font: $currentBodyFont'); // Output: 'Roboto'
```

### Display Font

The display font is typically used for large, prominent text such as headings or titles.

```dart
// Set the display font
WindTheme.setDisplayFontString('Lobster');
```

If no display font is set, `getDisplayFontString` falls back to the body font.

```dart
// Retrieve the current display font
String currentDisplayFont = WindTheme.getDisplayFontString();
print('Current display font: $currentDisplayFont'); // Output: 'Lobster'
```

<a name="binding-fonts-to-the-flutter-theme"></a>
## Binding Fonts to the Flutter Theme

To apply the configured fonts globally, bind them to Flutter's `ThemeData` through `WindTheme.toThemeData`, which integrates the font settings with Flutter's theme system. You can also pass `bodyFontString` and `displayFontString` directly to `toThemeData` to override the configured fonts for a single build.

```dart
MaterialApp(
  theme: WindTheme.toThemeData(
    bodyFontString: 'Roboto',
    displayFontString: 'Lobster',
  ),
);
```

For full guidance on applying fonts at the theme level, see [Binding the Flutter Theme](../getting-started/binding-the-flutter-theme.md).

<a name="related-documentation"></a>
## Related Documentation
- [Binding the Flutter Theme](../getting-started/binding-the-flutter-theme.md) — apply fonts at the theme level
- [Font Size](./font-size.md) — customize the typographic scale
- [Font Weight](./font-weight.md) — customize weight keys
