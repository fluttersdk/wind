import 'package:flutter/material.dart' hide DatePickerMode;

import 'w_date_picker.dart';
import 'w_div.dart';
import 'w_text.dart';

/// A Wind-styled date picker that integrates with Flutter's Form validation.
///
/// This widget wraps [WDatePicker] with [FormField] to provide:
/// - Native Form validation support
/// - Automatic error state styling (activates `error:` prefixed classes)
/// - Optional label, hint, and error message display
///
/// ## Basic Usage
///
/// ```dart
/// WFormDatePicker(
///   label: 'Birth Date',
///   initialValue: DateTime.now(),
///   className: 'p-3 border border-gray-300 rounded-lg error:border-red-500',
///   validator: (value) => value == null ? 'Please select a date' : null,
///   onChanged: (date) => print('Selected: $date'),
/// )
/// ```
class WFormDatePicker extends FormField<DateTime> {
  /// Creates a Wind-styled form date picker.
  WFormDatePicker({
    super.key,
    // FormField params
    super.validator,
    super.onSaved,
    super.autovalidateMode,
    super.enabled = true,
    // WDatePicker params
    DateTime? initialValue,
    this.initialRange,
    this.mode = DatePickerMode.single,
    this.onChanged,
    this.onRangeChanged,
    this.minDate,
    this.maxDate,
    this.className,
    this.placeholder,
    this.states,
    this.displayFormat,
    // Form wrapper params
    this.label,
    this.labelClassName =
        'text-sm font-medium text-gray-700 dark:text-gray-300 mb-1',
    this.showError = true,
    this.errorClassName = 'text-red-500 text-xs mt-1',
    this.hint,
    this.hintClassName = 'text-gray-500 text-xs mt-1',
  }) : super(
          initialValue: initialValue,
          builder: (FormFieldState<DateTime> state) {
            return _WFormDatePickerContent(
              state: state,
              mode: mode,
              initialRange: initialRange,
              onChanged: onChanged,
              onRangeChanged: onRangeChanged,
              minDate: minDate,
              maxDate: maxDate,
              className: className,
              placeholder: placeholder,
              enabled: enabled,
              states: states,
              displayFormat: displayFormat,
              label: label,
              labelClassName: labelClassName,
              showError: showError,
              errorClassName: errorClassName,
              hint: hint,
              hintClassName: hintClassName,
            );
          },
        );

  /// Selection mode: single date or date range.
  final DatePickerMode mode;

  /// The initially selected date range (range mode).
  final DateRange? initialRange;

  /// Called when a date is selected (single mode).
  final ValueChanged<DateTime>? onChanged;

  /// Called when a date range is selected (range mode).
  final ValueChanged<DateRange>? onRangeChanged;

  /// Minimum selectable date.
  final DateTime? minDate;

  /// Maximum selectable date.
  final DateTime? maxDate;

  /// Wind utility classes for the trigger container.
  final String? className;

  /// Placeholder text when no date is selected.
  final String? placeholder;

  /// Custom states for dynamic styling.
  final Set<String>? states;

  /// Custom display format function.
  final DateDisplayFormat? displayFormat;

  /// Optional label text displayed above the date picker.
  final String? label;

  /// Tailwind-like utility classes for styling the label.
  final String labelClassName;

  /// Whether to show the error message below the picker.
  final bool showError;

  /// Tailwind-like utility classes for styling the error message.
  final String errorClassName;

  /// Optional hint text displayed below the picker.
  final String? hint;

  /// Tailwind-like utility classes for styling the hint.
  final String hintClassName;
}

class _WFormDatePickerContent extends StatefulWidget {
  const _WFormDatePickerContent({
    required this.state,
    required this.mode,
    this.initialRange,
    this.onChanged,
    this.onRangeChanged,
    this.minDate,
    this.maxDate,
    this.className,
    this.placeholder,
    required this.enabled,
    this.states,
    this.displayFormat,
    this.label,
    required this.labelClassName,
    required this.showError,
    required this.errorClassName,
    this.hint,
    required this.hintClassName,
  });

  final FormFieldState<DateTime> state;
  final DatePickerMode mode;
  final DateRange? initialRange;
  final ValueChanged<DateTime>? onChanged;
  final ValueChanged<DateRange>? onRangeChanged;
  final DateTime? minDate;
  final DateTime? maxDate;
  final String? className;
  final String? placeholder;
  final bool enabled;
  final Set<String>? states;
  final DateDisplayFormat? displayFormat;
  final String? label;
  final String labelClassName;
  final bool showError;
  final String errorClassName;
  final String? hint;
  final String hintClassName;

  @override
  State<_WFormDatePickerContent> createState() =>
      _WFormDatePickerContentState();
}

class _WFormDatePickerContentState extends State<_WFormDatePickerContent> {
  DateRange? _currentRange;

  @override
  void initState() {
    super.initState();
    _currentRange = widget.initialRange;
  }

  @override
  void didUpdateWidget(_WFormDatePickerContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Sync external state changes (e.g. form reset)
    if (widget.mode == DatePickerMode.range) {
      if (widget.state.value == null && _currentRange != null) {
        setState(() => _currentRange = null);
      } else if (widget.state.value != null &&
          (_currentRange == null ||
              widget.state.value != _currentRange!.start)) {
        // If the state value changed and doesn't match range start, we might need to reset or sync
        // but FormField<DateTime> doesn't perfectly hold DateRange.
        // We prioritize the range state for internal consistency in range mode.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Set<String> effectiveStates = {
      ...?widget.states,
      if (widget.state.hasError) 'error',
    };

    final datePicker = WDatePicker(
      mode: widget.mode,
      value: widget.state.value,
      range: _currentRange,
      onChanged: (value) {
        widget.state.didChange(value);
        widget.onChanged?.call(value);
      },
      onRangeChanged: (range) {
        // For range mode, we sync the start date to FormFieldState<DateTime>
        // so that simple "required" validators still work.
        widget.state.didChange(range.start);
        setState(() => _currentRange = range);
        widget.onRangeChanged?.call(range);
      },
      minDate: widget.minDate,
      maxDate: widget.maxDate,
      className: widget.className,
      placeholder: widget.placeholder ?? 'Select date',
      disabled: !widget.enabled,
      states: effectiveStates,
      displayFormat: widget.displayFormat,
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

    return WDiv(
      className: 'flex flex-col',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            WText(widget.label!, className: widget.labelClassName),
          datePicker,
          if (bottomText != null) bottomText,
        ],
      ),
    );
  }
}
