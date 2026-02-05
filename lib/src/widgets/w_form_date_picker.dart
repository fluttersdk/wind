import 'package:flutter/material.dart';

import 'date_preset.dart';
import 'w_date_picker.dart';
import 'w_div.dart';
import 'w_text.dart';

/// A form-integrated date picker widget.
///
/// Wraps [WDatePicker] with [FormField] for validation, labels, hints,
/// and error display. Follows Wind UI form patterns.
///
/// Example:
/// ```dart
/// Form(
///   child: WFormDatePicker(
///     label: 'Start Date',
///     hint: 'Select when to start',
///     validator: (date) => date == null ? 'Required' : null,
///     onSaved: (date) => _startDate = date,
///   ),
/// )
/// ```
class WFormDatePicker extends FormField<DateTime> {
  /// Creates a form-integrated date picker.
  WFormDatePicker({
    super.key,
    super.initialValue,
    super.validator,
    super.onSaved,
    super.autovalidateMode,
    super.enabled = true,
    this.label,
    this.labelClassName,
    this.hint,
    this.hintClassName,
    this.errorClassName,
    this.placeholder,
    this.className,
    this.menuClassName,
    this.minDate,
    this.maxDate,
    this.presets,
    this.showPresets = false,
    this.onChanged,
  }) : super(
          builder: (FormFieldState<DateTime> state) {
            return _WFormDatePickerContent(
              state: state,
              label: label,
              labelClassName: labelClassName,
              hint: hint,
              hintClassName: hintClassName,
              errorClassName: errorClassName,
              placeholder: placeholder,
              className: className,
              menuClassName: menuClassName,
              minDate: minDate,
              maxDate: maxDate,
              presets: presets,
              showPresets: showPresets,
              enabled: enabled,
              onChanged: onChanged,
            );
          },
        );

  /// Label text displayed above the picker.
  final String? label;

  /// Wind utility classes for the label.
  final String? labelClassName;

  /// Hint text displayed below the picker (when no error).
  final String? hint;

  /// Wind utility classes for the hint.
  final String? hintClassName;

  /// Wind utility classes for error text.
  final String? errorClassName;

  /// Placeholder text when no date is selected.
  final String? placeholder;

  /// Wind utility classes for the picker trigger.
  final String? className;

  /// Wind utility classes for the popup menu.
  final String? menuClassName;

  /// Minimum selectable date.
  final DateTime? minDate;

  /// Maximum selectable date.
  final DateTime? maxDate;

  /// Preset date ranges for quick selection.
  final List<DatePreset>? presets;

  /// Whether to show preset buttons.
  final bool showPresets;

  /// Callback when value changes.
  final ValueChanged<DateTime?>? onChanged;
}

class _WFormDatePickerContent extends StatelessWidget {
  const _WFormDatePickerContent({
    required this.state,
    this.label,
    this.labelClassName,
    this.hint,
    this.hintClassName,
    this.errorClassName,
    this.placeholder,
    this.className,
    this.menuClassName,
    this.minDate,
    this.maxDate,
    this.presets,
    this.showPresets = false,
    this.enabled = true,
    this.onChanged,
  });

  final FormFieldState<DateTime> state;
  final String? label;
  final String? labelClassName;
  final String? hint;
  final String? hintClassName;
  final String? errorClassName;
  final String? placeholder;
  final String? className;
  final String? menuClassName;
  final DateTime? minDate;
  final DateTime? maxDate;
  final List<DatePreset>? presets;
  final bool showPresets;
  final bool enabled;
  final ValueChanged<DateTime?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final hasError = state.hasError;
    final effectiveLabelClassName =
        labelClassName ?? 'text-sm font-medium text-gray-700 dark:text-gray-300 mb-1';
    final effectiveHintClassName =
        hintClassName ?? 'text-xs text-gray-500 dark:text-gray-400 mt-1';
    final effectiveErrorClassName =
        errorClassName ?? 'text-xs text-red-500 dark:text-red-400 mt-1';

    // Add error state to className
    String effectiveClassName = className ?? '';
    if (hasError) {
      effectiveClassName += ' border-red-500 dark:border-red-400';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (label != null)
          WText(
            label!,
            className: effectiveLabelClassName,
          ),

        // Date Picker
        WDatePicker(
          value: state.value,
          onChanged: (date) {
            state.didChange(date);
            onChanged?.call(date);
          },
          placeholder: placeholder,
          className: effectiveClassName,
          menuClassName: menuClassName,
          minDate: minDate,
          maxDate: maxDate,
          presets: presets,
          showPresets: showPresets,
          disabled: !enabled,
        ),

        // Error or Hint
        if (hasError && state.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: WText(
              state.errorText!,
              className: effectiveErrorClassName,
            ),
          )
        else if (hint != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: WText(
              hint!,
              className: effectiveHintClassName,
            ),
          ),
      ],
    );
  }
}

/// A form-integrated date range picker widget.
///
/// Similar to [WFormDatePicker] but for date range selection.
class WFormDateRangePicker extends FormField<DateTimeRange> {
  /// Creates a form-integrated date range picker.
  WFormDateRangePicker({
    super.key,
    super.initialValue,
    super.validator,
    super.onSaved,
    super.autovalidateMode,
    super.enabled = true,
    this.label,
    this.labelClassName,
    this.hint,
    this.hintClassName,
    this.errorClassName,
    this.placeholder,
    this.className,
    this.menuClassName,
    this.minDate,
    this.maxDate,
    this.presets,
    this.showPresets = true,
    this.onChanged,
  }) : super(
          builder: (FormFieldState<DateTimeRange> state) {
            return _WFormDateRangePickerContent(
              state: state,
              label: label,
              labelClassName: labelClassName,
              hint: hint,
              hintClassName: hintClassName,
              errorClassName: errorClassName,
              placeholder: placeholder,
              className: className,
              menuClassName: menuClassName,
              minDate: minDate,
              maxDate: maxDate,
              presets: presets,
              showPresets: showPresets,
              enabled: enabled,
              onChanged: onChanged,
            );
          },
        );

  final String? label;
  final String? labelClassName;
  final String? hint;
  final String? hintClassName;
  final String? errorClassName;
  final String? placeholder;
  final String? className;
  final String? menuClassName;
  final DateTime? minDate;
  final DateTime? maxDate;
  final List<DatePreset>? presets;
  final bool showPresets;
  final ValueChanged<DateTimeRange?>? onChanged;
}

class _WFormDateRangePickerContent extends StatelessWidget {
  const _WFormDateRangePickerContent({
    required this.state,
    this.label,
    this.labelClassName,
    this.hint,
    this.hintClassName,
    this.errorClassName,
    this.placeholder,
    this.className,
    this.menuClassName,
    this.minDate,
    this.maxDate,
    this.presets,
    this.showPresets = true,
    this.enabled = true,
    this.onChanged,
  });

  final FormFieldState<DateTimeRange> state;
  final String? label;
  final String? labelClassName;
  final String? hint;
  final String? hintClassName;
  final String? errorClassName;
  final String? placeholder;
  final String? className;
  final String? menuClassName;
  final DateTime? minDate;
  final DateTime? maxDate;
  final List<DatePreset>? presets;
  final bool showPresets;
  final bool enabled;
  final ValueChanged<DateTimeRange?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final hasError = state.hasError;
    final effectiveLabelClassName =
        labelClassName ?? 'text-sm font-medium text-gray-700 dark:text-gray-300 mb-1';
    final effectiveHintClassName =
        hintClassName ?? 'text-xs text-gray-500 dark:text-gray-400 mt-1';
    final effectiveErrorClassName =
        errorClassName ?? 'text-xs text-red-500 dark:text-red-400 mt-1';

    String effectiveClassName = className ?? '';
    if (hasError) {
      effectiveClassName += ' border-red-500 dark:border-red-400';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          WText(
            label!,
            className: effectiveLabelClassName,
          ),

        WDatePicker(
          isRange: true,
          range: state.value,
          onRangeChanged: (range) {
            state.didChange(range);
            onChanged?.call(range);
          },
          placeholder: placeholder,
          className: effectiveClassName,
          menuClassName: menuClassName,
          minDate: minDate,
          maxDate: maxDate,
          presets: presets,
          showPresets: showPresets,
          disabled: !enabled,
        ),

        if (hasError && state.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: WText(
              state.errorText!,
              className: effectiveErrorClassName,
            ),
          )
        else if (hint != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: WText(
              hint!,
              className: effectiveHintClassName,
            ),
          ),
      ],
    );
  }
}
