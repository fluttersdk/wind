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
  List<String> _tags = [];
  List<SelectOption<String>> _tagOptions = [
    const SelectOption(value: 'flutter', label: 'Flutter'),
    const SelectOption(value: 'dart', label: 'Dart'),
    const SelectOption(value: 'react', label: 'React'),
  ];

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

  Future<List<SelectOption<String>>> _fetchUsers(String query, int page) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final start = (page - 1) * 10;
    final allUsers = List.generate(
      50,
      (i) => SelectOption(
        value: 'user_$i',
        label: 'User ${i + 1}',
        icon: const Icon(Icons.person, size: 16),
      ),
    );
    var filtered = query.isEmpty
        ? allUsers
        : allUsers
              .where((u) => u.label.toLowerCase().contains(query.toLowerCase()))
              .toList();
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
    if (moreUsers.length < 10) _hasMore = false;
    setState(() => _users = [..._users, ...moreUsers]);
    return moreUsers;
  }

  Future<SelectOption<String>> _onCreateTag(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newTag = SelectOption(
      value: query.toLowerCase().replaceAll(' ', '_'),
      label: query,
    );
    setState(() => _tagOptions = [..._tagOptions, newTag]);
    return newTag;
  }

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
              bg-gradient-to-r from-orange-500 to-red-500
            ''',
            children: const [
              WText(
                'Advanced Features',
                className: 'text-lg font-bold text-white',
              ),
              WText(
                'Tagging and pagination',
                className: 'text-sm text-orange-100',
              ),
            ],
          ),

          // Tagging
          _buildSection(
            title: 'Tagging (Create Options)',
            description: 'Type to create new tags',
            children: [
              WSelect<String>(
                isMulti: true,
                values: _tags,
                options: _tagOptions,
                searchable: true,
                searchPlaceholder: 'Search or create...',
                placeholder: 'Add tags...',
                onMultiChange: (values) => setState(() => _tags = values),
                onCreateOption: _onCreateTag,
                className: '''
                  w-80 p-2 min-h-10 rounded-lg
                  bg-white dark:bg-slate-800
                  border border-gray-300 dark:border-gray-600
                ''',
                menuClassName: '''
                  bg-white dark:bg-slate-800
                  border border-gray-200 dark:border-gray-600
                  rounded-lg shadow-lg max-h-64
                ''',
              ),
              if (_tags.isNotEmpty)
                WText(
                  'Tags: ${_tags.join(", ")}',
                  className: 'text-sm text-green-600 dark:text-green-400',
                ),
            ],
          ),

          // Pagination
          _buildSection(
            title: 'Infinite Scroll',
            description: 'Scroll to load more users',
            children: [
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
                className: '''
                  w-80 p-3 rounded-lg
                  bg-white dark:bg-slate-800
                  border border-gray-300 dark:border-gray-600
                ''',
                menuClassName: '''
                  bg-white dark:bg-slate-800
                  border border-gray-200 dark:border-gray-600
                  rounded-lg shadow-lg max-h-64
                ''',
              ),
            ],
          ),

          // Quick Reference
          WDiv(
            className: 'p-4 bg-gray-100 dark:bg-slate-800 rounded-lg',
            children: [
              const WText(
                'Advanced Props',
                className: 'font-semibold text-gray-800 dark:text-white mb-2',
              ),
              WDiv(
                className: 'flex flex-col gap-1',
                children: [
                  _referenceRow('onCreateOption:', 'Create new'),
                  _referenceRow('onLoadMore:', 'Pagination'),
                  _referenceRow('hasMore:', 'More available'),
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
