import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// WSelect basic example showing dropdown with styled trigger and menu.
class SelectBasicExamplePage extends StatefulWidget {
  const SelectBasicExamplePage({super.key});

  @override
  State<SelectBasicExamplePage> createState() => _SelectBasicExamplePageState();
}

class _SelectBasicExamplePageState extends State<SelectBasicExamplePage> {
  String? _selectedFruit;
  String? _selectedCountry;

  final _fruitOptions = const [
    SelectOption(value: 'apple', label: 'Apple'),
    SelectOption(value: 'banana', label: 'Banana'),
    SelectOption(value: 'cherry', label: 'Cherry'),
    SelectOption(value: 'date', label: 'Date'),
    SelectOption(value: 'elderberry', label: 'Elderberry'),
    SelectOption(value: 'fig', label: 'Fig'),
    SelectOption(value: 'grape', label: 'Grape'),
    SelectOption(value: 'honeydew', label: 'Honeydew'),
    SelectOption(value: 'kiwi', label: 'Kiwi'),
    SelectOption(value: 'lemon', label: 'Lemon'),
  ];

  final _countryOptions = const [
    SelectOption(value: 'us', label: 'United States'),
    SelectOption(value: 'uk', label: 'United Kingdom'),
    SelectOption(value: 'ca', label: 'Canada'),
    SelectOption(value: 'au', label: 'Australia'),
    SelectOption(value: 'de', label: 'Germany', disabled: true),
    SelectOption(value: 'fr', label: 'France'),
  ];

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
              bg-gradient-to-r from-indigo-500 to-purple-500
            ''',
            children: const [
              WText('WSelect', className: 'text-lg font-bold text-white'),
              WText(
                'Dropdown select with search and multi-select',
                className: 'text-sm text-indigo-100',
              ),
            ],
          ),

          // Basic select
          _buildSection(
            title: 'Basic Select',
            description: 'Simple dropdown with fruit options',
            children: [
              WSelect<String>(
                value: _selectedFruit,
                options: _fruitOptions,
                placeholder: 'Choose a fruit',
                onChange: (value) => setState(() => _selectedFruit = value),
                className: '''
                  w-64 p-3 rounded-lg
                  bg-white dark:bg-slate-800
                  border border-gray-300 dark:border-gray-600
                  hover:border-gray-400 focus:border-blue-500
                ''',
                menuClassName: '''
                  bg-white dark:bg-slate-800
                  border border-gray-200 dark:border-gray-600
                  rounded-lg shadow-lg max-h-48
                ''',
              ),
              if (_selectedFruit != null)
                WText(
                  'Selected: $_selectedFruit',
                  className: 'text-sm text-green-600 dark:text-green-400',
                ),
            ],
          ),

          // With disabled option
          _buildSection(
            title: 'With Disabled Option',
            description: 'Germany is disabled in this list',
            children: [
              WSelect<String>(
                value: _selectedCountry,
                options: _countryOptions,
                placeholder: 'Select a country',
                onChange: (value) => setState(() => _selectedCountry = value),
                className: '''
                  w-80 p-3 rounded-lg
                  bg-white dark:bg-slate-800
                  border border-gray-300 dark:border-gray-600
                  hover:border-blue-400 focus:border-blue-500
                  focus:ring-2 focus:ring-blue-200
                ''',
                menuClassName: '''
                  bg-white dark:bg-slate-800
                  border border-gray-200 dark:border-gray-600
                  rounded-lg shadow-xl max-h-64
                ''',
              ),
            ],
          ),

          // Disabled select
          _buildSection(
            title: 'Disabled State',
            description: 'Use disabled prop to prevent interaction',
            children: [
              WSelect<String>(
                value: 'apple',
                options: _fruitOptions,
                disabled: true,
                onChange: (_) {},
                className: '''
                  w-64 p-3 rounded-lg
                  bg-gray-100 dark:bg-slate-700
                  border border-gray-200 dark:border-gray-600
                  text-gray-400
                ''',
              ),
            ],
          ),

          // Quick Reference
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              const WText(
                'State Prefixes',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _referenceRow('hover:', 'Mouse over'),
                  _referenceRow('focus:', 'Widget focused'),
                  _referenceRow('open:', 'Menu open'),
                  _referenceRow('selected:', 'Has selection'),
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
