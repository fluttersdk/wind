import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WCalendarGridExamplePage extends StatefulWidget {
  const WCalendarGridExamplePage({super.key});

  @override
  State<WCalendarGridExamplePage> createState() =>
      _WCalendarGridExamplePageState();
}

class _WCalendarGridExamplePageState extends State<WCalendarGridExamplePage> {
  DateTime _currentMonth = DateTime.now();
  DateTime? _selectedDate;
  DateTimeRange? _selectedRange;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 2)),
      end: DateTime.now().add(const Duration(days: 3)),
    );
  }

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
            title: 'Standalone Calendar Grid',
            description: 'A month view grid with interactive day cells.',
            child: Column(
              children: [
                WCalendarHeader(
                  month: _currentMonth,
                  onMonthChanged: (m) => setState(() => _currentMonth = m),
                ),
                const SizedBox(height: 12),
                WCalendarGrid(
                  month: _currentMonth,
                  selectedDate: _selectedDate,
                  onDateSelected: (date) =>
                      setState(() => _selectedDate = date),
                ),
              ],
            ),
          ),
          _buildSection(
            title: 'Custom Styled Range',
            description: 'Grid with custom styling for ranges and selection.',
            child: Column(
              children: [
                WCalendarGrid(
                  month: DateTime.now(),
                  selectedRange: _selectedRange,
                  // Custom styling
                  dayClassName:
                      'hover:bg-purple-100 dark:hover:bg-purple-900 rounded-md m-[1px]',
                  todayClassName:
                      'border border-purple-500 text-purple-600 font-bold rounded-md',
                  selectedDayClassName:
                      'bg-purple-600 text-white rounded-md shadow-lg',
                  rangeDayClassName:
                      'bg-purple-50 dark:bg-purple-900/30 text-purple-900 dark:text-purple-100 rounded-none',
                  weekdayHeaderClassName:
                      'text-purple-500 font-bold text-xs uppercase',
                  onDateSelected: (date) {
                    setState(() {
                      // Simple range logic for demo
                      if (_selectedRange == null ||
                          date.isBefore(_selectedRange!.start)) {
                        _selectedRange = DateTimeRange(
                            start: date,
                            end: date.add(const Duration(days: 1)));
                      } else {
                        _selectedRange = DateTimeRange(
                            start: _selectedRange!.start, end: date);
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className: 'bg-gradient-to-r from-gray-700 to-gray-900 rounded-xl p-6',
      child: WText(
        'WCalendarGrid',
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
