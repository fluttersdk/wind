import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/widgets/date_preset.dart';

void main() {
  group('DatePreset', () {
    group('factory constructors', () {
      test('last24Hours returns range from now-24h to now', () {
        final now = DateTime.now();
        final preset = DatePreset.last24Hours();

        expect(preset.label, 'Last 24 hours');
        expect(preset.key, '24h');

        // Range should be approximately 24 hours
        final duration = preset.range.end.difference(preset.range.start);
        expect(duration.inHours, 24);

        // End should be close to now (within 1 second tolerance)
        expect(
          preset.range.end.difference(now).inSeconds.abs(),
          lessThan(2),
        );
      });

      test('last7Days returns range from now-7d to now', () {
        final now = DateTime.now();
        final preset = DatePreset.last7Days();

        expect(preset.label, 'Last 7 days');
        expect(preset.key, '7d');

        final duration = preset.range.end.difference(preset.range.start);
        expect(duration.inDays, 7);

        expect(
          preset.range.end.difference(now).inSeconds.abs(),
          lessThan(2),
        );
      });

      test('last30Days returns range from now-30d to now', () {
        final now = DateTime.now();
        final preset = DatePreset.last30Days();

        expect(preset.label, 'Last 30 days');
        expect(preset.key, '30d');

        final duration = preset.range.end.difference(preset.range.start);
        expect(duration.inDays, 30);

        expect(
          preset.range.end.difference(now).inSeconds.abs(),
          lessThan(2),
        );
      });

      test('thisMonth returns range from start of month to now', () {
        final now = DateTime.now();
        final preset = DatePreset.thisMonth();

        expect(preset.label, 'This month');
        expect(preset.key, 'this_month');

        // Start should be first day of current month
        expect(preset.range.start.day, 1);
        expect(preset.range.start.month, now.month);
        expect(preset.range.start.year, now.year);
      });

      test('lastMonth returns range for previous month', () {
        final now = DateTime.now();
        final preset = DatePreset.lastMonth();

        expect(preset.label, 'Last month');
        expect(preset.key, 'last_month');

        // Calculate expected previous month
        final expectedMonth = now.month == 1 ? 12 : now.month - 1;
        final expectedYear = now.month == 1 ? now.year - 1 : now.year;

        expect(preset.range.start.month, expectedMonth);
        expect(preset.range.start.year, expectedYear);
        expect(preset.range.start.day, 1);
      });

      test('custom creates preset with arbitrary range', () {
        final start = DateTime(2026, 1, 1);
        final end = DateTime(2026, 1, 15);
        final range = DateTimeRange(start: start, end: end);

        final preset = DatePreset.custom(
          label: 'First half of January',
          key: 'custom_jan',
          range: range,
        );

        expect(preset.label, 'First half of January');
        expect(preset.key, 'custom_jan');
        expect(preset.range.start, start);
        expect(preset.range.end, end);
      });
    });

    group('icon property', () {
      test('last24Hours has schedule icon', () {
        final preset = DatePreset.last24Hours();
        expect(preset.icon, Icons.schedule);
      });

      test('custom preset can have custom icon', () {
        final preset = DatePreset.custom(
          label: 'Custom',
          key: 'custom',
          range: DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 1)),
            end: DateTime.now(),
          ),
          icon: Icons.calendar_today,
        );
        expect(preset.icon, Icons.calendar_today);
      });
    });

    group('equality', () {
      test('presets with same key are equal', () {
        final preset1 = DatePreset.last24Hours();
        final preset2 = DatePreset.last24Hours();

        // Keys should match
        expect(preset1.key, preset2.key);
      });
    });

    group('isActive', () {
      test('returns true when current range matches preset range', () {
        final preset = DatePreset.last7Days();
        final currentRange = preset.range;

        expect(preset.isActive(currentRange), isTrue);
      });

      test('returns false when current range differs', () {
        final preset = DatePreset.last7Days();
        final differentRange = DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 14)),
          end: DateTime.now(),
        );

        expect(preset.isActive(differentRange), isFalse);
      });
    });
  });
}
