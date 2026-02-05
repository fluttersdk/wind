import 'package:flutter/material.dart';

/// A preset date range for quick selection in date pickers.
///
/// Provides factory constructors for common presets like "Last 24 hours",
/// "Last 7 days", etc. Can also create custom presets with arbitrary ranges.
///
/// Example:
/// ```dart
/// WDatePicker(
///   presets: [
///     DatePreset.last24Hours(),
///     DatePreset.last7Days(),
///     DatePreset.last30Days(),
///   ],
/// )
/// ```
@immutable
class DatePreset {
  /// Creates a date preset.
  const DatePreset({
    required this.label,
    required this.key,
    required this.range,
    this.icon,
  });

  /// Display label for the preset (e.g., "Last 24 hours").
  final String label;

  /// Unique key identifier (e.g., "24h", "7d").
  final String key;

  /// The date range this preset represents.
  final DateTimeRange range;

  /// Optional icon to display with the preset.
  final IconData? icon;

  /// Creates a preset for the last 24 hours.
  factory DatePreset.last24Hours() {
    final now = DateTime.now();
    return DatePreset(
      label: 'Last 24 hours',
      key: '24h',
      range: DateTimeRange(
        start: now.subtract(const Duration(hours: 24)),
        end: now,
      ),
      icon: Icons.schedule,
    );
  }

  /// Creates a preset for the last 7 days.
  factory DatePreset.last7Days() {
    final now = DateTime.now();
    return DatePreset(
      label: 'Last 7 days',
      key: '7d',
      range: DateTimeRange(
        start: now.subtract(const Duration(days: 7)),
        end: now,
      ),
      icon: Icons.date_range,
    );
  }

  /// Creates a preset for the last 30 days.
  factory DatePreset.last30Days() {
    final now = DateTime.now();
    return DatePreset(
      label: 'Last 30 days',
      key: '30d',
      range: DateTimeRange(
        start: now.subtract(const Duration(days: 30)),
        end: now,
      ),
      icon: Icons.calendar_month,
    );
  }

  /// Creates a preset for the current month (1st of month to now).
  factory DatePreset.thisMonth() {
    final now = DateTime.now();
    return DatePreset(
      label: 'This month',
      key: 'this_month',
      range: DateTimeRange(
        start: DateTime(now.year, now.month, 1),
        end: now,
      ),
      icon: Icons.calendar_today,
    );
  }

  /// Creates a preset for the previous month.
  factory DatePreset.lastMonth() {
    final now = DateTime.now();
    final lastMonthEnd = DateTime(now.year, now.month, 1)
        .subtract(const Duration(days: 1));
    final lastMonthStart = DateTime(lastMonthEnd.year, lastMonthEnd.month, 1);

    return DatePreset(
      label: 'Last month',
      key: 'last_month',
      range: DateTimeRange(
        start: lastMonthStart,
        end: lastMonthEnd,
      ),
      icon: Icons.calendar_view_month,
    );
  }

  /// Creates a custom preset with an arbitrary range.
  factory DatePreset.custom({
    required String label,
    required String key,
    required DateTimeRange range,
    IconData? icon,
  }) {
    return DatePreset(
      label: label,
      key: key,
      range: range,
      icon: icon,
    );
  }

  /// Checks if this preset is currently active based on the given range.
  ///
  /// Returns true if the [currentRange] matches this preset's range
  /// (comparing start and end timestamps within a small tolerance).
  bool isActive(DateTimeRange? currentRange) {
    if (currentRange == null) return false;

    // Compare with 1 second tolerance to account for timing differences
    final startDiff =
        range.start.difference(currentRange.start).inSeconds.abs();
    final endDiff = range.end.difference(currentRange.end).inSeconds.abs();

    return startDiff < 2 && endDiff < 2;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatePreset &&
          runtimeType == other.runtimeType &&
          key == other.key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => 'DatePreset(key: $key, label: $label)';
}
