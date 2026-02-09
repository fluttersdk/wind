import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WFormSelectExamplePage extends StatefulWidget {
  const WFormSelectExamplePage({super.key});

  @override
  State<WFormSelectExamplePage> createState() => _WFormSelectExamplePageState();
}

class _WFormSelectExamplePageState extends State<WFormSelectExamplePage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCountry;
  String? _selectedRole;

  final _countries = [
    SelectOption(label: 'United States', value: 'us'),
    SelectOption(label: 'United Kingdom', value: 'uk'),
    SelectOption(label: 'Canada', value: 'ca'),
    SelectOption(label: 'Australia', value: 'au'),
    SelectOption(label: 'Germany', value: 'de'),
    SelectOption(label: 'France', value: 'fr'),
    SelectOption(label: 'Japan', value: 'jp'),
  ];

  final _roles = [
    SelectOption(label: 'Admin', value: 'admin'),
    SelectOption(label: 'Editor', value: 'editor'),
    SelectOption(label: 'Viewer', value: 'viewer'),
  ];

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
            title: 'Basic Select',
            description: 'Simple dropdown with validation.',
            child: Form(
              key: _formKey,
              child: WDiv(
                className: 'flex flex-col gap-4',
                children: [
                  WFormSelect<String>(
                    label: 'User Role',
                    labelClassName:
                        'text-sm font-medium text-slate-700 dark:text-white mb-1',
                    placeholder: 'Select a role',
                    value: _selectedRole,
                    options: _roles,
                    onChange: (v) => setState(() => _selectedRole = v),
                    validator: (v) => v == null ? 'Please select a role' : null,
                    className:
                        'w-full px-3 py-2 bg-white dark:bg-slate-900 border border-slate-300 dark:border-slate-700 rounded-lg error:border-red-500',
                    menuClassName:
                        'bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-lg shadow-xl',
                  ),
                  WButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Role Selected!')),
                        );
                      }
                    },
                    className:
                        'bg-purple-600 hover:bg-purple-700 text-white px-4 py-2 rounded-lg self-start',
                    child: const WText('Validate'),
                  ),
                ],
              ),
            ),
          ),
          _buildSection(
            title: 'Searchable Select',
            description: 'Dropdown with search functionality for long lists.',
            child: WFormSelect<String>(
              label: 'Country',
              labelClassName:
                  'text-sm font-medium text-slate-700 dark:text-white mb-1',
              placeholder: 'Search country...',
              value: _selectedCountry,
              options: _countries,
              searchable: true,
              onChange: (v) => setState(() => _selectedCountry = v),
              className:
                  'w-full px-3 py-2 bg-white dark:bg-slate-900 border border-slate-300 dark:border-slate-700 rounded-lg',
              menuClassName:
                  'bg-white dark:bg-slate-900 border border-slate-200 dark:border-slate-700 rounded-lg shadow-xl',
            ),
          ),
          _buildSection(
            title: 'Async Search',
            description: 'Simulated API search.',
            child: WFormSelect<String>(
              label: 'Async Search',
              labelClassName:
                  'text-sm font-medium text-slate-700 dark:text-white mb-1',
              placeholder: 'Type "a" to search...',
              options: const [],
              searchable: true,
              onSearch: (query) async {
                await Future.delayed(const Duration(seconds: 1));
                return _countries
                    .where((c) =>
                        c.label.toLowerCase().contains(query.toLowerCase()))
                    .toList();
              },
              className:
                  'w-full px-3 py-2 bg-white dark:bg-slate-900 border border-slate-300 dark:border-slate-700 rounded-lg',
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
          'bg-gradient-to-r from-purple-500 to-pink-600 rounded-xl p-6 shadow-lg',
      child: WText(
        'Form Select',
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
