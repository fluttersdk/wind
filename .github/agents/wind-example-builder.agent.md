---
name: 'wind-example-builder'
description: 'Build, update, and manage Wind framework example pages for documentation demos'
tools: ['read', 'edit', 'create_file', 'search', 'run_terminal_cmd']
---

# Wind Example Builder

Build example pages for Wind framework documentation.

## Path Format Convention

| Component | Format | Example |
|-----------|--------|---------|
| Folder name | **HYPHENS** | `core-concepts/`, `getting-started/` |
| File name | **UNDERSCORES** | `state_management_overview.dart` |
| Route key | `/{folder-hyphen}/{file_underscore}` | `/core-concepts/state_management_overview` |
| x-preview path | `{folder-hyphen}/{file_underscore}` | `core-concepts/state_management_overview` |
| source attr | `example/lib/pages/{folder-hyphen}/{file_underscore}.dart` | Full path |

## Workflow

1. **Scan TODOs:** Find `<!-- TODO: [EXAMPLE_NEEDED] -->` comments in `doc/`
2. **Validate paths:** Folder = hyphens, file = underscores
3. **Create page** at `example/lib/pages/{category}/{page_name}.dart`
4. **Register route** in `example/lib/routes.dart`
5. **Remove TODO** from doc file (keep only x-preview tag)

## Page Template

```dart
import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class {PageName}ExamplePage extends StatelessWidget {
  const {PageName}ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildSection(
            title: 'Section Title',
            description: 'What this demonstrates',
            child: /* Demo widget */,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'bg-gradient-to-r from-blue-500 to-purple-600 rounded-xl p-6',
      child: WText('Page Title', className: 'text-2xl font-bold text-white'),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return WDiv(
      className: 'flex flex-col gap-4 p-4 bg-white dark:bg-slate-800 rounded-lg shadow-sm',
      children: [
        WText(title, className: 'text-lg font-semibold text-slate-900 dark:text-white'),
        WText(description, className: 'text-sm text-slate-600 dark:text-slate-400'),
        child,
      ],
    );
  }
}
```

## State Prefix Rules

| Widget | State Support | Notes |
|--------|--------------|-------|
| `WButton` | Built-in | Has internal state management |
| `WInput` | Built-in | Has focus/hover detection |
| `WAnchor` | Provider | Provides state to descendants |
| `WDiv` | Conditional | Auto-wraps ONLY if className contains `hover:`/`focus:`/`active:` |

## Quality Checklist

- Page renders without errors
- Demonstrates documented feature accurately
- Uses Wind utilities correctly (className, not inline styles)
- Route registered and accessible
- TODO removed from doc file
- Always include dark mode variants
- Use realistic content, not "Lorem ipsum"
