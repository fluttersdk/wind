import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/wind_parser.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme.dart';
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';
import 'package:fluttersdk_wind/src/widgets/w_text.dart';

void main() {
  group('WText inline foregroundColor', () {
    setUp(() {
      WindParser.clearCache();
    });

    testWidgets('applies foregroundColor to Text style when no text-* class',
        (tester) async {
      const color = Color(0xFF112233);
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WText(
              'hello',
              className: 'text-lg',
              foregroundColor: color,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('hello'));
      expect(text.style?.color, color);
    });

    testWidgets('foregroundColor wins over text-* className', (tester) async {
      const override = Color(0xFFCC00CC);
      await tester.pumpWidget(
        MaterialApp(
          home: WindTheme(
            data: WindThemeData(),
            child: const WText(
              'hello',
              className: 'text-red-500',
              foregroundColor: override,
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('hello'));
      expect(text.style?.color, override);
    });
  });
}
