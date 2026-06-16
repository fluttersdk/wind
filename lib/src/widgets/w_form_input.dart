import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'w_input.dart';
import 'w_text.dart';
import 'w_div.dart';

/// A Wind-styled input that integrates with Flutter's Form validation.
///
/// This widget wraps [WInput] with [FormField] to provide:
/// - Native Form validation support
/// - Automatic error state styling (activates `error:` prefixed classes)
/// - Controller synchronization with FormFieldState
/// - Optional error message display
///
/// ## Basic Usage
///
/// ```dart
/// Form(
///   key: _formKey,
///   child: Column(
///     children: [
///       WFormInput(
///         controller: _emailController,
///         type: InputType.email,
///         placeholder: 'Enter your email',
///         className: 'p-3 border border-gray-300 rounded-lg error:border-red-500',
///         validator: (value) {
///           if (value == null || value.isEmpty) {
///             return 'Email is required';
///           }
///           return null;
///         },
///       ),
///       FilledButton(
///         onPressed: () {
///           if (_formKey.currentState!.validate()) {
///             // Form is valid
///           }
///         },
///         child: Text('Submit'),
///       ),
///     ],
///   ),
/// )
/// ```
///
/// ## Error Styling
///
/// When validation fails, the `error` state is automatically added,
/// activating any `error:` prefixed classes:
///
/// ```dart
/// WFormInput(
///   className: '''
///     p-3 border border-gray-300 rounded-lg
///     error:border-red-500 error:ring-2 error:ring-red-200
///   ''',
///   validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
/// )
/// ```
///
/// ## Controller Bridge with Magic
///
/// Bridge with Magic controller validation:
///
/// ```dart
/// WFormInput(
///   controller: _emailController,
///   type: InputType.email,
///   validator: (_) => controller.getError('email'),
/// )
/// ```
class WFormInput extends FormField<String> {
  /// Creates a Wind-styled form input.
  ///
  /// The [controller] is used to read and write the text value.
  /// If not provided, an internal controller is created.
  WFormInput({
    super.key,
    this.controller,
    String? initialValue,
    super.validator,
    super.onSaved,
    super.autovalidateMode,
    super.restorationId,
    super.enabled = true,

    // WInput props
    this.focusNode,
    this.type = InputType.text,
    this.placeholder,
    this.className,
    this.placeholderClassName,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.onTapOutside,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines,
    this.minLines = 1,
    this.states,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,

    // Error display
    this.showError = true,
    this.errorClassName = 'text-red-500 dark:text-red-400 text-xs mt-1',

    // Label
    this.label,
    this.labelClassName =
        'text-sm font-medium text-gray-700 dark:text-gray-300 mb-1',

    // Hint
    this.hint,
    this.hintClassName = 'text-gray-500 dark:text-gray-400 text-xs mt-1',

    // Prefix/Suffix
    this.prefix,
    this.suffix,
  }) : super(
          initialValue: controller?.text ?? initialValue ?? '',
          builder: (FormFieldState<String> state) {
            return _WFormInputContent(
              state: state,
              controller: controller,
              focusNode: focusNode,
              type: type,
              placeholder: placeholder,
              className: className,
              placeholderClassName: placeholderClassName,
              textInputAction: textInputAction,
              onSubmitted: onSubmitted,
              onChanged: onChanged,
              onEditingComplete: onEditingComplete,
              onTap: onTap,
              onTapOutside: onTapOutside,
              readOnly: readOnly,
              autofocus: autofocus,
              maxLines: maxLines,
              minLines: minLines,
              enabled: enabled,
              states: states,
              inputFormatters: inputFormatters,
              textCapitalization: textCapitalization,
              autocorrect: autocorrect,
              enableSuggestions: enableSuggestions,
              showError: showError,
              errorClassName: errorClassName,
              label: label,
              labelClassName: labelClassName,
              hint: hint,
              hintClassName: hintClassName,
              prefix: prefix,
              suffix: suffix,
            );
          },
        );

  /// Optional external [TextEditingController].
  ///
  /// If provided, the controller's text is used as the initial value
  /// and changes are synced with the form field state.
  final TextEditingController? controller;

  /// Optional external [FocusNode].
  final FocusNode? focusNode;

  /// The type of input, determining keyboard and behavior.
  final InputType type;

  /// Placeholder text shown when the input is empty.
  final String? placeholder;

  /// Tailwind-like utility classes for styling the input field.
  ///
  /// Supports state prefixes:
  /// - `focus:` - Applied when input is focused
  /// - `disabled:` - Applied when enabled is false
  /// - `error:` - Applied when validation fails
  ///
  /// Example:
  /// ```dart
  /// className: 'p-3 border border-gray-300 rounded-lg error:border-red-500'
  /// ```
  final String? className;

  /// Tailwind-like utility classes for styling the placeholder text.
  final String? placeholderClassName;

  /// The action button on the keyboard (e.g., done, next, search).
  final TextInputAction? textInputAction;

  /// Called when the user submits the input.
  final ValueChanged<String>? onSubmitted;

  /// Called when the user changes the input value.
  final ValueChanged<String>? onChanged;

  /// Called when the user finishes editing.
  final VoidCallback? onEditingComplete;

  /// Called when the input field is tapped.
  final VoidCallback? onTap;

  /// Called when the user taps outside the input field.
  final TapRegionCallback? onTapOutside;

  /// Whether the input is read-only.
  final bool readOnly;

  /// Whether to autofocus on mount.
  final bool autofocus;

  /// Maximum number of lines for multiline input.
  final int? maxLines;

  /// Minimum number of lines for multiline input.
  final int minLines;

  /// Custom states for dynamic styling.
  ///
  /// These states are merged with the automatic `error` state
  /// when validation fails.
  final Set<String>? states;

  /// Input formatters to apply.
  final List<TextInputFormatter>? inputFormatters;

  /// Text capitalization behavior.
  final TextCapitalization textCapitalization;

  /// Whether to enable autocorrect.
  final bool autocorrect;

  /// Whether to show suggestions (predictive text).
  final bool enableSuggestions;

  /// Whether to show the error message below the input.
  ///
  /// Defaults to `true`. When `false`, only error styling is applied
  /// (via `error:` prefixed classes).
  final bool showError;

  /// Tailwind-like utility classes for styling the error message.
  ///
  /// Defaults to `'text-red-500 text-xs mt-1'`.
  final String errorClassName;

  /// Optional label text displayed above the input.
  ///
  /// Example:
  /// ```dart
  /// WFormInput(
  ///   label: 'Email Address',
  ///   labelClassName: 'text-sm font-semibold text-gray-800',
  /// )
  /// ```
  final String? label;

  /// Tailwind-like utility classes for styling the label.
  ///
  /// Defaults to `'text-sm font-medium text-gray-700 mb-1'`.
  final String labelClassName;

  /// Optional hint text displayed below the input.
  ///
  /// The hint is hidden when there's a validation error (error takes priority).
  ///
  /// Example:
  /// ```dart
  /// WFormInput(
  ///   hint: 'We will never share your email.',
  ///   hintClassName: 'text-gray-400 text-xs italic',
  /// )
  /// ```
  final String? hint;

  /// Tailwind-like utility classes for styling the hint.
  ///
  /// Defaults to `'text-gray-500 text-xs mt-1'`.
  final String hintClassName;

  /// Widget to display before the input field (e.g., icon).
  final Widget? prefix;

  /// Widget to display after the input field (e.g., visibility toggle).
  final Widget? suffix;
}

/// Internal stateful widget that handles controller sync and error state.
class _WFormInputContent extends StatefulWidget {
  const _WFormInputContent({
    required this.state,
    this.controller,
    this.focusNode,
    required this.type,
    this.placeholder,
    this.className,
    this.placeholderClassName,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.onTapOutside,
    required this.readOnly,
    required this.autofocus,
    this.maxLines,
    required this.minLines,
    required this.enabled,
    this.states,
    this.inputFormatters,
    required this.textCapitalization,
    required this.autocorrect,
    required this.enableSuggestions,
    required this.showError,
    required this.errorClassName,
    this.label,
    required this.labelClassName,
    this.hint,
    required this.hintClassName,
    this.prefix,
    this.suffix,
  });

  final FormFieldState<String> state;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputType type;
  final String? placeholder;
  final String? className;
  final String? placeholderClassName;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int minLines;
  final bool enabled;
  final Set<String>? states;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool showError;
  final String errorClassName;
  final String? label;
  final String labelClassName;
  final String? hint;
  final String hintClassName;
  final Widget? prefix;
  final Widget? suffix;

  @override
  State<_WFormInputContent> createState() => _WFormInputContentState();
}

class _WFormInputContentState extends State<_WFormInputContent> {
  late TextEditingController _effectiveController;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    if (widget.controller != null) {
      _effectiveController = widget.controller!;
      _ownsController = false;
    } else {
      _effectiveController = TextEditingController(text: widget.state.value);
      _ownsController = true;
    }
    _effectiveController.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    // Sync controller text with FormFieldState
    if (_effectiveController.text != widget.state.value) {
      widget.state.didChange(_effectiveController.text);
    }
  }

  @override
  void didUpdateWidget(_WFormInputContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle controller change
    if (widget.controller != oldWidget.controller) {
      _effectiveController.removeListener(_onControllerChanged);
      if (_ownsController) {
        _effectiveController.dispose();
      }
      _initController();
    }

    // Sync FormFieldState value back to controller (e.g., on reset)
    if (widget.state.value != _effectiveController.text) {
      _effectiveController.text = widget.state.value ?? '';
    }
  }

  @override
  void dispose() {
    _effectiveController.removeListener(_onControllerChanged);
    if (_ownsController) {
      _effectiveController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build states set including error state when validation fails
    final Set<String> effectiveStates = {
      ...?widget.states,
      if (widget.state.hasError) 'error',
    };

    // Accessibility: WFormInput exposes a separate `label` prop rendered
    // visually above the input. When set, we surface it as the Semantics
    // label of the underlying WInput so Playwright `getByLabel(...)` resolves
    // against the form field's label (preferred) and falls back to the
    // placeholder when no label is supplied.
    final input = WInput(
      controller: _effectiveController,
      focusNode: widget.focusNode,
      type: widget.type,
      placeholder: widget.placeholder,
      className: widget.className,
      placeholderClassName: widget.placeholderClassName,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      onChanged: (value) {
        widget.state.didChange(value);
        widget.onChanged?.call(value);
      },
      onEditingComplete: widget.onEditingComplete,
      onTap: widget.onTap,
      onTapOutside: widget.onTapOutside,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      states: effectiveStates,
      inputFormatters: widget.inputFormatters,
      textCapitalization: widget.textCapitalization,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      prefix: widget.prefix,
      suffix: widget.suffix,
      semanticLabel: widget.label ?? widget.placeholder,
    );

    // Determine bottom text: error takes priority over hint
    Widget? bottomText;
    if (widget.showError && widget.state.hasError) {
      bottomText = WText(
        widget.state.errorText!,
        className: widget.errorClassName,
      );
    } else if (widget.hint != null) {
      bottomText = WText(widget.hint!, className: widget.hintClassName);
    }

    // If no label and no bottom text, just return input
    if (widget.label == null && bottomText == null) {
      return input;
    }

    // Build column with optional label, input, and bottom text.
    //
    // The visible label is wrapped in ExcludeSemantics: its text is already the
    // input's `semanticLabel` (see above), so without this exclusion the field's
    // accessible name would be announced twice ("Email Address\nEmail Address").
    // The field's Semantics node remains the single canonical name carrier that
    // `getByLabel(...)` resolves against.
    return WDiv(
      className: 'flex flex-col',
      children: [
        if (widget.label != null)
          ExcludeSemantics(
            child: WText(widget.label!, className: widget.labelClassName),
          ),
        input,
        if (bottomText != null) bottomText,
      ],
    );
  }
}
