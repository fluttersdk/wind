# Wind UI Design Tokens

Design system expressed purely as className mappings. No theory, only application.

## Typography Hierarchy

| Role | className | Notes |
|------|-----------|-------|
| Page title | `text-2xl font-bold text-gray-900 dark:text-white` | Primary screen heading |
| Screen heading | `text-xl font-semibold text-gray-800 dark:text-gray-100` | Secondary screen heading |
| Section heading | `text-lg font-semibold text-gray-800 dark:text-gray-100` | Container/card titles |
| Body text | `text-base text-gray-700 dark:text-gray-300` | Standard paragraph text |
| Secondary/caption | `text-sm text-gray-500 dark:text-gray-400` | Supporting text, de-emphasized details |
| Label (forms) | `text-sm font-medium text-gray-700 dark:text-gray-300` | Input field labels |
| Section label (uppercase) | `text-xs font-bold uppercase tracking-wide text-gray-500 dark:text-gray-400` | List subheaders, tiny category markers |
| Metadata/timestamp | `text-xs text-gray-400 dark:text-gray-500` | Extremely de-emphasized data |
| Link | `text-sm text-primary hover:underline` | Inline interactive text |
| Error text | `text-sm text-red-600 dark:text-red-400` | Validation messages |

## Spacing Scale

| Scale name | gap- className | p- className | Use case |
|------------|----------------|--------------|----------|
| Micro | `gap-1` (4px) | `p-1` | Icon-to-text, badge padding |
| XSmall | `gap-2` (8px) | `p-2` | Tight related items |
| Small | `gap-3` (12px) | `p-3` | Button padding (min for touch) |
| Base | `gap-4` (16px) | `p-4` | Standard screen padding, between items |
| Medium | `gap-5` (20px) | `p-5` | Card padding |
| Large | `gap-6` (24px) | `p-6` | Between sections |
| XLarge | `gap-8` (32px) | `p-8` | Major section separation |
| 2XLarge | `gap-12` (48px) | `p-12` | Page-level separation |

## Touch Target Rules

| Element type | Minimum className | Recommended className | Why |
|--------------|-------------------|-----------------------|-----|
| Text button | `py-3 px-4` | `py-3.5 px-5` | ≈44dp height (iOS min) |
| Icon-only button | `p-3` | `p-3.5` | 12px pad + 24px icon = 48dp |
| List item | `py-3 px-4` | `py-4 px-4` | 48dp minimum tap area |
| Toggle/checkbox | `p-2` | `p-3` | Ensures 40dp+ |
| FAB | `p-4` | `p-4` | 56dp recommended |

NEVER use `py-1` or `p-1` on interactive elements.

## Color System

### Semantic Colors

| Meaning | Background | Text | Border |
|---------|------------|------|--------|
| Primary/Brand | `bg-primary` | `text-primary` | `border-primary` |
| Success | `bg-green-500` | `text-green-600 dark:text-green-400` | `border-green-500` |
| Warning | `bg-yellow-500` | `text-yellow-600 dark:text-yellow-400` | `border-yellow-500` |
| Error/Danger | `bg-red-500` | `text-red-600 dark:text-red-400` | `border-red-500` |
| Info | `bg-blue-500` | `text-blue-600 dark:text-blue-400` | `border-blue-500` |
| Neutral | `bg-gray-500` | `text-gray-500 dark:text-gray-400` | `border-gray-300` |

### Status Badges

| Status | className |
|--------|-----------|
| Active/Online | `bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400` |
| Warning/Degraded | `bg-yellow-100 dark:bg-yellow-900/30 text-yellow-700 dark:text-yellow-400` |
| Error/Down | `bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-400` |
| Inactive/Paused | `bg-gray-100 dark:bg-gray-800 text-gray-500 dark:text-gray-400` |
| Info/Pending | `bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-400` |

### Dark Mode Surface Pairs

| Light | Dark | Use case |
|-------|------|----------|
| `bg-white` | `dark:bg-gray-900` | App background |
| `bg-gray-50` | `dark:bg-gray-800` | Card/surface |
| `bg-gray-100` | `dark:bg-gray-700` | Hover state |
| `bg-gray-200` | `dark:bg-gray-600` | Disabled/skeleton |
| `text-gray-900` | `dark:text-white` | Primary text |
| `text-gray-600` | `dark:text-gray-300` | Body text |
| `text-gray-500` | `dark:text-gray-400` | Secondary text |
| `text-gray-400` | `dark:text-gray-500` | Placeholder/muted |
| `border-gray-200` | `dark:border-gray-700` | Standard border |
| `border-gray-300` | `dark:border-gray-600` | Input border |

## Shadow Scale

| Shadow class | Use case | Notes |
|--------------|----------|-------|
| `shadow-sm` | Subtle card lift, input fields | Base elevation |
| `shadow` | Standard cards, buttons | Standard elevation |
| `shadow-md` | Raised cards, dropdowns | Hover states, menus |
| `shadow-lg` | Modals, popovers | Floating elements |
| `shadow-xl` | Dialogs, high-emphasis surfaces | Max elevation |
| `shadow-none` | Flat/transparent surfaces | Reset elevation |

For colored shadows: `shadow-lg shadow-primary/20`

## Visual Hierarchy Rules

*   **Emphasize primary**: Use `font-bold` or `text-lg` (increase weight or size).
*   **De-emphasize secondary**: Use `text-gray-500 dark:text-gray-400` (change color, not size).
*   **Avoid competing primaries**: Only ONE element should be `text-gray-900 dark:text-white font-bold` per section.
*   **Icons support text**: `text-gray-400` for decorative icons, `text-primary` for active/brand icons.

## Border & Depth Without Shadows

| Effect | When to use | className |
|--------|-------------|-----------|
| Border only | Flat design, dividers | `border border-gray-200 dark:border-gray-700` |
| Background shift | Subtle elevation | `bg-white dark:bg-gray-800` on `bg-gray-50 dark:bg-gray-900` base |
| Shadow + border | Cards, interactive surfaces | `shadow-sm border border-gray-100 dark:border-gray-700` |
| Shadow only | Overlays, floating elements | `shadow-lg` |
