import 'package:flutter/widgets.dart';

import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';
import '../utils/wind_logger.dart';
import 'wind_animation_wrapper.dart';

/// **The Fundamental Building Block of Wind**
///
/// `WDiv` acts as the primary container for the Wind UI framework. It embodies
/// the "Intelligent Composition" philosophy, dynamically constructing the
/// most efficient widget tree based on the provided utility classes.
///
/// Instead of blindly wrapping content in a `Container`, `WDiv` inspects
/// the [className] and selectively applies specialized widgets like `Padding`,
/// `Align`, `Row`, or `GridView` only when necessary.
///
/// ### Supported Features:
/// - **Flexbox:** `flex`, `flex-row`, `items-center`, `justify-between`
/// - **Grid:** `grid`, `grid-cols-3`, `gap-4`
/// - **Spacing:** `p-4`, `m-2`, `space-x-4`
/// - **Sizing:** `w-full`, `h-12`, `min-h-screen`, `aspect-video`
/// - **Backgrounds:** `bg-red-500`, `bg-gradient-to-r`
/// - **Borders:** `border`, `border-red-500`, `rounded-lg`
/// - **Effects:** `shadow-lg`, `opacity-50`
/// - **Text:** `text-red-500`, `text-center`, `text-2xl`
/// - **Animation:** `animate-pulse`, `animate-bounce`, `animate-spin`
/// - **States:** `hover:bg-red-600`, `dark:bg-slate-900`
/// - **Transitions:** `transition-all`, `duration-300`, `ease-in-out`
///
/// ### Example Usage:
///
/// ```dart
/// // A responsive flex container with padding and gap
/// WDiv(
///   className: "flex flex-col md:flex-row gap-4 p-4 bg-gray-100 rounded-lg",
///   children: [
///     Text("Item 1"),
///     Text("Item 2"),
///   ],
/// )
/// ```
class WDiv extends StatelessWidget {
  /// The utility class string defining the style and layout.
  ///
  /// Supports:
  /// - **Layout:** `flex`, `grid`, `block`, `hidden`
  /// - **Spacing:** `p-4`, `m-2`, `gap-x-4`
  /// - **Sizing:** `w-full`, `h-12`, `min-h-screen`, `aspect-video`
  /// - **Styling:** `bg-red-500`, `text-white`, `rounded-xl`, `shadow-lg`
  /// - **States:** `hover:bg-red-600`, `dark:bg-slate-900`
  ///
  /// Example:
  /// ```dart
  /// className: "flex flex-col gap-4 p-6 bg-white shadow-sm"
  /// ```
  final String? className;

  /// The single child widget. Used for `block` layouts or simple wrappers.
  ///
  /// **Usage Rules:**
  /// - Use this when `className` does NOT contain `flex` or `grid`.
  /// - *Exclusive:* Cannot be used simultaneously with [children].
  final Widget? child;

  /// The list of children widgets. Used for `flex`, `grid`, or `wrap` layouts.
  ///
  /// **Usage Rules:**
  /// - Use this when `className` contains `flex`, `grid`, or `wrap`.
  /// - *Exclusive:* Cannot be used simultaneously with [child].
  final List<Widget>? children;

  /// An optional explicit style object.
  ///
  /// If provided, this serves as the "base" style, which [className]
  /// will override. Useful for creating reusable component widgets.
  final WindStyle? style;

  /// Custom states for dynamic state styling (e.g., 'loading', 'selected').
  ///
  /// When provided, these states activate their corresponding prefix classes.
  /// Example: `states: ['loading']` activates `loading:bg-blue-500`.
  final Set<String>? states;

  /// Creates a new [WDiv] instance.
  const WDiv({
    super.key,
    this.className,
    this.child,
    this.children,
    this.style,
    this.states,
  }) : assert(
         child == null || children == null,
         'WDiv Violation: You cannot provide both `child` and `children`. Please select one strategy.',
       );

  @override
  Widget build(BuildContext context) {
    // 1. RESOLVE STYLES (The Logic Layer)
    // We delegate parsing to the WindParser "Orchestrator".
    // It handles caching, precedence, and state resolution internally.
    final WindStyle styles = className != null
        ? WindParser.parse(
            className!,
            context,
            baseStyle: style,
            states: states,
          )
        : style ?? const WindStyle();

    // 2. DEBUGGING (The Developer Experience)
    // If debug mode is active via the `debug` utility class,
    // we spin up the logger to trace the composition process.
    final logger = WindLogger(
      debug: styles.debug,
      widgetName: runtimeType.toString(),
    );

    if (styles.debug) {
      logger.logStep("ClassName", "'$className'");
      logger.setFinalStyles(styles);
    }

    // 3. GUARD CLAUSE (Visibility)
    // If the element is hidden (e.g., `hidden` or `md:hidden`),
    // we short-circuit immediately to save resources.
    if (styles.isHidden) {
      logger.logStep("Visibility", "Hidden (returning SizedBox.shrink)");
      logger.printFinalCode();
      return const SizedBox.shrink();
    }

    // 4. BUILD CONTENT (The View Layer)
    // We construct the core structural widget (Row, Column, Grid) based
    // on the resolved display type.
    final Widget? coreContent = _buildCoreStructure(
      styles: styles,
      logger: logger,
    );

    // 5. COMPOSE DECORATORS (The Decorator Layer)
    // We wrap the core structure with styling widgets (Padding, Container)
    // in a specific order (from inside out) to achieve the desired effect.
    Widget finalWidget = _buildCompositionPipeline(
      styles: styles,
      content: coreContent,
      logger: logger,
    );

    /// 6. TEXT STYLES (If applicable)
    /// If text-specific styles are defined, we wrap the final widget
    /// in a `DefaultTextStyle.merge` to apply them.
    final TextStyle textStyle = styles.toTextStyle();
    final bool hasTextStyle = textStyle != const TextStyle(); // Check if empty
    final bool hasTextAlign = styles.textAlign != null;
    final bool hasSoftWrap = styles.softWrap != null;
    final bool hasTextOverflow = styles.textOverflow != null;
    final bool hasMaxLines = styles.maxLines != null;

    if (hasTextStyle ||
        hasTextAlign ||
        hasSoftWrap ||
        hasTextOverflow ||
        hasMaxLines) {
      logger.wrapWith("DefaultTextStyle.merge", "style: $textStyle");

      finalWidget = DefaultTextStyle.merge(
        style: textStyle,
        textAlign: styles.textAlign,
        softWrap: styles.softWrap,
        overflow: styles.textOverflow,
        maxLines: styles.maxLines,
        child: finalWidget,
      );
    }

    // 7. ASPECT RATIO
    // Wrap with AspectRatio widget if aspectRatio is set.
    if (styles.aspectRatio != null) {
      logger.wrapWith("AspectRatio", "aspectRatio: ${styles.aspectRatio}");
      finalWidget = AspectRatio(
        aspectRatio: styles.aspectRatio!,
        child: finalWidget,
      );
    }

    // 8. OPACITY (Effects Layer)
    // Wrap with AnimatedOpacity if transition duration is set, else static Opacity.
    if (styles.opacity != null) {
      if (styles.transitionDuration != null) {
        logger.wrapWith("AnimatedOpacity", "opacity: ${styles.opacity}");
        finalWidget = AnimatedOpacity(
          duration: styles.transitionDuration!,
          curve: styles.transitionCurve ?? Curves.linear,
          opacity: styles.opacity!,
          child: finalWidget,
        );
      } else {
        logger.wrapWith("Opacity", "opacity: ${styles.opacity}");
        finalWidget = Opacity(opacity: styles.opacity!, child: finalWidget);
      }
    }

    // 9. ANIMATION (animate-spin, animate-pulse, etc.)
    // Wrap with animation if animationType is set.
    if (styles.animationType != null &&
        styles.animationType != WindAnimationType.none) {
      logger.wrapWith("Animation", "type: ${styles.animationType}");
      finalWidget = wrapWithAnimation(
        child: finalWidget,
        animationType: styles.animationType,
        duration: styles.transitionDuration,
        curve: styles.transitionCurve,
      );
    }

    // Final: Print debug log if enabled
    logger.printFinalCode();
    return finalWidget;
  }

  /// **Core Structure Builder**
  ///
  /// Determines the layout mechanism (`Flex`, `Grid`, `Wrap`, or `Block`)
  /// and arranges the children accordingly.
  Widget? _buildCoreStructure({
    required WindStyle styles,
    required WindLogger logger,
  }) {
    // Case A: Single Child
    if (child != null) {
      // If flex display is specified, wrap single child in Row/Column for alignment
      if (styles.displayType == WindDisplayType.flex) {
        final direction = styles.flexDirection ?? Axis.horizontal;
        final isColumn = direction == Axis.vertical;

        logger.setCoreWidget(
          "${isColumn ? 'Column' : 'Row'}(child: single item)",
        );

        if (isColumn) {
          return Column(
            mainAxisAlignment:
                styles.mainAxisAlignment ?? MainAxisAlignment.start,
            crossAxisAlignment:
                styles.crossAxisAlignment ?? CrossAxisAlignment.start,
            mainAxisSize: styles.mainAxisSize ?? MainAxisSize.min,
            children: [child!],
          );
        } else {
          return Row(
            mainAxisAlignment:
                styles.mainAxisAlignment ?? MainAxisAlignment.start,
            crossAxisAlignment:
                styles.crossAxisAlignment ?? CrossAxisAlignment.start,
            mainAxisSize: styles.mainAxisSize ?? MainAxisSize.min,
            children: [child!],
          );
        }
      }

      // Pass-through for non-flex single child
      logger.setCoreWidget("child: $child");
      return child;
    }

    // Case B: Multiple Children (Layout required)
    if (children != null) {
      // If we have children but no display type specified, we fallback
      // to the default 'block' behavior.
      final type = styles.displayType ?? WindDisplayType.block;

      switch (type) {
        case WindDisplayType.flex:
          return _buildFlexStructure(styles, logger);
        case WindDisplayType.grid:
          return _buildGridStructure(styles, logger);
        case WindDisplayType.wrap:
          return _buildWrapStructure(styles, logger);
        default:
          return _buildBlockStructure(styles, logger);
      }
    }

    // Case C: No Content (Empty Box)
    return null;
  }

  /// Builds a Flexbox layout (`Row` or `Column`).
  Widget _buildFlexStructure(WindStyle styles, WindLogger logger) {
    final direction = styles.flexDirection ?? Axis.horizontal;
    final isColumn = direction == Axis.vertical;

    // Inject gaps if necessary (SRP: delegated to helper)
    final gappedChildren = _buildGappedChildren(
      children: children!,
      direction: direction,
      gapX: styles.gapX,
      gapY: styles.gapY,
    );

    logger.setCoreWidget(
      "${isColumn ? 'Column' : 'Row'}(children: [${children!.length} items])",
    );

    if (isColumn) {
      return Column(
        mainAxisAlignment: styles.mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment:
            styles.crossAxisAlignment ?? CrossAxisAlignment.start,
        mainAxisSize: styles.mainAxisSize ?? MainAxisSize.min,
        children: gappedChildren,
      );
    } else {
      return Row(
        mainAxisAlignment: styles.mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment:
            styles.crossAxisAlignment ?? CrossAxisAlignment.start,
        mainAxisSize: styles.mainAxisSize ?? MainAxisSize.min,
        children: gappedChildren,
      );
    }
  }

  /// Builds a Grid layout using Wrap for flexible item heights.
  ///
  /// Unlike CSS Grid which allows variable heights, Flutter's GridView forces
  /// equal heights. We use Wrap + LayoutBuilder to achieve Tailwind-like
  /// behavior where each item has intrinsic height.
  Widget _buildGridStructure(WindStyle styles, WindLogger logger) {
    final cols = styles.gridCols ?? 2;
    final gapX = styles.gapX ?? 0;
    final gapY = styles.gapY ?? 0;

    logger.setCoreWidget(
      "Wrap-Grid(cols: $cols, children: [${children!.length}])",
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate item width based on available space and columns
        final totalGapWidth = gapX * (cols - 1);
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final itemWidth = (availableWidth - totalGapWidth) / cols;

        return Wrap(
          spacing: gapX,
          runSpacing: gapY,
          children: children!.map((child) {
            return SizedBox(
              width: itemWidth > 0 ? itemWidth : null,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }

  /// Builds a Wrap layout.
  Widget _buildWrapStructure(WindStyle styles, WindLogger logger) {
    logger.setCoreWidget("Wrap(children: [${children!.length}])");

    return Wrap(
      direction: styles.flexDirection ?? Axis.horizontal,
      alignment: _translateMainAxisToWrap(styles.mainAxisAlignment),
      crossAxisAlignment: _translateCrossAxisToWrap(styles.crossAxisAlignment),
      runAlignment: styles.runAlignment ?? WrapAlignment.start,
      spacing: styles.gapX ?? 0,
      runSpacing: styles.gapY ?? 0,
      children: children!,
    );
  }

  /// Builds a standard Block layout (`Column` or Single Widget).
  Widget _buildBlockStructure(WindStyle styles, WindLogger logger) {
    // Optimization: Don't wrap a single child in a Column.
    if (children!.length == 1) {
      logger.setCoreWidget("child: ${children!.first}");
      return children!.first;
    }

    logger.setCoreWidget("Column(children: [${children!.length}])");
    return Column(
      mainAxisSize: styles.mainAxisSize ?? MainAxisSize.min,
      crossAxisAlignment: styles.crossAxisAlignment ?? CrossAxisAlignment.start,
      children: children!,
    );
  }

  /// **The Composition Pipeline**
  ///
  /// Wraps the core content with styling widgets.
  /// The order of execution is critical: **Inner Styles -> Outer Layout**.
  Widget _buildCompositionPipeline({
    required WindStyle styles,
    required Widget? content,
    required WindLogger logger,
  }) {
    Widget? widgetToBuild = content;

    // Check if we have overflow behavior that needs special handling
    final bool hasOverflowClip = styles.clipBehavior == Clip.hardEdge;
    final bool hasOverflowScroll =
        styles.overflow == WindOverflow.scroll ||
        styles.overflow == WindOverflow.auto ||
        styles.overflowX == WindOverflow.scroll ||
        styles.overflowX == WindOverflow.auto ||
        styles.overflowY == WindOverflow.scroll ||
        styles.overflowY == WindOverflow.auto;
    final bool hasOverflow = hasOverflowClip || hasOverflowScroll;

    // 1. INNER LAYER: Box Model & Decoration
    // ---------------------------------------------------------

    // Determine constraints (combining direct width/height with box constraints)
    BoxConstraints? constraints =
        (styles.width != null ||
            styles.height != null ||
            styles.constraints != null)
        ? (styles.constraints ?? const BoxConstraints()).copyWith(
            minWidth: styles.width ?? styles.constraints?.minWidth,
            maxWidth: styles.width ?? styles.constraints?.maxWidth,
            minHeight: styles.height ?? styles.constraints?.minHeight,
            maxHeight: styles.height ?? styles.constraints?.maxHeight,
          )
        : styles.constraints;

    // For overflow, we DON'T want to constrain children
    // Instead, we'll apply constraints to an outer SizedBox
    final BoxConstraints? innerConstraints = hasOverflow ? null : constraints;
    final BoxConstraints? outerConstraints = hasOverflow ? constraints : null;

    // Apply Container ONLY if we have box-specific properties
    final bool needsContainer =
        styles.decoration != null ||
        innerConstraints != null ||
        styles.boxShadow != null ||
        styles.ringShadow != null;

    // Track if padding is consumed by Container (so we don't apply it again)
    bool paddingConsumedByContainer = false;

    if (needsContainer) {
      // Merge decoration with shadows (boxShadow + ringShadow)
      BoxDecoration? finalDecoration = styles.decoration;

      // Combine box shadows and ring shadows
      List<BoxShadow>? combinedShadows;
      if (styles.boxShadow != null || styles.ringShadow != null) {
        combinedShadows = [...?styles.boxShadow, ...?styles.ringShadow];
      }

      if (combinedShadows != null && combinedShadows.isNotEmpty) {
        if (finalDecoration == null) {
          finalDecoration = BoxDecoration(boxShadow: combinedShadows);
        } else {
          finalDecoration = finalDecoration.copyWith(
            boxShadow: combinedShadows,
          );
        }
      }

      // Padding should be INSIDE the container (Tailwind behavior)
      final containerPadding = styles.padding;
      paddingConsumedByContainer =
          containerPadding != null && containerPadding != EdgeInsets.zero;

      // Use AnimatedContainer if transition duration is set
      if (styles.transitionDuration != null) {
        logger.wrapWith(
          "AnimatedContainer",
          "duration: ${styles.transitionDuration!.inMilliseconds}ms",
        );
        widgetToBuild = AnimatedContainer(
          duration: styles.transitionDuration!,
          curve: styles.transitionCurve ?? Curves.linear,
          constraints: innerConstraints,
          decoration: finalDecoration,
          padding: containerPadding,
          alignment: styles.alignment,
          child: widgetToBuild,
        );
      } else {
        logger.wrapWith("Container", "decoration/constraints/shadow");
        widgetToBuild = Container(
          constraints: innerConstraints,
          decoration: finalDecoration,
          padding: containerPadding,
          alignment: styles.alignment,
          child: widgetToBuild,
        );
      }
    }

    // 1c. EXPLICIT SIZING (w-*, h-* when not handled by overflow)
    // Apply SizedBox for explicit width/height regardless of Container
    // This ensures Tailwind-like behavior where child respects explicit sizing
    if (!hasOverflow && (styles.width != null || styles.height != null)) {
      logger.wrapWith(
        "SizedBox",
        "width: ${styles.width}, height: ${styles.height}",
      );
      widgetToBuild = SizedBox(
        width: styles.width,
        height: styles.height,
        child: widgetToBuild,
      );
    }

    // 1b. OVERFLOW HANDLING
    // Apply scroll/clip wrappers BEFORE outer sizing
    if (hasOverflowScroll) {
      if (styles.overflowX == WindOverflow.scroll ||
          styles.overflowX == WindOverflow.auto) {
        // Horizontal scroll only
        logger.wrapWith("SingleChildScrollView", "horizontal");
        widgetToBuild = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: widgetToBuild,
        );
      } else if (styles.overflowY == WindOverflow.scroll ||
          styles.overflowY == WindOverflow.auto) {
        // Vertical scroll only
        logger.wrapWith("SingleChildScrollView", "vertical");
        widgetToBuild = SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: widgetToBuild,
        );
      } else {
        // Both directions scroll - use nested ScrollViews
        logger.wrapWith("SingleChildScrollView", "both (nested)");
        widgetToBuild = SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: widgetToBuild,
          ),
        );
      }
    } else if (hasOverflowClip) {
      logger.wrapWith("ClipRect", "hardEdge");
      widgetToBuild = ClipRect(
        clipBehavior: Clip.hardEdge,
        child: OverflowBox(
          alignment: Alignment.topLeft,
          minWidth: 0,
          minHeight: 0,
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: widgetToBuild,
        ),
      );
    }

    // Apply outer sizing for overflow cases
    if (outerConstraints != null) {
      logger.wrapWith("SizedBox", "outer sizing for overflow");
      widgetToBuild = SizedBox(
        width: outerConstraints.maxWidth.isFinite
            ? outerConstraints.maxWidth
            : null,
        height: outerConstraints.maxHeight.isFinite
            ? outerConstraints.maxHeight
            : null,
        child: widgetToBuild,
      );
    }

    // 2. MIDDLE LAYER: Sizing & Spacing
    // ---------------------------------------------------------

    // Apply Fractional Sizing (e.g., w-1/2)
    if (styles.widthFactor != null || styles.heightFactor != null) {
      logger.wrapWith("FractionallySizedBox", "factor");
      widgetToBuild = FractionallySizedBox(
        widthFactor: styles.widthFactor,
        heightFactor: styles.heightFactor,
        child: widgetToBuild,
      );
    }

    // Apply Padding (p-*) - only if not already consumed by Container
    if (!paddingConsumedByContainer &&
        styles.padding != null &&
        styles.padding != EdgeInsets.zero) {
      logger.wrapWith("Padding", "${styles.padding}");
      widgetToBuild = Padding(padding: styles.padding!, child: widgetToBuild);
    }

    // Apply Margin (m-*)
    // Note: Margin wraps the element, but is inside layout wrappers like Expanded.
    if (styles.margin != null && styles.margin != EdgeInsets.zero) {
      logger.wrapWith("Padding (Margin)", "${styles.margin}");
      widgetToBuild = Padding(padding: styles.margin!, child: widgetToBuild);
    }

    // 3. OUTER LAYER: Parent Data / Layout Instructions
    // ---------------------------------------------------------
    // These must be the outermost widgets to communicate with parents (Row/Column).

    // Apply Alignment (align-self-*)
    if (styles.alignment != null) {
      logger.wrapWith("Align", "${styles.alignment}");
      widgetToBuild = Align(alignment: styles.alignment!, child: widgetToBuild);
    }

    // Apply mx-auto (horizontal centering like Tailwind)
    if (styles.marginXAuto) {
      logger.wrapWith("Align", "horizontal center (mx-auto)");
      widgetToBuild = Align(
        alignment: Alignment.topCenter,
        child: widgetToBuild,
      );
    }

    // Apply Flex/Expanded (flex-*)
    if (styles.flex != null) {
      logger.wrapWith("Expanded", "flex: ${styles.flex}");
      widgetToBuild = Expanded(
        flex: styles.flex!,
        child: widgetToBuild ?? const SizedBox.shrink(),
      );
    } else if (styles.flexFit != null) {
      logger.wrapWith("Flexible", "fit: ${styles.flexFit}");
      widgetToBuild = Flexible(
        fit: styles.flexFit!,
        child: widgetToBuild ?? const SizedBox.shrink(),
      );
    }

    return widgetToBuild ?? const SizedBox.shrink();
  }

  /// Helper to inject `SizedBox` gaps between list items.
  List<Widget> _buildGappedChildren({
    required List<Widget> children,
    required Axis direction,
    required double? gapX,
    required double? gapY,
  }) {
    if (children.isEmpty) return children;

    final double? gap = (direction == Axis.horizontal) ? gapX : gapY;
    if (gap == null || gap == 0) return children;

    return List<Widget>.generate(children.length * 2 - 1, (index) {
      if (index.isEven) return children[index ~/ 2];
      return direction == Axis.horizontal
          ? SizedBox(width: gap)
          : SizedBox(height: gap);
    });
  }

  /// Helper to translate `MainAxisAlignment` to `WrapAlignment`.
  WrapAlignment _translateMainAxisToWrap(MainAxisAlignment? alignment) {
    return switch (alignment) {
      MainAxisAlignment.start => WrapAlignment.start,
      MainAxisAlignment.end => WrapAlignment.end,
      MainAxisAlignment.center => WrapAlignment.center,
      MainAxisAlignment.spaceBetween => WrapAlignment.spaceBetween,
      MainAxisAlignment.spaceAround => WrapAlignment.spaceAround,
      MainAxisAlignment.spaceEvenly => WrapAlignment.spaceEvenly,
      _ => WrapAlignment.start,
    };
  }

  /// Helper to translate `CrossAxisAlignment` to `WrapCrossAlignment`.
  WrapCrossAlignment _translateCrossAxisToWrap(CrossAxisAlignment? alignment) {
    return switch (alignment) {
      CrossAxisAlignment.start => WrapCrossAlignment.start,
      CrossAxisAlignment.end => WrapCrossAlignment.end,
      CrossAxisAlignment.center => WrapCrossAlignment.center,
      _ => WrapCrossAlignment.start,
    };
  }
}
