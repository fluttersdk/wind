import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';

void main() {
  group('WindTheme', () {
    testWidgets('of returns the theme data', (WidgetTester tester) async {
      final themeData = WindThemeData();
      late final BuildContext capturedContext;

      await tester.pumpWidget(
        WindTheme(
          data: themeData,
          child: Builder(
            builder: (BuildContext context) {
              capturedContext = context;
              return Container();
            },
          ),
        ),
      );

      expect(WindTheme.of(capturedContext), themeData);
    });

    testWidgets('updateShouldNotify returns true when data changes',
        (WidgetTester tester) async {
      final oldThemeData = WindThemeData();
      final newThemeData =
          WindThemeData(colors: {'primary': Colors.blue});

      final oldWidget = WindTheme(data: oldThemeData, child: Container());
      final newWidget = WindTheme(data: newThemeData, child: Container());

      expect(newWidget.updateShouldNotify(oldWidget), isTrue);
    });

    testWidgets('updateShouldNotify returns false when data is the same',
        (WidgetTester tester) async {
      final themeData = WindThemeData();

      final oldWidget = WindTheme(data: themeData, child: Container());
      final newWidget = WindTheme(data: themeData, child: Container());

      expect(newWidget.updateShouldNotify(oldWidget), isFalse);
    });
  });
}

