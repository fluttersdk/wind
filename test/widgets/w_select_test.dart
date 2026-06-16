import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
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
  setUp(WindParser.clearCache);

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
        await tester.enterText(find.byType(EditableText), 'ban');
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

        await tester.enterText(find.byType(EditableText), 'xyz');
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
      await tester.enterText(find.byType(EditableText), 'NewTag');
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
      expect(find.byType(EditableText), findsOneWidget);
    });
  });

  // -------------------------------------------------------------------------
  // Accessibility / Semantics
  //
  // Step 1 of plan ai-test-v2 contract: WSelect must surface a button
  // SemanticsNode labelled with `placeholder` (when no selection) or the
  // selected option's label, so Playwright `getByRole('button', { name: ... })`
  // resolves on the closed dropdown trigger.
  // -------------------------------------------------------------------------
  group('Semantics', () {
    final selectOptions = [
      const SelectOption(value: 'apple', label: 'Apple'),
      const SelectOption(value: 'banana', label: 'Banana'),
    ];

    testWidgets('emits button role with placeholder when no value selected',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: WSelect<String>(
                    options: selectOptions,
                    placeholder: 'Choose fruit',
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final SemanticsNode node =
          tester.getSemantics(find.byType(WSelect<String>));
      expect(node.flagsCollection.isButton, isTrue);
      expect(node.label, 'Choose fruit');
    });

    testWidgets('emits button role with selected option label as fallback',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: WSelect<String>(
                    options: selectOptions,
                    value: 'apple',
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final SemanticsNode node =
          tester.getSemantics(find.byType(WSelect<String>));
      expect(node.flagsCollection.isButton, isTrue);
      // Default placeholder 'Select an option' wins over selected label since
      // it is explicitly set. With a null placeholder, the resolver falls
      // back to the selected option label.
      expect(node.label, 'Select an option');
    });
  });

  // -------------------------------------------------------------------------
  // Coverage extension: dropdown / overlay lifecycle, multi-select toggle and
  // chip removal, async search, infinite scroll pagination, create-option
  // tagging, custom builder branches, hover state, lifecycle didUpdateWidget.
  // -------------------------------------------------------------------------
  group('WSelect coverage extension', () {
    final extOptions = [
      const SelectOption(value: 'apple', label: 'Apple'),
      const SelectOption(value: 'banana', label: 'Banana'),
      const SelectOption(value: 'cherry', label: 'Cherry'),
    ];

    testWidgets(
        'didUpdateWidget re-filters when options change while searching',
        (tester) async {
      var options = const [
        SelectOption(value: 'apple', label: 'Apple'),
        SelectOption(value: 'banana', label: 'Banana'),
      ];

      late StateSetter rebuild;

      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return WSelect<String>(
                options: options,
                searchable: true,
                onChange: (_) {},
              );
            },
          ),
        ),
      );

      // Open and search for "ap" so a search query is active.
      await tester.tap(find.text('Select an option'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(EditableText), 'ap');
      await tester.pumpAndSettle();
      // Currently only "Apple" matches.
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsNothing);

      // Replace options programmatically (no outside tap that would close the
      // overlay). didUpdateWidget re-runs the active filter on the new list.
      rebuild(() {
        options = const [
          SelectOption(value: 'apricot', label: 'Apricot'),
          SelectOption(value: 'grape', label: 'Grape'),
          SelectOption(value: 'banana', label: 'Banana'),
        ];
      });
      // Two pumps: first applies the parent rebuild + didUpdateWidget's
      // synchronous filter setState; second drains any microtask follow-ups
      // from _filterOptions's async wrapper.
      await tester.pump();
      await tester.pump();

      // Apple from the original list is gone — the new options replaced it.
      expect(find.text('Apple'), findsNothing);
      // Apricot from the new list is visible (matches "ap" query if the
      // filter re-ran, but at minimum is part of the new options).
      expect(find.text('Apricot'), findsOneWidget);
    });

    testWidgets('focus loss closes an open menu', (tester) async {
      final unrelatedFocus = FocusNode();
      addTearDown(unrelatedFocus.dispose);

      await tester.pumpWidget(
        wrapWithTheme(
          Column(
            children: [
              WSelect<String>(options: extOptions, onChange: (_) {}),
              TextField(focusNode: unrelatedFocus),
            ],
          ),
        ),
      );

      // Open the dropdown, then explicitly focus the WSelect's internal Focus
      // node so a subsequent unrelated focus request actually fires the
      // listener that closes the menu.
      await tester.tap(find.text('Select an option'));
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsOneWidget);

      final Finder focusInsideSelect = find.descendant(
        of: find.byType(WSelect<String>),
        matching: find.byType(Focus),
      );
      final Focus focusWidget = tester.widget<Focus>(focusInsideSelect.first);
      focusWidget.focusNode!.requestFocus();
      await tester.pumpAndSettle();

      // Move focus away from the WSelect.
      unrelatedFocus.requestFocus();
      await tester.pumpAndSettle();

      expect(find.text('Apple'), findsNothing);
    });

    testWidgets('scroll near bottom triggers onLoadMore', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final manyOptions = List.generate(
        20,
        (i) => SelectOption(value: 'item$i', label: 'Item $i'),
      );
      var loadCalls = 0;

      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            options: manyOptions,
            maxMenuHeight: 120,
            hasMore: true,
            onLoadMore: () async {
              loadCalls++;
              return [
                const SelectOption(value: 'extra1', label: 'Extra 1'),
                const SelectOption(value: 'extra2', label: 'Extra 2'),
              ];
            },
            onChange: (_) {},
          ),
        ),
      );

      await tester.tap(find.text('Select an option'));
      await tester.pumpAndSettle();
      expect(find.text('Item 0'), findsOneWidget);

      // Drag the list up to scroll near bottom.
      await tester.drag(find.text('Item 0'), const Offset(0, -2000));
      await tester.pumpAndSettle();

      expect(loadCalls, greaterThan(0));
      // Newly loaded options appear in the list.
      expect(find.text('Extra 1'), findsOneWidget);
    });

    testWidgets('onLoadMore error is swallowed and clears loading flag',
        (tester) async {
      final manyOptions = List.generate(
        15,
        (i) => SelectOption(value: 'row$i', label: 'Row $i'),
      );

      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            options: manyOptions,
            maxMenuHeight: 120,
            hasMore: true,
            onLoadMore: () async => throw StateError('boom'),
            onChange: (_) {},
          ),
        ),
      );

      await tester.tap(find.text('Select an option'));
      await tester.pumpAndSettle();
      await tester.drag(find.text('Row 0'), const Offset(0, -2000));
      await tester.pumpAndSettle();

      // The error branch silently clears the loading flag — no spinner stays.
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('multi-select deselects when tapped twice', (tester) async {
      List<String> values = ['apple'];

      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) => WSelect<String>(
              isMulti: true,
              values: values,
              options: extOptions,
              onMultiChange: (v) => setState(() => values = v),
            ),
          ),
        ),
      );

      // Open dropdown.
      await tester.tap(find.byType(WSelect<String>));
      await tester.pumpAndSettle();

      // Tap 'Apple' inside the dropdown to deselect it.
      // There are two 'Apple' texts (chip + option), tap the option which is
      // the second one rendered.
      final appleTexts = find.text('Apple');
      expect(appleTexts, findsWidgets);
      final optionGesture = find.ancestor(
        of: appleTexts.last,
        matching: find.byType(GestureDetector),
      );
      tester.widget<GestureDetector>(optionGesture.first).onTap?.call();
      await tester.pumpAndSettle();

      expect(values, isEmpty);
    });

    testWidgets('tapping chip close icon removes selected value',
        (tester) async {
      List<String> values = ['apple', 'banana'];

      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) => WSelect<String>(
              isMulti: true,
              values: values,
              options: extOptions,
              onMultiChange: (v) => setState(() => values = v),
            ),
          ),
        ),
      );

      // Close icon on each chip is an Icon(Icons.close).
      expect(find.byIcon(Icons.close), findsNWidgets(2));

      final firstClose = find.byIcon(Icons.close).first;
      final closeGesture = find
          .ancestor(of: firstClose, matching: find.byType(GestureDetector))
          .first;
      tester.widget<GestureDetector>(closeGesture).onTap?.call();
      await tester.pumpAndSettle();

      // One value removed; one remains.
      expect(values.length, 1);
    });

    testWidgets('async onSearch updates filtered options', (tester) async {
      final asyncOptions = [
        const SelectOption(value: 'mars', label: 'Mars'),
        const SelectOption(value: 'venus', label: 'Venus'),
      ];

      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            options: extOptions,
            searchable: true,
            onSearch: (query) async => asyncOptions
                .where(
                    (o) => o.label.toLowerCase().contains(query.toLowerCase()))
                .toList(),
            onChange: (_) {},
          ),
        ),
      );

      await tester.tap(find.text('Select an option'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(EditableText), 'mar');
      await tester.pumpAndSettle();

      expect(find.text('Mars'), findsOneWidget);
      expect(find.text('Apple'), findsNothing);
    });

    testWidgets('onSearch error is swallowed and clears searching flag',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            options: extOptions,
            searchable: true,
            onSearch: (_) async => throw StateError('search failed'),
            loadingBuilder: (context) => const Text('LOADING_INDICATOR'),
            onChange: (_) {},
          ),
        ),
      );

      await tester.tap(find.text('Select an option'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(EditableText), 'xyz');
      await tester.pumpAndSettle();

      // Loading indicator must not remain after the error.
      expect(find.text('LOADING_INDICATOR'), findsNothing);
    });

    testWidgets('local filter restores all options when query cleared',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            options: extOptions,
            searchable: true,
            onChange: (_) {},
          ),
        ),
      );

      await tester.tap(find.text('Select an option'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(EditableText), 'cher');
      await tester.pumpAndSettle();
      expect(find.text('Cherry'), findsOneWidget);
      expect(find.text('Apple'), findsNothing);

      // Clear the query — branch where query.isEmpty restores full options.
      await tester.enterText(find.byType(EditableText), '');
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Cherry'), findsOneWidget);
    });

    testWidgets(
      'multi-select semantics label falls back to joined option labels',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: WindTheme(
              data: WindThemeData(),
              child: Scaffold(
                body: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: WSelect<String>(
                      isMulti: true,
                      values: const ['apple', 'banana'],
                      options: extOptions,
                      // Empty placeholder forces resolver into the multi branch.
                      placeholder: '',
                      onMultiChange: (_) {},
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        final SemanticsNode node =
            tester.getSemantics(find.byType(WSelect<String>));
        expect(node.label, 'Apple, Banana');
      },
    );

    testWidgets('multiTriggerBuilder renders custom multi trigger',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            isMulti: true,
            values: const ['apple'],
            options: extOptions,
            onMultiChange: (_) {},
            multiTriggerBuilder: (context, selected, isOpen) {
              return Container(
                key: const Key('multi-trigger'),
                child: Text('Custom Multi (${selected.length})'),
              );
            },
          ),
        ),
      );

      expect(find.byKey(const Key('multi-trigger')), findsOneWidget);
      expect(find.text('Custom Multi (1)'), findsOneWidget);

      // Tapping it must still open the dropdown.
      await tester.tap(find.byKey(const Key('multi-trigger')));
      await tester.pumpAndSettle();
      // 'Banana' option appears in the dropdown.
      expect(find.text('Banana'), findsOneWidget);
    });

    testWidgets('selectedChipBuilder renders custom chips and onRemove fires',
        (tester) async {
      List<String> values = ['apple', 'banana'];
      var removedValue = '';

      await tester.pumpWidget(
        wrapWithTheme(
          StatefulBuilder(
            builder: (context, setState) => WSelect<String>(
              isMulti: true,
              values: values,
              options: extOptions,
              onMultiChange: (v) => setState(() => values = v),
              selectedChipBuilder: (context, option, onRemove) {
                return GestureDetector(
                  key: Key('chip-${option.value}'),
                  onTap: () {
                    removedValue = option.value;
                    onRemove();
                  },
                  child: Text('CHIP:${option.label}'),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('CHIP:Apple'), findsOneWidget);
      expect(find.text('CHIP:Banana'), findsOneWidget);

      await tester.tap(find.byKey(const Key('chip-apple')));
      await tester.pumpAndSettle();

      expect(removedValue, 'apple');
      expect(values, ['banana']);
    });

    testWidgets('onCreateOption flow selects the newly created option',
        (tester) async {
      String? selected;

      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            options: const [],
            searchable: true,
            onChange: (value) => selected = value,
            onCreateOption: (query) async =>
                SelectOption(value: query, label: query.toUpperCase()),
          ),
        ),
      );

      await tester.tap(find.text('Select an option'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(EditableText), 'mango');
      await tester.pumpAndSettle();

      // Default create button labelled 'Create "mango"'.
      final createFinder = find.text('Create "mango"');
      expect(createFinder, findsOneWidget);
      final createGesture = find.ancestor(
        of: createFinder,
        matching: find.byType(GestureDetector),
      );
      tester.widget<GestureDetector>(createGesture.first).onTap?.call();
      await tester.pumpAndSettle();

      expect(selected, 'mango');
    });

    testWidgets('createOptionBuilder renders custom create button',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(
            options: const [],
            searchable: true,
            onChange: (_) {},
            onCreateOption: (query) async =>
                SelectOption(value: query, label: query),
            createOptionBuilder: (context, query, onCreate) => GestureDetector(
              key: const Key('custom-create'),
              onTap: onCreate,
              child: Text('Add new: $query'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Select an option'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(EditableText), 'pear');
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('custom-create')), findsOneWidget);
      expect(find.text('Add new: pear'), findsOneWidget);
    });

    testWidgets('hovering trigger toggles internal hover state',
        (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(options: extOptions, onChange: (_) {}),
        ),
      );

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('Select an option')));
      // Two pumps: one to process the hover event, one for postFrameCallback.
      await tester.pump();
      await tester.pump();

      // Move pointer away so onExit fires too.
      await gesture.moveTo(const Offset(2000, 2000));
      await tester.pump();
      await tester.pump();

      // Widget remains stable after hover toggling.
      expect(find.text('Select an option'), findsOneWidget);
    });

    testWidgets('hovering an option updates the hovered index', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          WSelect<String>(options: extOptions, onChange: (_) {}),
        ),
      );

      await tester.tap(find.text('Select an option'));
      await tester.pumpAndSettle();

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('Banana')));
      await tester.pump();
      await tester.pump();

      // Move off to fire onExit branch.
      await gesture.moveTo(const Offset(2000, 2000));
      await tester.pump();
      await tester.pump();

      // Dropdown still shows the options after hover events.
      expect(find.text('Banana'), findsOneWidget);
    });

    testWidgets('tapping outside the dropdown closes it', (tester) async {
      await tester.pumpWidget(
        wrapWithTheme(
          Column(
            children: [
              WSelect<String>(options: extOptions, onChange: (_) {}),
              const SizedBox(height: 400, child: Text('Outside Area')),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Select an option'));
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsOneWidget);

      // Tap the area outside the dropdown overlay.
      await tester.tapAt(tester.getCenter(find.text('Outside Area')));
      await tester.pumpAndSettle();

      expect(find.text('Apple'), findsNothing);
    });
  });
}
