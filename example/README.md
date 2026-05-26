# Wind Example Application

This example app demonstrates the capabilities of the Wind utility-first styling framework for Flutter.

## 📱 What's Included

The example app showcases:

- **Layout System**: Flex, Grid, and Wrap layouts with gap spacing
- **Typography**: Text styles, fonts, sizes, and decorations
- **Colors & Backgrounds**: Solid colors, gradients, and background images
- **Borders & Effects**: Rounded corners, shadows, rings, and opacity
- **Responsive Design**: Breakpoint-based layouts (sm, md, lg, xl, 2xl)
- **State Styling**: Hover, focus, disabled, and loading states
- **Dark Mode**: Theme toggling and dark mode utilities
- **Forms**: Inputs, checkboxes, selects, and date pickers
- **Interactive Widgets**: Buttons, popovers, and anchors
- **Transitions**: Duration, easing, and animations
- **Platform-Specific**: iOS, Android, and web modifiers

## 🚀 Running the Example

```bash
# Install dependencies
flutter pub get

# Run on web
flutter run -d chrome

# Run on mobile
flutter run

# Run on desktop
flutter run -d macos  # or windows, linux
```

## 📂 Project Structure

```
example/
├── lib/
│   ├── main.dart              # App entry point
│   ├── routes.dart            # Page routing map (consumed by fluttersdk.com iframes)
│   └── pages/
│       ├── animation/         # Animation examples
│       ├── backgrounds/       # Background utilities
│       ├── borders/           # Border and radius examples
│       ├── effects/           # Shadow, opacity, ring
│       ├── examples/          # Complete UI examples
│       ├── forms/             # Form widgets
│       ├── layout/            # Flex, grid, wrap
│       ├── popover/           # Popover examples
│       ├── responsive/        # Responsive design
│       └── ...                # See lib/pages/ for the full list
└── pubspec.yaml
```

The interactive playground formerly hosted here has been migrated to the [`fluttersdk.com`](https://fluttersdk.com/wind) site, where it runs as a `WDynamic`-driven Flutter app embedded in the Laravel host. The example app in this repository only ships the navigable demo gallery.

## 🎯 Key Examples

### Basic Layout
```dart
WDiv(
  className: 'flex flex-col gap-4 p-6 bg-white rounded-xl shadow-lg',
  children: [
    WText('Title', className: 'text-2xl font-bold'),
    WText('Subtitle', className: 'text-gray-600'),
  ],
)
```

### Responsive Card
```dart
WDiv(
  className: 'w-full md:w-1/2 lg:w-1/3 p-4',
  child: WDiv(
    className: 'bg-white dark:bg-gray-800 rounded-lg p-6 shadow hover:shadow-xl transition-shadow',
    child: // ... content
  ),
)
```

### Interactive Button
```dart
WButton(
  onTap: () => print('Clicked'),
  className: 'bg-blue-600 hover:bg-blue-700 active:bg-blue-800 text-white px-6 py-3 rounded-lg transition-colors',
  child: Text('Click Me'),
)
```

## 📚 Learn More

- **Documentation**: [fluttersdk.com/wind](https://fluttersdk.com/wind)
- **GitHub**: [github.com/fluttersdk/wind](https://github.com/fluttersdk/wind)
- **Pub.dev**: [pub.dev/packages/fluttersdk_wind](https://pub.dev/packages/fluttersdk_wind)

## 💡 Tips

1. **Hot Reload**: Use hot reload (r) to see changes instantly
2. **Dark Mode**: Toggle dark mode from the app header
3. **Breakpoints**: Resize the window to see responsive behavior
4. **State Styles**: Hover over buttons and inputs to see state changes
5. **Code Examples**: Each page includes code snippets you can copy

## 🐛 Issues?

Found a bug or have a suggestion? Please open an issue on [GitHub](https://github.com/fluttersdk/wind/issues).
