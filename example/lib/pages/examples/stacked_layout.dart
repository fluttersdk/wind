import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Stacked Layout with Bottom Border Example
/// A responsive navigation layout with bottom border indicators
class StackedLayoutExamplePage extends StatefulWidget {
  const StackedLayoutExamplePage({super.key});

  @override
  State<StackedLayoutExamplePage> createState() =>
      _StackedLayoutExamplePageState();
}

class _StackedLayoutExamplePageState extends State<StackedLayoutExamplePage> {
  bool _isMobileMenuOpen = false;
  bool _isProfileMenuOpen = false;
  int _currentIndex = 0;

  final List<String> _navItems = ['Dashboard', 'Team', 'Projects', 'Calendar'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111827), // gray-900
      body: SafeArea(
        child: WDiv(
          className: "flex flex-col h-full bg-gray-900",
          children: [
            // Navigation Bar
            _buildNavBar(),
            // Mobile Menu (absolute overlay when open)
            if (_isMobileMenuOpen) _buildMobileMenu(),
            // Main Content (only show when mobile menu is closed)
            if (!_isMobileMenuOpen) Expanded(child: _buildMainContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return WDiv(
      className: "border-b border-white/10 bg-gray-900",
      child: WDiv(
        className: "mx-auto max-w-7xl px-4 sm:px-6 lg:px-8",
        child: WDiv(
          className: "flex h-16 items-center justify-between",
          children: [
            // Left Side - Logo & Navigation
            WDiv(
              className: "flex items-center gap-x-6",
              children: [
                // Logo
                WIcon(Icons.wind_power, className: "text-indigo-500 text-3xl"),
                // Desktop Navigation
                WDiv(
                  className: "hidden sm:flex gap-x-8",
                  children: _navItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isActive = index == _currentIndex;
                    return WAnchor(
                      onTap: () => setState(() => _currentIndex = index),
                      child: WDiv(
                        className: '''
                          flex items-center border-b-2 px-1 pt-1 text-sm font-medium h-16
                          ${isActive ? 'border-indigo-500 text-white' : 'border-transparent text-gray-400 hover:border-white/20 hover:text-gray-200'}
                          duration-200
                        ''',
                        child: WText(item),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            // Right Side - Notification & Profile (Desktop)
            WDiv(
              className: "hidden sm:flex items-center gap-x-4",
              children: [
                // Notification Button
                WAnchor(
                  onTap: () {},
                  child: WDiv(
                    className:
                        "rounded-full p-1 text-gray-400 hover:text-white duration-200",
                    child: WIcon(
                      Icons.notifications_outlined,
                      className: "text-2xl",
                    ),
                  ),
                ),
                // Profile Dropdown
                WAnchor(
                  onTap: () =>
                      setState(() => _isProfileMenuOpen = !_isProfileMenuOpen),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      WImage(
                        src:
                            "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80",
                        className: "w-8 h-8 rounded-full",
                      ),
                      if (_isProfileMenuOpen)
                        Positioned(
                          top: 40,
                          right: 0,
                          child: _buildProfileDropdown(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            // Mobile Menu Button
            WDiv(
              className: "flex items-center sm:hidden",
              child: WAnchor(
                onTap: () =>
                    setState(() => _isMobileMenuOpen = !_isMobileMenuOpen),
                child: WDiv(
                  className:
                      "rounded-md p-2 text-gray-400 hover:bg-white/5 hover:text-white duration-200",
                  child: WIcon(
                    _isMobileMenuOpen ? Icons.close : Icons.menu,
                    className: "text-2xl",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDropdown() {
    return WDiv(
      className: "w-48 rounded-md bg-gray-800 py-1 shadow-lg",
      children: [
        _buildDropdownItem("Your profile"),
        _buildDropdownItem("Settings"),
        _buildDropdownItem("Sign out"),
      ],
    );
  }

  Widget _buildDropdownItem(String label) {
    return WAnchor(
      onTap: () => setState(() => _isProfileMenuOpen = false),
      child: WDiv(
        className:
            "block px-4 py-2 text-sm text-gray-300 hover:bg-white/5 duration-150",
        child: WText(label),
      ),
    );
  }

  Widget _buildMobileMenu() {
    return Expanded(
      child: SingleChildScrollView(
        child: WDiv(
          className: "sm:hidden bg-gray-900",
          children: [
            // Mobile Navigation Links
            WDiv(
              className: "pt-2 pb-3",
              children: _navItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isActive = index == _currentIndex;
                return WAnchor(
                  onTap: () => setState(() {
                    _currentIndex = index;
                    _isMobileMenuOpen = false;
                  }),
                  child: WDiv(
                    className: '''
                      block border-l-4 py-2 pr-4 pl-3 text-base font-medium
                      ${isActive ? 'border-indigo-500 bg-indigo-600/10 text-indigo-300' : 'border-transparent text-gray-400 hover:border-gray-500 hover:bg-white/5 hover:text-gray-200'}
                      duration-200
                    ''',
                    child: WText(item),
                  ),
                );
              }).toList(),
            ),
            // User Info Section
            WDiv(
              className: "border-t border-gray-700 pt-4 pb-3",
              children: [
                // User Header
                WDiv(
                  className: "flex items-center px-4",
                  children: [
                    WImage(
                      src:
                          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80",
                      className: "w-10 h-10 rounded-full shrink-0",
                    ),
                    WDiv(
                      className: "ml-3 flex-1 min-w-0",
                      children: [
                        WText(
                          "Tom Cook",
                          className: "text-base font-medium text-white",
                        ),
                        WText(
                          "tom@example.com",
                          className: "text-sm font-medium text-gray-400",
                        ),
                      ],
                    ),
                    WAnchor(
                      onTap: () {},
                      child: WDiv(
                        className:
                            "rounded-full p-1 text-gray-400 hover:text-white duration-200 shrink-0",
                        child: WIcon(
                          Icons.notifications_outlined,
                          className: "text-2xl",
                        ),
                      ),
                    ),
                  ],
                ),
                // User Menu Links
                WDiv(
                  className: "mt-3",
                  children: [
                    _buildMobileMenuItem("Your profile"),
                    _buildMobileMenuItem("Settings"),
                    _buildMobileMenuItem("Sign out"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileMenuItem(String label) {
    return WAnchor(
      onTap: () => setState(() => _isMobileMenuOpen = false),
      child: WDiv(
        className:
            "block px-4 py-2 text-base font-medium text-gray-400 hover:bg-white/5 hover:text-gray-200 duration-150",
        child: WText(label),
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: WDiv(
        className: "py-10 bg-gray-900",
        children: [
          // Header
          WDiv(
            className: "mx-auto max-w-7xl px-4 sm:px-6 lg:px-8",
            child: WText(
              _navItems[_currentIndex],
              className: "text-3xl font-bold text-white",
            ),
          ),
          // Main Content Area
          WDiv(
            className: "mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8",
            child: WDiv(
              className:
                  "rounded-lg border-2 border-dashed border-gray-700 h-96",
              child: WDiv(
                className: "flex items-center justify-center h-full",
                child: WText(
                  "Your content goes here",
                  className: "text-gray-400",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
