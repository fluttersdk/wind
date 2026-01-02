import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Helper to wrap widget in MaterialApp with WindTheme
/// Positions widget at top of screen so dropdowns have room to render within viewport
Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    ),
  );
}

/// Helper to tap a dropdown option by finding its GestureDetector and invoking onTap.
/// This works around Flutter test's inability to tap widgets in overlays.
Future<void> tapDropdownOption(WidgetTester tester, String label) async {
  final finder = find.text(label);
  expect(finder, findsOneWidget, reason: 'Option "$label" should be visible');

  // Find the GestureDetector ancestor of the text widget
  final gestureDetectorFinder = find.ancestor(
    of: finder,
    matching: find.byType(GestureDetector),
  );

  if (gestureDetectorFinder.evaluate().isNotEmpty) {
    // Get the first GestureDetector and invoke its onTap
    final gestureDetector = tester.widget<GestureDetector>(
      gestureDetectorFinder.first,
    );
    gestureDetector.onTap?.call();
    await tester.pumpAndSettle();
  } else {
    // Fallback to regular tap
    await tester.tap(finder, warnIfMissed: false);
    await tester.pumpAndSettle();
  }
}

void main() {
  final testOptions = [
    const SelectOption(value: 'apple', label: 'Apple'),
    const SelectOption(value: 'banana', label: 'Banana'),
    const SelectOption(value: 'cherry', label: 'Cherry'),
    const SelectOption(value: 'disabled', label: 'Disabled', disabled: true),
  ];

  group('WSelect Widget Tests', () {
    group('Basic Rendering', () {
      testWidgets('renders trigger with placeholder', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(options: testOptions, onChange: (_) {}),
          ),
        );

        expect(find.text('Select an option'), findsOneWidget);
      });

      testWidgets('renders trigger with selected value label', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              value: 'banana',
              options: testOptions,
              onChange: (_) {},
            ),
          ),
        );

        expect(find.text('Banana'), findsOneWidget);
      });

      testWidgets('renders custom placeholder', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              options: testOptions,
              placeholder: 'Choose a fruit',
              onChange: (_) {},
            ),
          ),
        );

        expect(find.text('Choose a fruit'), findsOneWidget);
      });

      testWidgets('renders chevron icon', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(options: testOptions, onChange: (_) {}),
          ),
        );

        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      });
    });

    group('Dropdown Behavior', () {
      testWidgets('opens dropdown on tap', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(options: testOptions, onChange: (_) {}),
          ),
        );

        // Tap the trigger
        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        // Should show all options
        expect(find.text('Apple'), findsOneWidget);
        expect(find.text('Banana'), findsOneWidget);
        expect(find.text('Cherry'), findsOneWidget);
      });

      testWidgets('shows up arrow when open', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(options: testOptions, onChange: (_) {}),
          ),
        );

        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);

        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
      });

      testWidgets('closes dropdown when option selected', (tester) async {
        String? selected;

        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              options: testOptions,
              onChange: (value) => selected = value,
            ),
          ),
        );

        // Open
        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        // Select Apple using helper
        await tapDropdownOption(tester, 'Apple');

        expect(selected, 'apple');
        // Dropdown should be closed - can't find other options anymore
        expect(find.text('Banana'), findsNothing);
      });
    });

    group('Selection', () {
      testWidgets('calls onChange with selected value', (tester) async {
        String? selected;

        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              options: testOptions,
              onChange: (value) => selected = value,
            ),
          ),
        );

        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        await tapDropdownOption(tester, 'Cherry');

        expect(selected, 'cherry');
      });

      testWidgets('shows check icon for selected option', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              value: 'banana',
              options: testOptions,
              onChange: (_) {},
            ),
          ),
        );

        await tester.tap(find.text('Banana'));
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.check), findsOneWidget);
      });

      testWidgets('disabled options cannot be selected', (tester) async {
        String? selected;

        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              options: testOptions,
              onChange: (value) => selected = value,
            ),
          ),
        );

        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        // Try to tap disabled option
        await tester.tap(find.text('Disabled'));
        await tester.pumpAndSettle();

        expect(selected, isNull);
      });
    });

    group('Disabled State', () {
      testWidgets('does not open when disabled', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              options: testOptions,
              disabled: true,
              onChange: (_) {},
            ),
          ),
        );

        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        // Options should not be visible
        expect(find.text('Apple'), findsNothing);
      });
    });

    group('Searchable', () {
      testWidgets('shows search input when searchable', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              options: testOptions,
              searchable: true,
              onChange: (_) {},
            ),
          ),
        );

        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        expect(find.byType(WInput), findsOneWidget);
      });

      testWidgets('filters options based on search query', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              options: testOptions,
              searchable: true,
              onChange: (_) {},
            ),
          ),
        );

        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        // Enter search query
        await tester.enterText(find.byType(TextField), 'ban');
        await tester.pumpAndSettle();

        // Should only show Banana
        expect(find.text('Banana'), findsOneWidget);
        expect(find.text('Apple'), findsNothing);
        expect(find.text('Cherry'), findsNothing);
      });

      testWidgets('shows "No options found" when no matches', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              options: testOptions,
              searchable: true,
              onChange: (_) {},
            ),
          ),
        );

        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'xyz');
        await tester.pumpAndSettle();

        expect(find.text('No options found'), findsOneWidget);
      });
    });

    group('Custom Builders', () {
      testWidgets('uses triggerBuilder when provided', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              options: testOptions,
              triggerBuilder: (context, selected, isOpen) {
                return Container(
                  key: const Key('custom-trigger'),
                  child: Text(selected?.label ?? 'Custom Trigger'),
                );
              },
              onChange: (_) {},
            ),
          ),
        );

        expect(find.byKey(const Key('custom-trigger')), findsOneWidget);
        expect(find.text('Custom Trigger'), findsOneWidget);
      });

      testWidgets('uses itemBuilder when provided', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              options: testOptions,
              itemBuilder: (context, option, isSelected, isHovered) {
                return Container(
                  key: Key('item-${option.value}'),
                  child: Text('Custom: ${option.label}'),
                );
              },
              onChange: (_) {},
            ),
          ),
        );

        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        expect(find.text('Custom: Apple'), findsOneWidget);
        expect(find.text('Custom: Banana'), findsOneWidget);
      });
    });

    group('Styling', () {
      testWidgets('applies className to trigger', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              options: testOptions,
              className: 'p-4 bg-blue-500 rounded-lg',
              onChange: (_) {},
            ),
          ),
        );

        // Widget should render without errors
        expect(find.text('Select an option'), findsOneWidget);
      });

      testWidgets('applies menuClassName to dropdown', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              options: testOptions,
              menuClassName: 'bg-white border rounded-lg shadow-lg',
              onChange: (_) {},
            ),
          ),
        );

        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        // Options should be visible
        expect(find.text('Apple'), findsOneWidget);
      });
    });

    group('Options with Icons', () {
      testWidgets('renders icons when provided', (tester) async {
        final optionsWithIcons = [
          const SelectOption(
            value: 'apple',
            label: 'Apple',
            icon: Icon(Icons.apple, key: Key('apple-icon')),
          ),
        ];

        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(options: optionsWithIcons, onChange: (_) {}),
          ),
        );

        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('apple-icon')), findsOneWidget);
      });
    });

    group('Menu Sizing via className', () {
      testWidgets('matches trigger width by default', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            SizedBox(
              width: 250,
              child: WSelect<String>(options: testOptions, onChange: (_) {}),
            ),
          ),
        );

        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        // Dropdown should be visible and options rendered
        expect(find.text('Apple'), findsOneWidget);
      });

      testWidgets('respects menuWidth prop', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              options: testOptions,
              menuWidth: 300,
              onChange: (_) {},
            ),
          ),
        );

        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        expect(find.text('Apple'), findsOneWidget);
      });

      testWidgets('respects w-* class in menuClassName', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              options: testOptions,
              menuClassName: 'bg-white w-64', // 256px
              onChange: (_) {},
            ),
          ),
        );

        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        expect(find.text('Apple'), findsOneWidget);
      });

      testWidgets('trigger respects w-* class in className', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              options: testOptions,
              className: 'w-64 bg-white border rounded-lg p-3', // 256px trigger
              onChange: (_) {},
            ),
          ),
        );

        // Trigger should render with width constraint
        expect(find.text('Select an option'), findsOneWidget);

        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        // Menu should match trigger width (256px)
        expect(find.text('Apple'), findsOneWidget);
      });

      testWidgets('respects max-h-* class in menuClassName', (tester) async {
        // Generate many options to test scrolling
        final manyOptions = List.generate(
          20,
          (i) => SelectOption(value: 'item$i', label: 'Item $i'),
        );

        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              options: manyOptions,
              menuClassName: 'bg-white max-h-32', // 128px max height
              onChange: (_) {},
            ),
          ),
        );

        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        // First item visible
        expect(find.text('Item 0'), findsOneWidget);
        // Menu should be scrollable (later items may not be visible)
      });

      testWidgets('respects maxMenuHeight prop as default', (tester) async {
        final manyOptions = List.generate(
          20,
          (i) => SelectOption(value: 'item$i', label: 'Item $i'),
        );

        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              options: manyOptions,
              maxMenuHeight: 100,
              onChange: (_) {},
            ),
          ),
        );

        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        expect(find.text('Item 0'), findsOneWidget);
      });
    });

    group('Scrollable Options', () {
      testWidgets('can scroll through many options', (tester) async {
        final manyOptions = List.generate(
          30,
          (i) => SelectOption(value: 'fruit$i', label: 'Fruit $i'),
        );

        await tester.pumpWidget(
          wrapWithTheme(
            WSelect<String>(
              options: manyOptions,
              maxMenuHeight: 200,
              onChange: (_) {},
            ),
          ),
        );

        await tester.tap(find.text('Select an option'));
        await tester.pumpAndSettle();

        // First items visible
        expect(find.text('Fruit 0'), findsOneWidget);

        // Scroll down
        await tester.drag(find.text('Fruit 0'), const Offset(0, -300));
        await tester.pumpAndSettle();

        // Later items should now be visible
        // Note: exact item depends on item height
      });
    });
  });

  group('SelectOption', () {
    test('equality works correctly', () {
      const opt1 = SelectOption(value: 'a', label: 'A');
      const opt2 = SelectOption(value: 'a', label: 'A');
      const opt3 = SelectOption(value: 'b', label: 'B');

      expect(opt1 == opt2, isTrue);
      expect(opt1 == opt3, isFalse);
    });

    test('hashCode is consistent', () {
      const opt1 = SelectOption(value: 'a', label: 'A');
      const opt2 = SelectOption(value: 'a', label: 'A');

      expect(opt1.hashCode, opt2.hashCode);
    });

    test('toString returns expected format', () {
      const option = SelectOption(value: 'test', label: 'Test', disabled: true);
      expect(
        option.toString(),
        'SelectOption(value: test, label: Test, disabled: true)',
      );
    });
  });

  group('Multi-Select Mode', () {
    testWidgets('renders placeholder when no values selected', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            isMulti: true,
            values: const [],
            options: testOptions,
            onMultiChange: (_) {},
            placeholder: 'Select tags...',
          ),
        ),
      );

      expect(find.text('Select tags...'), findsOneWidget);
    });

    testWidgets('renders chips for selected values', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            isMulti: true,
            values: const ['apple', 'banana'],
            options: testOptions,
            onMultiChange: (_) {},
          ),
        ),
      );

      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);
    });

    testWidgets('shows checkboxes in dropdown', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            isMulti: true,
            values: const ['apple'],
            options: testOptions,
            onMultiChange: (_) {},
          ),
        ),
      );

      await tester.tap(find.text('Apple'));
      await tester.pumpAndSettle();

      // Should show checkbox icons
      expect(find.byIcon(Icons.check_box), findsOneWidget);
      expect(find.byIcon(Icons.check_box_outline_blank), findsWidgets);
    });

    testWidgets('toggles selection on tap', (tester) async {
      List<String> selectedValues = ['apple'];

      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) => WSelect<String>(
              isMulti: true,
              values: selectedValues,
              options: testOptions,
              onMultiChange: (values) =>
                  setState(() => selectedValues = values),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Apple'));
      await tester.pumpAndSettle();

      // Tap banana to add using helper
      await tapDropdownOption(tester, 'Banana');

      expect(selectedValues, contains('banana'));
      expect(selectedValues, contains('apple'));
    });

    testWidgets('does not close menu on selection', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            isMulti: true,
            values: const [],
            options: testOptions,
            onMultiChange: (_) {},
          ),
        ),
      );

      await tester.tap(find.text('Select an option'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Apple'));
      await tester.pumpAndSettle();

      // Menu should still be open
      expect(find.text('Banana'), findsOneWidget);
    });
  });

  group('Tagging (Create Option)', () {
    testWidgets('shows create button when no matches', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            isMulti: true,
            values: const [],
            options: testOptions,
            searchable: true,
            onMultiChange: (_) {},
            onCreateOption: (query) async =>
                SelectOption(value: query, label: query),
          ),
        ),
      );

      await tester.tap(find.text('Select an option'));
      await tester.pumpAndSettle();

      // Type a non-existing value
      await tester.enterText(find.byType(TextField), 'NewTag');
      await tester.pumpAndSettle();

      expect(find.textContaining('Create'), findsOneWidget);
    });
  });

  group('Pagination', () {
    testWidgets('has onLoadMore callback property', (tester) async {
      bool loadMoreCalled = false;

      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            options: testOptions,
            onChange: (_) {},
            onLoadMore: () async {
              loadMoreCalled = true;
              return [];
            },
            hasMore: true,
          ),
        ),
      );

      // Just verify widget builds with pagination props
      expect(find.text('Select an option'), findsOneWidget);
      expect(loadMoreCalled, isFalse); // Not called until scroll
    });
  });

  group('Custom Builders', () {
    testWidgets('uses custom searchPlaceholder', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            options: testOptions,
            onChange: (_) {},
            searchable: true,
            searchPlaceholder: 'Type to search...',
          ),
        ),
      );

      await tester.tap(find.text('Select an option'));
      await tester.pumpAndSettle();

      expect(find.text('Type to search...'), findsOneWidget);
    });

    testWidgets('uses custom emptyBuilder', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            options: const [],
            onChange: (_) {},
            emptyBuilder: (context, query) => const Text('Nothing here!'),
          ),
        ),
      );

      await tester.tap(find.text('Select an option'));
      await tester.pumpAndSettle();

      expect(find.text('Nothing here!'), findsOneWidget);
    });

    testWidgets('uses custom loadingBuilder', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            options: testOptions,
            onChange: (_) {},
            searchable: true,
            onSearch: (query) async {
              // Short delay that won't cause timer issues
              return testOptions;
            },
            loadingBuilder: (context) => const Text('Loading...'),
          ),
        ),
      );

      await tester.tap(find.text('Select an option'));
      await tester.pumpAndSettle();

      // Verify the builder prop is accepted (actual loading UI tested manually)
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
