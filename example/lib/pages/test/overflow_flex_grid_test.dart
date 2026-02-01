import 'package:flutter/material.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// **Overflow, Flex & Grid Edge Cases Test Page**
///
/// This page tests critical edge cases that must match Tailwind CSS behavior:
/// 1. Overflow with flex containers
/// 2. Nested flex with overflow-hidden
/// 3. Grid with overflow content
/// 4. Flex shrink behavior
/// 5. Overflow-x and overflow-y independently
/// 6. Flex items with min-w-0 (text truncation)
class OverflowFlexGridTestPage extends StatelessWidget {
  const OverflowFlexGridTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overflow/Flex/Grid Tests'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('1. Flex Row with Overflow Hidden'),
            _testFlexRowOverflowHidden(),
            const SizedBox(height: 24),

            _buildSectionTitle('2. Flex Column with Overflow Scroll'),
            _testFlexColumnOverflowScroll(),
            const SizedBox(height: 24),

            _buildSectionTitle('3. Nested Flex with Overflow'),
            _testNestedFlexOverflow(),
            const SizedBox(height: 24),

            _buildSectionTitle('4. Flex Shrink Behavior (Text Truncation)'),
            _testFlexShrinkTruncation(),
            const SizedBox(height: 24),

            _buildSectionTitle('5. Grid with Overflow-X Scroll'),
            _testGridOverflowX(),
            const SizedBox(height: 24),

            _buildSectionTitle('6. Overflow-Y with Fixed Height'),
            _testOverflowYFixedHeight(),
            const SizedBox(height: 24),

            _buildSectionTitle('7. Flex Wrap with Gap'),
            _testFlexWrapGap(),
            const SizedBox(height: 24),

            _buildSectionTitle('8. Justify-Between in Fixed Width'),
            _testJustifyBetweenFixedWidth(),
            const SizedBox(height: 24),

            _buildSectionTitle('9. Items-Stretch in Flex Row'),
            _testItemsStretchFlexRow(),
            const SizedBox(height: 24),

            _buildSectionTitle('10. Complex Nested Layout'),
            _testComplexNestedLayout(),
            const SizedBox(height: 24),

            _buildSectionTitle('11. Overflow Hidden with Border Radius'),
            _testOverflowHiddenBorderRadius(),
            const SizedBox(height: 24),

            _buildSectionTitle('12. Flex-1 Children Equal Distribution'),
            _testFlex1EqualDistribution(),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
    );
  }

  /// Test 1: Flex row with overflow-hidden should clip overflowing content
  /// Tailwind: <div class="flex overflow-hidden w-64">
  ///   <div class="w-48 shrink-0">Fixed</div>
  ///   <div class="w-48 shrink-0">Overflow</div>
  /// </div>
  Widget _testFlexRowOverflowHidden() {
    return WDiv(
      className: 'flex overflow-hidden w-64 bg-gray-100 rounded-lg',
      children: [
        WDiv(
          className: 'w-48 h-12 bg-blue-500 flex items-center justify-center',
          child: const WText('Fixed', className: 'text-white'),
        ),
        WDiv(
          className: 'w-48 h-12 bg-red-500 flex items-center justify-center',
          child: const WText('Should Clip', className: 'text-white'),
        ),
      ],
    );
  }

  /// Test 2: Flex column with overflow-scroll and fixed height
  /// Tailwind: <div class="flex flex-col overflow-scroll h-32">
  Widget _testFlexColumnOverflowScroll() {
    return WDiv(
      className:
          'flex flex-col overflow-scroll h-32 w-64 bg-gray-100 rounded-lg',
      children: List.generate(
        8,
        (i) => WDiv(
          className: 'p-2 bg-green-${(i % 4 + 3) * 100}',
          child: WText('Item ${i + 1}', className: 'text-white'),
        ),
      ),
    );
  }

  /// Test 3: Nested flex containers with inner overflow
  /// Parent is flex-row, child is flex-col with overflow-y-scroll
  Widget _testNestedFlexOverflow() {
    return WDiv(
      className: 'flex gap-4 w-full',
      children: [
        // Left sidebar - fixed width
        WDiv(
          className:
              'w-24 h-40 bg-purple-500 rounded-lg flex items-center justify-center',
          child: const WText('Sidebar', className: 'text-white text-sm'),
        ),
        // Main content - flex-1 with overflow-y-scroll
        WDiv(
          className: 'flex-1 h-40 overflow-y-scroll bg-gray-100 rounded-lg',
          child: WDiv(
            className: 'flex flex-col gap-2 p-2',
            children: List.generate(
              10,
              (i) => WDiv(
                className: 'p-2 bg-blue-${(i % 4 + 3) * 100} rounded',
                child: WText('Content ${i + 1}', className: 'text-white'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Test 4: Flex items should shrink and text should truncate
  /// Tailwind: <div class="flex w-64"><div class="min-w-0 truncate">Long text...</div></div>
  Widget _testFlexShrinkTruncation() {
    return WDiv(
      className: 'flex w-64 bg-gray-100 rounded-lg p-2 gap-2',
      children: [
        WDiv(
          className:
              'w-16 h-8 bg-blue-500 rounded flex items-center justify-center',
          child: const WText('Icon', className: 'text-white text-xs'),
        ),
        // This should truncate, not overflow
        WDiv(
          className: 'flex-1 overflow-hidden',
          child: const WText(
            'This is a very long text that should be truncated when it overflows the container',
            className: 'text-sm truncate',
          ),
        ),
      ],
    );
  }

  /// Test 5: Grid with horizontal overflow scroll
  /// Tailwind: <div class="w-64"><div class="grid grid-cols-6 gap-4 overflow-x-scroll">
  Widget _testGridOverflowX() {
    return WDiv(
      className: 'w-64 bg-gray-100 rounded-lg',
      child: WDiv(
        className: 'grid grid-cols-6 gap-4 p-2 overflow-x-scroll',
        children: List.generate(
          6,
          (i) => WDiv(
            className:
                'w-24 h-16 bg-indigo-${(i % 4 + 3) * 100} rounded flex items-center justify-center',
            child: WText('${i + 1}', className: 'text-white font-bold'),
          ),
        ),
      ),
    );
  }

  /// Test 6: Overflow-Y only with fixed height container
  /// Content overflows horizontally should NOT scroll, vertically should
  Widget _testOverflowYFixedHeight() {
    return WDiv(
      className:
          'overflow-y-scroll overflow-x-hidden h-32 w-48 bg-gray-100 rounded-lg p-2',
      child: WDiv(
        className: 'flex flex-col gap-2',
        children: List.generate(
          8,
          (i) => WDiv(
            className:
                'w-64 h-8 bg-teal-${(i % 4 + 3) * 100} rounded flex items-center px-2',
            child: WText('Wide item ${i + 1}', className: 'text-white text-sm'),
          ),
        ),
      ),
    );
  }

  /// Test 7: Flex wrap with gap should work like Tailwind
  /// Tailwind: <div class="flex flex-wrap gap-2">
  Widget _testFlexWrapGap() {
    return WDiv(
      className: 'wrap gap-2 w-64 bg-gray-100 rounded-lg p-2',
      children: List.generate(
        8,
        (i) => WDiv(
          className:
              'w-14 h-10 bg-pink-${(i % 4 + 3) * 100} rounded flex items-center justify-center',
          child: WText('${i + 1}', className: 'text-white font-bold'),
        ),
      ),
    );
  }

  /// Test 8: Justify-between with fixed width container
  /// Items should spread evenly with space between
  Widget _testJustifyBetweenFixedWidth() {
    return WDiv(
      className: 'flex justify-between w-64 bg-gray-100 rounded-lg p-2',
      children: [
        WDiv(
          className:
              'w-12 h-12 bg-orange-500 rounded flex items-center justify-center',
          child: const WText('1', className: 'text-white font-bold'),
        ),
        WDiv(
          className:
              'w-12 h-12 bg-orange-600 rounded flex items-center justify-center',
          child: const WText('2', className: 'text-white font-bold'),
        ),
        WDiv(
          className:
              'w-12 h-12 bg-orange-700 rounded flex items-center justify-center',
          child: const WText('3', className: 'text-white font-bold'),
        ),
      ],
    );
  }

  /// Test 9: Items-stretch should make items fill cross-axis
  /// Tailwind: <div class="flex items-stretch h-24">
  Widget _testItemsStretchFlexRow() {
    return WDiv(
      className:
          'flex items-stretch h-24 gap-2 w-64 bg-gray-100 rounded-lg p-2',
      children: [
        WDiv(
          className:
              'flex-1 bg-cyan-500 rounded flex items-center justify-center',
          child: const WText('A', className: 'text-white font-bold'),
        ),
        WDiv(
          className:
              'flex-1 bg-cyan-600 rounded flex items-center justify-center',
          child: const WText('B', className: 'text-white font-bold'),
        ),
        WDiv(
          className:
              'flex-1 bg-cyan-700 rounded flex items-center justify-center',
          child: const WText('C', className: 'text-white font-bold'),
        ),
      ],
    );
  }

  /// Test 10: Complex nested layout mimicking a real UI
  /// Card with header, scrollable content, and footer
  Widget _testComplexNestedLayout() {
    return WDiv(
      className:
          'w-72 h-64 bg-white rounded-xl shadow-lg overflow-hidden flex flex-col',
      children: [
        // Header - fixed
        WDiv(
          className: 'p-3 bg-indigo-600 flex items-center justify-between',
          children: [
            const WText('Card Header', className: 'text-white font-bold'),
            WDiv(
              className: 'w-6 h-6 bg-white/20 rounded-full',
              child: const SizedBox(),
            ),
          ],
        ),
        // Content - scrollable (should take remaining space)
        WDiv(
          className: 'flex-1 overflow-y-scroll p-3',
          child: WDiv(
            className: 'flex flex-col gap-2',
            children: List.generate(
              10,
              (i) => WDiv(
                className: 'p-2 bg-gray-100 rounded',
                child: WText('List item ${i + 1}', className: 'text-gray-700'),
              ),
            ),
          ),
        ),
        // Footer - fixed
        WDiv(
          className:
              'p-3 bg-gray-50 border-t border-gray-200 flex justify-end gap-2',
          children: [
            WDiv(
              className: 'px-3 py-1 bg-gray-200 rounded text-sm',
              child: const WText('Cancel', className: 'text-gray-700'),
            ),
            WDiv(
              className: 'px-3 py-1 bg-indigo-600 rounded text-sm',
              child: const WText('Save', className: 'text-white'),
            ),
          ],
        ),
      ],
    );
  }

  /// Test 11: Overflow hidden should respect border radius
  /// Content should be clipped to rounded corners
  Widget _testOverflowHiddenBorderRadius() {
    return WDiv(
      className: 'w-48 h-32 rounded-2xl overflow-hidden bg-gray-100',
      child: WDiv(
        className: 'w-full h-full',
        children: [
          // This image/color block should be clipped to parent's border radius
          WDiv(
            className:
                'w-full h-full bg-gradient-to-br from-purple-500 to-pink-500',
            child: WDiv(
              className: 'flex items-center justify-center h-full',
              child: const WText(
                'Clipped Corners',
                className: 'text-white font-bold',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Test 12: Multiple flex-1 children should distribute space equally
  /// Tailwind: <div class="flex"><div class="flex-1">A</div><div class="flex-1">B</div></div>
  Widget _testFlex1EqualDistribution() {
    return WDiv(
      className: 'flex w-64 h-16 bg-gray-100 rounded-lg gap-2 p-2',
      children: [
        WDiv(
          className:
              'flex-1 bg-emerald-500 rounded flex items-center justify-center',
          child: const WText('Flex-1', className: 'text-white font-bold'),
        ),
        WDiv(
          className:
              'flex-1 bg-emerald-600 rounded flex items-center justify-center',
          child: const WText('Flex-1', className: 'text-white font-bold'),
        ),
        WDiv(
          className:
              'flex-1 bg-emerald-700 rounded flex items-center justify-center',
          child: const WText('Flex-1', className: 'text-white font-bold'),
        ),
      ],
    );
  }
}
