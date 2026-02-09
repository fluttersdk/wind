import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WDatePickerRangeExamplePage extends StatefulWidget {
  const WDatePickerRangeExamplePage({super.key});

  @override
  State<WDatePickerRangeExamplePage> createState() =>
      _WDatePickerRangeExamplePageState();
}

class _WDatePickerRangeExamplePageState
    extends State<WDatePickerRangeExamplePage> {
  DateTimeRange? _range1;
  DateTimeRange? _range2;

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildSection(
            title: 'Range Selection',
            description: 'Select a start and end date using dual calendars.',
            child: WDatePicker(
              isRange: true,
              range: _range1,
              onRangeChanged: (range) => setState(() => _range1 = range),
              placeholder: 'Select date range',
            ),
          ),
          _buildSection(
            title: 'With Presets',
            description:
                'Range picker with quick selection presets (e.g., Last 7 Days).',
            child: WDatePicker(
              isRange: true,
              showPresets: true,
              presets: [
                DatePreset.last24Hours(),
                DatePreset.last7Days(),
                DatePreset.last30Days(),
                DatePreset.thisMonth(),
                DatePreset.lastMonth(),
              ],
              range: _range2,
              onRangeChanged: (range) => setState(() => _range2 = range),
              placeholder: 'Select range with presets',
              className: 'w-full',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'bg-gradient-to-r from-emerald-500 to-teal-600 rounded-xl p-6',
      child: WText(
        'Date Range Selection',
        className: 'text-2xl font-bold text-white',
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required Widget child,
  }) {
    return WDiv(
      className:
          'flex flex-col gap-4 p-6 bg-white dark:bg-slate-800 rounded-lg shadow-sm border border-gray-100 dark:border-gray-700',
      children: [
        WText(title,
            className: 'text-lg font-semibold text-slate-900 dark:text-white'),
        WText(description,
            className: 'text-sm text-slate-600 dark:text-slate-400'),
        child,
      ],
    );
  }
}
