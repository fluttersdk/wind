import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WSelectSingleExamplePage extends StatefulWidget {
  const WSelectSingleExamplePage({super.key});

  @override
  State<WSelectSingleExamplePage> createState() =>
      _WSelectSingleExamplePageState();
}

class _WSelectSingleExamplePageState extends State<WSelectSingleExamplePage> {
  String? _selectedFruit;
  String? _selectedCountry;
  String? _selectedFramework;

  final List<SelectOption<String>> _fruits = [
    SelectOption(value: 'apple', label: 'Apple'),
    SelectOption(value: 'banana', label: 'Banana'),
    SelectOption(value: 'cherry', label: 'Cherry'),
    SelectOption(value: 'date', label: 'Date'),
    SelectOption(value: 'elderberry', label: 'Elderberry'),
  ];

  final List<SelectOption<String>> _countries = [
    SelectOption(value: 'us', label: 'United States'),
    SelectOption(value: 'ca', label: 'Canada'),
    SelectOption(value: 'uk', label: 'United Kingdom'),
    SelectOption(value: 'de', label: 'Germany'),
    SelectOption(value: 'fr', label: 'France'),
    SelectOption(value: 'jp', label: 'Japan'),
    SelectOption(value: 'au', label: 'Australia'),
    SelectOption(value: 'br', label: 'Brazil'),
  ];

  final List<SelectOption<String>> _frameworks = [
    SelectOption(value: 'flutter', label: 'Flutter'),
    SelectOption(value: 'react', label: 'React'),
    SelectOption(value: 'vue', label: 'Vue'),
    SelectOption(value: 'angular', label: 'Angular'),
    SelectOption(value: 'svelte', label: 'Svelte'),
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
            title: 'Basic Single Select',
            description: 'Standard dropdown with a list of options.',
            child: WSelect<String>(
              value: _selectedFruit,
              options: _fruits,
              placeholder: 'Select a fruit',
              onChange: (value) => setState(() => _selectedFruit = value),
              className:
                  'w-full bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-600 rounded-lg p-3 hover:border-blue-500 focus:ring-2 focus:ring-blue-200 dark:focus:ring-blue-900 transition-all',
              menuClassName:
                  'bg-white dark:bg-slate-800 border border-gray-200 dark:border-slate-700 shadow-xl rounded-xl mt-1',
            ),
          ),
          _buildSection(
            title: 'Searchable Select',
            description: 'Dropdown with a search input for filtering options.',
            child: WSelect<String>(
              value: _selectedCountry,
              options: _countries,
              searchable: true,
              searchPlaceholder: 'Search country...',
              placeholder: 'Select a country',
              onChange: (value) => setState(() => _selectedCountry = value),
              className:
                  'w-full bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-600 rounded-lg p-3 hover:border-purple-500 focus:ring-2 focus:ring-purple-200 dark:focus:ring-purple-900 transition-all',
              menuClassName:
                  'bg-white dark:bg-slate-800 border border-gray-200 dark:border-slate-700 shadow-xl rounded-xl mt-1',
            ),
          ),
          _buildSection(
            title: 'Disabled State',
            description: 'Select component in disabled state.',
            child: WSelect<String>(
              value: _selectedFramework,
              options: _frameworks,
              disabled: true,
              placeholder: 'Cannot select',
              onChange: (value) => setState(() => _selectedFramework = value),
              className:
                  'w-full bg-gray-100 dark:bg-slate-800/50 border border-gray-200 dark:border-slate-700 rounded-lg p-3 opacity-60 cursor-not-allowed',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return WDiv(
      className:
          'bg-gradient-to-r from-blue-500 to-indigo-600 rounded-xl p-6 shadow-lg',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WText(
            'WSelect Single',
            className: 'text-2xl font-bold text-white mb-2',
          ),
          WText(
            'Single item selection with search and customization capabilities.',
            className: 'text-blue-100',
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
