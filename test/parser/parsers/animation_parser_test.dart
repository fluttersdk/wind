import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  group('AnimationParser Tests', () {
    testWidgets('parses animate-spin', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Builder(
              builder: (context) {
                final style = WindParser.parse('animate-spin', context);
                expect(style.animationType, equals(WindAnimationType.spin));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('parses animate-pulse', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Builder(
              builder: (context) {
                final style = WindParser.parse('animate-pulse', context);
                expect(style.animationType, equals(WindAnimationType.pulse));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('parses animate-bounce', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Builder(
              builder: (context) {
                final style = WindParser.parse('animate-bounce', context);
                expect(style.animationType, equals(WindAnimationType.bounce));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('parses animate-ping', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Builder(
              builder: (context) {
                final style = WindParser.parse('animate-ping', context);
                expect(style.animationType, equals(WindAnimationType.ping));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('parses animate-none', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: Builder(
              builder: (context) {
                final style = WindParser.parse('animate-none', context);
                expect(style.animationType, equals(WindAnimationType.none));
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  });

  group('Animation Widget Integration Tests', () {
    testWidgets('WDiv with animate-spin renders animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(className: 'w-8 h-8 bg-blue-500 animate-spin'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(WDiv), findsOneWidget);
      // WindAnimationWrapper should be in the tree
      expect(find.byType(WindAnimationWrapper), findsOneWidget);
    });

    testWidgets('WDiv with animate-pulse renders animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(className: 'w-8 h-8 bg-gray-300 animate-pulse'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(WDiv), findsOneWidget);
      expect(find.byType(WindAnimationWrapper), findsOneWidget);
    });

    testWidgets('WDiv without animation does not have wrapper', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WDiv(className: 'w-8 h-8 bg-blue-500'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(WDiv), findsOneWidget);
      expect(find.byType(WindAnimationWrapper), findsNothing);
    });
  });
}
