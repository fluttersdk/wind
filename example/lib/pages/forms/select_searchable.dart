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

  final _allOptions = const [
    SelectOption(value: 'apple', label: 'Apple'),
    SelectOption(value: 'apricot', label: 'Apricot'),
    SelectOption(value: 'banana', label: 'Banana'),
    SelectOption(value: 'blueberry', label: 'Blueberry'),
    SelectOption(value: 'cherry', label: 'Cherry'),
    SelectOption(value: 'coconut', label: 'Coconut'),
    SelectOption(value: 'date', label: 'Date'),
    SelectOption(value: 'dragonfruit', label: 'Dragon Fruit'),
    SelectOption(value: 'elderberry', label: 'Elderberry'),
    SelectOption(value: 'fig', label: 'Fig'),
    SelectOption(value: 'grape', label: 'Grape'),
    SelectOption(value: 'guava', label: 'Guava'),
    SelectOption(value: 'honeydew', label: 'Honeydew'),
    SelectOption(value: 'kiwi', label: 'Kiwi'),
    SelectOption(value: 'lemon', label: 'Lemon'),
    SelectOption(value: 'lime', label: 'Lime'),
    SelectOption(value: 'mango', label: 'Mango'),
    SelectOption(value: 'melon', label: 'Melon'),
    SelectOption(value: 'orange', label: 'Orange'),
    SelectOption(value: 'papaya', label: 'Papaya'),
  ];

  /// Simulates API search with delay
  Future<List<SelectOption<String>>> _asyncSearch(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (query.isEmpty) return _allOptions;
    return _allOptions
        .where((opt) => opt.label.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'p-6 bg-gray-100 h-full',
      children: [
        // Local searchable select
        const WText(
          'Searchable (Local Filtering)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WSelect<String>(
          value: _selectedLocal,
          options: _allOptions,
          searchable: true,
          placeholder: 'Search fruits...',
          onChange: (value) => setState(() => _selectedLocal = value),
          className:
              'w-72 bg-white border border-gray-300 rounded-lg p-3 hover:border-gray-400 focus:border-blue-500',
          menuClassName:
              'bg-white border border-gray-200 rounded-lg shadow-lg max-h-64',
        ),

        const WDiv(className: 'h-6'),

        // Async searchable select
        const WText(
          'Searchable (Async API Search)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WSelect<String>(
          value: _selectedAsync,
          options: _allOptions,
          searchable: true,
          onSearch: _asyncSearch,
          placeholder: 'Search with API...',
          onChange: (value) => setState(() => _selectedAsync = value),
          className:
              'w-72 bg-white border border-gray-300 rounded-lg p-3 hover:border-purple-400 focus:border-purple-500',
          menuClassName:
              'bg-white border border-gray-200 rounded-lg shadow-lg max-h-64',
        ),

        const WDiv(className: 'h-6'),

        // Selected values display
        if (_selectedLocal != null || _selectedAsync != null)
          WDiv(
            className: 'p-4 bg-blue-50 rounded-lg',
            children: [
              if (_selectedLocal != null)
                WText(
                  'Local search: $_selectedLocal',
                  className: 'text-blue-700',
                ),
              if (_selectedAsync != null)
                WText(
                  'Async search: $_selectedAsync',
                  className: 'text-blue-700',
                ),
            ],
          ),
      ],
    );
  }
}
