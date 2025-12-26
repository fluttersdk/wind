import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';
import '../theme/wind_theme.dart';
import '../theme/wind_theme_data.dart';
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
class WInput extends StatefulWidget {
  /// The controlled value of the input.
  ///
  /// When this changes, the internal controller is updated.
  final String? value;

  /// Called when the user changes the input value.
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
  /// If provided, `value` prop is ignored.
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
  });

  @override
  State<WInput> createState() => _WInputState();
}

class _WInputState extends State<WInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _ownsController = false;
  bool _ownsFocusNode = false;

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

    // Build InputDecoration from WindStyle
    final InputDecoration decoration = _buildInputDecoration(
      context: context,
      styles: styles,
      placeholderStyles: placeholderStyles,
    );

    // Determine keyboard type and obscure text
    final (TextInputType keyboardType, bool obscureText) = _getKeyboardConfig();

    // Determine max/min lines
    final int? maxLines = widget.type == InputType.multiline
        ? widget.maxLines
        : 1;
    final int minLines = widget.type == InputType.multiline
        ? widget.minLines
        : 1;

    // Build text style from WindStyle
    final TextStyle textStyle = styles.toTextStyle();

    logger.setCoreWidget("TextField");
    logger.printFinalCode();

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      textInputAction:
          widget.textInputAction ??
          (widget.type == InputType.multiline
              ? TextInputAction.newline
              : TextInputAction.next),
      textCapitalization: widget.textCapitalization,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      maxLines: maxLines,
      minLines: minLines,
      style: textStyle,
      decoration: decoration,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
      onTap: widget.onTap,
      onTapOutside: widget.onTapOutside,
    );
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

  /// Builds InputDecoration from WindStyle
  InputDecoration _buildInputDecoration({
    required BuildContext context,
    required WindStyle styles,
    required WindStyle placeholderStyles,
  }) {
    final theme = WindTheme.of(context);

    // Extract padding from styles
    final EdgeInsets contentPadding =
        styles.padding ??
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8);

    // Extract background color
    Color? fillColor;
    bool filled = false;
    if (styles.decoration?.color != null) {
      fillColor = styles.decoration!.color;
      filled = true;
    }

    // Extract border configuration
    final InputBorder border = _buildBorder(styles, theme, isFocused: false);
    final InputBorder focusedBorder = _buildBorder(
      styles,
      theme,
      isFocused: true,
    );
    final InputBorder disabledBorder = _buildBorder(
      styles,
      theme,
      isDisabled: true,
    );

    // Build hint style from placeholderStyles or fallback
    TextStyle hintStyle = placeholderStyles.toTextStyle();

    // If no placeholder color specified, use text color with lower opacity
    if (placeholderStyles.color == null && styles.color != null) {
      hintStyle = hintStyle.copyWith(
        color: styles.color!.withValues(alpha: 0.5),
      );
    } else if (placeholderStyles.color == null) {
      hintStyle = hintStyle.copyWith(color: Colors.grey.shade500);
    }

    return InputDecoration(
      hintText: widget.placeholder,
      hintStyle: hintStyle,
      contentPadding: contentPadding,
      filled: filled,
      fillColor: fillColor,
      border: border,
      enabledBorder: border,
      focusedBorder: focusedBorder,
      disabledBorder: disabledBorder,
      isDense: true,
    );
  }

  /// Builds border from WindStyle
  InputBorder _buildBorder(
    WindStyle styles,
    WindThemeData theme, {
    bool isFocused = false,
    bool isDisabled = false,
  }) {
    // Get border from decoration if available
    final boxDecoration = styles.decoration;

    // Default values
    double borderWidth = 1.0;
    Color borderColor = Colors.grey.shade300;
    double borderRadius = 4.0;

    // Extract border properties from BoxDecoration
    if (boxDecoration != null) {
      // Border width and color
      if (boxDecoration.border is Border) {
        final border = boxDecoration.border as Border;
        borderWidth = border.top.width;
        borderColor = border.top.color;
      }

      // Border radius
      if (boxDecoration.borderRadius is BorderRadius) {
        final br = boxDecoration.borderRadius as BorderRadius;
        borderRadius = br.topLeft.x;
      }
    }

    // Apply ring shadow as focus indicator if present
    if (isFocused &&
        styles.ringShadow != null &&
        styles.ringShadow!.isNotEmpty) {
      // Ring color becomes border color on focus
      if (styles.ringColor != null) {
        borderColor = styles.ringColor!;
      }
      // Ring width adds to border
      if (styles.ringWidth != null && styles.ringWidth! > 0) {
        borderWidth = styles.ringWidth!;
      }
    }

    // Disabled state
    if (isDisabled) {
      borderColor = Colors.grey.shade200;
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    );
  }
}
