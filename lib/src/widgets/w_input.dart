import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';
import '../theme/wind_theme.dart';
import '../utils/wind_logger.dart';

/// Input type enum for WInput widget
///
/// Determines the keyboard type, obscuring behavior, and line configuration.
enum InputType {
  /// Standard text input
  text,

  /// Password input with obscured text
  password,

  /// Email input with email keyboard
  email,

  /// Number input with numeric keyboard
  number,

  /// Multiline text area (like HTML textarea)
  multiline,
}

/// **The Utility-First Input Component**
///
/// `WInput` is a form input widget that combines React-style controlled state
/// management with Tailwind-like utility class styling.
///
/// It renders Material-free: an [EditableText] core inside a decorated
/// `Container`, so it works under any theming ancestor (Material, Cupertino,
/// shadcn, a custom root, or a bare `WidgetsApp`) without requiring a Material
/// ancestor.
///
/// ### Supported Features:
/// - **Controlled Value:** Pass `value` and `onChanged` for React-style binding
/// - **Styling:** `bg-gray-50` `text-gray-900` `rounded-lg` `border-gray-300`
/// - **Focus:** `focus:ring-2` `focus:border-blue-500`
/// - **Placeholders:** Styled via `placeholderClassName`
/// - **States:** `disabled:bg-gray-100` `disabled:cursor-not-allowed`
/// - **Types:** `text`, `password`, `email`, `number`, `multiline`
///
/// ### Example Usage:
///
/// ```dart
/// WInput(
///   value: _email,
///   onChanged: (value) => setState(() => _email = value),
///   type: InputType.email,
///   placeholder: 'Enter your email',
///   className: 'p-3 border border-gray-300 rounded-lg text-gray-900 focus:ring-2 focus:ring-blue-500',
///   placeholderClassName: 'text-gray-400 italic',
/// )
/// ```
///
/// ```dart
/// WInput(
///   value: _email,
///   onChanged: (value) => setState(() => _email = value),
///   type: InputType.email,
///   placeholder: 'Enter your email',
///   className: 'p-3 border border-gray-300 rounded-lg text-gray-900',
///   placeholderClassName: 'text-gray-400',
///   textInputAction: TextInputAction.next,
///   onSubmitted: (value) => _focusNext(),
/// )
/// ```
///
/// See also:
///
///  * [WFormInput], which wraps `WInput` with form validation and `FormField` integration.
///  * [WButton], which is the typical submit trigger paired with `WInput` in a form.
class WInput extends StatefulWidget {
  /// The controlled value of the input.
  ///
  /// When this changes, the internal controller is updated.
  final String? value;

  /// Called when the user changes the input value.
  ///
  /// Follows Flutter's `TextField.onChanged` contract: it fires on user and
  /// IME edits only. Writing `controller.text` programmatically on an external
  /// [controller] does NOT fire this callback, exactly as a bare `EditableText`
  /// behaves. For reactive binding, drive the field through [value] +
  /// [onChanged], or use `WFormInput` when you need form-state propagation.
  final ValueChanged<String>? onChanged;

  /// The type of input, determining keyboard and behavior.
  final InputType type;

  /// Tailwind-like utility classes for styling the input field.
  ///
  /// Supports:
  /// - **Box Model:** `p-3`, `mx-2`, `w-full`, `rounded-lg`
  /// - **Border:** `border`, `border-gray-300`, `border-2`
  /// - **Typography:** `text-lg`, `text-gray-900`, `font-medium`
  /// - **Background:** `bg-white`, `bg-gray-50`
  /// - **States:** `focus:ring-2`, `focus:border-blue-500`, `disabled:bg-gray-100`
  ///
  /// Example: `'w-full p-2.5 bg-gray-50 border border-gray-300 rounded-lg text-sm'`
  final String? className;

  /// Tailwind-like utility classes for styling the placeholder text.
  ///
  /// Supports:
  /// - **Color:** `text-gray-400`, `text-gray-500/50`
  /// - **Typography:** `text-sm`, `italic`, `font-light`
  ///
  /// Example: `'text-gray-400 text-sm italic'`
  final String? placeholderClassName;

  /// Placeholder text shown when the input is empty.
  final String? placeholder;

  /// Whether the input is enabled.
  ///
  /// When false, `disabled:` prefixed classes are applied.
  final bool enabled;

  /// Whether the input is read-only.
  final bool readOnly;

  /// Whether to autofocus on mount.
  final bool autofocus;

  /// The action button on the keyboard (e.g., done, next, search, send).
  ///
  /// Common values:
  /// - `TextInputAction.done` - Shows "Done" button
  /// - `TextInputAction.next` - Shows "Next" button (moves to next field)
  /// - `TextInputAction.search` - Shows "Search" button
  /// - `TextInputAction.send` - Shows "Send" button
  /// - `TextInputAction.go` - Shows "Go" button
  final TextInputAction? textInputAction;

  /// Called when the user submits the input (e.g., presses done/enter/send).
  ///
  /// This is triggered when the user taps the action button on the keyboard.
  final ValueChanged<String>? onSubmitted;

  /// Called when the user finishes editing (taps outside or presses action button).
  ///
  /// Useful for triggering validation or focus changes.
  final VoidCallback? onEditingComplete;

  /// Called when the input field is tapped.
  final VoidCallback? onTap;

  /// Called when the user taps outside the input field.
  ///
  /// Useful for dismissing keyboard or triggering blur actions.
  final TapRegionCallback? onTapOutside;

  /// Maximum number of lines for multiline input.
  ///
  /// Set to `null` for unlimited lines.
  final int? maxLines;

  /// Minimum number of lines for multiline input.
  final int minLines;

  /// Optional external focus node.
  final FocusNode? focusNode;

  /// Optional external text editing controller.
  ///
  /// If provided, the [value] prop is ignored. Note that mutating
  /// `controller.text` yourself updates the displayed text but does not fire
  /// [onChanged], matching Flutter's `EditableText` semantics. See [onChanged].
  final TextEditingController? controller;

  /// Custom states for dynamic styling (e.g., 'error', 'success').
  final Set<String>? states;

  /// Input formatters to apply.
  final List<TextInputFormatter>? inputFormatters;

  /// Text capitalization behavior.
  ///
  /// Defaults to `TextCapitalization.none`.
  final TextCapitalization textCapitalization;

  /// Whether to enable autocorrect.
  final bool autocorrect;

  /// Whether to show suggestions (predictive text).
  final bool enableSuggestions;

  /// Widget to display before the input field (e.g., icon).
  ///
  /// Example:
  /// ```dart
  /// WInput(
  ///   prefix: Icon(Icons.email, size: 20),
  ///   className: 'pl-10 p-3 border rounded-lg',
  /// )
  /// ```
  final Widget? prefix;

  /// Widget to display after the input field (e.g., visibility toggle).
  ///
  /// Example:
  /// ```dart
  /// WInput(
  ///   suffix: IconButton(
  ///     icon: Icon(Icons.visibility),
  ///     onPressed: () => toggleVisibility(),
  ///   ),
  /// )
  /// ```
  final Widget? suffix;

  /// Optional accessibility label override.
  ///
  /// When set, this string is used as the `label` of the underlying
  /// `Semantics(textField: true, ...)` node (and therefore the resulting
  /// `aria-label` on Flutter web). When `null` (default), the [placeholder]
  /// is used as the Semantics label. Form-integrated wrappers such as
  /// [WFormInput] supply this to override the placeholder with the form
  /// field's `label`.
  final String? semanticLabel;

  /// Creates a new [WInput] instance.
  const WInput({
    super.key,
    this.value,
    this.onChanged,
    this.type = InputType.text,
    this.className,
    this.placeholderClassName,
    this.placeholder,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.textInputAction,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.onTapOutside,
    this.maxLines,
    this.minLines = 1,
    this.focusNode,
    this.controller,
    this.states,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.prefix,
    this.suffix,
    this.semanticLabel,
  }) : assert(
          value == null || controller == null,
          'WInput: pass value (controlled) or controller (external), not both; '
          'value is ignored when controller is set.',
        );

  @override
  State<WInput> createState() => _WInputState();
}

class _WInputState extends State<WInput> {
  /// Default content padding (12 horizontal / 8 vertical) used when className
  /// supplies no `p-*`.
  static const EdgeInsets _defaultContentPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 8);

  /// Default visual box matching the previous Material defaults: a 1px grey
  /// border at a 4px radius. Applied when className resolves no decoration.
  static const double _defaultBorderWidth = 1.0;
  static const double _defaultBorderRadius = 4.0;
  static const Color _defaultBorderColor = Color(0xFFD1D5DB); // grey.shade300

  /// Minimum hit target for the suffix slot, so an interactive control (e.g. a
  /// visibility toggle) keeps a usable tap area now that we own the layout.
  static const double _minSuffixTapTarget = 48.0;

  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _ownsController = false;
  bool _ownsFocusNode = false;

  /// Stable identity for the EditableText element. A conditional prefix/suffix
  /// (e.g. a clear button that appears once the field has text) changes the
  /// field's ancestor chain between the Row and no-Row layouts; without a
  /// GlobalKey Flutter would destroy and rebuild the EditableText on that
  /// switch, dropping focus mid-typing. The key moves the same element instead.
  final GlobalKey _editableTextKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initController();
    _initFocusNode();
  }

  void _initController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = TextEditingController(text: widget.value ?? '');
      _ownsController = true;
    }
  }

  void _initFocusNode() {
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
      _ownsFocusNode = false;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  void didUpdateWidget(WInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle controller change
    if (widget.controller != oldWidget.controller) {
      if (_ownsController) {
        _controller.dispose();
      }
      _initController();
    }

    // Handle focus node change
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_onFocusChange);
      if (_ownsFocusNode) {
        _focusNode.dispose();
      }
      _initFocusNode();
    }

    // Sync external value with internal controller
    // Only if we own the controller and value prop changed
    if (_ownsController &&
        widget.value != oldWidget.value &&
        widget.value != _controller.text) {
      _updateControllerValue(widget.value ?? '');
    }
  }

  /// Updates controller text while preserving cursor position
  void _updateControllerValue(String newValue) {
    final currentSelection = _controller.selection;
    _controller.text = newValue;

    // Try to preserve cursor position
    if (currentSelection.isValid && currentSelection.end <= newValue.length) {
      _controller.selection = currentSelection;
    } else if (newValue.isNotEmpty) {
      _controller.selection = TextSelection.collapsed(offset: newValue.length);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build active states set
    final Set<String> activeStates = {
      ...?widget.states,
      if (_isFocused) 'focus',
      if (!widget.enabled) 'disabled',
      if (widget.readOnly) 'readonly',
    };

    // Parse styles with current states
    final WindStyle styles = widget.className != null
        ? WindParser.parse(widget.className!, context, states: activeStates)
        : const WindStyle();

    final logger = WindLogger(
      debug: styles.debug,
      widgetName: runtimeType.toString(),
    );

    if (styles.debug) {
      logger.logStep("ClassName", "'${widget.className}'");
      logger.setFinalStyles(styles);
    }

    // Parse placeholder styles
    final WindStyle placeholderStyles = widget.placeholderClassName != null
        ? WindParser.parse(widget.placeholderClassName!, context)
        : const WindStyle();

    // Determine keyboard type and obscure text
    final (TextInputType keyboardType, bool obscureText) = _getKeyboardConfig();

    // Determine max/min lines. Password/single-line types force maxLines == 1,
    // which EditableText asserts when obscureText is true.
    final int? maxLines =
        widget.type == InputType.multiline ? widget.maxLines : 1;
    final int minLines =
        widget.type == InputType.multiline ? widget.minLines : 1;

    // Build text style from WindStyle, with a brightness-aware baseline color
    // so text stays legible under a bare root with no Material/Cupertino theme.
    // Prefer Wind's effective brightness (the source `dark:` classes resolve
    // against) so the default color matches the rendered background; fall back
    // to the platform brightness only when no WindTheme is present.
    final Brightness brightness = WindTheme.maybeDataOf(context)?.brightness ??
        MediaQuery.maybePlatformBrightnessOf(context) ??
        Brightness.light;
    final Color baselineColor = brightness == Brightness.dark
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF000000);
    final TextStyle textStyle = styles.toTextStyle().color == null
        ? styles.toTextStyle().copyWith(color: baselineColor)
        : styles.toTextStyle();

    // EditableText requires both cursor colors explicitly (no theme to fall
    // back to). Derive from the resolved text color, mirroring WText's
    // brightness fallback (w_text.dart:181-193).
    final Color cursorColor = styles.color ?? baselineColor;

    // Selection highlight must be visible without a theme: prefer the ring
    // color, else a translucent platform-aware default.
    final Color selectionColor = styles.ringColor?.withValues(alpha: 0.4) ??
        (brightness == Brightness.dark
            ? const Color(0x66FFFFFF)
            : const Color(0x663B82F6));

    logger.setCoreWidget("EditableText");
    logger.printFinalCode();

    // Interactive selection (handles + long-press toolbar) reaches for the root
    // Overlay; under a bare root with no Overlay it would throw on long-press.
    // Gate it so typing/cursor/focus still work and only selection UI degrades.
    final bool hasOverlay = Overlay.maybeOf(context) != null;

    // Shared by the EditableText and the placeholder Text so both occupy the
    // exact same line height. Without forcing the same strut on the placeholder
    // the empty-vs-filled box height differs by ~1-2px and the field jumps when
    // the user starts typing.
    final StrutStyle strutStyle = StrutStyle(
      forceStrutHeight: true,
      height: styles.effectiveLineHeight,
      fontSize: styles.fontSize,
      fontWeight: styles.fontWeight,
      fontStyle: styles.fontStyle,
      fontFamily: styles.fontFamily,
    );

    final Widget editable = EditableText(
      key: _editableTextKey,
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: widget.readOnly || !widget.enabled,
      autofocus: widget.autofocus,
      textInputAction: widget.textInputAction ??
          (widget.type == InputType.multiline
              ? TextInputAction.newline
              : TextInputAction.next),
      textCapitalization: widget.textCapitalization,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      maxLines: maxLines,
      minLines: minLines,
      style: textStyle,
      strutStyle: strutStyle,
      cursorColor: cursorColor,
      // The floating-cursor anchor (iOS trackpad drag) uses inactive grey by
      // convention, matching Material/Cupertino TextField; it is not the live
      // cursor color.
      backgroundCursorColor: CupertinoColors.inactiveGray,
      selectionColor: _isFocused ? selectionColor : null,
      selectionControls:
          hasOverlay ? cupertinoTextSelectionHandleControls : null,
      enableInteractiveSelection: hasOverlay,
      contextMenuBuilder: hasOverlay ? _buildContextMenu : null,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
      onTapOutside: widget.onTapOutside,
    );

    // Build the placeholder text style by inheriting typography from the input
    // and applying a softer color when the placeholder className sets none.
    final TextStyle hintStyle = _buildHintStyle(
      styles: styles,
      placeholderStyles: placeholderStyles,
      textStyle: textStyle,
      baselineColor: baselineColor,
    );

    // Stack the placeholder behind the EditableText so it shows only when the
    // field is empty (the EditableText-in-Container recipe; no Material hint).
    Widget field =
        _wrapWithPlaceholder(editable, hintStyle, strutStyle, maxLines);

    // Content padding wraps the text on every side. With a prefix/suffix the
    // text keeps an 8px gap to the adornment while the adornment carries the
    // outer inset to the border; on any side without an adornment the text
    // keeps the full content inset, so it never sits flush against the border.
    final EdgeInsets contentPadding = styles.padding ?? _defaultContentPadding;
    if (widget.prefix != null || widget.suffix != null) {
      field = Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.prefix != null)
            Padding(
              padding: EdgeInsets.only(left: contentPadding.left),
              child: widget.prefix,
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: widget.prefix != null ? 8 : contentPadding.left,
                right: widget.suffix != null ? 8 : contentPadding.right,
                top: contentPadding.top,
                bottom: contentPadding.bottom,
              ),
              child: field,
            ),
          ),
          if (widget.suffix != null)
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: _minSuffixTapTarget,
                minHeight: _minSuffixTapTarget,
              ),
              child: Padding(
                padding: EdgeInsets.only(right: contentPadding.right),
                child: Center(child: widget.suffix),
              ),
            ),
        ],
      );
    } else {
      field = Padding(padding: contentPadding, child: field);
    }

    // Wrap in the decorated box (className → BoxDecoration, same path WDiv
    // uses), recomputing on focus so the ring/border reacts to `_isFocused`.
    Widget result = DecoratedBox(
      decoration: _buildDecoration(styles),
      child: field,
    );

    // Tapping anywhere in the box focuses the field (the box, not just the text
    // glyphs, is the tap target) and fires onTap. EditableText alone only reacts
    // to taps on the text itself; this restores TextField's whole-box behavior.
    if (widget.enabled) {
      result = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (!_focusNode.hasFocus) {
            _focusNode.requestFocus();
          }
          widget.onTap?.call();
        },
        child: result,
      );
    }

    // Accessibility: attach the label to EditableText's own isTextField node.
    // A non-container Semantics merges into the descendant node (default
    // explicitChildNodes: false), producing exactly ONE textField node carrying
    // the label, instead of the second node the old container+MergeSemantics
    // wrapper minted. EditableText already reports value + obscured.
    result = Semantics(
      label: widget.semanticLabel ?? widget.placeholder,
      child: result,
    );

    // Apply Box Model (Margin, Width, Height)
    // WInput needs to respect standard Wind utility classes for sizing and spacing
    final bool hasBoxProps = styles.margin != null ||
        styles.width != null ||
        styles.height != null ||
        styles.widthFactor != null ||
        styles.heightFactor != null ||
        styles.constraints != null;

    if (hasBoxProps) {
      double? width = styles.width;
      double? height = styles.height;

      // Handle w-full / h-full behavior
      if (styles.widthFactor == 1.0) width = double.infinity;
      if (styles.heightFactor == 1.0) height = double.infinity;

      result = Container(
        margin: styles.margin,
        width: width,
        height: height,
        constraints: styles.constraints,
        child: result,
      );
    }

    // Apply Flexible/Expanded wrapper if flex-auto or flex-1 is present
    // This allows WInput to properly expand in flex containers
    if (styles.flex != null) {
      result = Expanded(flex: styles.flex!, child: result);
    } else if (styles.flexFit != null) {
      result = Flexible(fit: styles.flexFit!, child: result);
    }

    // Directionality guarantee: provide a default TextDirection.ltr when no
    // ancestor supplies one, so bare usages outside MaterialApp/WidgetsApp do
    // not throw "No Directionality widget found" (mirrors WText:228-236).
    if (Directionality.maybeOf(context) == null) {
      result = Directionality(textDirection: TextDirection.ltr, child: result);
    }

    return result;
  }

  /// Returns keyboard type and obscureText based on InputType
  (TextInputType, bool) _getKeyboardConfig() {
    return switch (widget.type) {
      InputType.text => (TextInputType.text, false),
      InputType.password => (TextInputType.visiblePassword, true),
      InputType.email => (TextInputType.emailAddress, false),
      InputType.number => (TextInputType.number, false),
      InputType.multiline => (TextInputType.multiline, false),
    };
  }

  /// Builds the visual box from WindStyle, applying the previous Material
  /// defaults (1px grey border, 4px radius) when className resolves none, and
  /// surfacing the focus ring (`ring-*` → `ringColor`/`ringWidth`/`ringShadow`)
  /// as a border + shadow when `_isFocused`.
  BoxDecoration _buildDecoration(WindStyle styles) {
    final BoxDecoration? parsed = styles.decoration;

    final Color? fillColor = parsed?.color;
    final BorderRadius borderRadius = parsed?.borderRadius is BorderRadius
        ? parsed!.borderRadius as BorderRadius
        : BorderRadius.circular(_defaultBorderRadius);

    // Resolve the resting border: className-provided or the grey default.
    // A border width of 0 (border-0) means no border.
    BoxBorder? border;
    if (parsed?.border is Border) {
      final Border b = parsed!.border as Border;
      border = b.top.width == 0 ? null : b;
    } else {
      border = Border.all(
        color: _defaultBorderColor,
        width: _defaultBorderWidth,
      );
    }

    // Focus ring: promote ring color/width to the border and paint the ring
    // shadow, matching the previous focus-on border behavior.
    List<BoxShadow>? boxShadow = styles.boxShadow;
    if (_isFocused &&
        styles.ringShadow != null &&
        styles.ringShadow!.isNotEmpty) {
      boxShadow = styles.ringShadow;
      final Color ringColor = styles.ringColor ?? _defaultBorderColor;
      final double ringWidth = styles.ringWidth ?? _defaultBorderWidth;
      border = Border.all(color: ringColor, width: ringWidth);
    }

    return BoxDecoration(
      color: fillColor,
      border: border,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      gradient: parsed?.gradient,
      image: parsed?.image,
    );
  }

  /// Builds the placeholder text style by inheriting the input's typography and
  /// softening the color when the placeholder className supplies none.
  TextStyle _buildHintStyle({
    required WindStyle styles,
    required WindStyle placeholderStyles,
    required TextStyle textStyle,
    required Color baselineColor,
  }) {
    TextStyle hintStyle = textStyle.merge(placeholderStyles.toTextStyle());

    if (placeholderStyles.color == null) {
      final Color base = styles.color ?? baselineColor;
      hintStyle = hintStyle.copyWith(color: base.withValues(alpha: 0.5));
    }

    return hintStyle;
  }

  /// Stacks the placeholder behind [editable], visible only while the field is
  /// empty. Listens to the controller so it toggles as the user types.
  Widget _wrapWithPlaceholder(
    Widget editable,
    TextStyle hintStyle,
    StrutStyle strutStyle,
    int? maxLines,
  ) {
    if (widget.placeholder == null) {
      return editable;
    }

    return Stack(
      children: [
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, value, child) {
            if (value.text.isNotEmpty) {
              return const SizedBox.shrink();
            }
            // ExcludeSemantics: the visible placeholder must not leak into the
            // accessible name. The single outer Semantics(label: ...) node owns
            // the label (W1); without this exclusion the placeholder Text would
            // merge a duplicate/extra label (e.g. "Email\nEmail").
            return ExcludeSemantics(
              child: IgnorePointer(
                // The placeholder shares the EditableText strut so the box keeps
                // the same height whether it is empty or filled (no jump on the
                // first keystroke).
                child: Text(
                  widget.placeholder!,
                  style: hintStyle,
                  strutStyle: strutStyle,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        ),
        editable,
      ],
    );
  }

  /// Builds a Material-free selection toolbar (Cupertino chrome) whose action
  /// labels read from [WidgetsLocalizations], which is always resolvable (via
  /// `DefaultWidgetsLocalizations`) even with no Material/Cupertino ancestor.
  Widget _buildContextMenu(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    final WidgetsLocalizations localizations = WidgetsLocalizations.of(context);
    final TextSelectionToolbarAnchors anchors =
        editableTextState.contextMenuAnchors;

    final List<Widget> children = [
      for (final ContextMenuButtonItem item
          in editableTextState.contextMenuButtonItems)
        CupertinoTextSelectionToolbarButton.text(
          onPressed: item.onPressed,
          text: _contextMenuLabel(item, localizations),
        ),
    ];

    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return CupertinoTextSelectionToolbar(
      anchorAbove: anchors.primaryAnchor,
      anchorBelow: anchors.secondaryAnchor ?? anchors.primaryAnchor,
      children: children,
    );
  }

  /// Maps a context-menu button to its localized label, preferring the
  /// `WidgetsLocalizations` strings for the standard edit actions and falling
  /// back to the button item's own label for anything else.
  String _contextMenuLabel(
    ContextMenuButtonItem item,
    WidgetsLocalizations localizations,
  ) {
    return switch (item.type) {
      ContextMenuButtonType.copy => localizations.copyButtonLabel,
      ContextMenuButtonType.cut => localizations.cutButtonLabel,
      ContextMenuButtonType.paste => localizations.pasteButtonLabel,
      ContextMenuButtonType.selectAll => localizations.selectAllButtonLabel,
      _ => item.label ?? '',
    };
  }
}
