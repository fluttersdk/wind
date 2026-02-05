import 'package:flutter/material.dart';

import '../theme/wind_theme.dart';
import '../theme/wind_theme_data.dart';
import 'date_preset.dart';
import 'w_button.dart';
import 'w_calendar_grid.dart';
import 'w_calendar_header.dart';
import 'w_div.dart';
import 'w_icon.dart';
import 'w_text.dart';

/// A date picker widget with popup calendar.
///
/// Uses its own overlay mechanism (not WPopover) for better stability
/// in complex widget hierarchies.
///
/// Example - Single date:
/// ```dart
/// WDatePicker(
///   value: selectedDate,
///   onChanged: (date) => setState(() => selectedDate = date),
///   placeholder: 'Select date',
/// )
/// ```
///
/// Example - Date range with presets:
/// ```dart
/// WDatePicker(
///   isRange: true,
///   range: selectedRange,
///   onRangeChanged: (range) => setState(() => selectedRange = range),
///   showPresets: true,
/// )
/// ```
class WDatePicker extends StatefulWidget {
  /// Creates a date picker.
  const WDatePicker({
    super.key,
    this.value,
    this.range,
    this.onChanged,
    this.onRangeChanged,
    this.isRange = false,
    this.placeholder,
    this.className,
    this.menuClassName,
    this.minDate,
    this.maxDate,
    this.disabled = false,
    this.presets,
    this.showPresets = false,
    this.dateFormat,
  });

  /// Currently selected single date.
  final DateTime? value;

  /// Currently selected date range (for range mode).
  final DateTimeRange? range;

  /// Callback when a single date is selected.
  final ValueChanged<DateTime>? onChanged;

  /// Callback when a date range is selected.
  final ValueChanged<DateTimeRange>? onRangeChanged;

  /// Enable date range selection mode.
  final bool isRange;

  /// Placeholder text when no date is selected.
  final String? placeholder;

  /// Wind utility classes for the trigger.
  final String? className;

  /// Wind utility classes for the popup menu.
  final String? menuClassName;

  /// Minimum selectable date.
  final DateTime? minDate;

  /// Maximum selectable date.
  final DateTime? maxDate;

  /// Whether the picker is disabled.
  final bool disabled;

  /// Preset date ranges for quick selection.
  final List<DatePreset>? presets;

  /// Whether to show preset buttons.
  final bool showPresets;

  /// Custom date format pattern.
  final String? dateFormat;

  @override
  State<WDatePicker> createState() => _WDatePickerState();
}

class _WDatePickerState extends State<WDatePicker>
    with SingleTickerProviderStateMixin {
  final GlobalKey _triggerKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  late DateTime _displayMonth;
  DateTime? _rangeStart;
  bool _isSelectingRange = false;

  // Store theme data for overlay
  WindThemeData? _themeData;

  @override
  void initState() {
    super.initState();
    _initDisplayMonth();
  }

  @override
  void didUpdateWidget(WDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value || widget.range != oldWidget.range) {
      _initDisplayMonth();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Capture theme data from current context for use in overlay
    try {
      _themeData = WindTheme.dataOf(context);
    } catch (_) {
      // No WindTheme in context, will use defaults
      _themeData = null;
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _initDisplayMonth() {
    if (widget.value != null) {
      _displayMonth = DateTime(widget.value!.year, widget.value!.month, 1);
    } else if (widget.range != null) {
      _displayMonth =
          DateTime(widget.range!.start.year, widget.range!.start.month, 1);
    } else {
      _displayMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
    }
  }

  void _toggleOverlay() {
    if (widget.disabled) return;
    if (_isOpen) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    if (_isOpen) return;

    final overlay = Overlay.of(context);
    final renderBox =
        _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final triggerSize = renderBox?.size ?? const Size(200, 40);

    _overlayEntry = OverlayEntry(
      builder: (context) => _DatePickerOverlay(
        link: _layerLink,
        triggerWidth: triggerSize.width,
        menuClassName: widget.menuClassName,
        isRange: widget.isRange,
        displayMonth: _displayMonth,
        value: widget.value,
        range: widget.range,
        minDate: widget.minDate,
        maxDate: widget.maxDate,
        showPresets: widget.showPresets,
        presets: widget.presets,
        rangeStart: _rangeStart,
        isSelectingRange: _isSelectingRange,
        themeData: _themeData,
        onDisplayMonthChanged: (month) {
          _displayMonth = month;
          _overlayEntry?.markNeedsBuild();
        },
        onDateSelected: _handleDateSelected,
        onRangeSelected: _handleRangeSelected,
        onRangeStartChanged: (start) {
          _rangeStart = start;
          _isSelectingRange = start != null;
          _overlayEntry?.markNeedsBuild();
        },
        onClose: _removeOverlay,
      ),
    );

    overlay.insert(_overlayEntry!);
    _isOpen = true;
    // Defer setState to avoid mouse_tracker conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    // Only call setState if widget is still mounted and not being disposed
    if (_isOpen && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _isOpen = false);
        }
      });
    }
    _isOpen = false;
  }

  void _handleDateSelected(DateTime date) {
    widget.onChanged?.call(date);
    _removeOverlay();
  }

  void _handleRangeSelected(DateTimeRange range) {
    widget.onRangeChanged?.call(range);
    _rangeStart = null;
    _isSelectingRange = false;
    _removeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    // TEMPORARILY REMOVED hover: classes to debug mouse_tracker issue
    final effectiveClassName = widget.className ??
        '''
        px-3 py-2
        bg-white dark:bg-gray-800
        border border-gray-300 dark:border-gray-600
        rounded-lg
        disabled:bg-gray-100 disabled:cursor-not-allowed
        ''';

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleOverlay,
        child: KeyedSubtree(
          key: _triggerKey,
          child: _buildTrigger(effectiveClassName, _isOpen),
        ),
      ),
    );
  }

  Widget _buildTrigger(String className, bool isOpen) {
    final displayText = _getDisplayText();

    return WDiv(
      className: 'flex items-center gap-2 $className',
      children: [
        WIcon(
          Icons.calendar_today,
          className: 'text-gray-400 dark:text-gray-500 text-base',
        ),
        WText(
          displayText,
          className: widget.value != null || widget.range != null
              ? 'flex-1 truncate text-sm text-gray-900 dark:text-gray-100'
              : 'flex-1 truncate text-sm text-gray-400 dark:text-gray-500',
        ),
        WIcon(
          isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          className: 'text-gray-400 dark:text-gray-500 text-base',
        ),
      ],
    );
  }

  String _getDisplayText() {
    if (widget.isRange && widget.range != null) {
      final start = _formatDate(widget.range!.start);
      final end = _formatDate(widget.range!.end);
      return '$start - $end';
    } else if (widget.value != null) {
      return _formatDate(widget.value!);
    }
    return widget.placeholder ?? 'Select date';
  }

  String _formatDate(DateTime date) {
    // Simple format: "Feb 15, 2026"
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

/// Overlay widget for the date picker popup.
///
/// Uses CompositedTransformFollower to position relative to trigger,
/// with TapRegion for outside tap detection.
class _DatePickerOverlay extends StatefulWidget {
  const _DatePickerOverlay({
    required this.link,
    required this.triggerWidth,
    required this.menuClassName,
    required this.isRange,
    required this.displayMonth,
    required this.value,
    required this.range,
    required this.minDate,
    required this.maxDate,
    required this.showPresets,
    required this.presets,
    required this.rangeStart,
    required this.isSelectingRange,
    required this.themeData,
    required this.onDisplayMonthChanged,
    required this.onDateSelected,
    required this.onRangeSelected,
    required this.onRangeStartChanged,
    required this.onClose,
  });

  final LayerLink link;
  final double triggerWidth;
  final String? menuClassName;
  final bool isRange;
  final DateTime displayMonth;
  final DateTime? value;
  final DateTimeRange? range;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool showPresets;
  final List<DatePreset>? presets;
  final DateTime? rangeStart;
  final bool isSelectingRange;
  final WindThemeData? themeData;
  final ValueChanged<DateTime> onDisplayMonthChanged;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<DateTimeRange> onRangeSelected;
  final ValueChanged<DateTime?> onRangeStartChanged;
  final VoidCallback onClose;

  @override
  State<_DatePickerOverlay> createState() => _DatePickerOverlayState();
}

class _DatePickerOverlayState extends State<_DatePickerOverlay> {
  late final Object _tapRegionGroupId = Object();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Build decoration without WindParser to avoid theme context issues
    // when overlay is outside WindTheme tree
    final decoration = BoxDecoration(
      color: isDark ? const Color(0xFF1F2937) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 20,
          offset: Offset(0, 10),
        ),
      ],
    );

    // Wrap content in WindTheme if available to support calendar widgets
    Widget content = _buildContent(isDark);
    if (widget.themeData != null) {
      content = WindTheme(
        data: widget.themeData!,
        child: content,
      );
    }

    return CompositedTransformFollower(
      link: widget.link,
      targetAnchor: Alignment.bottomLeft,
      followerAnchor: Alignment.topLeft,
      offset: const Offset(0, 4),
      child: TapRegion(
        groupId: _tapRegionGroupId,
        onTapOutside: (_) => widget.onClose(),
        child: Material(
          elevation: 0,
          color: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(
              minWidth: widget.triggerWidth,
              maxHeight: 500,
            ),
            decoration: decoration,
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showPresets && widget.presets != null) ...[
          _buildPresets(),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
        ],
        if (widget.isRange) _buildRangeCalendars() else _buildSingleCalendar(),
      ],
    );
  }

  Widget _buildPresets() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.presets!.map((preset) {
        final isActive = widget.range != null && preset.isActive(widget.range);

        return WButton(
          onTap: () {
            widget.onRangeSelected(preset.range);
          },
          className: isActive
              ? 'px-3 py-1.5 text-sm bg-primary text-white rounded-lg'
              : 'px-3 py-1.5 text-sm bg-gray-100 dark:bg-gray-700 text-gray-700 dark:text-gray-300 rounded-lg hover:bg-gray-200 dark:hover:bg-gray-600',
          child: WText(preset.label, className: 'text-sm'),
        );
      }).toList(),
    );
  }

  Widget _buildSingleCalendar() {
    return SizedBox(
      width: 280,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          WCalendarHeader(
            month: widget.displayMonth,
            minDate: widget.minDate,
            maxDate: widget.maxDate,
            onMonthChanged: widget.onDisplayMonthChanged,
          ),
          const SizedBox(height: 8),
          WCalendarGrid(
            month: widget.displayMonth,
            selectedDate: widget.value,
            minDate: widget.minDate,
            maxDate: widget.maxDate,
            onDateSelected: widget.onDateSelected,
          ),
        ],
      ),
    );
  }

  Widget _buildRangeCalendars() {
    final nextMonth =
        DateTime(widget.displayMonth.year, widget.displayMonth.month + 1, 1);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First calendar
        SizedBox(
          width: 280,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WCalendarHeader(
                month: widget.displayMonth,
                minDate: widget.minDate,
                maxDate: widget.maxDate,
                onMonthChanged: widget.onDisplayMonthChanged,
              ),
              const SizedBox(height: 8),
              WCalendarGrid(
                month: widget.displayMonth,
                selectedRange: widget.range,
                minDate: widget.minDate,
                maxDate: widget.maxDate,
                onDateSelected: _handleRangeSelection,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Second calendar
        SizedBox(
          width: 280,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WCalendarHeader(
                month: nextMonth,
                minDate: widget.minDate,
                maxDate: widget.maxDate,
                onMonthChanged: (month) {
                  widget.onDisplayMonthChanged(DateTime(
                    month.year,
                    month.month - 1,
                    1,
                  ));
                },
              ),
              const SizedBox(height: 8),
              WCalendarGrid(
                month: nextMonth,
                selectedRange: widget.range,
                minDate: widget.minDate,
                maxDate: widget.maxDate,
                onDateSelected: _handleRangeSelection,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleRangeSelection(DateTime date) {
    if (!widget.isSelectingRange || widget.rangeStart == null) {
      // Start new range selection
      widget.onRangeStartChanged(date);
    } else {
      // Complete range selection
      final start =
          widget.rangeStart!.isBefore(date) ? widget.rangeStart! : date;
      final end = widget.rangeStart!.isBefore(date) ? date : widget.rangeStart!;
      widget.onRangeSelected(DateTimeRange(start: start, end: end));
    }
  }
}
