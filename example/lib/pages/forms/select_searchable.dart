import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Searchable WSelect example with local and async filtering.
class SelectSearchableExamplePage extends StatefulWidget {
  const SelectSearchableExamplePage({super.key});

  @override
  State<SelectSearchableExamplePage> createState() =>
      _SelectSearchableExamplePageState();
}

class _SelectSearchableExamplePageState
    extends State<SelectSearchableExamplePage> {
  String? _selectedLocal;
  String? _selectedAsync;

  final _options = const [
    SelectOption(value: 'apple', label: 'Apple'),
    SelectOption(value: 'banana', label: 'Banana'),
    SelectOption(value: 'cherry', label: 'Cherry'),
    SelectOption(value: 'date', label: 'Date'),
    SelectOption(value: 'elderberry', label: 'Elderberry'),
    SelectOption(value: 'fig', label: 'Fig'),
    SelectOption(value: 'grape', label: 'Grape'),
    SelectOption(value: 'honeydew', label: 'Honeydew'),
  ];

  Future<List<SelectOption<String>>> _asyncSearch(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (query.isEmpty) return _options;
    return _options
        .where((opt) => opt.label.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'w-full h-full overflow-y-auto p-4',
      child: WDiv(
        className: 'flex flex-col gap-6',
        children: [
          // Header with gradient
          WDiv(
            className: '''
              w-full p-4 rounded-xl
              bg-gradient-to-r from-cyan-500 to-teal-500
            ''',
            children: const [
              WText(
                'Searchable Select',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Local and async search filtering',
                className: 'text-sm text-cyan-100',
              ),
            ],
          ),

          // Local search
          _buildSection(
            title: 'Local Filtering',
            description: 'Search filters options locally',
            children: [
              WSelect<String>(
                value: _selectedLocal,
                options: _options,
                searchable: true,
                placeholder: 'Search fruits...',
                onChange: (value) => setState(() => _selectedLocal = value),
                className: '''
                  w-72 p-3 rounded-lg
                  bg-white dark:bg-slate-800
                  border border-gray-300 dark:border-gray-600
                  hover:border-gray-400 focus:border-blue-500
                ''',
                menuClassName: '''
                  bg-white dark:bg-slate-800
                  border border-gray-200 dark:border-gray-600
                  rounded-lg shadow-lg max-h-64
                ''',
              ),
              if (_selectedLocal != null)
                WText(
                  'Selected: $_selectedLocal',
                  className: 'text-sm text-green-600 dark:text-green-400',
                ),
            ],
          ),

          // Async search
          _buildSection(
            title: 'Async API Search',
            description: 'Search calls async function',
            children: [
              WSelect<String>(
                value: _selectedAsync,
                options: _options,
                searchable: true,
                onSearch: _asyncSearch,
                placeholder: 'Search with API...',
                onChange: (value) => setState(() => _selectedAsync = value),
                className: '''
                  w-72 p-3 rounded-lg
                  bg-white dark:bg-slate-800
                  border border-gray-300 dark:border-gray-600
                  hover:border-purple-400 focus:border-purple-500
                ''',
                menuClassName: '''
                  bg-white dark:bg-slate-800
                  border border-gray-200 dark:border-gray-600
                  rounded-lg shadow-lg max-h-64
                ''',
              ),
            ],
          ),

          // Quick Reference
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              const WText(
                'Search Props',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _referenceRow('searchable:', 'true'),
                  _referenceRow('onSearch:', 'Async callback'),
                  _referenceRow('searchPlaceholder:', 'Hint text'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required List<Widget> children,
  }) {
    return WDiv(
      className: 'flex flex-col gap-2',
      children: [
        WText(
          title,
          className: 'font-semibold text-gray-800 dark:text-white font-mono',
        ),
        WText(
          description,
          className: 'text-sm text-gray-500 dark:text-gray-400',
        ),
        ...children,
      ],
    );
  }

  Widget _referenceRow(String className, String value) {
    return WDiv(
      className: 'flex justify-between',
      children: [
        WText(
          className,
          className: 'text-sm font-mono text-gray-600 dark:text-gray-300',
        ),
        WText(value, className: 'text-sm text-gray-500 dark:text-gray-400'),
      ],
    );
  }
}
