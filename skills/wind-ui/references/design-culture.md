# Design Culture for Wind UI

Actionable design rules for polished Flutter interfaces with Wind UI className tokens.

[Design Philosophy](#design-philosophy) | [Visual Hierarchy](#visual-hierarchy) | [Color System](#color-system) | [Typography](#typography) | [Spacing & Layout](#spacing--layout) | [Depth & Shadows](#depth--shadows) | [Mobile Patterns](#mobile-patterns) | [iOS Navigation Rules](#ios-navigation-rules) | [Anti-Patterns](#anti-patterns)

## Design Philosophy

Three iOS HIG pillars:
1. **Clarity**: Readable text at every size. Spacing, color, weight for hierarchy. Minimal decoration.
2. **Deference**: Content fills the screen. Translucency for context. No decorative shadows.
3. **Depth**: Layered surfaces and realistic motion. Transitions reinforce spatial relationships.

Before writing any widget, answer four questions:

| Question | Purpose |
|:---------|:--------|
| Purpose | What problem does this screen solve? Who uses it? |
| Tone | Pick one direction, commit fully (see tone table) |
| Constraints | Framework limits, performance budgets, accessibility |
| Differentiation | The ONE memorable thing about this interface |

| Tone | Character |
|:-----|:----------|
| Brutally minimal | Max whitespace, single accent, stark contrast |
| Luxury/refined | Generous spacing, muted palette, thin typography |
| Playful/toy-like | Rounded corners, bright accents, bouncy motion |
| Editorial/magazine | Strong type hierarchy, grid discipline, dramatic imagery |
| Soft/pastel | Low saturation, gentle gradients, warm neutrals |

Workflow: design core functionality first, not the shell. Grayscale until hierarchy is clear. Systems before details.

## Visual Hierarchy

Every element sits at one of three levels. See design-tokens.md for className mappings.

| Level | Weight | Color | Usage |
|:------|:-------|:------|:------|
| Primary | 600-700 | Darkest neutral | Headlines, key values (one per section) |
| Secondary | 400-500 | Mid grey | Supporting text, descriptions |
| Tertiary | 400 | Light grey | Metadata, timestamps, copyright |

- Use weight and color before increasing font size. Size is the last lever.
- Emphasize by de-emphasizing: soften competing elements instead of making the target louder.
- Icons are visually heavy; give them softer colors to balance with text.
- Labels are a last resort. Combine: "12 left in stock" beats "Stock: 12".

| Button Level | Style | Rule |
|:-------------|:------|:-----|
| Primary | Solid, high-contrast fill | One per section maximum |
| Secondary | Outline or low-contrast fill | Visible but not competing |
| Tertiary | Styled like a link | Discoverable but unobtrusive |

Destructive actions: big and red on confirmation dialogs only. Tertiary styling on regular screens.

## Color System

See design-tokens.md for semantic colors, status badges, and dark mode surface pairs.

### iOS Semantic Colors to Wind Tokens

| Role | iOS Color (light/dark) | Wind Token | Usage |
|:-----|:-----------------------|:-----------|:------|
| Primary | systemBlue #007AFF / #0A84FF | `bg-primary`, `text-primary` | Links, buttons, tint |
| Success | systemGreen #34C759 / #30D158 | `bg-green-500`, `text-green-600` | Confirmation |
| Error | systemRed #FF3B30 / #FF453A | `bg-red-500`, `text-red-600` | Deletion, errors |
| Warning | systemOrange #FF9500 / #FF9F0A | `bg-yellow-500`, `text-yellow-600` | Caution |
| Premium | systemPurple #AF52DE / #BF5AF2 | `bg-purple-500`, `text-purple-600` | Special features |
| Info | systemTeal #5AC8FA / #64D2FF | `bg-blue-500`, `text-blue-600` | Informational |

### HSL Shade Generation

Use HSL for palette decisions. Hex is for storage, not design.

1. Pick base (500): works as button background.
2. Pick edges: 900 for dark text on light backgrounds, 100 for tinted backgrounds.
3. Fill gaps: 700 and 300 first, then 800, 600, 400, 200.

Saturation: increase as lightness moves away from 50%. Lighten by rotating hue toward 60/180/300 degrees. Darken by rotating toward 0/120/240 degrees. Never rotate more than 20-30 degrees.

Grey temperature: cool = saturate with blue. Warm = saturate with yellow/orange. True black looks unnatural; use very dark grey.

### Dark Mode Layers

Lighter values = more elevation: `gray-900` (base) > `gray-800` (surface) > `gray-700` (elevated). Always define light + dark pairs. Never hardcode hex for UI chrome.

### Contrast

Normal body text: 4.5:1 minimum. Large text (bold 18sp+ or regular 24sp+): 3:1 minimum. Never use color as the sole meaning channel; pair with icons, text, or shape.

## Typography

See design-tokens.md for the full typography hierarchy className table.

### iOS Text Styles to Wind Tokens

| iOS Style | Size | Weight | Wind Equivalent |
|:----------|:-----|:-------|:----------------|
| Large Title | 34pt | Bold | `text-2xl font-bold` |
| Title 1 | 28pt | Regular | `text-xl` |
| Title 2 | 22pt | Regular | `text-lg` |
| Headline | 17pt | Semibold | `text-base font-semibold` |
| Body | 17pt | Regular | `text-base` |
| Subheadline | 15pt | Regular | `text-sm` |
| Caption 1 | 12pt | Regular | `text-xs` |

Minimum: 12px (`text-xs`). Never go below this.

Line height: small text taller (1.5-2.0), large headlines shorter (1.0-1.2), wider content taller. Letter spacing: tighten for headlines, increase for ALL-CAPS, trust the designer for body. Alignment: left by default, center only for headlines and blocks under 3 lines, right-align numbers in columns, baseline-align mixed sizes on one line.

## Spacing & Layout

See design-tokens.md for the full spacing scale and className mappings.

- Start with too much whitespace, then remove. "A little too much" in isolation = "just enough" in context.
- Do not fill the screen. If content needs 300dp, use 300dp.
- More space between groups than within groups. Applies to form labels, section headings, list clusters.
- Large elements shrink faster than small elements across breakpoints.

### iOS Layout Values

| Rule | Value |
|:-----|:------|
| Standard margin (compact) | 16pt (`p-4`) |
| Standard margin (regular) | 20pt (`p-5`) |
| Intra-group spacing | 8pt (`gap-2`) |
| Section spacing | 20pt (`gap-5`) |
| Min touch area | 44x44pt |

### Concentric Shapes

Nest radii: `inner_radius = parent_radius - padding`. A parent with `rounded-2xl` and `p-4` needs a child with smaller radius. Use `rounded-full` for iPhone edge elements. Center elements optically, not mathematically.

Fewer borders: too many = busy. Use box shadows, different background colors, or extra spacing instead.

## Depth & Shadows

See design-tokens.md for the shadow scale className table.

Light from above: raised elements get lighter top edge + shadow below; inset elements get lighter bottom + shadow above. Drag increases shadow; press decreases shadow.

Depth without shadows: lighter than background = raised, darker = inset.

iOS depth style: subtle shadows, blur/frosted glass, minimal elevation. Premium: combine large soft shadow (direct light) with tight dark shadow (ambient occlusion).

## Mobile Patterns

### Forms

Full-width inputs with horizontal padding. Label above or floating. Helper text below. Error: colored border + message. Primary action: full-width button at the bottom.

### Loading and Empty States

Skeleton screens over spinners, always. Shimmer for placeholders. Pull to refresh for lists. Empty states are first impressions: illustration + title + description + CTA. Hide irrelevant UI.

### Feedback

| Type | Use case |
|:-----|:---------|
| Snackbar | Transient message, optional undo |
| Dialog | Requires user decision |
| Bottom sheet | Multiple options to choose from |

### Lists

| Style | Wind approach |
|:------|:-------------|
| Plain | `flex flex-col` with dividers |
| Grouped | Sections with header backgrounds |
| Inset grouped | `mx-4 rounded-xl` with card background |

Min row height: 44pt. Support pull-to-refresh and swipe-to-delete.

## iOS Navigation Rules

| Pattern | When | Rules |
|:--------|:-----|:------|
| Tab Bar | Top-level sections (3-5 tabs) | Persist everywhere. Never hide. Never switch programmatically |
| Hierarchical Push | Parent-detail drill-down | Back button = previous title. Tab bar stays visible. Chevron = push |
| Modal Sheet | Focused tasks | Present from bottom. Explicit dismiss (Cancel/Done/swipe). Medium detent for quick info |

Modal rules: limit stacking to one level. Disable swipe-to-dismiss with unsaved data. Nav bar layout: title center, action right (bold verb), Cancel left. Disable action until required fields filled.

App bar types: standard (title + actions), search (integrated field), collapsing (hero + shrinking title). Leading icons: hamburger opens drawer, back arrow pops navigation, close X dismisses modal.

### Gestures

| Gesture | Behavior |
|:--------|:---------|
| Tap | Activate control, select item |
| Swipe horizontal | Navigate back, reveal delete |
| Long press | Context menu, reorder mode |
| Drag | Move element, scroll content |

Never override system gestures (bottom/top swipe). Shortcuts supplement controls, never replace them.

## Anti-Patterns

| Mistake | Wind-Specific Fix |
|:--------|:------------------|
| Touch target below 44pt | `py-3 px-4` minimum on interactive elements |
| Color-only status | Add icon or text label alongside color |
| Hardcoded hex in UI chrome | Use Wind tokens: `bg-primary`, `text-gray-900` |
| Missing dark mode pair | Always pair: `bg-white dark:bg-gray-900` |
| Modal without dismiss | Add Cancel/Done + swipe-to-dismiss |
| Horizontal scroll on main | Fit layouts to screen width |
| Font below 12px | `text-xs` is the absolute minimum |
| Tab bar hidden mid-navigation | Keep visible across all pushed screens |
| Destructive as primary button | `bg-red-500` with separate Cancel alongside |
| Grey text on colored background | Hand-pick hue-matched color instead |
| Filling screen with sparse content | Constrain width; let content breathe |
| Ambiguous group spacing | More space between groups (`gap-6`) than within (`gap-2`) |
| Ignoring safe area insets | Respect notch and home indicator zones |
