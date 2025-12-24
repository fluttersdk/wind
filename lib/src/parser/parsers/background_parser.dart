import 'dart:io';

import 'package:flutter/material.dart';

import '../../theme/wind_theme_data.dart';
import '../../utils/color_utils.dart';
import '../wind_context.dart';
import '../wind_style.dart';
import 'wind_parser_interface.dart';

/// Parser for background related classes
///
/// Example classes:
/// - Background color: bg-red-500, bg-[#FF5733]
/// - Background image: bg-[url(https://example.com/image.png)], bg-[assets/image.png]
/// - Background size: bg-cover, bg-contain
/// - Background position: bg-center, bg-top-left
/// - Background repeat: bg-no-repeat, bg-repeat-x
class BackgroundParser implements WindParserInterface {
  const BackgroundParser();

  /// Regex for background color classes
  static final _backgroundColorRegex = RegExp(
    r'^bg-(?:(?<color>[a-zA-Z0-9]+)-?(?<shade>[0-9]{0,3})|\[(?<arbitrary>#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6}))\])$',
  );

  /// Regex for background image classes
  static final _backgroundImageRegex = RegExp(
    r'^bg-\[url\((.*?)\)\]$|^bg-\[([^\]]+)\]$',
  );

  /// Map for background fit values
  static final _fitMap = <String, BoxFit>{
    'bg-cover': BoxFit.cover,
    'bg-contain': BoxFit.contain,
  };

  /// Map for background position values
  static final _alignmentMap = <String, Alignment>{
    'bg-center': Alignment.center,
    'bg-top': Alignment.topCenter,
    'bg-bottom': Alignment.bottomCenter,
    'bg-left': Alignment.centerLeft,
    'bg-right': Alignment.centerRight,
    'bg-top-left': Alignment.topLeft,
    'bg-top-right': Alignment.topRight,
    'bg-bottom-left': Alignment.bottomLeft,
    'bg-bottom-right': Alignment.bottomRight,
  };

  /// Map for background repeat values
  static final _repeatMap = <String, ImageRepeat>{
    'bg-no-repeat': ImageRepeat.noRepeat,
    'bg-repeat': ImageRepeat.repeat,
    'bg-repeat-x': ImageRepeat.repeatX,
    'bg-repeat-y': ImageRepeat.repeatY,
  };

  /// Parses background related classes and returns updated WindStyle
  ///
  /// Example:
  /// ```dart
  /// final parser = BackgroundParser();
  /// final styles = WindStyle();
  /// final classes = ['bg-red-500', 'bg-cover', 'bg-center'];
  /// final context = WindContext(theme: WindThemeData());
  /// final updatedStyles = parser.parse(styles, classes, context);
  /// ```
  @override
  WindStyle parse(
    WindStyle styles,
    List<String>? classes,
    WindContext context,
  ) {
    if (classes == null) return styles;

    final color = parseColor(classes, context.theme);
    final image = parseImage(classes);

    // If no background classes are found, return original styles
    if (color == null && image == null) {
      return styles;
    }

    // Get existing decoration or create a new one
    final decoration = styles.decoration ?? const BoxDecoration();

    return styles.copyWith(
      decoration: decoration.copyWith(color: color, image: image),
    );
  }

  /// Checks if the parser can handle the given class name
  ///
  /// Example:
  /// ```dart
  /// final parser = BackgroundParser();
  /// final canParse = parser.canParse('bg-red-500');
  /// // canParse will be true
  /// ```
  @override
  bool canParse(String className) {
    return className.startsWith('bg-');
  }

  /// Parses background color from the given classes
  /// Returns null if no valid background color is found
  /// If multiple background color classes are present,
  /// the last one takes precedence.
  /// Arbitrary colors in the format bg-[#RRGGBB] are also supported.
  ///
  /// Example:
  /// ```dart
  /// final color = BackgroundParser.parseColor(['bg-red-500', 'bg-blue-500'], themeData);
  /// // color will be blue-500
  /// ```
  ///
  /// Example with arbitrary color:
  /// ```dart
  /// final color = BackgroundParser.parseColor(['bg-[#FF5733]'], themeData);
  /// // color will be Color(0xFFFF5733)
  /// ```
  static Color? parseColor(List<String> classes, WindThemeData themeData) {
    // Iterate through classes in reverse to give precedence to the last one
    for (var i = classes.length - 1; i >= 0; i--) {
      final className = classes[i];
      final match = _backgroundColorRegex.firstMatch(className);
      if (match != null) {
        if (match.namedGroup('arbitrary') != null) {
          // Parse arbitrary color
          final hexCode = match.namedGroup('arbitrary')!;
          return hexToColor(hexCode);
        } else if (match.namedGroup('color') != null) {
          final colorName = match.namedGroup('color')!;
          final shadeStr = match.namedGroup('shade')!;
          final shade = shadeStr.isNotEmpty ? int.parse(shadeStr) : 500;

          if (themeData.isValidColor(colorName, shade: shade)) {
            return themeData.getColor(colorName, shade);
          }
        }
      }
    }

    return null;
  }

  /// Parses background image from the given classes
  /// Returns null if no valid background image is found
  /// If multiple background image classes are present,
  /// the last one takes precedence.
  ///
  /// Example:
  /// ```dart
  /// final image = BackgroundParser.parseImage(['bg-[url(https://example.com/image.png)]', 'bg-cover', 'bg-center', 'bg-repeat-x']);
  /// // image will be a DecorationImage with the specified properties
  /// ```
  static DecorationImage? parseImage(List<String> classes) {
    String? imageUrlOrPath;
    BoxFit? fit;
    Alignment? alignment;
    ImageRepeat? repeat;

    for (var i = classes.length - 1; i >= 0; i--) {
      final className = classes[i];

      if (imageUrlOrPath == null) {
        final match = _backgroundImageRegex.firstMatch(className);
        if (match != null) {
          imageUrlOrPath = match.group(1) ?? match.group(2);
        }
      }

      if (fit == null) {
        final fitMatch = _fitMap.containsKey(className)
            ? _fitMap[className]
            : null;
        if (fitMatch != null) {
          fit = fitMatch;
        }
      }

      if (alignment == null) {
        final alignMatch = _alignmentMap.containsKey(className)
            ? _alignmentMap[className]
            : null;
        if (alignMatch != null) {
          alignment = alignMatch;
        }
      }

      if (repeat == null) {
        final repeatMatch = _repeatMap.containsKey(className)
            ? _repeatMap[className]
            : null;
        if (repeatMatch != null) {
          repeat = repeatMatch;
        }
      }
    }

    if (imageUrlOrPath != null) {
      ImageProvider imageProvider;
      if (imageUrlOrPath.startsWith('http://') ||
          imageUrlOrPath.startsWith('https://')) {
        imageProvider = NetworkImage(imageUrlOrPath);
      } else if (imageUrlOrPath.startsWith('/')) {
        imageProvider = FileImage(File(imageUrlOrPath));
      } else {
        String assetPath = imageUrlOrPath;
        if (imageUrlOrPath.startsWith('~/') ||
            imageUrlOrPath.startsWith('@/')) {
          assetPath = 'assets/' + imageUrlOrPath.substring(2);
        } else if (!imageUrlOrPath.startsWith('assets/')) {
          assetPath = 'assets/' + imageUrlOrPath;
        }
        imageProvider = AssetImage(assetPath);
      }

      return DecorationImage(
        image: imageProvider,
        fit: fit,
        alignment: alignment ?? Alignment.center,
        repeat: repeat ?? ImageRepeat.noRepeat,
      );
    }

    return null;
  }
}
