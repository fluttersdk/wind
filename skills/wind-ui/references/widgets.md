# Wind 1.0 — Widget reference

Full constructor surface, every named parameter, every default. Reach for this file when picking a widget, wiring callbacks, or recovering from a "what does this prop do?" stall.

All widgets import from the single barrel:

```dart
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
```

No sub-barrels (`lib/dusk_integration.dart` and similar were removed in 1.0 alpha-10).

## Contents

1. [Conventions shared across W-widgets](#1-conventions-shared-across-w-widgets)
2. [Layout: WDiv, WSpacer, WBreakpoint](#2-layout-wdiv-wspacer-wbreakpoint)
3. [Display: WText, WIcon, WImage, WSvg](#3-display-wtext-wicon-wimage-wsvg)
4. [Interactive: WAnchor, WButton](#4-interactive-wanchor-wbutton)
5. [Form (raw): WInput, WCheckbox, WSelect, WDatePicker](#5-form-raw-winput-wcheckbox-wselect-wdatepicker)
6. [Form (FormField): WFormInput, WFormSelect, WFormMultiSelect, WFormCheckbox, WFormDatePicker](#6-form-formfield-wforminput-wformselect-wformmultiselect-wformcheckbox-wformdatepicker)
7. [Keyboard: WKeyboardActions](#7-keyboard-wkeyboardactions)
8. [Animation: WindAnimationWrapper](#8-animation-windanimationwrapper)
9. [Overlay: WPopover](#9-overlay-wpopover)
10. [Structural: WDynamic](#10-structural-wdynamic)
11. [Supporting types: SelectOption, DateRange, InputType, WDatePickerMode, PopoverAlignment, WindAnimationType](#11-supporting-types)

---

## 1. Conventions shared across W-widgets

- **`className: String?`** — the styling surface. Every W-widget that renders anything visual accepts it. Triple-quoted multi-line when 3+ concerns.
- **`states: Set<String>?`** — consumer-passed state strings (e.g. `{'selected'}`). Merges with the widget's automatic states (`hover`, `focus`, `loading`, `disabled`, `checked`, `error`).
- **`child` XOR `children`** — for widgets that accept both, the assertion fires at construction. Pass exactly one.
- **Outlined icon convention** — when using `Icons.*`, prefer the `_outlined` variant. `Icons.settings_outlined`, not `Icons.settings`.
- **`semanticLabel` for icon-only controls** — `WButton` / `WAnchor` accept `semanticLabel: String?`. An icon-only button (no text child) is nameless to screen readers and Playwright `getByRole('button', { name })` without it; always set it when the child carries no readable text. When set, the child subtree is excluded from semantics, so the label overrides any child text rather than concatenating with it. Prefer it for icon-only controls; omit it when the child already exposes readable text. The label must NOT contain the word "button"; the role appends it (`'Close button'` becomes "Close button button").
- **Inline color escape hatches**:
  - `WDiv(backgroundColor: Color)` overrides any `bg-*` / `dark:bg-*`.
  - `WText(foregroundColor: Color)` overrides any `text-*` / `dark:text-*`.
  - These bypass the parser cache; use them for runtime-dynamic colors (a hex from the API).

---

## 2. Layout: WDiv, WSpacer, WBreakpoint

### `WDiv`

Universal container. Replaces `Container`, `Row`, `Column`, `Wrap`, `Stack`, `SizedBox` for most cases.

```dart
const WDiv({
  Key? key,
  String? className,
  Widget? child,
  List<Widget>? children,           // child XOR children
  WindStyle? style,                 // pre-parsed override (rare)
  Set<String>? states,
  bool scrollPrimary = false,        // PASS true alongside `overflow-y-auto` for iOS tap-to-top
  Color? backgroundColor,           // runtime escape hatch; bypasses className
})
```

Behavior:
- Auto-wraps in `WAnchor` when className contains the literal substrings `hover:`, `focus:`, or `active:`. (Note: `active:` prefix is not yet wired; the substring check is for forward-compatibility.)
- Honors layout tokens (flex, grid, wrap, block), sizing, spacing (padding/margin/gap), positioning, borders, shadows, opacity, transitions, animations.
- Composition pipeline (innermost → outermost): aspect ratio → opacity → animation → Container (decoration + constraints + padding) → scroll/clip → outer sizing → fractional sizing → margin → alignment → flex/expanded.
- `scrollPrimary: true` only applies when className contains `overflow-y-auto`, `overflow-y-scroll`, `overflow-x-auto`, `overflow-x-scroll`, or `overflow-scroll`.
- `flex-*` classes skip the Expanded wrap when `WindFlexOverflowScope.skipExpanded` is true (the main axis is scrollable). This is invisible to consumers and prevents unbounded-constraint assertions.

### `WSpacer`

Lightweight container that reads only `w-N` / `h-N`. Everything else is ignored.

```dart
const WSpacer({
  Key? key,
  String? className,
})
```

Use for explicit gaps inside non-flex contexts. Inside `flex` / `wrap` / `grid`, prefer `gap-N` on the parent.

### `WBreakpoint`

Per-breakpoint `WidgetBuilder` map. Escape hatch when className prefixes are not enough.

```dart
const WBreakpoint({
  Key? key,
  required WidgetBuilder base,           // required fallback
  WidgetBuilder? sm,
  WidgetBuilder? md,
  WidgetBuilder? lg,
  WidgetBuilder? xl,
  WidgetBuilder? xxl,                    // theme key '2xl'
  Map<String, WidgetBuilder>? custom,    // custom theme breakpoints
})
```

Resolves in descending breakpoint order; picks the highest defined builder whose breakpoint ≤ active breakpoint. Falls back to `base`. Custom breakpoints (theme-defined) coexist naturally with built-ins.

```dart
WBreakpoint(
  base: (_) => const MobileLayout(),
  md: (_) => const TabletLayout(),
  lg: (_) => const DesktopLayout(),
)
```

---

## 3. Display: WText, WIcon, WImage, WSvg

### `WText`

Typography only. No `child` / `children`.

```dart
const WText(
  String data,                       // required positional
  {
    Key? key,
    String? className,
    WindStyle? style,
    TextStyle? textStyle,             // merges with parsed style; className wins
    bool selectable = false,
    Set<String>? states,
    Color? foregroundColor,           // runtime escape hatch
  },
)
```

Behavior:
- Renders `Text(data)` or `SelectableText(data)` based on `selectable`.
- Honors typography tokens, color, alignment, transforms, decoration, padding, margin, flex-sizing.
- No animation or opacity at the text level; wrap in `WDiv` for those.
- Text transformation (`uppercase` / `lowercase` / `capitalize`) applied at core level before rendering.

### `WIcon`

Material icon. Use `_outlined` variants by convention.

```dart
const WIcon(
  IconData icon,                    // required positional
  {
    Key? key,
    String? className,
    Set<String>? states,
    String? semanticLabel,
    TextDirection? textDirection,
  },
)
```

Resolution:
- Size: `styles.width ?? styles.height ?? styles.fontSize ?? inheritedSize`. Inherits from `DefaultTextStyle`.
- Color: `styles.color ?? inheritedColor` (also from `DefaultTextStyle`).
- Animation: wraps in `WindAnimationWrapper` when className contains `animate-*`.
- Opacity: `AnimatedOpacity` when both `opacity-*` and `duration-*` are present; otherwise plain `Opacity`.

### `WImage`

Network, asset, or `ImageProvider` source.

```dart
const WImage({
  Key? key,
  String? src,                                       // URL or 'asset://path'
  ImageProvider? image,                              // takes precedence over `src`
  String? alt,
  String? className,
  Set<String>? states,
  Widget? placeholder,
  ImageErrorWidgetBuilder? errorBuilder,             // (context, error, stack) => Widget
  ImageLoadingBuilder? loadingBuilder,
})
```

Assertion: `src != null || image != null`.

Source dispatch:
- `image: ImageProvider` wins (precedence over `src`).
- `src: 'asset://path/to/asset.png'` → `Image.asset('path/to/asset.png')` (prefix stripped).
- `src: 'https://...'` → `Image.network(src)`.

Tokens consumed:
- `object-cover` (default) / `object-contain` / `object-fill` / `object-none` / `object-scale-down` → `BoxFit`
- `aspect-*` → `AspectRatio` wrapping
- `rounded-*` → `ClipRRect`
- `border-*` / `shadow-*` → `Container` decoration
- `w-*` / `h-*` → outer `SizedBox`
- `opacity-*` → `Opacity`

### `WSvg`

Two constructors: asset path OR raw SVG string.

```dart
const WSvg({
  Key? key,
  required String src,                // asset path
  String? className,
  Set<String>? states,
  String? semanticsLabel,
})

const WSvg.string({
  Key? key,
  required String svg,                // raw SVG markup
  String? className,
  Set<String>? states,
  String? semanticsLabel,
})
```

Color resolution priority:
1. `stroke-*` token (outlined-icon use case)
2. `fill-*` token
3. `text-*` token (fallback)
4. Inherited from `DefaultTextStyle`

Apply via `ColorFilter.mode(color, BlendMode.srcIn)`. The `preserve-colors` token disables the filter entirely for multi-color SVGs (QR codes, logos).

---

## 4. Interactive: WAnchor, WButton

### `WAnchor`

Low-level state propagator. Tracks hover and focus; provides `WindAnchorStateProvider` to descendants. Emits `Semantics(button: true)` for accessibility / E2E.

```dart
const WAnchor({
  Key? key,
  required Widget child,
  VoidCallback? onTap,
  VoidCallback? onLongPress,
  VoidCallback? onDoubleTap,
  bool isDisabled = false,
  Set<String>? states,
  MouseCursor? mouseCursor,           // defaults to SystemMouseCursors.click when gestures exist
  String? semanticLabel,              // accessible name for icon-only anchors (no child text for Semantics to absorb)
})
```

Structure (outermost → innermost):
`MergeSemantics` → `Semantics(button: true, enabled: !isDisabled)` → `MouseRegion(onEnter/onExit)` → `WindAnchorStateProvider` (broadcasts hover/focus/disabled state) → `Focus(canRequestFocus: !isDisabled)` → optional `GestureDetector` (only if any callback is non-null) → `child`.

State tracking:
- Hover: `MouseRegion.onEnter` / `onExit` set `_isHovering`; calls `setState` only on change.
- Focus: `FocusNode` listener reads `hasFocus` and calls `setState` on change.
- Press tracking does NOT exist. `active:` prefix is reserved but not wired; `WAnchor` does not detect press duration via `onTapDown` / `onTapUp` today.

### `WButton`

Pressable surface with built-in loading state. Always wraps in `WAnchor`.

```dart
const WButton({
  Key? key,
  required Widget child,
  VoidCallback? onTap,
  VoidCallback? onLongPress,
  VoidCallback? onDoubleTap,
  bool isLoading = false,            // injects `loading:` state, blocks taps
  bool disabled = false,             // injects `disabled:` state, blocks taps
  String? className,
  String? loadingText,               // shown next to spinner
  Widget? loadingWidget,             // overrides default CircularProgressIndicator
  double loadingSize = 16,
  Color? loadingColor,               // explicit override; otherwise contrast-detected
  Set<String>? states,
  String? semanticLabel,             // accessible name for icon-only buttons (no child text for Semantics to absorb)
})
```

Loading state mechanics:
- `isLoading: true` replaces the child with a default 16×16 `CircularProgressIndicator` (2 px stroke) plus optional `loadingText` in a flex row.
- All taps are absorbed via `AbsorbPointer` when loading.
- Spinner color resolution chain: explicit `loadingColor` → `styles.color` (from `text-*`) → contrast color (W3C relative-luminance against background) → white fallback.

Disabled state:
- `disabled: true` blocks all taps and sets the cursor to `SystemMouseCursors.forbidden`.
- The `disabled:` state prefix activates className branches.

State injection summary:
- `loading` — from `isLoading: true`
- `disabled` — from `disabled: true` or `isLoading: true`
- `hover` / `focus` — from `WAnchor` automatically

---

## 5. Form (raw): WInput, WCheckbox, WSelect, WDatePicker

Use raw variants when:
- The field is standalone (no `Form` ancestor).
- State is managed externally (Riverpod, Bloc, ChangeNotifier).
- Validation is bespoke (handled in the controller, not via `FormState.validate()`).

For multi-field forms with declarative validators, use the `WForm*` family (§6).

### `WInput`

Controlled `TextField`.

```dart
const WInput({
  Key? key,
  String? value,                     // controlled value
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmitted,
  VoidCallback? onEditingComplete,
  VoidCallback? onTap,
  TapRegionCallback? onTapOutside,
  InputType type = InputType.text,   // text|password|email|number|multiline
  String? placeholder,
  String? placeholderClassName,
  String? className,
  Set<String>? states,
  bool enabled = true,
  bool autofocus = false,
  bool obscureText = false,          // explicit override; defaults from `type: InputType.password`
  TextEditingController? controller, // optional; widget creates internal one if null
  FocusNode? focusNode,              // optional; widget creates internal one if null
  TextInputAction? textInputAction,
  TextInputType? keyboardType,       // explicit override; defaults from `type`
  TextCapitalization textCapitalization = TextCapitalization.none,
  int? maxLines,
  int? minLines,
  int? maxLength,
  bool readOnly = false,
  Widget? prefix,                    // 12 px left padding, 8 px right
  Widget? suffix,                    // 8 px left padding, 12 px right
  List<TextInputFormatter>? inputFormatters,
  String? semanticLabel,
  // ...
})
```

Keyboard config from `type`:
- `text` → `TextInputType.text`
- `password` → `TextInputType.visiblePassword`, `obscureText: true`
- `email` → `TextInputType.emailAddress`
- `number` → `TextInputType.number`
- `multiline` → `TextInputType.multiline`, allows newlines via Enter

State injection: `focus` (auto when focused) + `disabled` (auto when `!enabled`) + custom states from `states`.

Controller / focusNode ownership:
- External `controller` / `focusNode` not owned (consumer disposes).
- Internal created only when external is null. Disposed on `dispose()`.
- `didUpdateWidget` syncs `value` prop → internal controller text (cursor preserved).

### `WCheckbox`

```dart
const WCheckbox({
  Key? key,
  required bool value,
  ValueChanged<bool>? onChanged,
  String? className,
  String? iconClassName,
  bool disabled = false,
  IconData? checkIcon,               // default Icons.check (MaterialIcons 0xe156)
  Set<String>? states,
})
```

State injection: `checked` (when `value: true`) + `disabled` + custom states.

Default className (appended to user className):
```
w-5 h-5 rounded border border-gray-300 items-center justify-center
checked:bg-blue-500 error:border-red-500 checked:bg-primary checked:border-transparent
```

Uses `checked:bg-primary` which requires a `primary` color family in `WindThemeData.colors`.

### `WSelect<T>`

Dropdown with single OR multi-select, search, async search, tagging, pagination.

```dart
const WSelect({
  Key? key,
  // Single-select mode:
  T? value,
  ValueChanged<T>? onChange,
  // Multi-select mode:
  bool isMulti = false,
  List<T>? values,
  ValueChanged<List<T>>? onMultiChange,
  // Required:
  required List<SelectOption<T>> options,
  // Search:
  bool searchable = false,
  Future<List<SelectOption<T>>> Function(String query)? onSearch,
  String searchPlaceholder = 'Search...',
  // Tagging / create new:
  Future<SelectOption<T>> Function(String query)? onCreateOption,
  CreateOptionBuilder? createOptionBuilder,
  // Pagination:
  Future<List<SelectOption<T>>> Function()? onLoadMore,
  bool hasMore = false,
  // Styling:
  String? className,                 // trigger container
  String? menuClassName,             // dropdown overlay
  Set<String>? states,
  double maxMenuHeight = 300,
  double? menuWidth,                 // defaults to trigger width
  bool disabled = false,
  String? placeholder,
  // Builders:
  SelectTriggerBuilder<T>? triggerBuilder,
  MultiSelectTriggerBuilder<T>? multiTriggerBuilder,
  SelectItemBuilder<T>? itemBuilder,
  SelectedChipBuilder<T>? selectedChipBuilder,
  EmptyStateBuilder? emptyBuilder,
  LoadingBuilder? loadingBuilder,
})
```

Behavior:
- `OverlayPortal` + `CompositedTransformFollower` for positioning.
- Auto-flips upward when space below trigger < `maxMenuHeight` and triggerY > spaceBelow.
- Multi-select keeps menu open after each selection; default chips use `bg-blue-100 rounded px-2 py-0.5`.
- Search: async `onSearch` runs filtering remotely; without it, local `contains`-based filter.
- Pagination: scroll listener triggers `onLoadMore` at 50 px from bottom when `hasMore: true`.

### `WDatePicker`

Calendar popover with single OR range mode.

```dart
const WDatePicker({
  Key? key,
  WDatePickerMode mode = WDatePickerMode.single,
  // Single mode:
  DateTime? value,
  ValueChanged<DateTime>? onChanged,
  // Range mode:
  DateRange? range,
  ValueChanged<DateRange>? onRangeChanged,
  // Constraints:
  DateTime? minDate,
  DateTime? maxDate,
  // Styling:
  String? className,
  String? placeholder,
  Set<String>? states,
  DateDisplayFormat? displayFormat,  // custom formatter callback
})
```

Behavior:
- Wraps a `WPopover` (auto-flip handled by popover).
- Single mode closes after selection. Range mode requires two clicks; auto-swaps if end < start.
- Calendar grid: 42 cells (6 weeks starting Monday); current month + adjacent days; state styling for selected / today / inactive / hover preview.
- `displayFormat: (DateTime) => String` overrides the default "Jan 15, 2025" pattern.

---

## 6. Form (FormField): WFormInput, WFormSelect, WFormMultiSelect, WFormCheckbox, WFormDatePicker

Each extends `FormField<T>` and integrates with Flutter's `Form` + `GlobalKey<FormState>`. Validators receive the nullable typed value. The `error:` state injects automatically when `FormFieldState.hasError`.

### `WFormInput extends FormField<String>`

```dart
const WFormInput({
  Key? key,
  // FormField:
  String? initialValue,
  FormFieldValidator<String>? validator,
  FormFieldSetter<String>? onSaved,
  AutovalidateMode? autovalidateMode,
  String? restorationId,
  bool enabled = true,
  String? forceErrorText,            // bypass validator; set non-null for server errors
  // Layout:
  String? label,
  String? labelClassName,            // default 'text-sm font-medium text-gray-700 mb-1'
  String? hint,
  String? hintClassName,             // default 'text-gray-500 text-xs mt-1'
  bool showError = true,
  String? errorClassName,            // default 'text-red-500 text-xs mt-1'
  // WInput passthrough:
  TextEditingController? controller,
  FocusNode? focusNode,
  InputType type = InputType.text,
  String? placeholder,
  String? className,
  Set<String>? states,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmitted,
  TextInputAction? textInputAction,
  Widget? prefix,
  Widget? suffix,
  int? maxLength,
  // ...
})
```

State synchronization:
- TextEditingController text → `FormFieldState.value` via internal listener.
- External `value` prop changes sync the other direction (`didUpdateWidget`).
- `state.hasError` → `'error'` added to `effectiveStates` → `error:border-red-500` activates.

Validator signature: `String? Function(String?)` inherited from `FormField<String>`.

### `WFormSelect<T> extends FormField<T>`

Single-select with validation. Same props as `WSelect` plus FormField additions.

```dart
const WFormSelect({
  Key? key,
  T? value,
  ValueChanged<T>? onChange,
  required List<SelectOption<T>> options,
  // FormField:
  FormFieldValidator<T>? validator,
  FormFieldSetter<T>? onSaved,
  AutovalidateMode? autovalidateMode,
  bool enabled = true,
  String? forceErrorText,
  // Layout label / hint / error: same as WFormInput
  String? label,
  String? labelClassName,
  String? hint,
  String? hintClassName,
  bool showError = true,
  String? errorClassName,
  // WSelect passthrough: searchable, onSearch, onCreateOption, onLoadMore, hasMore,
  // disabled, menuWidth, maxMenuHeight, className, menuClassName, states, placeholder,
  // triggerBuilder, itemBuilder, emptyBuilder, loadingBuilder
  // ...
})
```

### `WFormMultiSelect<T> extends FormField<List<T>>`

Multi-select with validation. Validator inspects the full `List<T>?`.

```dart
const WFormMultiSelect({
  Key? key,
  List<T>? values,                   // initial selected list
  ValueChanged<List<T>>? onMultiChange,
  required List<SelectOption<T>> options,
  // FormField (operates on List<T>):
  FormFieldValidator<List<T>>? validator,
  FormFieldSetter<List<T>>? onSaved,
  AutovalidateMode? autovalidateMode,
  bool enabled = true,
  String? forceErrorText,
  // Layout: same as WFormSelect
  // WSelect passthrough: searchable, onSearch, onCreateOption, onLoadMore, hasMore,
  // multiTriggerBuilder, selectedChipBuilder, itemBuilder, emptyBuilder, loadingBuilder
  // ...
})
```

### `WFormCheckbox extends FormField<bool>`

Custom `createState()` returns `_WFormCheckboxState` (not default) to sync external `value` prop via `didUpdateWidget`.

```dart
const WFormCheckbox({
  Key? key,
  bool value = false,
  ValueChanged<bool>? onChanged,
  // FormField:
  FormFieldValidator<bool>? validator,
  FormFieldSetter<bool>? onSaved,
  AutovalidateMode? autovalidateMode,
  bool enabled = true,
  String? forceErrorText,
  // Layout:
  Widget? label,                     // custom label widget
  String? labelText,                 // OR plain text label
  String? labelClassName,            // default 'text-sm text-gray-700'
  String? hint,
  String? hintClassName,
  bool showError = true,
  String? errorClassName,
  // WCheckbox passthrough:
  String? className,
  String? iconClassName,
  bool disabled = false,
  IconData? checkIcon,
  Set<String>? states,
})
```

Layout: checkbox + label side-by-side (8 px gap) in a row; error/hint rendered below with `pl-8 pt-1`.

### `WFormDatePicker extends FormField<DateTime>`

Range mode gotcha: stores only `range.start` in `FormFieldState<DateTime>`. Validators can only inspect the start date. For range completeness validation, reach for the internal state separately.

```dart
const WFormDatePicker({
  Key? key,
  DateTime? initialValue,
  DateRange? initialRange,
  WDatePickerMode mode = WDatePickerMode.single,
  ValueChanged<DateTime>? onChanged,
  ValueChanged<DateRange>? onRangeChanged,
  // FormField:
  FormFieldValidator<DateTime>? validator,
  FormFieldSetter<DateTime>? onSaved,
  AutovalidateMode? autovalidateMode,
  bool enabled = true,
  String? forceErrorText,
  // Constraints:
  DateTime? minDate,
  DateTime? maxDate,
  // Layout (defaults documented):
  String? label,
  String? labelClassName,            // default 'text-sm font-medium text-gray-700 dark:text-gray-300 mb-1'
  String? hint,
  String? hintClassName,             // default 'text-gray-500 text-xs mt-1'
  bool showError = true,
  String? errorClassName,            // default 'text-red-500 text-xs mt-1'
  // Styling:
  String? className,
  String? placeholder,
  Set<String>? states,
  DateDisplayFormat? displayFormat,
})
```

---

## 7. Keyboard: WKeyboardActions

Above-keyboard toolbar that adds a Done button and Previous/Next field-navigation controls. Most common use case is iOS numeric keyboards that have no built-in Done button.

```dart
const WKeyboardActions({
  Key? key,
  required Widget child,
  required List<FocusNode> focusNodes,
  String platform = 'all',       // 'all' | 'ios' | 'android'
  bool nextFocus = true,         // show Previous/Next arrows
  String? toolbarClassName,      // Wind bg-* classes for toolbar background
  Widget Function(FocusNode)? closeWidgetBuilder, // replaces default "Done" button
})
```

Usage:
- Create one `FocusNode` per input field. Pass them in focus-navigation order via `focusNodes`.
- Set `platform: 'ios'` to limit the toolbar to iOS (most common pattern for numeric keyboards).
- Set `nextFocus: false` for single-field forms — shows only the Done button.
- `toolbarClassName` accepts any `bg-*` Wind class; always pair with `dark:`. When null the toolbar uses `Theme.of(context).colorScheme.surfaceContainerHighest`.
- `closeWidgetBuilder(node)` receives the focused `FocusNode`; call `node.unfocus()` to dismiss.

```dart
WKeyboardActions(
  platform: 'ios',
  focusNodes: [_nameFocus, _amountFocus],
  toolbarClassName: 'bg-gray-100 dark:bg-gray-800',
  child: Column(
    children: [
      WInput(focusNode: _nameFocus, placeholder: 'Jane Doe'),
      WInput(
        focusNode: _amountFocus,
        placeholder: '0.00',
        type: InputType.number,
      ),
    ],
  ),
)
```

Dispose every `FocusNode` you own in `State.dispose()`. `WKeyboardActions` attaches and removes listeners automatically when the widget updates or disposes.

---

## 8. Animation: WindAnimationWrapper

Low-level stateful wrapper that runs a looping `AnimationController` and applies one of four visual effects to its `child`. It is the
engine behind `animate-*` className tokens; use it directly when you need programmatic control over type, duration, or curve.

```dart
const WindAnimationWrapper({
  Key? key,
  required Widget child,
  required WindAnimationType animationType,
  Duration duration = const Duration(milliseconds: 1000),
  Curve curve = Curves.linear,
})
```

| Prop | Type | Default | Description |
|:-----|:-----|:--------|:------------|
| `child` | `Widget` | **Required** | The widget to animate. |
| `animationType` | `WindAnimationType` | **Required** | `spin`, `ping`, `pulse`, `bounce`, or `none`. |
| `duration` | `Duration` | `Duration(milliseconds: 1000)` | Full cycle length for all types. |
| `curve` | `Curve` | `Curves.linear` | Easing curve passed to the controller. `ping` and `pulse` apply their own `CurvedAnimation` internally. |

Animation mechanics per type:

| Type | Effect | Flutter primitive |
|:-----|:-------|:------------------|
| `spin` | 360-degree continuous rotation. | `RotationTransition` |
| `ping` | Scale 1.0 to 1.5 with matching opacity fade. | `AnimatedBuilder` + `Transform.scale` + `Opacity` |
| `pulse` | Opacity oscillates 1.0 to 0.5, reversing. | `FadeTransition` + `repeat(reverse: true)` |
| `bounce` | Vertical offset 0 to -5 px, reversing. | `AnimatedBuilder` + `Transform.translate` |
| `none` | No-op; returns child unchanged. | Direct child pass-through |

Lifecycle: `didUpdateWidget` stops and restarts the controller when `animationType` or `duration` changes. No manual controller
management is needed by the caller.

Typical usage via className (preferred):

```dart
WIcon(Icons.refresh_outlined, className: 'text-blue-500 dark:text-blue-400 animate-spin')
```

Programmatic usage (needed when child has no `className`):

```dart
WindAnimationWrapper(
  animationType: WindAnimationType.pulse,
  duration: const Duration(milliseconds: 2000),
  child: WDiv(className: 'h-4 w-48 bg-gray-200 dark:bg-gray-700 rounded'),
)
```

---

## 9. Overlay: WPopover

OverlayPortal-based popover with controller + auto-flip + close-on-tap-outside.

```dart
const WPopover({
  Key? key,
  required PopoverTriggerBuilder triggerBuilder,
  required PopoverContentBuilder contentBuilder,
  PopoverController? controller,         // external open/close control
  bool enableTriggerOnTap = true,        // tap on trigger toggles popover
  PopoverAlignment alignment = PopoverAlignment.bottomLeft,
  String? className,                     // overlay container styling
  Offset offset = const Offset(0, 4),    // trigger-to-popover gap
  double maxHeight = 400,
  double? width,                         // fixed overlay width (WSelect parity); overrides w-* token
  double? maxWidth,                      // upper bound; falls back to max-w-* token then screen width
  bool disabled = false,
  bool closeOnContentTap = false,
  VoidCallback? onOpen,
  VoidCallback? onClose,
  bool autoFlip = true,                  // flip alignment when overflow would occur
})
```

Builder signatures:
- `triggerBuilder: Widget Function(BuildContext, bool isOpen, bool isHovering)`
- `contentBuilder: Widget Function(BuildContext, VoidCallback close)`

`PopoverController`:
```dart
class PopoverController extends ChangeNotifier {
  bool get isOpen;
  void show();
  void hide();
  void toggle();
}
```

`computeEffectiveAlignment` (static) is exposed as a standalone utility for pre-calculating the flipped alignment before showing an overlay.

Trigger interactivity: `enableTriggerOnTap` toggling is driven by a pointer-down `Listener`, not a tap `GestureDetector`, so it opens reliably even when `triggerBuilder` returns an interactive widget that owns its own `onTap` (a `WButton` or `WAnchor`). Both the trigger's `onTap` and the popover toggle fire on the same tap. The opening gesture cannot self-dismiss the popover (a one-shot first-frame guard absorbs the opening pointer-up); a genuine later outside tap still closes it.

---

## 10. Structural: WDynamic

Server-driven UI. JSON tree → Wind widget tree.

```dart
const WDynamic({
  Key? key,
  required Map<String, dynamic> json,
  Map<String, Function> actions = const {},          // action handlers
  WDynamicController? controller,                    // external state container
  Set<String>? denyWidgets,                          // block specific widget types
  Map<String, WWidgetBuilder>? builders,             // custom widget types
  Map<String, IconData>? customIcons,                // override / extend icon map
  int maxDepth = 50,                                 // recursion limit
  void Function(String type, Map<String, dynamic> props)? onUnknownWidget,
})
```

JSON node schema:
```json
{
  "type": "WDiv",
  "props": {"className": "...", "id": "...", "onTap": {...}},
  "children": [{"type": "WText", "props": {"text": "..."}}]
}
```

Allowed widget types (13 Wind + 16 Flutter core, by default):
- Wind: `WDiv`, `WText`, `WButton`, `WImage`, `WIcon`, `WAnchor`, `WInput`, `WCheckbox`, `WSvg`, `WSelect`, `WPopover`, `WDatePicker`, `WSpacer`
- Flutter core: `Column`, `Row`, `Center`, `SizedBox`, `Expanded`, `Container`, `Wrap`, `Stack`, `Positioned`, `Padding`, `Align`, `Opacity`, `AspectRatio`, `FittedBox`, `ClipRRect`, `Spacer`

Action format:
```json
{"action": "actionName", "args": {"key": "value"}}
```

Handler signatures (auto-detected):
- `Function(Map<String, dynamic> args)`
- `Function(Map<String, dynamic> args, WDynamicState state)`

`parseValueAction<T>` (used by inputs) auto-injects the changed value as `_value` in args and optionally updates state by `id` before dispatch.

Full JSON contract + state binding + security model: `${CLAUDE_SKILL_DIR}/references/dynamic.md`.

---

## 11. Supporting types

### `SelectOption<T>`

```dart
class SelectOption<T> {
  final T value;
  final String label;
  final bool disabled;        // default false
  final Widget? icon;
  const SelectOption({required this.value, required this.label, this.disabled = false, this.icon});
}
```

Equality based on value + label + disabled (NOT icon).

### `DateRange`

```dart
class DateRange {
  final DateTime start;
  final DateTime end;
  DateRange({required this.start, required this.end});
  bool get isComplete => /* end > start */;
  DateRange copyWith({DateTime? start, DateTime? end});
}
```

### `InputType` enum

```dart
enum InputType { text, password, email, number, multiline }
```

### `WDatePickerMode` enum

```dart
enum WDatePickerMode { single, range }
```

### `PopoverAlignment` enum

```dart
enum PopoverAlignment {
  bottomLeft, bottomCenter, bottomRight,
  topLeft, topCenter, topRight,
}
```

### `WindAnimationType` enum

```dart
enum WindAnimationType { none, spin, ping, pulse, bounce }
```

All loop infinitely. Wired via the `animate-*` className tokens.

### `WindThemeController`

Exposed via `context.windTheme` (extension on `BuildContext`).

```dart
class WindThemeController extends ChangeNotifier {
  Brightness get brightness;
  Map<String, MaterialColor> get colors;
  Map<String, int> get screens;
  WindThemeData get data;

  void toggleTheme();                              // flips brightness; disables syncWithSystem
  void setTheme(WindThemeData newData);
  void updateTheme({Brightness? brightness, Map<String, MaterialColor>? colors, /* ... */});
  void resetToSystem();                            // re-enables OS-brightness sync
  ThemeData toThemeData();                         // for MaterialApp.theme
}
```

`context.windIsDark` is a shortcut for `context.windTheme.brightness == Brightness.dark`.

Full theme customization (custom colors, custom breakpoints, font families, `baseSpacingUnit`): `${CLAUDE_SKILL_DIR}/references/theme.md`.
