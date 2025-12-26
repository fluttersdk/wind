import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Basic WSelect example showing simple dropdown with styled trigger and menu.
class SelectBasicExamplePage extends StatefulWidget {
  const SelectBasicExamplePage({super.key});

  @override
  State<SelectBasicExamplePage> createState() => _SelectBasicExamplePageState();
}

class _SelectBasicExamplePageState extends State<SelectBasicExamplePage> {
  String? _selectedFruit;
  String? _selectedCountry;

  // 20 fruit options to test scrolling
  final _fruitOptions = const [
    SelectOption(value: 'apple', label: 'Apple'),
    SelectOption(value: 'banana', label: 'Banana'),
    SelectOption(value: 'cherry', label: 'Cherry'),
    SelectOption(value: 'date', label: 'Date'),
    SelectOption(value: 'elderberry', label: 'Elderberry'),
    SelectOption(value: 'fig', label: 'Fig'),
    SelectOption(value: 'grape', label: 'Grape'),
    SelectOption(value: 'honeydew', label: 'Honeydew'),
    SelectOption(value: 'imbe', label: 'Imbe'),
    SelectOption(value: 'jackfruit', label: 'Jackfruit'),
    SelectOption(value: 'kiwi', label: 'Kiwi'),
    SelectOption(value: 'lemon', label: 'Lemon'),
    SelectOption(value: 'mango', label: 'Mango'),
    SelectOption(value: 'nectarine', label: 'Nectarine'),
    SelectOption(value: 'orange', label: 'Orange'),
    SelectOption(value: 'papaya', label: 'Papaya'),
    SelectOption(value: 'quince', label: 'Quince'),
    SelectOption(value: 'raspberry', label: 'Raspberry'),
    SelectOption(value: 'strawberry', label: 'Strawberry'),
    SelectOption(value: 'tangerine', label: 'Tangerine'),
  ];

  final _countryOptions = const [
    SelectOption(value: 'us', label: 'United States'),
    SelectOption(value: 'uk', label: 'United Kingdom'),
    SelectOption(value: 'ca', label: 'Canada'),
    SelectOption(value: 'au', label: 'Australia'),
    SelectOption(value: 'de', label: 'Germany', disabled: true),
    SelectOption(value: 'fr', label: 'France'),
    SelectOption(value: 'jp', label: 'Japan'),
    SelectOption(value: 'kr', label: 'South Korea'),
    SelectOption(value: 'br', label: 'Brazil'),
    SelectOption(value: 'mx', label: 'Mexico'),
  ];

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'p-6 bg-gray-100',
      children: [
        // Basic select with max-h from className
        const WText(
          'Basic Select (max-h-48)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WSelect<String>(
          value: _selectedFruit,
          options: _fruitOptions,
          placeholder: 'Choose a fruit',
          onChange: (value) => setState(() => _selectedFruit = value),
          className:
              'w-64 bg-white border border-gray-300 rounded-lg p-3 hover:border-gray-400 focus:border-blue-500',
          menuClassName:
              'bg-white border border-gray-200 rounded-lg shadow-lg max-h-48',
        ),

        const WDiv(className: 'h-6'),

        // Styled select with w-64 and max-h-64
        const WText(
          'With Width & Height (w-80 max-h-64)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WSelect<String>(
          value: _selectedCountry,
          options: _countryOptions,
          placeholder: 'Select a country',
          onChange: (value) => setState(() => _selectedCountry = value),
          // w-80 controls trigger width (320px)
          className:
              'w-80 bg-white border border-gray-300 rounded-lg p-3 hover:border-blue-400 focus:border-blue-500 focus:ring-2 focus:ring-blue-200',
          // max-h-64 controls menu max height (256px)
          menuClassName:
              'bg-white border border-gray-200 rounded-lg shadow-xl max-h-64',
        ),

        const WDiv(className: 'h-6'),

        // Disabled select
        const WText(
          'Disabled Select',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        WSelect<String>(
          value: 'apple',
          options: _fruitOptions,
          disabled: true,
          onChange: (_) {},
          className:
              'w-64 bg-gray-100 border border-gray-200 rounded-lg p-3 text-gray-400',
        ),

        const WDiv(className: 'h-6'),

        // Selected values display
        if (_selectedFruit != null || _selectedCountry != null)
          WDiv(
            className: 'p-4 bg-green-50 rounded-lg',
            children: [
              if (_selectedFruit != null)
                WText(
                  'Selected fruit: $_selectedFruit',
                  className: 'text-green-700',
                ),
              if (_selectedCountry != null)
                WText(
                  'Selected country: $_selectedCountry',
                  className: 'text-green-700',
                ),
            ],
          ),
      ],
    );
  }
}
