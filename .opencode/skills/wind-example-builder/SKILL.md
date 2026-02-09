---
name: wind-example-builder
description: Build, update, and manage Wind framework example pages based on documentation TODOs. Use when processing `<!-- TODO: [EXAMPLE_NEEDED] -->` comments in doc/ files, creating new example pages in example/lib/pages/, updating routes.dart, or cleaning up unused example pages. Triggers on "create example", "build example page", "process doc TODOs", "update example app", "clean unused pages". REQUIRES loading wind-ui skill for Wind widget/utility knowledge.
---

# Wind Example Builder

Build example pages for Wind framework documentation.

## Prerequisites

**ALWAYS load these skills together:**
```
load_skills=["wind-example-builder", "wind-ui"]
```

The `wind-ui` skill provides:
- Widget API knowledge (WDiv, WButton, WAnchor, etc.)
- Utility class syntax (bg-*, text-*, flex, etc.)
- State prefix rules (hover:, focus:, dark:, etc.)
- Responsive breakpoint patterns (sm:, md:, lg:, etc.)

**ALWAYS read source code first:**
- Utility docs → Read `lib/src/parser/parsers/{utility}_parser.dart`
- Widget docs → Read `lib/src/widgets/w_{widget}.dart`
- Theme docs → Read `lib/src/theme/`
- State handling → Read `lib/src/widgets/w_anchor.dart` (CRITICAL for hover:/focus:)

## Path Format Convention (CRITICAL)

**This is the #1 source of errors. Follow EXACTLY:**

| Component | Format | Example |
|-----------|--------|---------|
| Folder name | **HYPHENS** | `core-concepts/`, `getting-started/` |
| File name | **UNDERSCORES** | `state_management_overview.dart` |
| Route key | `/{folder-hyphen}/{file_underscore}` | `/core-concepts/state_management_overview` |
| x-preview path | `{folder-hyphen}/{file_underscore}` | `core-concepts/state_management_overview` |
| source attr | `example/lib/pages/{folder-hyphen}/{file_underscore}.dart` | `example/lib/pages/core-concepts/state_management_overview.dart` |

**COMMON MISTAKES TO FIX:**
- `core_concepts/` → `core-concepts/` (folder must use hyphen)
- Path mismatch between TODO and x-preview → Make them identical
- Route key different from x-preview path → Must match (route has leading `/`)

## Workflow

### 1. Scan Documentation TODOs

Find all pending example pages:
```bash
grep -r "TODO: \[EXAMPLE_NEEDED\]" doc/
```

**TODO Format:**
```html
<!-- TODO: [EXAMPLE_NEEDED] path="core-concepts/state_management_overview" action="CREATE" -->
<!-- Description: What this example should demonstrate -->
<x-preview path="core-concepts/state_management_overview" size="md" source="example/lib/pages/core-concepts/state_management_overview.dart"></x-preview>
```

Actions: `CREATE` (new page), `UPDATE` (modify existing), `VERIFY` (check works)

### 1.5. Validate & Fix Path Format

**BEFORE creating any page, check and fix path format in doc file:**

1. Extract path from TODO: `path="..."`
2. Validate folder uses HYPHENS (not underscores)
3. Validate file uses UNDERSCORES (not hyphens)
4. If wrong, FIX the doc file first:
   - Update TODO path attribute
   - Update x-preview path attribute  
   - Update x-preview source attribute
5. Then proceed with page creation

### 2. Create Example Page

**File:** `example/lib/pages/{category}/{page_name}.dart`

**Template:**
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
      child: WText(
        'Page Title',
        className: 'text-2xl font-bold text-white',
      ),
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

### 3. Register Route

**File:** `example/lib/routes.dart`

**CRITICAL: Route key MUST match x-preview path (with leading `/`)**

1. Add import at top:
```dart
import 'package:example/pages/core-concepts/state_management_overview.dart';
```

2. Add route entry in `appRoutes` map:
```dart
'/core-concepts/state_management_overview': const StateManagementOverviewExamplePage(),
```

**Class naming:** Convert path to PascalCase + `ExamplePage`
- `state_management_overview` → `StateManagementOverviewExamplePage`
- `dark_mode_basic` → `DarkModeBasicExamplePage`

### 4. Remove TODO After Completion (MANDATORY)

**After creating/updating page, you MUST:**

1. Remove the TODO comment line completely
2. Remove the Description comment line
3. Keep ONLY the x-preview tag

**Before:**
```html
<!-- TODO: [EXAMPLE_NEEDED] path="core-concepts/state_management_overview" action="CREATE" -->
<!-- Description: A demonstration of hover/focus states -->
<x-preview path="core-concepts/state_management_overview" size="md" source="example/lib/pages/core-concepts/state_management_overview.dart"></x-preview>
```

**After:**
```html
<x-preview path="core-concepts/state_management_overview" size="md" source="example/lib/pages/core-concepts/state_management_overview.dart"></x-preview>
```

**FAILURE TO REMOVE TODO = INCOMPLETE WORK**

## Cleanup Unused Pages

To find orphaned pages not referenced in docs:

1. List all pages: `ls example/lib/pages/**/*.dart`
2. Grep doc references: `grep -r "x-preview" doc/ | grep -o 'source="[^"]*"'`
3. Compare and identify unused pages
4. **ASK USER** before deleting any page

## Interactive Mode

When multiple TODOs exist, present options:
```
Found 5 pending example pages:
1. [CREATE] core-concepts/state_management_overview - Hover/focus state demo
2. [CREATE] interactivity/animation_basic - Animate classes demo
3. [UPDATE] responsive/breakpoints - Add tablet examples
...

Which would you like to work on? (1-5, 'all', or 'skip')
```

## Quality Checklist

Before marking complete:
- [ ] Page renders without errors
- [ ] Demonstrates documented feature accurately
- [ ] Uses Wind utilities correctly (className, not inline styles)
- [ ] Route registered and accessible
- [ ] TODO removed from doc file
- [ ] Follows existing page patterns in same category

## State Prefix Rules (CRITICAL)

**`hover:`, `focus:`, `active:`, `disabled:` prefixes require state detection.**

| Widget | State Support | Notes |
|--------|--------------|-------|
| `WButton` | ✅ Built-in | Has internal state management |
| `WInput` | ✅ Built-in | Has focus/hover detection |
| `WAnchor` | ✅ Provider | Provides state to descendants |
| `WDiv` | ⚠️ Conditional | Auto-wraps ONLY if className contains `hover:`/`focus:`/`active:` |

**CRITICAL: WDiv with state prefixes**

WDiv auto-detects and wraps itself in WAnchor IF the className contains state prefixes.
However, for complex nested structures or custom state needs, wrap explicitly:

```dart
// ✅ CORRECT: WButton has built-in state
WButton(
  className: 'bg-blue-500 hover:bg-blue-600',
  child: WText('Works'),
)

// ✅ CORRECT: WDiv auto-wraps when hover: detected in its own className
WDiv(
  className: 'p-4 hover:bg-blue-100', // Will auto-wrap in WAnchor
  child: WText('Works'),
)

// ⚠️ SAFER: Explicit WAnchor for complex hover interactions
WAnchor(
  child: WDiv(
    className: 'p-4 hover:shadow-lg hover:border-blue-500',
    children: [/* nested content */],
  ),
)

// ❌ WRONG: State prefix on child but not detected by parent
WDiv(
  className: 'p-4', // No hover: here
  child: WDiv(
    className: 'hover:bg-red-500', // May not work if parent blocks
  ),
)
```

**When to use explicit WAnchor:**
- Multiple hover effects on nested elements
- Custom disabled state control
- Click handlers with visual feedback

## Common Patterns

**State demos (hover/focus):**
```dart
// Simple - WButton has built-in state
WButton(
  className: 'bg-blue-500 hover:bg-blue-600 focus:ring-2 focus:ring-blue-300',
  child: WText('Hover me'),
)

// Complex - Use explicit WAnchor for cards/containers
WAnchor(
  child: WDiv(
    className: 'p-4 border rounded-lg hover:shadow-lg hover:border-blue-500 transition-all',
    children: [
      WText('Hoverable Card', className: 'font-semibold'),
      WText('With shadow effect', className: 'text-gray-500'),
    ],
  ),
)
```

**Animation demos:**
```dart
WDiv(
  className: 'animate-spin w-8 h-8 bg-blue-500 rounded',
)
```

**Responsive demos:**
```dart
WDiv(
  className: 'flex flex-col md:flex-row gap-4',
  children: [/* items */],
)
```

**Dark mode demos:**
```dart
WDiv(
  className: 'bg-white dark:bg-slate-800 text-black dark:text-white',
)
```
