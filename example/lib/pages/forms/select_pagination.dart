import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Pagination and tagging WSelect example.
class SelectPaginationExamplePage extends StatefulWidget {
  const SelectPaginationExamplePage({super.key});

  @override
  State<SelectPaginationExamplePage> createState() =>
      _SelectPaginationExamplePageState();
}

class _SelectPaginationExamplePageState
    extends State<SelectPaginationExamplePage> {
  // Tagging state
  List<String> _tags = [];
  List<SelectOption<String>> _tagOptions = [
    const SelectOption(value: 'flutter', label: 'Flutter'),
    const SelectOption(value: 'dart', label: 'Dart'),
    const SelectOption(value: 'react', label: 'React'),
  ];

  // Pagination state
  String? _selectedUser;
  List<SelectOption<String>> _users = [];
  int _page = 1;
  bool _hasMore = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadInitialUsers();
  }

  Future<void> _loadInitialUsers() async {
    final users = await _fetchUsers('', 1);
    setState(() {
      _users = users;
      _page = 1;
      _hasMore = users.length >= 10;
    });
  }

  /// Simulated API call with pagination
  Future<List<SelectOption<String>>> _fetchUsers(String query, int page) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate fake users
    final start = (page - 1) * 10;
    final allUsers = List.generate(
      50,
      (i) => SelectOption(
        value: 'user_$i',
        label: 'User ${i + 1}',
        icon: const Icon(Icons.person, size: 16),
      ),
    );

    // Filter by query
    var filtered = query.isEmpty
        ? allUsers
        : allUsers
              .where((u) => u.label.toLowerCase().contains(query.toLowerCase()))
              .toList();

    // Paginate
    final end = (start + 10).clamp(0, filtered.length);
    if (start >= filtered.length) return [];
    return filtered.sublist(start, end);
  }

  Future<List<SelectOption<String>>> _onSearch(String query) async {
    _searchQuery = query;
    _page = 1;
    final results = await _fetchUsers(query, 1);
    _hasMore = results.length >= 10;
    return results;
  }

  Future<List<SelectOption<String>>> _onLoadMore() async {
    _page++;
    final moreUsers = await _fetchUsers(_searchQuery, _page);
    if (moreUsers.length < 10) {
      _hasMore = false;
    }
    // Update local state for display
    setState(() {
      _users = [..._users, ...moreUsers];
    });
    return moreUsers;
  }

  /// Create a new tag
  Future<SelectOption<String>> _onCreateTag(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newTag = SelectOption(
      value: query.toLowerCase().replaceAll(' ', '_'),
      label: query,
    );
    setState(() {
      _tagOptions = [..._tagOptions, newTag];
    });
    return newTag;
  }

  @override
  Widget build(BuildContext context) {
    return WDiv(
      className: 'p-6 bg-gray-100 h-full',
      children: [
        // Tagging example
        const WText(
          'Tagging (Create New Options)',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        const WText(
          'Type to search, or create new tags that don\'t exist.',
          className: 'text-xs text-gray-500 mb-2',
        ),
        WSelect<String>(
          isMulti: true,
          values: _tags,
          options: _tagOptions,
          searchable: true,
          searchPlaceholder: 'Search or create tag...',
          placeholder: 'Add tags...',
          onMultiChange: (values) => setState(() => _tags = values),
          onCreateOption: _onCreateTag,
          className:
              'w-80 bg-white border border-gray-300 rounded-lg p-2 min-h-10',
          menuClassName:
              'bg-white border border-gray-200 rounded-lg shadow-lg max-h-64',
        ),

        const WDiv(className: 'h-8'),

        // Pagination example
        const WText(
          'Infinite Scroll Pagination',
          className: 'font-bold text-sm text-gray-700 mb-2',
        ),
        const WText(
          'Scroll down in the dropdown to load more users.',
          className: 'text-xs text-gray-500 mb-2',
        ),
        WSelect<String>(
          value: _selectedUser,
          options: _users,
          searchable: true,
          searchPlaceholder: 'Search users...',
          placeholder: 'Select a user...',
          onChange: (value) => setState(() => _selectedUser = value),
          onSearch: _onSearch,
          onLoadMore: _onLoadMore,
          hasMore: _hasMore,
          className: 'w-80 bg-white border border-gray-300 rounded-lg p-3',
          menuClassName:
              'bg-white border border-gray-200 rounded-lg shadow-lg max-h-64',
        ),

        const WDiv(className: 'h-6'),

        // Display results
        if (_tags.isNotEmpty || _selectedUser != null)
          WDiv(
            className: 'p-4 bg-green-50 rounded-lg',
            children: [
              if (_tags.isNotEmpty)
                WText(
                  'Created tags: ${_tags.join(", ")}',
                  className: 'text-green-700',
                ),
              if (_selectedUser != null)
                WText(
                  'Selected user: $_selectedUser',
                  className: 'text-green-700',
                ),
            ],
          ),
      ],
    );
  }
}
