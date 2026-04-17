import 'package:flutter/material.dart';

import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';
import '../state/wind_flex_overflow_scope.dart';
import '../utils/wind_logger.dart';

/// **The Utility-First Text Component**
///
/// `WText` is the specialized widget for rendering typography in the Wind framework.
/// It applies the "Intelligent Composition" philosophy to text, separating
/// typography styles (font, color, line-height) from layout styles (padding, margin, flex).
///
/// It acts as a "Controller", delegating parsing to [WindParser] and
/// rendering to specialized private builders.
///
/// ### Supported Features:
/// - **Typography:** `text-lg`, `font-bold`, `uppercase`, `text-center`
/// - **Colors:** `text-blue-500`, `text-opacity-50`, `text-[#FF0000]`
/// - **Formatting:** `truncate`, `line-clamp-2`, `leading-loose`, `tracking-wide`
/// - **Decoration:** `underline`, `line-through`
/// - **Layout:** `p-4`, `m-2`, `flex-1` (when inside Flex)
///
/// ### Example Usage:
///
/// ```dart
/// WText(
///   'Hello World',
///   className: 'text-xl text-blue-500 font-bold text-center p-4 uppercase',
/// )
/// ```
class WText extends StatelessWidget {
  /// The text string to display.
  final String data;

  /// The string of Tailwind-like utility classes.
  ///
  /// Supports:
  /// - **Font:** `font-sans`, `font-bold`, `italic`
  /// - **Size:** `text-xs`, `text-xl`, `text-4xl`
  /// - **Color:** `text-white`, `text-slate-500`
  /// - **Align:** `text-center`, `text-right`
  /// - **Spacing:** `p-2`, `m-4` (applied to container)
  ///
  /// Example:
  /// ```dart
  /// className: "text-lg font-semibold text-gray-800 p-2"
  /// ```
  final String? className;

  /// An explicit WindStyle object to serve as the base style.
  final WindStyle? style;

  /// Explicit TextStyle to merge with the parsed styles.
  ///
  /// **Usage:**
  /// Use this when you want to inherit from standard Flutter themes or
  /// apply dynamic TextStyle properties not available in utility classes.
  ///
  /// *Note: `className` styles take precedence over this textStyle.*
  final TextStyle? textStyle;

  /// Whether the text should be selectable.
  /// If true, renders [SelectableText] instead of [Text].
  final bool selectable;

  /// Custom states for dynamic state styling (e.g., 'loading', 'selected').
  final Set<String>? states;

  const WText(
    this.data, {
    super.key,
    this.className,
    this.style,
    this.textStyle,
    this.selectable = false,
    this.states,
  });

  @override
  Widget build(BuildContext context) {
    // 1. CALL THE "ORCHESTRATOR": Style Resolution final
    WindStyle styles = className != null
        ? WindParser.parse(
            className!,
            context,
            baseStyle: style,
            states: states,
          )
        : style ?? const WindStyle();

    // 2. INITIALIZE DEBUGGER
    final logger = WindLogger(
      debug: styles.debug,
      widgetName: runtimeType.toString(),
    );

    if (styles.debug) {
      logger.logStep("ClassName", "'$className'");
      logger.logStep("Data", "'$data'");
      logger.setFinalStyles(styles);
    }

    // 3. VISIBILITY CHECK
    if (styles.isHidden) {
      logger.logStep("Visibility", "Hidden (returning SizedBox.shrink)");
      logger.printFinalCode();
      return const SizedBox.shrink();
    }

    // 4. DELEGATE CORE CONTENT CREATION (SRP)
    // Builds the Text widget with correct typography.
    final Widget coreContent = _buildCoreContent(
      context: context,
      styles: styles,
      logger: logger,
    );

    // 5. DELEGATE COMPOSITION PIPELINE (SRP)
    // Wraps the text in layout widgets (Padding, Container, Expanded, etc.)
    final bool skipFlexWrap =
        WindFlexOverflowScope.maybeOf(context)?.skipExpanded ?? false;

    final Widget finalWidget = _buildCompositionPipeline(
      styles: styles,
      content: coreContent,
      logger: logger,
      skipFlexWrap: skipFlexWrap,
    );

    // 6. FINALIZE
    logger.printFinalCode();
    return finalWidget;
  }

  /// (HELPER 1) Core Typography Builder
  ///
  /// Constructs the Text or SelectableText widget and applies
  /// all typography-related styles (color, font, align, transform).
  Widget _buildCoreContent({
    required BuildContext context,
    required WindStyle styles,
    required WindLogger logger,
  }) {
    // A. Build TextStyle
    // Use the helper from WindStyle. This style will contain `null` for
    // properties not set in the className.
    final TextStyle windTextStyle = styles.toTextStyle();

    // Merge with explicit `textStyle` prop.
    // Note: We do NOT manually merge with DefaultTextStyle here.
    // The `Text` widget does that automatically for null properties.
    final TextStyle finalTextStyle = windTextStyle.merge(textStyle);

    // B. Apply Text Transformation (uppercase, lowercase)
    final String transformedData = _applyTextTransform(
      data,
      styles.textTransform,
    );

    // C. Determine Text Widget Type
    // Check if 'selectable' class is present in addition to the prop
    final bool isSelectable =
        selectable || (className?.contains('selectable') ?? false);

    if (isSelectable) {
      logger.setCoreWidget("SelectableText('$transformedData')");
      return SelectableText(
        transformedData,
        style: finalTextStyle,
        textAlign: styles.textAlign,
        maxLines: styles.maxLines,
        // SelectableText doesn't support overflow directly in the same way
      );
    } else {
      logger.setCoreWidget("Text('$transformedData')");
      return Text(
        transformedData,
        style: finalTextStyle,
        textAlign: styles.textAlign,
        overflow: styles.textOverflow,
        maxLines: styles.maxLines,
        softWrap: styles.softWrap,
      );
    }
  }

  /// (HELPER 2) Composition Pipeline
  ///
  /// Wraps the core Text widget with layout and decoration widgets.
  /// Order: Padding > Container (Bg) > Margin > Alignment > Flex.
  Widget _buildCompositionPipeline({
    required WindStyle styles,
    required Widget content,
    required WindLogger logger,
    bool skipFlexWrap = false,
  }) {
    Widget widgetToBuild = content;

    // Step A: Decoration (Background Color / Border)
    // Text can have a background color via `bg-` classes.
    final bool needsContainer = styles.decoration != null ||
        styles.width != null ||
        styles.height != null ||
        styles.constraints != null;

    if (needsContainer) {
      // Combine constraints
      final BoxConstraints? constraints = (styles.width != null ||
              styles.height != null ||
              styles.constraints != null)
          ? (styles.constraints ?? const BoxConstraints()).copyWith(
              minWidth: styles.width ?? styles.constraints?.minWidth,
              maxWidth: styles.width ?? styles.constraints?.maxWidth,
              minHeight: styles.height ?? styles.constraints?.minHeight,
              maxHeight: styles.height ?? styles.constraints?.maxHeight,
            )
          : styles.constraints;

      logger.wrapWith("Container", "decoration: ${styles.decoration}");
      widgetToBuild = Container(
        decoration: styles.decoration,
        constraints: constraints,
        child: widgetToBuild,
      );
    }

    // Step B: Padding
    if (styles.padding != null && styles.padding != EdgeInsets.zero) {
      logger.wrapWith("Padding", "padding: ${styles.padding}");
      widgetToBuild = Padding(padding: styles.padding!, child: widgetToBuild);
    }

    // Step C: Margin
    if (styles.margin != null && styles.margin != EdgeInsets.zero) {
      logger.wrapWith("Padding (Margin)", "padding: ${styles.margin}");
      widgetToBuild = Padding(padding: styles.margin!, child: widgetToBuild);
    }

    // Step D: Alignment (align-self)
    if (styles.alignment != null) {
      logger.wrapWith("Align", "alignment: ${styles.alignment}");
      widgetToBuild = Align(alignment: styles.alignment!, child: widgetToBuild);
    }

    // Step E: Flex (Expanded/Flexible) — skipped inside a scrollable main axis.
    if (!skipFlexWrap) {
      if (styles.flex != null) {
        logger.wrapWith("Expanded", "flex: ${styles.flex}");
        widgetToBuild = Expanded(flex: styles.flex!, child: widgetToBuild);
      } else if (styles.flexFit != null) {
        logger.wrapWith("Flexible", "fit: ${styles.flexFit}");
        widgetToBuild = Flexible(fit: styles.flexFit!, child: widgetToBuild);
      }
    }

    return widgetToBuild;
  }

  /// Applies text transformations (uppercase, lowercase, capitalize).
  String _applyTextTransform(String text, WindTextTransform? transform) {
    if (transform == null) return text;
    switch (transform) {
      case WindTextTransform.uppercase:
        return text.toUpperCase();
      case WindTextTransform.lowercase:
        return text.toLowerCase();
      case WindTextTransform.capitalize:
        if (text.isEmpty) {
          return text;
        }
        // Simple capitalization: first letter upper, rest as-is.
        return text[0].toUpperCase() + text.substring(1);
      case WindTextTransform.none:
        return text;
    }
  }
}
