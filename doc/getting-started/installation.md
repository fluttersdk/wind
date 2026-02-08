# Installation

- [Introduction](#introduction)
- [Requirements](#requirements)
- [Installation](#installation-step)
- [Basic Setup](#basic-setup)
    - [The Builder Pattern](#the-builder-pattern)
- [Alternative Setup](#alternative-setup)
- [Verify Installation](#verify-installation)

<!-- TODO: [EXAMPLE_NEEDED] path="getting-started/installation_basic" action="CREATE" -->
<!-- Description: Basic installation setup showing WindTheme with MaterialApp -->
<x-preview path="getting-started/installation_basic" size="md" source="example/lib/pages/getting-started/installation_basic.dart"></x-preview>

<a name="introduction"></a>
## Introduction

Today, I'll show you how to get Wind up and running in your Flutter project. It's a quick process, and I'll walk you through the best way to set it up so you can start styling with utilities immediately.

Wind is designed to be a drop-in replacement for traditional Flutter styling, but it needs a little bit of context to work its magic. Let's get started!

<a name="requirements"></a>
## Requirements

Before we dive in, make sure your environment meets these minimum requirements. I recommend staying on the latest stable versions to get the best performance and features.

| Dependency | Minimum Version | Recommended |
|:-----------|:----------------|:------------|
| Flutter    | `>= 3.22.0`     | `3.27.0+`   |
| Dart       | `>= 3.4.0`      | `3.6.0+`    |

<a name="installation-step"></a>
## Installation

First, we need to add the package to your `pubspec.yaml`. You can do this easily from your terminal:

```bash
flutter pub add fluttersdk_wind
```

That's it for the dependency. Now, let's look at how to hook it up to your app.

<a name="basic-setup"></a>
## Basic Setup

To use Wind widgets and utilities, you must wrap your application with the `WindTheme` widget. This provides the necessary context for responsive breakpoints, dark mode, and theme resolution.

<a name="the-builder-pattern"></a>
### The Builder Pattern (Recommended)

I always recommend using the `builder` pattern. Why? Because it's the most reactive way to handle theme changes. When you use `builder`, Wind gives you a `controller` that you can use to sync Wind's theme state directly with your `MaterialApp`.

Let's look at the code:

```dart
import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WindTheme(
      // We use 'data' to pass our theme configuration
      data: WindThemeData(), 
      builder: (context, controller) {
        return MaterialApp(
          title: 'Wind App',
          // This keeps MaterialApp in sync when you toggle dark mode!
          theme: controller.toThemeData(),
          home: const HomePage(),
        );
      },
    );
  }
}
```

Let's give it a shot. By using this pattern, whenever you call `context.windTheme.toggleTheme()`, your entire app (including native Material components) will update instantly.

> [!NOTE]
> Always use the `data:` parameter to provide your `WindThemeData`. The old `theme:` parameter is deprecated and will not work in v1.

<a name="alternative-setup"></a>
## Alternative Setup

If you don't need the `MaterialApp` to reactively update its own `ThemeData`, or if you're wrapping only a specific part of your app, you can use the `child` pattern:

```dart
WindTheme(
  data: WindThemeData(),
  child: MaterialApp(
    home: HomePage(),
  ),
)
```

This works fine for Wind widgets (`WDiv`, `WText`, etc.), but native Material widgets won't know when the Wind theme changes unless you handle that state manually.

<a name="verify-installation"></a>
## Verify Installation

Now that we're set up, let's make sure everything is working. Drop a `WDiv` into your home page and try some utility classes:

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

If you see a blue rounded card with white text, you're all set!

That's all for the installation. Now, we can move to the next part and explore some core concepts.

Have a nice day.
