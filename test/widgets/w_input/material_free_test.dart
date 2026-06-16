import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/wind_parser.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';
import 'package:fluttersdk_wind/src/widgets/w_input.dart';

/// Wraps [child] in the bare harness used throughout the Material-free tests:
/// [Directionality] > [WindTheme] > child (no MaterialApp, no Scaffold).
Widget _bareHarness(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: WindTheme(
      data: WindThemeData(),
      child: child,
    ),
  );
}

void main() {
  setUp(WindParser.clearCache);

  group('WInput Material-free rendering', () {
    // (a) Pumps under bare harness — no "No Material widget found" crash.
    group('bare context (no Material / Scaffold ancestor)', () {
      testWidgets(
        'renders without throwing No Material widget found',
        (tester) async {
          final controller = TextEditingController();
          addTearDown(controller.dispose);

          // WInput must build and lay out without requiring a Material ancestor.
          // Currently crashes because TextField internally calls
          // Theme.of(context), which throws when no Material ancestor exists.
          await tester.pumpWidget(
            _bareHarness(
              WInput(
                controller: controller,
                placeholder: 'Enter text',
              ),
            ),
          );

          expect(find.byType(WInput), findsOneWidget);
        },
      );

      testWidgets(
        'accepts programmatic text via controller and reflects it',
        (tester) async {
          final controller = TextEditingController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            _bareHarness(
              WInput(
                controller: controller,
                placeholder: 'Enter text',
              ),
            ),
          );

          // Enter text via the test framework; EditableText should surface one
          // text-field widget we can type into.
          await tester.enterText(find.byType(EditableText), 'hello');
          await tester.pump();

          expect(
            controller.text,
            'hello',
            reason:
                'Text entered into the field must be reflected in the controller.',
          );
        },
      );
    });

    // (b) Semantics tree contains EXACTLY ONE isTextField node.
    group('semantics', () {
      testWidgets(
        'emits exactly one isTextField semantics node with placeholder label',
        (tester) async {
          final controller = TextEditingController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            _bareHarness(
              WInput(
                controller: controller,
                placeholder: 'Email address',
              ),
            ),
          );

          // Collect every semantics node flagged as a text field, starting from
          // the node enclosing the WInput subtree.
          final List<SemanticsNode> textFieldNodes = _collectTextFieldNodes(
            tester.getSemantics(find.byType(WInput)),
          );

          expect(
            textFieldNodes,
            hasLength(1),
            reason: 'WInput must emit exactly one isTextField semantics node. '
                'Currently emits two due to the Semantics(container:true, '
                'textField:true) + MergeSemantics wrapping around TextField.',
          );

          expect(
            textFieldNodes.first.label,
            contains('Email address'),
            reason:
                'The single textField node must carry the placeholder label.',
          );
        },
      );

      testWidgets(
        'emits exactly one isTextField semantics node with semanticLabel when set',
        (tester) async {
          final controller = TextEditingController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            _bareHarness(
              WInput(
                controller: controller,
                placeholder: 'Search...',
                semanticLabel: 'Global search box',
              ),
            ),
          );

          final List<SemanticsNode> textFieldNodes = _collectTextFieldNodes(
            tester.getSemantics(find.byType(WInput)),
          );

          expect(textFieldNodes, hasLength(1));
          expect(
            textFieldNodes.first.label,
            contains('Global search box'),
            reason:
                'semanticLabel overrides placeholder for the isTextField node.',
          );
        },
      );

      testWidgets(
        'password input isTextField node reports isObscured',
        (tester) async {
          final controller = TextEditingController();
          addTearDown(controller.dispose);

          await tester.pumpWidget(
            _bareHarness(
              WInput(
                controller: controller,
                placeholder: 'Password',
                type: InputType.password,
              ),
            ),
          );

          final List<SemanticsNode> textFieldNodes = _collectTextFieldNodes(
            tester.getSemantics(find.byType(WInput)),
          );

          expect(textFieldNodes, hasLength(1));
          expect(
            textFieldNodes.first.flagsCollection.isObscured,
            isTrue,
            reason:
                'The password isTextField node must report isObscured == true.',
          );
        },
      );
    });

    // (c) value + controller misuse throws AssertionError (W2 guard).
    group('value and controller mutual exclusion (W2)', () {
      test(
        'constructing WInput with both value and controller throws AssertionError',
        () {
          final controller = TextEditingController(text: 'preset');
          addTearDown(controller.dispose);

          expect(
            () => WInput(
              value: 'x',
              controller: controller,
            ),
            throwsA(isA<AssertionError>()),
            reason: 'Passing both value and controller is a developer error. '
                'WInput must assert in debug mode to catch misuse early.',
          );
        },
      );
    });
  });
}

/// Walks the semantics tree rooted at [node] and returns every node whose
/// [SemanticsFlag.isTextField] flag is set.
List<SemanticsNode> _collectTextFieldNodes(SemanticsNode node) {
  final List<SemanticsNode> result = [];

  if (node.flagsCollection.isTextField) {
    result.add(node);
  }

  node.visitChildren((child) {
    result.addAll(_collectTextFieldNodes(child));
    return true;
  });

  return result;
}
