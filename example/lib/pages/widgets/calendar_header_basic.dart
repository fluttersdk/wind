import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class CalendarHeaderBasicExamplePage extends StatefulWidget {
  const CalendarHeaderBasicExamplePage({super.key});

  @override
  State<CalendarHeaderBasicExamplePage> createState() =>
      _CalendarHeaderBasicExamplePageState();
}

class _CalendarHeaderBasicExamplePageState
    extends State<CalendarHeaderBasicExamplePage> {
  DateTime _month = DateTime.now();

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
            title: 'Standard Header',
            description: 'Month navigation with default styling.',
            child: WCalendarHeader(
              month: _month,
              onMonthChanged: (m) => setState(() => _month = m),
            ),
          ),
          _buildSection(
            title: 'Constrained Navigation',
            description:
                'Header with min/max dates (Prevents navigation beyond 1 month).',
            child: WCalendarHeader(
              month: _month,
              minDate: DateTime.now().subtract(const Duration(days: 30)),
              maxDate: DateTime.now().add(const Duration(days: 30)),
              onMonthChanged: (m) => setState(() => _month = m),
            ),
          ),
          _buildSection(
            title: 'Custom Styled',
            description: 'Header with custom colors and button styles.',
            child: WDiv(
              className: 'bg-indigo-600 rounded-xl p-2',
              child: WCalendarHeader(
                month: _month,
                monthYearClassName:
                    'text-white text-lg font-bold tracking-widest',
                buttonClassName:
                    'text-indigo-100 hover:bg-white/20 rounded-full p-2 transition-colors',
                disabledButtonClassName: 'text-indigo-400 p-2',
                onMonthChanged: (m) => setState(() => _month = m),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'bg-gradient-to-r from-cyan-500 to-blue-500 rounded-xl p-6',
      child: WText(
        'WCalendarHeader',
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
