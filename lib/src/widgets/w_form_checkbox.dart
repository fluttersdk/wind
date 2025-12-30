import 'package:flutter/widgets.dart';

import 'w_anchor.dart';
import 'w_checkbox.dart';
import 'w_text.dart';
import 'w_div.dart';

/// A Wind-styled checkbox that integrates with Flutter's Form validation.
///
/// This widget wraps [WCheckbox] with [FormField<bool>] to provide:
/// - Native Form validation support
/// - Automatic error state styling (activates `error:` prefixed classes)
/// - Optional label (widget or text) and error message display
///
/// ## Basic Usage
///
/// ```dart
/// Form(
///   key: _formKey,
///   child: WFormCheckbox(
///     value: _agreeTerms,
///     onChanged: (v) => setState(() => _agreeTerms = v),
///     labelText: 'I agree to Terms of Service',
///     className: 'w-5 h-5 rounded border checked:bg-blue-500 error:border-red-500',
///     validator: (value) => value != true ? 'You must agree to terms' : null,
///   ),
/// )
/// ```
class WFormCheckbox extends FormField<bool> {
  /// Creates a Wind-styled form checkbox.
  WFormCheckbox({
    super.key,
    bool value = false,
    super.validator,
    super.onSaved,
    super.autovalidateMode,
    super.restorationId,
    super.enabled = true,

    // WCheckbox props
    this.onChanged,
    this.className,
    this.iconClassName,
    this.disabled = false,
    this.checkIcon,
    this.states,

    // Label
    this.label,
    this.labelText,
    this.labelClassName = 'text-sm text-gray-700',

    // Hint
    this.hint,
    this.hintClassName = 'text-gray-500 text-xs mt-1',

    // Error display
    this.showError = true,
    this.errorClassName = 'text-red-500 text-xs mt-1',
  }) : super(
         initialValue: value,
         builder: (FormFieldState<bool> state) {
           return _WFormCheckboxContent(
             state: state,
             onChanged: onChanged,
             className: className,
             iconClassName: iconClassName,
             disabled: disabled || !enabled,
             checkIcon: checkIcon,
             states: states,
             label: label,
             labelText: labelText,
             labelClassName: labelClassName,
             hint: hint,
             hintClassName: hintClassName,
             showError: showError,
             errorClassName: errorClassName,
           );
         },
       );

  /// Called when the checkbox value changes.
  final ValueChanged<bool>? onChanged;

  /// Tailwind-like utility classes for the checkbox.
  final String? className;

  /// Tailwind-like utility classes for the check icon.
  final String? iconClassName;

  /// Whether the checkbox is disabled.
  final bool disabled;

  /// Custom check icon.
  final IconData? checkIcon;

  /// Custom states for dynamic styling.
  final Set<String>? states;

  /// Custom label widget.
  ///
  /// Takes precedence over [labelText] if both are provided.
  final Widget? label;

  /// Simple text label.
  final String? labelText;

  /// Tailwind-like classes for label text.
  final String labelClassName;

  /// Optional hint text below the checkbox.
  final String? hint;

  /// Tailwind-like classes for hint text.
  final String hintClassName;

  /// Whether to show error message below.
  final bool showError;

  /// Tailwind-like classes for error message.
  final String errorClassName;
}

/// Internal widget for WFormCheckbox.
class _WFormCheckboxContent extends StatelessWidget {
  const _WFormCheckboxContent({
    required this.state,
    this.onChanged,
    this.className,
    this.iconClassName,
    required this.disabled,
    this.checkIcon,
    this.states,
    this.label,
    this.labelText,
    required this.labelClassName,
    this.hint,
    required this.hintClassName,
    required this.showError,
    required this.errorClassName,
  });

  final FormFieldState<bool> state;
  final ValueChanged<bool>? onChanged;
  final String? className;
  final String? iconClassName;
  final bool disabled;
  final IconData? checkIcon;
  final Set<String>? states;
  final Widget? label;
  final String? labelText;
  final String labelClassName;
  final String? hint;
  final String hintClassName;
  final bool showError;
  final String errorClassName;

  @override
  Widget build(BuildContext context) {
    // Build states set including error state when validation fails
    final Set<String> effectiveStates = {
      ...?states,
      if (state.hasError) 'error',
    };

    final checkbox = WCheckbox(
      value: state.value ?? false,
      onChanged: disabled
          ? null
          : (newValue) {
              state.didChange(newValue);
              onChanged?.call(newValue);
            },
      className: className,
      iconClassName: iconClassName,
      disabled: disabled,
      checkIcon: checkIcon,
      states: effectiveStates,
    );

    // Build the label widget
    Widget? labelWidget;
    if (label != null) {
      labelWidget = label;
    } else if (labelText != null) {
      labelWidget = WText(labelText!, className: labelClassName);
    }

    // Determine bottom text: error takes priority over hint
    Widget? bottomText;
    if (showError && state.hasError) {
      bottomText = WText(state.errorText!, className: errorClassName);
    } else if (hint != null) {
      bottomText = WText(hint!, className: hintClassName);
    }

    // If no label and no bottom text, just return checkbox
    if (labelWidget == null && bottomText == null) {
      return checkbox;
    }

    // Build layout with checkbox, label, and optional bottom text
    return WDiv(
      className: 'flex flex-col items-start justify-start axis-min',
      children: [
        WAnchor(
          isDisabled: disabled,
          onTap: () {
            final newValue = !(state.value ?? false);
            state.didChange(newValue);
            onChanged?.call(newValue);
          },
          child: WDiv(
            className: 'flex items-center axis-min',
            children: [
              checkbox,
              if (labelWidget != null) ...[
                const SizedBox(width: 8),
                labelWidget,
              ],
            ],
          ),
        ),
        if (bottomText != null) WDiv(className: 'pl-8 pt-1', child: bottomText),
      ],
    );
  }
}
