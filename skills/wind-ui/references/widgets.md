# Wind UI Widget Reference (v1.0.0)

Every public W-widget with its constructor surface, key invariants, and the consumer code shape that uses it. Read for depth when SKILL.md's at-a-glance table is not enough.

## Index

- [Layout](#layout): `WDiv`, `WSpacer`
- [Display](#display): `WText`, `WIcon`, `WImage`, `WSvg`
- [Interactive](#interactive): `WButton`, `WAnchor`
- [Form (base)](#form-base): `WInput`, `WCheckbox`, `WSelect`, `WDatePicker`
- [Form (FormField wrappers)](#form-formfield-wrappers): `WFormInput`, `WFormSelect`, `WFormMultiSelect`, `WFormCheckbox`, `WFormDatePicker`
- [Overlay](#overlay): `WPopover`
- [Structural](#structural): `WDynamic`, `WBreakpoint`

Every widget accepts `className: String?` (the styling API) and most accept `states: Set<String>?` (state-prefix activator). Explicit Dart props always override the className-derived value.

## Layout

### `WDiv`

Universal container. Maps to Container/Row/Column/Stack/Wrap/GridView depending on className tokens. Auto-wraps in `WAnchor` when className contains `hover:` / `focus:` / `active:` prefixes.

```dart
const WDiv({
  Key? key,
  String? className,
  Widget? child,                       // XOR with children
  List<Widget>? children,              // XOR with child
  WindStyle? style,                    // pre-parsed style (advanced)
  Set<String>? states,                 // 'selected', 'loading', custom...
  bool scrollPrimary = false,          // MANDATORY on root scrollables for iOS tap-to-top
  Color? backgroundColor,              // runtime override; bypasses cache
})
```

**Invariants:**
- `child` XOR `children` (assertion at construction).
- `scrollPrimary: true` is required on any WDiv whose className includes `overflow-y-auto`/`overflow-y-scroll` — there is no className equivalent.
- Inline `backgroundColor` overrides any `bg-*` className token and is excluded from the parser cache key (good for dynamic colors like color pickers).

### `WSpacer`

Lightweight SizedBox that ONLY extracts width/height from className. Use it when you do not want any of WDiv's composition logic.

```dart
const WSpacer({Key? key, String? className})  // className extracts w-N / h-N only
```

## Display

### `WText`

Typography. Note the irregular constructor: required positional `data: String` precedes `super.key`.

```dart
const WText(
  String data, {                       // required positional
  Key? key,
  String? className,
  WindStyle? style,
  TextStyle? textStyle,                // merged AFTER className-derived TextStyle
  bool selectable = false,             // SelectableText fallback
  Set<String>? states,
  Color? foregroundColor,              // runtime override
})
```

**Invariants:**
- `selectable: true` swaps the underlying widget to `SelectableText`; behavior identical otherwise.
- `textStyle` is MERGED with the parsed className style; classname wins on overlap.

### `WIcon`

Material icons. Use the `*_outlined` variant family — Wind's icons are outlined by design convention.

```dart
const WIcon(
  IconData icon, {                     // required positional
  Key? key,
  String? className,
  Set<String>? states,
  String? semanticLabel,
  TextDirection? textDirection,
})
```

Color and size inherit from the enclosing `DefaultTextStyle`. Apply `text-red-500` / `text-2xl` to the parent or to the icon's className directly. Animations (`animate-spin`, `animate-pulse`) and opacity work.

### `WImage`

Network, asset, or `ImageProvider` source. `object-cover` is the default fit.

```dart
const WImage({
  Key? key,
  String? src,                         // 'https://...' OR 'asset://path/to/img.png'
  ImageProvider? image,                // alt: provide a provider directly
  String? alt,                         // → semanticLabel
  String? className,
  Set<String>? states,
  Widget? placeholder,
  ImageErrorBuilder? errorBuilder,
  ImageLoadingBuilder? loadingBuilder,
})  // assert(src != null || image != null)
```

**Asset path prefix**: prepend `asset://` to use `Image.asset`; otherwise treated as network URL. `object-cover`/`object-contain`/`object-fill`/`object-none`/`object-scale-down` map to `BoxFit`. `aspect-square`/`aspect-video`/`aspect-[N/M]` wrap in `AspectRatio`. `rounded-*` wraps in `ClipRRect`.

### `WSvg`

SVG renderer. Two constructors.

```dart
const WSvg({
  Key? key,
  required String src,                 // asset: 'assets/foo.svg' OR network URL
  String? className,
  Set<String>? states,
  String? semanticsLabel,
})

const WSvg.string(
  String svg, {                        // raw SVG markup as a string
  Key? key,
  String? className,
  Set<String>? states,
  String? semanticsLabel,
})
```

**Color tokens** (`fill-blue-500`, `stroke-current`) apply via `ColorFilter`. The class `preserve-colors` opts out for multi-color brand SVGs.

## Interactive

### `WButton`

Always wraps in `WAnchor`. Has a built-in loading state.

```dart
const WButton({
  Key? key,
  required Widget child,
  VoidCallback? onTap,
  VoidCallback? onLongPress,
  VoidCallback? onDoubleTap,
  bool isLoading = false,              // injects 'loading' into states
  bool disabled = false,               // injects 'disabled' into states
  String? className,
  String? loadingText,                 // optional text beside the spinner
  Widget? loadingWidget,               // override the default spinner
  double loadingSize = 16,
  Color? loadingColor,                 // override the auto-contrast color
  Set<String>? states,
})
```

`isLoading: true` activates `loading:` prefixed classes and disables tap. `disabled: true` activates `disabled:` and disables tap. Spinner color: `loadingColor` > `styles.color` > auto-contrast against `bg-*`.

### `WAnchor`

Lower-level than `WButton`. The gesture + focus + hover state propagator that powers `WDiv` / `WButton` auto-wrapping. Use it when you want hover/focus on a complex composition without a button shape.

```dart
const WAnchor({
  Key? key,
  required Widget child,
  VoidCallback? onTap,
  VoidCallback? onLongPress,
  VoidCallback? onDoubleTap,
  bool isDisabled = false,
  Set<String>? states,
  MouseCursor? mouseCursor,
})
```

Children read the state via `WindAnchorStateProvider.of(context)` — typically via a `Builder` inside the anchor.

## Form (base)

These are the controlled-state widgets. Use directly when you do NOT need `Form` integration; use the `WForm*` wrappers (next section) when you DO.

### `WInput`

Controlled `TextField`. Manages `TextEditingController` + `FocusNode` lifecycle when not provided.

```dart
const WInput({
  Key? key,
  String? value,                       // controlled value
  ValueChanged<String>? onChanged,
  InputType type = InputType.text,     // text | password | email | number | multiline | tel | url | search
  String? className,
  String? placeholderClassName,
  String? placeholder,
  bool enabled = true,
  bool readOnly = false,
  bool autofocus = false,
  TextInputAction? textInputAction,
  ValueChanged<String>? onSubmitted,
  VoidCallback? onEditingComplete,
  VoidCallback? onTap,
  TapRegionCallback? onTapOutside,
  int? maxLines,                       // only set for multiline; default null
  int minLines = 1,
  FocusNode? focusNode,                // optional; otherwise WInput owns one
  TextEditingController? controller,   // optional; otherwise WInput owns one
  Set<String>? states,
  List<TextInputFormatter>? inputFormatters,
  TextCapitalization textCapitalization = TextCapitalization.none,
  bool autocorrect = true,
  bool enableSuggestions = true,
  Widget? prefix,                      // leading widget inside the field
  Widget? suffix,                      // trailing widget inside the field
  String? semanticLabel,               // accessibility label (a11y)
})
```

**Multiline**: set `type: InputType.multiline` AND `maxLines`/`minLines`. `OutlineInputBorder.gapPadding` is forced to `0.0` so `px-*` produces exact pixel insets (Material's label-cutout reservation is bypassed).

### `WCheckbox`

Boolean checkbox. Activates `checked:` prefix when `value: true`.

```dart
const WCheckbox({
  Key? key,
  required bool value,
  ValueChanged<bool>? onChanged,
  String? className,
  String? iconClassName,               // styles the check mark itself
  bool disabled = false,
  IconData? checkIcon,                 // default: Icons.check
  Set<String>? states,
})
```

### `WSelect<T>`

Single OR multi-select dropdown with overlay. Searchable, paginated, taggable.

```dart
const WSelect<T>({
  Key? key,
  T? value,                            // single-mode value
  ValueChanged<T>? onChange,           // single-mode callback
  bool isMulti = false,
  List<T>? values,                     // multi-mode values
  ValueChanged<List<T>>? onMultiChange,// multi-mode callback
  SelectedChipBuilder<T>? selectedChipBuilder,
  required List<SelectOption<T>> options,
  bool searchable = false,
  Future<List<SelectOption<T>>> Function(String query)? onSearch,
  String searchPlaceholder = 'Search...',
  Future<SelectOption<T>> Function(String query)? onCreateOption,
  CreateOptionBuilder? createOptionBuilder,
  Future<List<SelectOption<T>>> Function()? onLoadMore,
  bool hasMore = false,
  String? className,
  String? menuClassName,
  String placeholder = 'Select an option',
  bool disabled = false,
  double? menuWidth,
  double maxMenuHeight = 300,
  Set<String>? states,
  SelectTriggerBuilder<T>? triggerBuilder,
  MultiSelectTriggerBuilder<T>? multiTriggerBuilder,
  SelectItemBuilder<T>? itemBuilder,
  EmptyStateBuilder? emptyBuilder,
  LoadingBuilder? loadingBuilder,
})
```

**Single vs multi APIs are distinct**: never mix `value`/`onChange` with `values`/`onMultiChange`. The overlay auto-flips direction (above/below trigger) on screen-edge collision.

### `WDatePicker`

Single date or date range. Popover-based.

```dart
const WDatePicker({
  Key? key,
  DatePickerMode mode = DatePickerMode.single,  // single | range
  DateTime? value,                              // single-mode
  DateRange? range,                             // range-mode
  ValueChanged<DateTime>? onChanged,
  ValueChanged<DateRange>? onRangeChanged,
  DateTime? minDate,
  DateTime? maxDate,
  String? className,
  String placeholder = 'Select date',
  bool disabled = false,
  Set<String> states = const {},
  DateDisplayFormat? displayFormat,             // override the trigger label format
})
```

## Form (FormField wrappers)

Each wraps the base widget and extends `FormField<T>`. Use these inside a `Form(key: _formKey)`. They auto-inject `error:` state when `state.hasError` and render the error message below the field.

### `WFormInput` (extends `FormField<String>`)

```dart
WFormInput({
  Key? key,
  TextEditingController? controller,
  String? initialValue,
  FormFieldValidator<String>? validator,        // (value) => null on pass, error string on fail
  FormFieldSetter<String>? onSaved,
  AutovalidateMode? autovalidateMode,
  String? restorationId,
  bool enabled = true,
  FocusNode? focusNode,
  InputType type = InputType.text,
  String? placeholder,
  String? className,
  String? placeholderClassName,
  TextInputAction? textInputAction,
  ValueChanged<String>? onSubmitted,
  ValueChanged<String>? onChanged,
  VoidCallback? onEditingComplete,
  VoidCallback? onTap,
  TapRegionCallback? onTapOutside,
  Widget? label,                                // optional label widget above the field
  String? labelText,                            // alt: label text
  String labelClassName = 'text-sm ...',
  Widget? hint,                                 // hint below the field (shown when no error)
  String hintClassName = 'text-gray-500 text-xs mt-1',
  bool showError = true,
  String errorClassName = 'text-red-500 text-xs mt-1',
  // ...all WInput pass-through props
})
```

### `WFormSelect<T>` / `WFormMultiSelect<T>`

Same pattern as `WFormInput`. `WFormSelect` extends `FormField<T>`; `WFormMultiSelect` extends `FormField<List<T>>`.

### `WFormCheckbox` (extends `FormField<bool>`)

Custom `FormFieldState` subclass to sync external `value` changes via `didUpdateWidget`.

### `WFormDatePicker` (extends `FormField<DateTime>`)

`mode: DatePickerMode.range` is supported; the form state holds the range start for simple validators.

**Common form recipe:**

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: WDiv(
    className: 'flex flex-col gap-4',
    children: [
      WFormInput(
        labelText: 'Email',
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        className: '''
          px-3 py-2 rounded-lg
          border border-gray-300 dark:border-gray-600
          bg-white dark:bg-gray-800
          error:border-red-500 error:ring-2 error:ring-red-200
        ''',
      ),
      WButton(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            // submit
          }
        },
        className: 'bg-blue-600 dark:bg-blue-700 text-white px-4 py-2 rounded-lg',
        child: const WText('Submit'),
      ),
    ],
  ),
);
```

Full forms reference: `references/forms.md`.

## Overlay

### `WPopover`

Anchored overlay via `OverlayPortal` + `CompositedTransformFollower`. Auto-flips direction on screen-edge collision.

```dart
WPopover({
  Key? key,
  required PopoverTriggerBuilder triggerBuilder,
  required PopoverContentBuilder contentBuilder,
  PopoverController? controller,                // external open/close control
  PopoverAlignment alignment = PopoverAlignment.bottomLeft,
  bool disabled = false,
  String? className,
  double? maxHeight,
  double? maxWidth,
  Offset offset = Offset.zero,
  VoidCallback? onOpen,
  VoidCallback? onClose,
})
```

**`PopoverController`**: external control via `controller.show()` / `controller.hide()` / `controller.toggle()`. Listenable; `addListener` works for state-bound chrome.

## Structural

### `WDynamic`

Renders Flutter widget trees from JSON with whitelist security + id-keyed state binding + action dispatch. Use for server-driven UI, in-app config screens, or CMS-driven layouts.

```dart
const WDynamic({
  Key? key,
  required Map<String, dynamic> json,
  Map<String, Function> actions = const {},    // 'submit': (args) => ..., or (args, state) => ...
  WDynamicController? controller,               // external state ownership
  Set<String>? denyWidgets,                     // block specific types
  Map<String, WWidgetBuilder>? builders,        // custom type → widget builder
  Map<String, IconData>? customIcons,           // extend the 256-icon map
  int maxDepth = 50,                            // recursion guard
  Widget Function(String type, Object error)? onError,
  Widget Function(String type, Map<String, dynamic> props)? onUnknownWidget,
})
```

**Security**: `builders` > `denyWidgets` > default whitelist. Disallowed types render an error widget unless `onUnknownWidget` is provided. See the parent project's `.claude/rules/dynamic.md` for the full security model + two documented bugs (`WSelect<String>+null` crash, `WDatePicker.onChange` asymmetry).

### `WBreakpoint`

Declarative per-breakpoint widget builder. Use when the WIDGET STRUCTURE — not just style — changes between breakpoints.

```dart
const WBreakpoint({
  Key? key,
  required WidgetBuilder base,                  // fallback for base + anything below sm
  WidgetBuilder? sm,
  WidgetBuilder? md,
  WidgetBuilder? lg,
  WidgetBuilder? xl,
  WidgetBuilder? xxl,                           // '2xl' — dart identifier can't start with a digit
  Map<String, WidgetBuilder> custom = const {}, // override with custom screen keys
})
```

Resolves to the highest-matching builder ≤ active breakpoint. When all you need is style differences across breakpoints, use className prefixes instead (`md:grid-cols-2 lg:grid-cols-3`).

## Convention quick-list

- `super.key` first in const constructors, except `WText` (positional `data` first).
- `child` XOR `children` invariant.
- `className: String?` accepts triple-quoted multi-line for 3+ concerns.
- `states: Set<String>?` activates state-prefixed classes.
- Inline color props (`backgroundColor`, `foregroundColor`) override className AND bypass cache.
- All form-base widgets manage internal `TextEditingController` / `FocusNode` / overlay state unless one is provided.
- All `WForm*` wrappers delegate to an internal `_W{Form*}Content` stateful widget; the outer `FormField` stays `const`-constructible.

## What is NOT a public W-widget

- `WindAnchorStateProvider` — InheritedWidget for `WAnchor` internals. Consume via `.of(context)`; do not construct.
- `WindAnimationWrapper` — exported but rarely used directly; `animate-spin` / `animate-pulse` / `animate-bounce` / `animate-ping` className tokens compose this for you.
- `WKeyboardActions` — exists for iOS-keyboard toolbar UX but is not part of the 19-widget v1 roster; treat as advanced/internal.
- `select_option.dart` (`SelectOption<T>`) — value type passed to `WSelect.options`, not a widget.
- `WindStyle`, `WindContext`, `WindParser` — parser plumbing; the consumer should never construct these directly.
