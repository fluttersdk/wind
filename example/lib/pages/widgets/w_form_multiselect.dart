import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WFormMultiSelectExamplePage extends StatefulWidget {
  const WFormMultiSelectExamplePage({super.key});

  @override
  State<WFormMultiSelectExamplePage> createState() =>
      _WFormMultiSelectExamplePageState();
}

class _WFormMultiSelectExamplePageState
    extends State<WFormMultiSelectExamplePage> {
  final _formKey = GlobalKey<FormState>();
  List<String> _selectedSkills = [];
  List<String> _selectedTags = ['flutter', 'wind'];

  final _skills = [
    SelectOption(label: 'Flutter', value: 'flutter'),
    SelectOption(label: 'React Native', value: 'react_native'),
    SelectOption(label: 'Swift', value: 'swift'),
    SelectOption(label: 'Kotlin', value: 'kotlin'),
    SelectOption(label: 'Dart', value: 'dart'),
    SelectOption(label: 'TypeScript', value: 'typescript'),
  ];

  late List<SelectOption<String>> _tagOptions;

  @override
  void initState() {
    super.initState();
    _tagOptions = [
      SelectOption(label: 'Flutter', value: 'flutter'),
      SelectOption(label: 'Wind', value: 'wind'),
      SelectOption(label: 'UI', value: 'ui'),
      SelectOption(label: 'UX', value: 'ux'),
    ];
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
            title: 'Multi-Select with Validation',
            description: 'Select multiple options. Requires at least 2.',
            child: Form(
              key: _formKey,
              child: WDiv(
                className: 'flex flex-col gap-4',
                children: [
                  WFormMultiSelect<String>(
                    label: 'Skills',
                    labelClassName:
                        'text-sm font-medium text-slate-700 dark:text-white mb-1',
                    values: _selectedSkills,
                    options: _skills,
                    onMultiChange: (v) => setState(() => _selectedSkills = v),
                    validator: (v) {
                      if (v == null || v.length < 2) {
                        return 'Please select at least 2 skills';
                      }
                      return null;
                    },
                    className:
                        'w-full px-3 py-2 bg-white dark:bg-slate-900 border border-slate-300 dark:border-slate-700 rounded-lg min-h-[42px] error:border-red-500',
                    menuClassName:
                        'bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-lg shadow-xl',
                  ),
                  WButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Skills Validated!')),
                        );
                      }
                    },
                    className:
                        'bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 rounded-lg self-start',
                    child: const WText('Validate'),
                  ),
                ],
              ),
            ),
          ),
          _buildSection(
            title: 'Tag Creation',
            description:
                'Searchable multi-select with ability to create new tags.',
            child: WFormMultiSelect<String>(
              label: 'Tags',
              labelClassName:
                  'text-sm font-medium text-slate-700 dark:text-white mb-1',
              placeholder: 'Add tags...',
              values: _selectedTags,
              options: _tagOptions,
              searchable: true,
              onMultiChange: (v) => setState(() => _selectedTags = v),
              onCreateOption: (query) async {
                final newOption =
                    SelectOption(label: query, value: query.toLowerCase());
                setState(() {
                  _tagOptions.add(newOption);
                });
                return newOption;
              },
              className:
                  'w-full px-3 py-2 bg-white dark:bg-slate-900 border border-slate-300 dark:border-slate-700 rounded-lg min-h-[42px]',
              menuClassName:
                  'bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-lg shadow-xl',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-indigo-500 to-blue-600 rounded-xl p-6 shadow-lg',
      child: WText(
        'Multi-Select',
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
          'flex flex-col gap-4 p-6 bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-slate-200 dark:border-slate-700',
      children: [
        WDiv(
          className: 'flex flex-col gap-1',
          children: [
            WText(title,
                className:
                    'text-lg font-semibold text-slate-900 dark:text-white'),
            WText(description,
                className: 'text-sm text-slate-600 dark:text-slate-400'),
          ],
        ),
        const WSpacer(className: 'h-4'),
        child,
      ],
    );
  }
}
