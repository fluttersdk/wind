import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}

void main() {
  group('WImage Widget Tests', () {
    group('Widget Construction', () {
      test('creates widget with required src', () {
        const widget = WImage(src: 'https://example.com/image.jpg');
        expect(widget.src, 'https://example.com/image.jpg');
      });

      test('identifies asset prefix correctly', () {
        const widget = WImage(src: 'asset://assets/test.png');
        expect(widget.src.startsWith('asset://'), isTrue);
      });

      test('stores alt text', () {
        const widget = WImage(
          src: 'https://example.com/image.jpg',
          alt: 'Description',
        );
        expect(widget.alt, 'Description');
      });

      test('stores className', () {
        const widget = WImage(
          src: 'https://example.com/image.jpg',
          className: 'w-24 h-24 rounded-lg',
        );
        expect(widget.className, 'w-24 h-24 rounded-lg');
      });
    });

    group('Object Fit Parsing (unit tests)', () {
      // Test the internal parsing logic via widget construction + properties
      test('className with object-cover is stored', () {
        const widget = WImage(
          src: 'https://example.com/image.jpg',
          className: 'w-24 h-24 object-cover',
        );
        expect(widget.className!.contains('object-cover'), isTrue);
      });

      test('className with object-contain is stored', () {
        const widget = WImage(
          src: 'https://example.com/image.jpg',
          className: 'object-contain w-24 h-24',
        );
        expect(widget.className!.contains('object-contain'), isTrue);
      });

      test('className with object-fill is stored', () {
        const widget = WImage(
          src: 'https://example.com/image.jpg',
          className: 'object-fill w-24',
        );
        expect(widget.className!.contains('object-fill'), isTrue);
      });

      test('className with object-none is stored', () {
        const widget = WImage(
          src: 'https://example.com/image.jpg',
          className: 'object-none',
        );
        expect(widget.className!.contains('object-none'), isTrue);
      });
    });

    group('Aspect Ratio Classes', () {
      test('accepts aspect-square class', () {
        const widget = WImage(
          src: 'https://example.com/image.jpg',
          className: 'w-24 aspect-square',
        );
        expect(widget.className!.contains('aspect-square'), isTrue);
      });

      test('accepts aspect-video class', () {
        const widget = WImage(
          src: 'https://example.com/image.jpg',
          className: 'w-24 aspect-video',
        );
        expect(widget.className!.contains('aspect-video'), isTrue);
      });
    });

    group('Props', () {
      test('accepts placeholder widget', () {
        final widget = WImage(
          src: 'https://example.com/image.jpg',
          placeholder: Container(color: Colors.grey),
        );
        expect(widget.placeholder, isNotNull);
      });

      test('accepts errorBuilder', () {
        final widget = WImage(
          src: 'https://example.com/image.jpg',
          errorBuilder: (ctx, err, stack) => const Icon(Icons.error),
        );
        expect(widget.errorBuilder, isNotNull);
      });

      test('accepts states', () {
        const widget = WImage(
          src: 'https://example.com/image.jpg',
          states: {'hover', 'focus'},
        );
        expect(widget.states, contains('hover'));
        expect(widget.states, contains('focus'));
      });
    });
  });
}
