import 'package:flutter/widgets.dart';

import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';
import '../utils/wind_logger.dart';
import 'wind_animation_wrapper.dart';

/// **The Utility-First Icon Component**
///
/// `WIcon` wraps Flutter's [Icon] widget and applies Tailwind-like utility
/// classes for styling. Control size, color, and opacity via className.
///
/// ### Features:
/// - **Inherits from parent:** When inside WDiv, inherits color/size from text styles
/// - **Text size classes:** Use `text-sm`, `text-lg`, etc. for icon sizing
/// - **Width/height classes:** Use `w-6 h-6` for icon sizing
///
/// ### Basic Usage:
///
/// ```dart
/// WIcon(Icons.star, className: 'text-yellow-500 text-lg')
/// ```
///
/// ### Inheriting from parent WDiv:
///
/// ```dart
/// WDiv(
///   className: 'text-red-500 text-xl',
///   children: [
///     WIcon(Icons.favorite), // Inherits red color and xl size
///     WText('Liked'),
///   ],
/// )
/// ```
///
/// ### Supported Utility Classes:
///
/// | Class | Effect |
/// |-------|--------|
/// | `text-{color}` | Icon color |
/// | `text-{size}` | Icon size (sm, base, lg, xl, 2xl, etc.) |
/// | `w-{n}`, `h-{n}` | Icon size (explicit pixel size) |
/// | `opacity-{n}` | Icon opacity |
class WIcon extends StatelessWidget {
  /// The icon to display.
  final IconData icon;

  /// Tailwind-like utility classes for styling.
  ///
  /// Supports:
  /// - `text-{color}` → icon color
  /// - `text-{size}` → icon size (uses font size mapping)
  /// - `w-{n}`, `h-{n}` → icon size (uses width or height)
  /// - `opacity-{n}` → icon opacity
  final String? className;

  /// Custom states for dynamic styling.
  ///
  /// When provided, these states activate their corresponding prefix classes.
  /// Example: `states: {'hover'}` activates `hover:text-red-500`.
  final Set<String>? states;

  /// Optional semantic label for accessibility.
  final String? semanticLabel;

  /// Text direction for the icon.
  final TextDirection? textDirection;

  /// Creates a new [WIcon] instance.
  const WIcon(
    this.icon, {
    super.key,
    this.className,
    this.states,
    this.semanticLabel,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    // Get inherited text style from parent (e.g., from WDiv's DefaultTextStyle)
    final TextStyle inheritedStyle = DefaultTextStyle.of(context).style;
    final double? inheritedSize = inheritedStyle.fontSize;
    final Color? inheritedColor = inheritedStyle.color;

    // If no className, use inherited values
    if (className == null) {
      return Icon(
        icon,
        size: inheritedSize,
        color: inheritedColor,
        semanticLabel: semanticLabel,
        textDirection: textDirection,
      );
    }

    // Parse styles from className
    final WindStyle styles = WindParser.parse(
      className!,
      context,
      states: states,
    );

    // Determine size: width/height > fontSize (from text-{size}) > inherited
    final double? size =
        styles.width ?? styles.height ?? styles.fontSize ?? inheritedSize;

    // Determine color: className color > inherited color
    final Color? color = styles.color ?? inheritedColor;

    Widget iconWidget = Icon(
      icon,
      size: size,
      color: color,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );

    // Apply opacity if specified (animated when duration is set)
    if (styles.opacity != null) {
      if (styles.transitionDuration != null) {
        iconWidget = AnimatedOpacity(
          duration: styles.transitionDuration!,
          curve: styles.transitionCurve ?? Curves.linear,
          opacity: styles.opacity!,
          child: iconWidget,
        );
      } else {
        iconWidget = Opacity(opacity: styles.opacity!, child: iconWidget);
      }
    }

    // Apply animation if specified
    if (styles.animationType != null &&
        styles.animationType != WindAnimationType.none) {
      iconWidget = wrapWithAnimation(
        child: iconWidget,
        animationType: styles.animationType,
        duration: styles.transitionDuration,
        curve: styles.transitionCurve,
      );
    }

    // Logger integration
    final logger = WindLogger(
      debug: styles.debug,
      widgetName: runtimeType.toString(),
    );

    if (styles.debug) {
      logger.logStep("ClassName", "'$className'");
      logger.setCoreWidget("Icon(icon: $icon, color: $color, size: $size)");
      logger.setFinalStyles(styles);
      // Log wrappers
      if (styles.opacity != null)
        logger.wrapWith("Opacity", "opacity: ${styles.opacity}");
      if (styles.animationType != null)
        logger.wrapWith("Animation", "type: ${styles.animationType}");
      logger.printFinalCode();
    }

    return iconWidget;
  }
}
