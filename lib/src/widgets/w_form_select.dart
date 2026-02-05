import 'package:flutter/material.dart';

import 'select_option.dart';
import 'w_select.dart';
import 'w_div.dart';
import 'w_text.dart';

/// A Wind-styled single-select that integrates with Flutter's Form validation.
///
/// This widget wraps [WSelect] with [FormField] to provide:
/// - Native Form validation support
/// - Automatic error state styling (activates `error:` prefixed classes)
/// - Value synchronization with FormFieldState
/// - Optional label, hint, and error message display
///
/// ## Basic Usage
///
/// ```dart
/// Form(
///   key: _formKey,
///   child: WFormSelect<String>(
///     value: _country,
///     options: [
///       SelectOption(value: 'us', label: 'United States'),
///       SelectOption(value: 'uk', label: 'United Kingdom'),
///     ],
///     onChange: (v) => setState(() => _country = v),
///     label: 'Country',
///     className: 'w-64 border rounded-lg error:border-red-500',
///     validator: (value) => value == null ? 'Required' : null,
///   ),
/// )
/// ```
class WFormSelect<T> extends FormField<T> {
  /// Creates a Wind-styled form select (single-select).
  WFormSelect({
    super.key,
    T? value,
    super.validator,
    super.onSaved,
    super.autovalidateMode,
    super.restorationId,
    super.enabled = true,

    // WSelect props
    required this.options,
    this.onChange,
    this.placeholder = 'Select an option',
    this.className,
    this.menuClassName,
    this.searchable = false,
    this.searchPlaceholder = 'Search...',
    this.onSearch,
    this.onCreateOption,
    this.createOptionBuilder,
    this.onLoadMore,
    this.hasMore = false,
    this.disabled = false,
    this.menuWidth,
    this.maxMenuHeight = 300,
    this.states,
    this.triggerBuilder,
    this.itemBuilder,
    this.emptyBuilder,
    this.loadingBuilder,

    // Label & Hint
    this.label,
    this.labelClassName = 'text-sm font-medium text-gray-700 mb-1',
    this.hint,
    this.hintClassName = 'text-gray-500 text-xs mt-1',

    // Error display
    this.showError = true,
    this.errorClassName = 'text-red-500 text-xs mt-1',
  }) : super(
          initialValue: value,
          builder: (FormFieldState<T> state) {
            return _WFormSelectContent<T>(
              state: state,
              options: options,
              onChange: onChange,
              placeholder: placeholder,
              className: className,
              menuClassName: menuClassName,
              searchable: searchable,
              searchPlaceholder: searchPlaceholder,
              onSearch: onSearch,
              onCreateOption: onCreateOption,
              createOptionBuilder: createOptionBuilder,
              onLoadMore: onLoadMore,
              hasMore: hasMore,
              disabled: disabled || !enabled,
              menuWidth: menuWidth,
              maxMenuHeight: maxMenuHeight,
              states: states,
              triggerBuilder: triggerBuilder,
              itemBuilder: itemBuilder,
              emptyBuilder: emptyBuilder,
              loadingBuilder: loadingBuilder,
              label: label,
              labelClassName: labelClassName,
              hint: hint,
              hintClassName: hintClassName,
              showError: showError,
              errorClassName: errorClassName,
            );
          },
        );

  /// The list of available options.
  final List<SelectOption<T>> options;

  /// Called when the user selects an option.
  final ValueChanged<T?>? onChange;

  /// Placeholder text shown when no value is selected.
  final String placeholder;

  /// Tailwind-like utility classes for the trigger.
  final String? className;

  /// Tailwind-like utility classes for the dropdown menu.
  final String? menuClassName;

  /// Whether to show search input in dropdown.
  final bool searchable;

  /// Placeholder for search input.
  final String searchPlaceholder;

  /// Async callback for remote search.
  final Future<List<SelectOption<T>>> Function(String query)? onSearch;

  /// Callback to create a new option from query.
  final Future<SelectOption<T>> Function(String query)? onCreateOption;

  /// Custom builder for create option button.
  final CreateOptionBuilder? createOptionBuilder;

  /// Callback for pagination (infinite scroll).
  final Future<List<SelectOption<T>>> Function()? onLoadMore;

  /// Whether more options are available for pagination.
  final bool hasMore;

  /// Whether the select is disabled.
  final bool disabled;

  /// Width of the dropdown menu.
  final double? menuWidth;

  /// Maximum height of the dropdown menu.
  final double maxMenuHeight;

  /// Custom states for dynamic styling.
  final Set<String>? states;

  /// Custom trigger builder.
  final SelectTriggerBuilder<T>? triggerBuilder;

  /// Custom item builder.
  final SelectItemBuilder<T>? itemBuilder;

  /// Custom empty state builder.
  final EmptyStateBuilder? emptyBuilder;

  /// Custom loading indicator builder.
  final LoadingBuilder? loadingBuilder;

  /// Optional label text above the select.
  final String? label;

  /// Tailwind-like classes for the label.
  final String labelClassName;

  /// Optional hint text below the select.
  final String? hint;

  /// Tailwind-like classes for the hint.
  final String hintClassName;

  /// Whether to show error message below.
  final bool showError;

  /// Tailwind-like classes for error message.
  final String errorClassName;
}

/// Internal widget for WFormSelect.
class _WFormSelectContent<T> extends StatelessWidget {
  const _WFormSelectContent({
    required this.state,
    required this.options,
    this.onChange,
    required this.placeholder,
    this.className,
    this.menuClassName,
    required this.searchable,
    required this.searchPlaceholder,
    this.onSearch,
    this.onCreateOption,
    this.createOptionBuilder,
    this.onLoadMore,
    required this.hasMore,
    required this.disabled,
    this.menuWidth,
    required this.maxMenuHeight,
    this.states,
    this.triggerBuilder,
    this.itemBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
    this.label,
    required this.labelClassName,
    this.hint,
    required this.hintClassName,
    required this.showError,
    required this.errorClassName,
  });

  final FormFieldState<T> state;
  final List<SelectOption<T>> options;
  final ValueChanged<T?>? onChange;
  final String placeholder;
  final String? className;
  final String? menuClassName;
  final bool searchable;
  final String searchPlaceholder;
  final Future<List<SelectOption<T>>> Function(String query)? onSearch;
  final Future<SelectOption<T>> Function(String query)? onCreateOption;
  final CreateOptionBuilder? createOptionBuilder;
  final Future<List<SelectOption<T>>> Function()? onLoadMore;
  final bool hasMore;
  final bool disabled;
  final double? menuWidth;
  final double maxMenuHeight;
  final Set<String>? states;
  final SelectTriggerBuilder<T>? triggerBuilder;
  final SelectItemBuilder<T>? itemBuilder;
  final EmptyStateBuilder? emptyBuilder;
  final LoadingBuilder? loadingBuilder;
  final String? label;
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

    final select = WSelect<T>(
      value: state.value,
      options: options,
      onChange: (newValue) {
        state.didChange(newValue);
        onChange?.call(newValue);
      },
      placeholder: placeholder,
      className: className,
      menuClassName: menuClassName,
      searchable: searchable,
      searchPlaceholder: searchPlaceholder,
      onSearch: onSearch,
      onCreateOption: onCreateOption,
      createOptionBuilder: createOptionBuilder,
      onLoadMore: onLoadMore,
      hasMore: hasMore,
      disabled: disabled,
      menuWidth: menuWidth,
      maxMenuHeight: maxMenuHeight,
      states: effectiveStates,
      triggerBuilder: triggerBuilder,
      itemBuilder: itemBuilder,
      emptyBuilder: emptyBuilder,
      loadingBuilder: loadingBuilder,
    );

    // Determine bottom text: error takes priority over hint
    Widget? bottomText;
    if (showError && state.hasError) {
      bottomText = WText(state.errorText!, className: errorClassName);
    } else if (hint != null) {
      bottomText = WText(hint!, className: hintClassName);
    }

    // If no label and no bottom text, just return select
    if (label == null && bottomText == null) {
      return select;
    }

    // Build column with optional label, select, and bottom text
    return WDiv(
      className: 'flex flex-col',
      children: [
        if (label != null) WText(label!, className: labelClassName),
        select,
        if (bottomText != null) bottomText,
      ],
    );
  }
}

// ============================================================================
// MULTI-SELECT
// ============================================================================

/// A Wind-styled multi-select that integrates with Flutter's Form validation.
///
/// This widget wraps [WSelect] (with `isMulti: true`) with [FormField] to provide:
/// - Native Form validation support
/// - Automatic error state styling
/// - Value synchronization with FormFieldState
/// - Optional label, hint, and error message display
///
/// ## Basic Usage
///
/// ```dart
/// Form(
///   key: _formKey,
///   child: WFormMultiSelect<String>(
///     values: _selectedTags,
///     options: tagOptions,
///     onMultiChange: (v) => setState(() => _selectedTags = v),
///     label: 'Tags',
///     className: 'w-80 border rounded-lg error:border-red-500',
///     validator: (values) {
///       if (values == null || values.isEmpty) {
///         return 'Select at least one tag';
///       }
///       if (values.length > 5) {
///         return 'Maximum 5 tags allowed';
///       }
///       return null;
///     },
///   ),
/// )
/// ```
class WFormMultiSelect<T> extends FormField<List<T>> {
  /// Creates a Wind-styled form multi-select.
  WFormMultiSelect({
    super.key,
    List<T>? values,
    super.validator,
    super.onSaved,
    super.autovalidateMode,
    super.restorationId,
    super.enabled = true,

    // WSelect props
    required this.options,
    this.onMultiChange,
    this.placeholder = 'Select options',
    this.className,
    this.menuClassName,
    this.searchable = false,
    this.searchPlaceholder = 'Search...',
    this.onSearch,
    this.onCreateOption,
    this.createOptionBuilder,
    this.onLoadMore,
    this.hasMore = false,
    this.disabled = false,
    this.menuWidth,
    this.maxMenuHeight = 300,
    this.states,
    this.multiTriggerBuilder,
    this.selectedChipBuilder,
    this.itemBuilder,
    this.emptyBuilder,
    this.loadingBuilder,

    // Label & Hint
    this.label,
    this.labelClassName = 'text-sm font-medium text-gray-700 mb-1',
    this.hint,
    this.hintClassName = 'text-gray-500 text-xs mt-1',

    // Error display
    this.showError = true,
    this.errorClassName = 'text-red-500 text-xs mt-1',
  }) : super(
          initialValue: values ?? [],
          builder: (FormFieldState<List<T>> state) {
            return _WFormMultiSelectContent<T>(
              state: state,
              options: options,
              onMultiChange: onMultiChange,
              placeholder: placeholder,
              className: className,
              menuClassName: menuClassName,
              searchable: searchable,
              searchPlaceholder: searchPlaceholder,
              onSearch: onSearch,
              onCreateOption: onCreateOption,
              createOptionBuilder: createOptionBuilder,
              onLoadMore: onLoadMore,
              hasMore: hasMore,
              disabled: disabled || !enabled,
              menuWidth: menuWidth,
              maxMenuHeight: maxMenuHeight,
              states: states,
              multiTriggerBuilder: multiTriggerBuilder,
              selectedChipBuilder: selectedChipBuilder,
              itemBuilder: itemBuilder,
              emptyBuilder: emptyBuilder,
              loadingBuilder: loadingBuilder,
              label: label,
              labelClassName: labelClassName,
              hint: hint,
              hintClassName: hintClassName,
              showError: showError,
              errorClassName: errorClassName,
            );
          },
        );

  /// The list of available options.
  final List<SelectOption<T>> options;

  /// Called when selection changes.
  final ValueChanged<List<T>>? onMultiChange;

  /// Placeholder text shown when no values are selected.
  final String placeholder;

  /// Tailwind-like utility classes for the trigger.
  final String? className;

  /// Tailwind-like utility classes for the dropdown menu.
  final String? menuClassName;

  /// Whether to show search input in dropdown.
  final bool searchable;

  /// Placeholder for search input.
  final String searchPlaceholder;

  /// Async callback for remote search.
  final Future<List<SelectOption<T>>> Function(String query)? onSearch;

  /// Callback to create a new option from query.
  final Future<SelectOption<T>> Function(String query)? onCreateOption;

  /// Custom builder for create option button.
  final CreateOptionBuilder? createOptionBuilder;

  /// Callback for pagination (infinite scroll).
  final Future<List<SelectOption<T>>> Function()? onLoadMore;

  /// Whether more options are available for pagination.
  final bool hasMore;

  /// Whether the select is disabled.
  final bool disabled;

  /// Width of the dropdown menu.
  final double? menuWidth;

  /// Maximum height of the dropdown menu.
  final double maxMenuHeight;

  /// Custom states for dynamic styling.
  final Set<String>? states;

  /// Custom trigger builder for multi-select.
  final MultiSelectTriggerBuilder<T>? multiTriggerBuilder;

  /// Custom chip builder for selected values.
  final SelectedChipBuilder<T>? selectedChipBuilder;

  /// Custom item builder.
  final SelectItemBuilder<T>? itemBuilder;

  /// Custom empty state builder.
  final EmptyStateBuilder? emptyBuilder;

  /// Custom loading indicator builder.
  final LoadingBuilder? loadingBuilder;

  /// Optional label text above the select.
  final String? label;

  /// Tailwind-like classes for the label.
  final String labelClassName;

  /// Optional hint text below the select.
  final String? hint;

  /// Tailwind-like classes for the hint.
  final String hintClassName;

  /// Whether to show error message below.
  final bool showError;

  /// Tailwind-like classes for error message.
  final String errorClassName;
}

/// Internal widget for WFormMultiSelect.
class _WFormMultiSelectContent<T> extends StatelessWidget {
  const _WFormMultiSelectContent({
    required this.state,
    required this.options,
    this.onMultiChange,
    required this.placeholder,
    this.className,
    this.menuClassName,
    required this.searchable,
    required this.searchPlaceholder,
    this.onSearch,
    this.onCreateOption,
    this.createOptionBuilder,
    this.onLoadMore,
    required this.hasMore,
    required this.disabled,
    this.menuWidth,
    required this.maxMenuHeight,
    this.states,
    this.multiTriggerBuilder,
    this.selectedChipBuilder,
    this.itemBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
    this.label,
    required this.labelClassName,
    this.hint,
    required this.hintClassName,
    required this.showError,
    required this.errorClassName,
  });

  final FormFieldState<List<T>> state;
  final List<SelectOption<T>> options;
  final ValueChanged<List<T>>? onMultiChange;
  final String placeholder;
  final String? className;
  final String? menuClassName;
  final bool searchable;
  final String searchPlaceholder;
  final Future<List<SelectOption<T>>> Function(String query)? onSearch;
  final Future<SelectOption<T>> Function(String query)? onCreateOption;
  final CreateOptionBuilder? createOptionBuilder;
  final Future<List<SelectOption<T>>> Function()? onLoadMore;
  final bool hasMore;
  final bool disabled;
  final double? menuWidth;
  final double maxMenuHeight;
  final Set<String>? states;
  final MultiSelectTriggerBuilder<T>? multiTriggerBuilder;
  final SelectedChipBuilder<T>? selectedChipBuilder;
  final SelectItemBuilder<T>? itemBuilder;
  final EmptyStateBuilder? emptyBuilder;
  final LoadingBuilder? loadingBuilder;
  final String? label;
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

    final select = WSelect<T>(
      isMulti: true,
      values: state.value,
      options: options,
      onMultiChange: (newValues) {
        state.didChange(newValues);
        onMultiChange?.call(newValues);
      },
      placeholder: placeholder,
      className: className,
      menuClassName: menuClassName,
      searchable: searchable,
      searchPlaceholder: searchPlaceholder,
      onSearch: onSearch,
      onCreateOption: onCreateOption,
      createOptionBuilder: createOptionBuilder,
      onLoadMore: onLoadMore,
      hasMore: hasMore,
      disabled: disabled,
      menuWidth: menuWidth,
      maxMenuHeight: maxMenuHeight,
      states: effectiveStates,
      multiTriggerBuilder: multiTriggerBuilder,
      selectedChipBuilder: selectedChipBuilder,
      itemBuilder: itemBuilder,
      emptyBuilder: emptyBuilder,
      loadingBuilder: loadingBuilder,
    );

    // Determine bottom text: error takes priority over hint
    Widget? bottomText;
    if (showError && state.hasError) {
      bottomText = WText(state.errorText!, className: errorClassName);
    } else if (hint != null) {
      bottomText = WText(hint!, className: hintClassName);
    }

    // If no label and no bottom text, just return select
    if (label == null && bottomText == null) {
      return select;
    }

    // Build column with optional label, select, and bottom text
    return WDiv(
      className: 'flex flex-col',
      children: [
        if (label != null) WText(label!, className: labelClassName),
        select,
        if (bottomText != null) bottomText,
      ],
    );
  }
}
