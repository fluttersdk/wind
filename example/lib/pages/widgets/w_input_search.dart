import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

class WInputSearchExamplePage extends StatefulWidget {
  const WInputSearchExamplePage({super.key});

  @override
  State<WInputSearchExamplePage> createState() =>
      _WInputSearchExamplePageState();
}

class _WInputSearchExamplePageState extends State<WInputSearchExamplePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className:
          'w-full h-full overflow-y-auto p-4 bg-gray-50 dark:bg-gray-900',
      scrollPrimary: true,
      child: WDiv(
        className: 'flex flex-col gap-6 max-w-4xl mx-auto',
        children: [
          _buildHeader(),
          _buildSection(
            title: 'Simple Search',
            description: 'Standard search input with prefix icon.',
            child: WInput(
              prefix: const Icon(Icons.search, size: 20, color: Colors.grey),
              placeholder: 'Search documentation...',
              className:
                  'w-full pl-2 p-3 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-lg focus:ring-2 focus:ring-blue-500',
              placeholderClassName: 'text-gray-400',
            ),
          ),
          _buildSection(
            title: 'Rounded Pill Search',
            description: 'Fully rounded search bar common in headers.',
            child: WInput(
              prefix: const Icon(Icons.search, size: 20, color: Colors.grey),
              placeholder: 'Search...',
              className:
                  'w-full pl-2 p-3 bg-gray-100 dark:bg-gray-700 rounded-full border-transparent focus:bg-white dark:focus:bg-gray-800 focus:ring-2 focus:ring-blue-500 transition-colors',
              placeholderClassName: 'text-gray-500 dark:text-gray-400',
            ),
          ),
          _buildSection(
            title: 'With Clear Button',
            description: 'Interactive search with clear button suffix.',
            child: WInput(
              controller: _searchController,
              prefix: const Icon(Icons.search, size: 20, color: Colors.grey),
              suffix: IconButton(
                icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                onPressed: () => _searchController.clear(),
              ),
              placeholder: 'Type to search...',
              onChanged: (v) => setState(() {}),
              className:
                  'w-full pl-2 p-3 bg-white dark:bg-gray-800 border border-gray-300 dark:border-gray-700 rounded-lg shadow-sm focus:border-blue-500',
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
        'Search Inputs',
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
          'flex flex-col gap-4 p-6 bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700',
      children: [
        WText(title,
            className: 'text-lg font-bold text-gray-900 dark:text-white'),
        WText(description,
            className: 'text-sm text-gray-500 dark:text-gray-400'),
        child,
      ],
    );
  }
}
