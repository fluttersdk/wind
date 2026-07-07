import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';
import '../utils/wind_logger.dart';

/// **The Utility-First SVG Component**
///
/// `WSvg` brings HTML SVG semantics to Flutter with Tailwind-like utility
/// classes for styling. Like `WIcon`, it inherits color/size from parent styles.
///
/// ### Supported Features:
/// - **Sources:** Asset paths (`src`) or raw Strings (`svgString`)
/// - **Coloring:** `fill-blue-500`, `stroke-red-500`, `text-green-500` (fallback)
/// - **Sizing:** `w-6`, `h-6`, `text-xl`
/// - **Effects:** `opacity-50`, `animate-spin`
///
/// ### Example Usage:
///
/// ```dart
/// WSvg(
///   src: 'assets/icons/star.svg',
///   className: 'fill-yellow-500 w-6 h-6 hover:scale-110 transition-transform',
/// )
/// ```
///
/// ### Outlined Icons Example:
///
/// ```dart
/// WSvg.string(
///   '<svg>...</svg>',
///   className: 'stroke-blue-500 stroke-2 w-8 h-8',
/// )
/// ```
class WSvg extends StatelessWidget {
  /// The asset path to the SVG file.
  final String? src;

  /// Raw SVG string content.
  final String? svgString;

  /// Tailwind-like utility classes for styling.
  ///
  /// Supports:
  /// - **Fill:** `fill-red-500`
  /// - **Stroke:** `stroke-blue-500`
  /// - **Size:** `w-6 h-6` or `text-xl`
  /// - **Fallback:** `text-gray-500` (applies to fill if no fill specified)
  ///
  /// Example: `'fill-current text-blue-500 w-8 h-8'`
  final String? className;

  /// Custom states for dynamic styling.
  final Set<String>? states;

  /// Semantic label for accessibility.
  final String? semanticsLabel;

  /// Creates a [WSvg] from an asset path.
  const WSvg({
    super.key,
    required this.src,
    this.className,
    this.states,
    this.semanticsLabel,
  }) : svgString = null;

  /// Creates a [WSvg] from a raw SVG string.
  const WSvg.string(
    String svg, {
    super.key,
    this.className,
    this.states,
    this.semanticsLabel,
  })  : svgString = svg,
        src = null;

  @override
  Widget build(BuildContext context) {
    // Get inherited text style from parent (like WIcon)
    final TextStyle inheritedStyle = DefaultTextStyle.of(context).style;
    final double? inheritedSize = inheritedStyle.fontSize;
    final Color? inheritedColor = inheritedStyle.color;

    // Parse styles from className
    final WindStyle styles = className != null
        ? WindParser.parse(className!, context, states: states)
        : const WindStyle();

    // Determine size: width/height > fontSize (from text-{size}) > inherited
    final double? size =
        styles.width ?? styles.height ?? styles.fontSize ?? inheritedSize;

    // Determine color priority:
    // 1. stroke-{color} (for outlined icons)
    // 2. fill-{color}
    // 3. text-{color}
    // 4. inherited from parent
    final Color? color = styles.strokeColor ??
        styles.fillColor ??
        styles.color ??
        inheritedColor;

    // Build the color filter: skipped entirely when `preserve-colors` is set,
    // so multi-colour SVGs (QR codes, logos) render with their own embedded colours.
    ColorFilter? colorFilter;
    if (!styles.preserveColors && color != null) {
      colorFilter = ColorFilter.mode(color, BlendMode.srcIn);
    }

    // Build the SVG widget
    Widget svgWidget;
    if (svgString != null) {
      svgWidget = SvgPicture.string(
        svgString!,
        width: size,
        height: size,
        colorFilter: colorFilter,
        semanticsLabel: semanticsLabel,
      );
    } else if (src != null) {
      svgWidget = SvgPicture.asset(
        src!,
        width: size,
        height: size,
        colorFilter: colorFilter,
        semanticsLabel: semanticsLabel,
      );
    } else {
      return const SizedBox.shrink();
    }

    // Apply opacity if specified (animated when duration is set)
    if (styles.opacity != null) {
      if (styles.transitionDuration != null) {
        svgWidget = AnimatedOpacity(
          duration: styles.transitionDuration!,
          curve: styles.transitionCurve ?? Curves.linear,
          opacity: styles.opacity!,
          child: svgWidget,
        );
      } else {
        svgWidget = Opacity(opacity: styles.opacity!, child: svgWidget);
      }
    }

    // Logger integration
    final logger = WindLogger(
      debug: styles.debug,
      widgetName: runtimeType.toString(),
    );

    if (styles.debug) {
      logger.logStep("ClassName", "'$className'");
      if (src != null) logger.logStep("Source", "'$src'");
      logger.setCoreWidget("SvgPicture(${src != null ? 'asset' : 'string'})");
      logger.setFinalStyles(styles);
      if (styles.opacity != null) {
        logger.wrapWith("Opacity", "opacity: ${styles.opacity}");
      }
      logger.printFinalCode();
    }

    return svgWidget;
  }
}
