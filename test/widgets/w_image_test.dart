import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

/// Helper to wrap widget in MaterialApp with WindTheme
Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

/// Silent error builder — returns an empty box so image load failures do not
/// propagate as unhandled exceptions inside testWidgets.
Widget _silentErrorBuilder(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
) =>
    const SizedBox.shrink();

void main() {
  group('WImage Widget Tests', () {
    group('Source', () {
      testWidgets('renders network image when src is HTTPS URL',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WImage(
              src: 'https://example.com/x.jpg',
              errorBuilder: _silentErrorBuilder,
            ),
          ),
        );

        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('renders asset image when src uses asset:// prefix',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WImage(
              src: 'asset://logo.png',
              errorBuilder: _silentErrorBuilder,
            ),
          ),
        );

        expect(find.byType(Image), findsOneWidget);
        final image = tester.widget<Image>(find.byType(Image));
        expect(image.image, isA<AssetImage>());
      });

      testWidgets('renders from ImageProvider when image param is supplied',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WImage(
              image: MemoryImage(Uint8List(0)),
              errorBuilder: _silentErrorBuilder,
            ),
          ),
        );

        expect(find.byType(Image), findsOneWidget);
        final image = tester.widget<Image>(find.byType(Image));
        expect(image.image, isA<MemoryImage>());
      });
    });

    group('Object Fit', () {
      testWidgets('defaults to BoxFit.cover when no object-* token',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WImage(
              src: 'https://example.com/x.jpg',
              className: 'w-32 h-32',
              errorBuilder: _silentErrorBuilder,
            ),
          ),
        );

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.fit, equals(BoxFit.cover));
      });

      testWidgets('applies BoxFit.cover for object-cover token',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WImage(
              src: 'https://example.com/x.jpg',
              className: 'object-cover',
              errorBuilder: _silentErrorBuilder,
            ),
          ),
        );

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.fit, equals(BoxFit.cover));
      });

      testWidgets('applies BoxFit.contain for object-contain token',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WImage(
              src: 'https://example.com/x.jpg',
              className: 'object-contain',
              errorBuilder: _silentErrorBuilder,
            ),
          ),
        );

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.fit, equals(BoxFit.contain));
      });

      testWidgets('applies BoxFit.fill for object-fill token', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WImage(
              src: 'https://example.com/x.jpg',
              className: 'object-fill',
              errorBuilder: _silentErrorBuilder,
            ),
          ),
        );

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.fit, equals(BoxFit.fill));
      });

      testWidgets('applies BoxFit.none for object-none token', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WImage(
              src: 'https://example.com/x.jpg',
              className: 'object-none',
              errorBuilder: _silentErrorBuilder,
            ),
          ),
        );

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.fit, equals(BoxFit.none));
      });

      testWidgets('applies BoxFit.scaleDown for object-scale-down token',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WImage(
              src: 'https://example.com/x.jpg',
              className: 'object-scale-down',
              errorBuilder: _silentErrorBuilder,
            ),
          ),
        );

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.fit, equals(BoxFit.scaleDown));
      });
    });

    group('Object Position', () {
      Future<Image> pumpImage(WidgetTester tester, String? className) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WImage(
              src: 'https://example.com/x.jpg',
              className: className,
              errorBuilder: _silentErrorBuilder,
            ),
          ),
        );
        return tester.widget<Image>(find.byType(Image));
      }

      testWidgets('defaults to Alignment.center when no object-* position',
          (tester) async {
        final image = await pumpImage(tester, 'w-32 h-32 object-cover');

        expect(image.alignment, equals(Alignment.center));
      });

      testWidgets('defaults to Alignment.center when className is null',
          (tester) async {
        final image = await pumpImage(tester, null);

        expect(image.alignment, equals(Alignment.center));
      });

      testWidgets('object-top with object-cover aligns the crop to topCenter',
          (tester) async {
        final image =
            await pumpImage(tester, 'w-full h-full object-cover object-top');

        expect(image.fit, equals(BoxFit.cover));
        expect(image.alignment, equals(Alignment.topCenter));
      });

      testWidgets('position token order does not matter against the fit token',
          (tester) async {
        final image = await pumpImage(tester, 'object-top object-contain');

        expect(image.fit, equals(BoxFit.contain));
        expect(image.alignment, equals(Alignment.topCenter));
      });

      const positions = <String, Alignment>{
        'object-bottom': Alignment.bottomCenter,
        'object-center': Alignment.center,
        'object-left': Alignment.centerLeft,
        'object-left-bottom': Alignment.bottomLeft,
        'object-left-top': Alignment.topLeft,
        'object-right': Alignment.centerRight,
        'object-right-bottom': Alignment.bottomRight,
        'object-right-top': Alignment.topRight,
        'object-top': Alignment.topCenter,
      };

      for (final entry in positions.entries) {
        testWidgets('maps ${entry.key} to ${entry.value}', (tester) async {
          final image = await pumpImage(tester, 'w-32 h-32 ${entry.key}');

          expect(image.alignment, equals(entry.value));
        });
      }

      testWidgets('applies the alignment to asset and provider images',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            Column(
              children: [
                WImage(
                  src: 'asset://logo.png',
                  className: 'object-left-top',
                  errorBuilder: _silentErrorBuilder,
                ),
                WImage(
                  image: MemoryImage(Uint8List(0)),
                  className: 'object-right-bottom',
                  errorBuilder: _silentErrorBuilder,
                ),
              ],
            ),
          ),
        );

        final images = tester.widgetList<Image>(find.byType(Image)).toList();
        expect(images[0].alignment, equals(Alignment.topLeft));
        expect(images[1].alignment, equals(Alignment.bottomRight));
      });

      testWidgets('keeps Alignment.center for an unknown object-* token',
          (tester) async {
        final image = await pumpImage(tester, 'object-nowhere');

        expect(image.alignment, equals(Alignment.center));
      });
    });

    group('Decoration', () {
      testWidgets('wraps with SizedBox when w-32 h-32 tokens are present',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WImage(
              src: 'https://example.com/x.jpg',
              className: 'w-32 h-32',
              errorBuilder: _silentErrorBuilder,
            ),
          ),
        );

        final sizedBoxes = tester.widgetList<SizedBox>(
          find.ancestor(
              of: find.byType(Image), matching: find.byType(SizedBox)),
        );
        expect(sizedBoxes, isNotEmpty);

        final sizedBox = sizedBoxes.first;
        expect(sizedBox.width, equals(128.0));
        expect(sizedBox.height, equals(128.0));
      });

      testWidgets('wraps with AspectRatio when aspect-square token is present',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WImage(
              src: 'https://example.com/x.jpg',
              className: 'aspect-square',
              errorBuilder: _silentErrorBuilder,
            ),
          ),
        );

        expect(
          find.ancestor(
              of: find.byType(Image), matching: find.byType(AspectRatio)),
          findsOneWidget,
        );
      });

      testWidgets('wraps with Opacity at 0.75 when opacity-75 token is present',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WImage(
              src: 'https://example.com/x.jpg',
              className: 'opacity-75',
              errorBuilder: _silentErrorBuilder,
            ),
          ),
        );

        final opacityWidgets = tester.widgetList<Opacity>(
          find.ancestor(of: find.byType(Image), matching: find.byType(Opacity)),
        );
        expect(opacityWidgets, isNotEmpty);
        expect(opacityWidgets.first.opacity, closeTo(0.75, 0.01));
      });

      testWidgets('wraps with ClipRRect when rounded-lg token is present',
          (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WImage(
              src: 'https://example.com/x.jpg',
              className: 'rounded-lg',
              errorBuilder: _silentErrorBuilder,
            ),
          ),
        );

        expect(
          find.ancestor(
              of: find.byType(Image), matching: find.byType(ClipRRect)),
          findsOneWidget,
        );
      });

      testWidgets('sets semanticLabel from alt parameter', (tester) async {
        await tester.pumpWidget(
          wrapWithTheme(
            WImage(
              src: 'https://example.com/x.jpg',
              alt: 'avatar',
              errorBuilder: _silentErrorBuilder,
            ),
          ),
        );

        final image = tester.widget<Image>(find.byType(Image));
        expect(image.semanticLabel, equals('avatar'));
      });
    });

    group('Validation', () {
      testWidgets(
          'throws AssertionError when neither src nor image is provided',
          (tester) async {
        expect(() => WImage(), throwsAssertionError);
      });
    });
  });
}
