import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/src/parser/parsers/background_parser.dart';
import 'package:fluttersdk_wind/src/parser/wind_context.dart';
import 'package:fluttersdk_wind/src/parser/wind_style.dart';
import 'package:fluttersdk_wind/src/theme/defaults/colors.dart'
    as default_colors;
import 'package:fluttersdk_wind/src/theme/wind_theme_data.dart';

// Helper function to create a WindContext for testing
WindContext createTestContext({
  bool isHovering = false,
  bool isFocused = false,
  bool isDisabled = false,
  String activeBreakpoint = 'base',
  Brightness brightness = Brightness.light,
  String platform = 'unknown',
  bool isMobile = false,
}) {
  return WindContext(
    theme: WindThemeData().copyWith(brightness: brightness),
    activeBreakpoint: activeBreakpoint,
    platform: platform,
    isMobile: isMobile,
    screenWidth: 400,
    screenHeight: 800,
    activeStates: {
      if (isHovering) 'hover',
      if (isFocused) 'focus',
      if (isDisabled) 'disabled',
    },
  );
}

void main() {
  group('BackgroundParser.parseColor', () {
    late WindThemeData themeData;

    setUp(() {
      themeData = WindThemeData();
    });

    test('parses a single valid color class', () {
      final classes = ['bg-red-500'];
      final color = BackgroundParser.parseColor(classes, themeData);
      expect(color, default_colors.colors['red']![500]);
    });

    test('last color class takes precedence', () {
      final classes = ['bg-red-500', 'bg-blue-500'];
      final color = BackgroundParser.parseColor(classes, themeData);
      expect(color, default_colors.colors['blue']![500]);
    });

    test('parses color with default shade', () {
      final classes = ['bg-red'];
      final color = BackgroundParser.parseColor(classes, themeData);
      expect(color, default_colors.colors['red']![500]);
    });

    test('parses an arbitrary color class', () {
      final classes = ['bg-[#FF5733]'];
      final color = BackgroundParser.parseColor(classes, themeData);
      expect(color, const Color(0xFFFF5733));
    });

    test('parses a short arbitrary color class', () {
      final classes = ['bg-[#f00]'];
      final color = BackgroundParser.parseColor(classes, themeData);
      expect(color, const Color(0xffff0000));
    });

    test('returns null for invalid color name', () {
      final classes = ['bg-invalid-500'];
      final color = BackgroundParser.parseColor(classes, themeData);
      expect(color, isNull);
    });

    test('returns null for invalid shade', () {
      final classes = ['bg-red-999'];
      final color = BackgroundParser.parseColor(classes, themeData);
      expect(color, isNull);
    });

    test('returns null for empty list of classes', () {
      final classes = <String>[];
      final color = BackgroundParser.parseColor(classes, themeData);
      expect(color, isNull);
    });

    test('returns null for list with no color classes', () {
      final classes = ['text-red-500', 'p-4'];
      final color = BackgroundParser.parseColor(classes, themeData);
      expect(color, isNull);
    });
  });

  group('BackgroundParser.parseImage', () {
    test('returns null for empty classes', () {
      final image = BackgroundParser.parseImage([]);
      expect(image, isNull);
    });

    test('returns null if no image url is provided', () {
      final image = BackgroundParser.parseImage(['bg-cover', 'bg-center']);
      expect(image, isNull);
    });

    test('parses network image correctly', () {
      final classes = ['bg-[url(https://example.com/image.png)]'];
      final image = BackgroundParser.parseImage(classes);
      expect(image, isA<DecorationImage>());
      expect(image!.image, isA<NetworkImage>());
      expect(
        (image.image as NetworkImage).url,
        'https://example.com/image.png',
      );
    });

    test('parses asset image correctly', () {
      final classes = ['bg-[images/my_image.jpg]'];
      final image = BackgroundParser.parseImage(classes);
      expect(image, isA<DecorationImage>());
      expect(image!.image, isA<AssetImage>());
      expect(
        (image.image as AssetImage).assetName,
        'assets/images/my_image.jpg',
      );
    });

    test('parses asset image with ~/ prefix correctly', () {
      final classes = ['bg-[~/images/my_image.jpg]'];
      final image = BackgroundParser.parseImage(classes);
      expect(image, isA<DecorationImage>());
      expect(image!.image, isA<AssetImage>());
      expect(
        (image.image as AssetImage).assetName,
        'assets/images/my_image.jpg',
      );
    });

    test('parses file image correctly', () {
      final classes = ['bg-[/path/to/image.png]'];
      final image = BackgroundParser.parseImage(classes);
      expect(image, isA<DecorationImage>());
      expect(image!.image, isA<FileImage>());
      expect((image.image as FileImage).file.path, '/path/to/image.png');
    });

    test('parses all properties correctly', () {
      final classes = [
        'bg-[url(https://example.com/image.png)]',
        'bg-contain',
        'bg-bottom-right',
        'bg-repeat-y',
      ];
      final image = BackgroundParser.parseImage(classes);
      expect(image, isA<DecorationImage>());
      expect(image!.image, isA<NetworkImage>());
      expect(image.fit, BoxFit.contain);
      expect(image.alignment, Alignment.bottomRight);
      expect(image.repeat, ImageRepeat.repeatY);
    });

    test('last image url takes precedence', () {
      final classes = [
        'bg-[url(https://first.com/image.png)]',
        'bg-[url(https://second.com/image.png)]',
      ];
      final image = BackgroundParser.parseImage(classes);
      expect(image, isA<DecorationImage>());
      expect(image!.image, isA<NetworkImage>());
      expect((image.image as NetworkImage).url, 'https://second.com/image.png');
    });

    test('uses default values for missing properties', () {
      final classes = ['bg-[url(https://example.com/image.png)]'];
      final image = BackgroundParser.parseImage(classes);
      expect(image, isA<DecorationImage>());
      expect(image!.fit, isNull); // Default is null
      expect(image.alignment, Alignment.center); // Default
      expect(image.repeat, ImageRepeat.noRepeat); // Default
    });
  });

  group('BackgroundParser.parse', () {
    late BackgroundParser parser;
    late WindThemeData themeData;
    late WindContext context;

    setUp(() {
      parser = const BackgroundParser();
      themeData = WindThemeData();
      context = createTestContext();
    });

    test('applies background color to style', () {
      final styles = WindStyle();
      final classes = ['bg-red-500'];
      final updatedStyles = parser.parse(styles, classes, context);

      expect(updatedStyles.decoration, isA<BoxDecoration>());
      final decoration = updatedStyles.decoration as BoxDecoration;
      expect(decoration.color, themeData.getColor('red', 500));
    });

    test('applies background image to style', () {
      final styles = WindStyle();
      final classes = ['bg-[url(https://example.com/image.png)]'];
      final updatedStyles = parser.parse(styles, classes, context);

      expect(updatedStyles.decoration, isA<BoxDecoration>());
      final decoration = updatedStyles.decoration as BoxDecoration;
      expect(decoration.image, isA<DecorationImage>());
      expect(
        (decoration.image!.image as NetworkImage).url,
        'https://example.com/image.png',
      );
    });

    test('applies both background color and image', () {
      final styles = WindStyle();
      final classes = [
        'bg-blue-500',
        'bg-[url(https://a.com/b.png)]',
        'bg-cover',
      ];
      final updatedStyles = parser.parse(styles, classes, context);

      expect(updatedStyles.decoration, isA<BoxDecoration>());
      final decoration = updatedStyles.decoration as BoxDecoration;
      expect(decoration.color, themeData.getColor('blue', 500));
      expect(decoration.image, isA<DecorationImage>());
      expect(
        (decoration.image!.image as NetworkImage).url,
        'https://a.com/b.png',
      );
      expect(decoration.image!.fit, BoxFit.cover);
    });

    test('updates existing decoration color', () {
      final initialDecoration = BoxDecoration(
        color: themeData.getColor('green', 500),
      );
      final styles = WindStyle(decoration: initialDecoration);
      final classes = ['bg-red-500'];
      final updatedStyles = parser.parse(styles, classes, context);

      final decoration = updatedStyles.decoration as BoxDecoration;
      expect(decoration.color, themeData.getColor('red', 500));
    });

    test('does not change style if no relevant classes are present', () {
      final styles = WindStyle();
      final classes = ['text-lg', 'font-bold'];
      final updatedStyles = parser.parse(styles, classes, context);

      expect(updatedStyles, styles);
      expect(updatedStyles.decoration, isNull);
    });

    test('returns original style if classes are null', () {
      final styles = WindStyle();
      final updatedStyles = parser.parse(styles, null, context);
      expect(updatedStyles, styles);
    });

    test('creates decoration if it does not exist', () {
      final styles = WindStyle(); // No decoration initially
      final classes = ['bg-red-500'];
      final updatedStyles = parser.parse(styles, classes, context);

      expect(updatedStyles.decoration, isNotNull);
      expect(
        (updatedStyles.decoration as BoxDecoration).color,
        themeData.getColor('red', 500),
      );
    });
  });

  group('BackgroundParser.canParse', () {
    late BackgroundParser parser;

    setUp(() {
      parser = const BackgroundParser();
    });

    test('returns true for a valid background color class', () {
      expect(parser.canParse('bg-red-500'), isTrue);
    });

    test('returns true for a valid background image class', () {
      expect(parser.canParse('bg-[url(image.png)]'), isTrue);
    });

    test('returns true for a valid background utility class', () {
      expect(parser.canParse('bg-cover'), isTrue);
    });

    test('returns false for a non-background class', () {
      expect(parser.canParse('text-red-500'), isFalse);
    });

    test('returns false for an empty string', () {
      expect(parser.canParse(''), isFalse);
    });

    test(
      'returns false for a class that contains but does not start with "bg-"',
      () {
        expect(parser.canParse('border-bg-red-500'), isFalse);
      },
    );
  });
}
