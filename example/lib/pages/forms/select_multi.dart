import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Multi-select WSelect example with chips/tags.
class SelectMultiExamplePage extends StatefulWidget {
  const SelectMultiExamplePage({super.key});

  @override
  State<SelectMultiExamplePage> createState() => _SelectMultiExamplePageState();
}

class _SelectMultiExamplePageState extends State<SelectMultiExamplePage> {
  List<String> _selectedTags = [];
  List<String> _selectedColors = ['red', 'blue'];

  final _tagOptions = const [
    SelectOption(value: 'flutter', label: 'Flutter'),
    SelectOption(value: 'dart', label: 'Dart'),
    SelectOption(value: 'mobile', label: 'Mobile'),
    SelectOption(value: 'web', label: 'Web'),
    SelectOption(value: 'desktop', label: 'Desktop'),
    SelectOption(value: 'ui', label: 'UI/UX'),
    SelectOption(value: 'backend', label: 'Backend'),
    SelectOption(value: 'database', label: 'Database'),
  ];

  final _colorOptions = const [
    SelectOption(
      value: 'red',
      label: 'Red',
      icon: Icon(Icons.circle, color: Colors.red, size: 16),
    ),
    SelectOption(
      value: 'blue',
      label: 'Blue',
      icon: Icon(Icons.circle, color: Colors.blue, size: 16),
    ),
    SelectOption(
      value: 'green',
      label: 'Green',
      icon: Icon(Icons.circle, color: Colors.green, size: 16),
    ),
    SelectOption(
      value: 'orange',
      label: 'Orange',
      icon: Icon(Icons.circle, color: Colors.orange, size: 16),
    ),
    SelectOption(
      value: 'purple',
      label: 'Purple',
      icon: Icon(Icons.circle, color: Colors.purple, size: 16),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'p-6 bg-gray-100 h-full',
      children: [
        // Basic multi-select
        const WText(
          'Multi-Select (Tags)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WSelect<String>(
          isMulti: true,
          values: _selectedTags,
          options: _tagOptions,
          searchable: true,
          placeholder: 'Select tags...',
          onMultiChange: (values) => setState(() => _selectedTags = values),
          className:
              'w-80 bg-white border border-gray-300 rounded-lg p-2 min-h-10',
          menuClassName:
              'bg-white border border-gray-200 rounded-lg shadow-lg max-h-64',
        ),

        const WDiv(className: 'h-6'),

        // Multi-select with icons
        const WText(
          'Multi-Select with Icons',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WSelect<String>(
          isMulti: true,
          values: _selectedColors,
          options: _colorOptions,
          placeholder: 'Select colors...',
          onMultiChange: (values) => setState(() => _selectedColors = values),
          className:
              'w-80 bg-white border border-gray-300 rounded-lg p-2 min-h-10',
          menuClassName:
              'bg-white border border-gray-200 rounded-lg shadow-lg max-h-48',
        ),

        const WDiv(className: 'h-6'),

        // Selected values display
        if (_selectedTags.isNotEmpty || _selectedColors.isNotEmpty)
          WDiv(
            className: 'p-4 bg-blue-50 rounded-lg',
            children: [
              if (_selectedTags.isNotEmpty)
                WText(
                  'Tags: ${_selectedTags.join(", ")}',
                  className: 'text-blue-700',
                ),
              if (_selectedColors.isNotEmpty)
                WText(
                  'Colors: ${_selectedColors.join(", ")}',
                  className: 'text-blue-700',
                ),
            ],
          ),
      ],
    );
  }
}
