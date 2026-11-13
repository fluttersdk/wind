# Installation

Add wind_kit to a Flutter app, wrap it in `WindTheme` and style your first widget with a className.

- [Requirements](#requirements)
- [Installation](#installation-step)
- [Basic Setup](#basic-setup)
- [Alternative Setup](#alternative-setup)
- [Verify Installation](#verify-installation)

<x-preview path="" size="lg" source="example/lib/pages/getting-started/installation_basic.dart"></x-preview>

Getting started with Wind requires a few configuration steps to ensure utility classes resolve correctly across your application.

<a name="requirements"></a>
## Requirements

Before adding Wind to your project, ensure your environment meets these minimum version requirements. We recommend staying on the latest stable versions for the best experience.

| Dependency | Minimum Version | Recommended |
|:-----------|:----------------|:------------|
| Flutter    | `>= 3.27.0`     | `3.27.0+`   |
| Dart       | `>= 3.4.0`      | `3.6.0+`    |

<a name="installation-step"></a>
## Installation

Add `wind_kit` to your `pubspec.yaml` using the Flutter CLI:

```bash
flutter pub add wind_kit
```

Alternatively, add it manually to your dependencies:

```yaml
dependencies:
  wind_kit: any  # or pin to latest stable from pub.dev/packages/wind_kit
```

<a name="basic-setup"></a>
## Basic Setup

To use Wind utilities, you must wrap your application with the `WindTheme` widget. This provides the context needed for responsive breakpoints, dark mode, and state resolution.

### The Builder Pattern (Recommended)

The `builder` pattern is the preferred way to initialise Wind. It provides a `controller` that synchronises Wind's theme state (like dark mode) directly with your `MaterialApp`.

Let's look at a typical implementation:

```dart
import 'package:flutter/material.dart';
import 'package:wind_kit/wind_kit.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WindTheme(
      // Always use the 'data' parameter for configuration
      data: WindThemeData(), 
      builder: (context, controller) {
        return MaterialApp(
          title: 'Wind App',
          // Automatically syncs Material theme with Wind's state
          theme: controller.toThemeData(),
          home: const HomePage(),
        );
      },
    );
  }
}
```

By using the `builder` pattern, any theme changes triggered via `context.windTheme.toggleTheme()` will instantly propagate to both Wind widgets and native Material components.

> [!NOTE]
> Ensure you use the `data:` parameter. `WindTheme` has no `theme:` parameter, so an argument of that name does not compile.

<a name="alternative-setup"></a>
## Alternative Setup

If you do not need reactive synchronisation with `MaterialApp` or are only using Wind in a specific subtree, you can use the `child` pattern:

```dart
WindTheme(
  data: WindThemeData(),
  child: MaterialApp(
    home: const HomePage(),
  ),
)
```

While this setup works for Wind widgets like `WDiv` or `WText`, native Material widgets will not automatically react to Wind theme changes unless handled manually.

<a name="verify-installation"></a>
## Verify Installation

To verify that Wind is correctly configured, add a `WDiv` with a few utility classes to your project:

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WDiv(
          className: 'bg-blue-500 p-6 rounded-xl shadow-lg',
          child: WText(
            'Wind is working!',
            className: 'text-white font-bold text-xl',
          ),
        ),
      ),
    );
  }
}
```

If you see a blue card with white text, the installation is successful.
