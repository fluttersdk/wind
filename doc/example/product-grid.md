# Product Grid

A responsive product collection grid that switches from a single-column layout on small screens
to a multi-column row layout on medium screens and above.

- [Overview](#overview)
- [Code Walkthrough](#code-walkthrough)
- [Key Patterns](#key-patterns)
- [Related Documentation](#related-documentation)

<x-preview path="example/product_grid" size="lg" source="example/lib/pages/example/product_grid.dart"></x-preview>

```dart
import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: wColor('gray', shade: 200),
      body: WFlexContainer(
        className: 'flex-col md:flex-row gap-4 p-4',
        children: [
          collectionCard(
            imageUrl: 'https://picsum.photos/400/300',
            title: 'Desk and Office',
            description: 'Work from home accessories',
          ),
          collectionCard(
            imageUrl: 'https://picsum.photos/400/300',
            title: 'Self-Improvement',
            description: 'Journals and note-taking',
          ),
          collectionCard(
            imageUrl: 'https://picsum.photos/400/300',
            title: 'Travel',
            description: 'Daily commute essentials',
          ),
        ],
      ),
    );
  }

  Widget collectionCard({
    required String imageUrl,
    required String title,
    required String description,
  }) {
    return WFlexContainer(
      className: 'flex-1 flex-col gap-2',
      children: [
        WContainer(
          className: 'rounded-lg bg-white',
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
        WText(title, className: 'text-base font-bold text-gray-900'),
        WText(description, className: 'text-sm text-gray-500'),
      ],
    );
  }
}
```

<a name="overview"></a>
## Overview

This example builds a product collection grid using only Wind utility classes. The layout
stacks cards vertically by default (`flex-col`) and switches to a horizontal row (`md:flex-row`)
once the screen reaches the `md` breakpoint (768 px). No manual `MediaQuery` calls are needed.

<a name="code-walkthrough"></a>
## Code Walkthrough

### Outer container

```dart
WFlexContainer(
  className: 'flex-col md:flex-row gap-4 p-4',
  ...
)
```

- `flex-col` — stacks children vertically on small screens.
- `md:flex-row` — switches to horizontal layout at 768 px and wider.
- `gap-4` — uniform spacing between the three collection cards.
- `p-4` — page padding on all sides.

### Collection card

```dart
WFlexContainer(
  className: 'flex-1 flex-col gap-2',
  ...
)
```

- `flex-1` — each card grows to fill an equal share of the available row space.
- `flex-col` — stacks the image, title, and description vertically.
- `gap-2` — tight spacing between card elements.

### Image container

```dart
WContainer(
  className: 'rounded-lg bg-white',
  child: Image.network(imageUrl, fit: BoxFit.cover),
)
```

- `rounded-lg` — applies the theme's large corner radius.
- `bg-white` — white background for the image card.

<a name="key-patterns"></a>
## Key Patterns

| Pattern | Classes used | Purpose |
| :--- | :--- | :--- |
| Responsive direction | `flex-col md:flex-row` | Single column on mobile, side-by-side on desktop |
| Equal-width columns | `flex-1` | All cards share available space equally |
| Consistent spacing | `gap-4`, `gap-2` | Uniform gutters without manual `SizedBox` |
| Theme color via helper | `wColor('gray', shade: 200)` | Access theme color palette in Dart code |

<a name="related-documentation"></a>
## Related Documentation

- [Flex Direction](../flex/flex-direction.md) — `flex-col` and `flex-row`
- [Flex X](../flex/flex-x.md) — `flex-1` and proportional sizing
- [Gap](../flex/gap.md) — spacing between flex children
- [Responsive Design](../concepts/responsive-design.md) — breakpoint prefixes like `md:`
- [WFlexContainer](../widgets/wflexcontainer.md) — the flex layout widget
- [WContainer](../widgets/wcontainer.md) — the container widget used for the image card
