import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Locks `uppercase` / `lowercase` / `capitalize` to the AMBIENT locale's
/// casing rules.
///
/// `String.toUpperCase()` is locale-independent and maps `i` to `I`. Turkish and
/// Azerbaijani distinguish a dotted from a dotless `i`, so the uppercase of `i`
/// is `İ` and the uppercase of `ı` is `I`. Without this a Turkish app rendered
/// `IZLEYICILER` and `GÜVENLIK` for headings that carried the utility, which are
/// not words, and the defect followed the CLASS NAME across every consumer
/// rather than living at one call site.
///
/// This is the only casing site in the package that follows the locale. Every
/// other `toUpperCase` / `toLowerCase` normalises a class name or a wire token
/// and must stay locale-independent; the last group here pins that.
void main() {
  // A bare `Localizations` rather than a `MaterialApp`: the Material delegate
  // ships no `tr` translations and warns the test to death about it, and this
  // widget reads nothing from it. Only the ambient LOCALE is under test.
  Widget wrap(Widget child, {Locale? locale}) {
    return Localizations(
      locale: locale ?? const Locale('en'),
      delegates: const <LocalizationsDelegate<dynamic>>[
        DefaultWidgetsLocalizations.delegate,
      ],
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: WindTheme(data: WindThemeData(), child: child),
      ),
    );
  }

  group('Turkish', () {
    testWidgets('uppercase keeps the dot on i and takes it off ı', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const WText('Çalışan izleyiciler', className: 'uppercase'),
          locale: const Locale('tr'),
        ),
      );

      expect(find.text('ÇALIŞAN İZLEYİCİLER'), findsOneWidget);
    });

    testWidgets('a dotless ı still uppercases to a dotless I', (tester) async {
      // A guard rather than a reproducer: Dart already gets this one right, and
      // the point is that the fix must not BREAK it. It is why the transform
      // cannot be a blanket `I` -> `İ` replacement.
      await tester.pumpWidget(
        wrap(
          const WText('Kullanılan', className: 'uppercase'),
          locale: const Locale('tr'),
        ),
      );

      expect(find.text('KULLANILAN'), findsOneWidget);
    });

    testWidgets('lowercase takes the dot off I', (tester) async {
      // `I` is the mapping Dart is missing on the way down: it lowers to `i`
      // where Turkish needs `ı`. Measured, so this input reproduces and
      // `İZLEYİCİ` would not: Dart already lowers that to a clean `izleyici`.
      await tester.pumpWidget(
        wrap(
          const WText('IZLEYICI', className: 'lowercase'),
          locale: const Locale('tr'),
        ),
      );

      expect(find.text('ızleyıcı'), findsOneWidget);
    });

    testWidgets('capitalize dots the leading i', (tester) async {
      await tester.pumpWidget(
        wrap(
          const WText('izleyici', className: 'capitalize'),
          locale: const Locale('tr'),
        ),
      );

      expect(find.text('İzleyici'), findsOneWidget);
    });
  });

  group('English', () {
    testWidgets('casing is unchanged', (tester) async {
      await tester.pumpWidget(
        wrap(
          const WText('Monitors up', className: 'uppercase'),
          locale: const Locale('en'),
        ),
      );

      expect(find.text('MONITORS UP'), findsOneWidget);
    });
  });

  group('with no Localizations ancestor', () {
    testWidgets('falls back to the locale-independent transform', (
      tester,
    ) async {
      // `maybeLocaleOf`, not `localeOf`: a bare pump has no `Localizations`, and
      // throwing there would break every widget test in every consumer that
      // renders a `WText` without an app around it.
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: WindTheme(
            data: WindThemeData(),
            child: const WText('monitors up', className: 'uppercase'),
          ),
        ),
      );

      expect(find.text('MONITORS UP'), findsOneWidget);
    });
  });
}
