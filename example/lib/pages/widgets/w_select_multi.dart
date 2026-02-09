import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WSelectMultiExamplePage extends StatefulWidget {
  const WSelectMultiExamplePage({super.key});

  @override
  State<WSelectMultiExamplePage> createState() =>
      _WSelectMultiExamplePageState();
}

class _WSelectMultiExamplePageState extends State<WSelectMultiExamplePage> {
  List<String> _selectedTags = ['design', 'development'];
  List<String> _selectedTeam = [];

  final List<SelectOption<String>> _tags = [
    SelectOption(value: 'design', label: 'Design'),
    SelectOption(value: 'development', label: 'Development'),
    SelectOption(value: 'marketing', label: 'Marketing'),
    SelectOption(value: 'sales', label: 'Sales'),
    SelectOption(value: 'support', label: 'Support'),
    SelectOption(value: 'hr', label: 'Human Resources'),
    SelectOption(value: 'finance', label: 'Finance'),
  ];

  final List<SelectOption<String>> _members = [
    SelectOption(value: 'alice', label: 'Alice Johnson'),
    SelectOption(value: 'bob', label: 'Bob Smith'),
    SelectOption(value: 'charlie', label: 'Charlie Brown'),
    SelectOption(value: 'david', label: 'David Wilson'),
    SelectOption(value: 'eve', label: 'Eve Davis'),
    SelectOption(value: 'frank', label: 'Frank Miller'),
  ];

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          'w-full h-full overflow-y-auto p-4 bg-gray-50 dark:bg-slate-900',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildSection(
            title: 'Basic Multi-Select',
            description: 'Select multiple items from a dropdown list.',
            child: WSelect<String>(
              isMulti: true,
              values: _selectedTags,
              options: _tags,
              placeholder: 'Select tags...',
              onMultiChange: (values) => setState(() => _selectedTags = values),
              className:
                  'w-full bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-600 rounded-lg p-2 min-h-[48px] hover:border-teal-500 focus:ring-2 focus:ring-teal-200 dark:focus:ring-teal-900 transition-all',
              menuClassName:
                  'bg-white dark:bg-slate-800 border border-gray-200 dark:border-slate-700 shadow-xl rounded-xl mt-1',
            ),
          ),
          _buildSection(
            title: 'Searchable Multi-Select',
            description:
                'Multi-select with search capability for larger lists.',
            child: WSelect<String>(
              isMulti: true,
              searchable: true,
              values: _selectedTeam,
              options: _members,
              placeholder: 'Add team members...',
              searchPlaceholder: 'Search members...',
              onMultiChange: (values) => setState(() => _selectedTeam = values),
              className:
                  'w-full bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-600 rounded-lg p-2 min-h-[48px] hover:border-indigo-500 focus:ring-2 focus:ring-indigo-200 dark:focus:ring-indigo-900 transition-all',
              menuClassName:
                  'bg-white dark:bg-slate-800 border border-gray-200 dark:border-slate-700 shadow-xl rounded-xl mt-1',
              selectedChipBuilder: (context, option, onRemove) {
                return WDiv(
                  className:
                      'flex items-center gap-1 bg-indigo-50 dark:bg-indigo-900/30 border border-indigo-100 dark:border-indigo-800 rounded-full px-3 py-1',
                  children: [
                    WText(
                      option.label,
                      className:
                          'text-sm font-medium text-indigo-700 dark:text-indigo-300',
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: Colors.indigo.shade400,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-teal-500 to-emerald-600 rounded-xl p-6 shadow-lg',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WText(
            'WSelect Multi',
            className: 'text-2xl font-bold text-white mb-2',
          ),
          WText(
            'Multiple item selection with chips and custom rendering support.',
            className: 'text-teal-100',
          ),
        ],
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
          'flex flex-col gap-4 p-6 bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700',
      children: [
        WDiv(
          className: 'flex flex-col gap-1',
          children: [
            WText(title,
                className: 'text-lg font-bold text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-slate-500 dark:text-slate-400'),
          ],
        ),
        WDiv(
          className:
              'p-4 bg-gray-50 dark:bg-slate-900/50 rounded-lg border border-gray-200 dark:border-slate-700/50',
          child: child,
        ),
      ],
    );
  }
}
