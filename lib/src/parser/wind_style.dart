import 'package:flutter/material.dart';

enum WindDisplayType { block, flex, grid, wrap }

enum WindTextTransform { none, uppercase, lowercase, capitalize }

/// Overflow behavior types
enum WindOverflow { visible, hidden, scroll, auto }

/// Animation types for animate-* classes
enum WindAnimationType { spin, ping, pulse, bounce, none }

/// Position types for positioned elements e.g., relative, absolute
enum WindPositionType { relative, absolute }

/// **The Immutable Style Object**
///
/// `WindStyle` represents a resolved set of style properties derived from
/// utility classes. It is the "Output" of the `WindParser`.
///
/// It aggregates properties from all specialized parsers (Typography, Spacing,
/// Layout, etc.) into a single, flattening data structure that can be easily
/// consumed by widgets like `WDiv` or `WText`.
///
/// ### Characteristics:
/// - **Immutable:** Once created, it cannot be changed (use `copyWith`).
/// - **Comprehensive:** Covers all supported CSS-like properties.
/// - **Null-safe:** Properties are null if not specified by a utility class.
@immutable
class WindStyle {
  /// `hidden` property e.g., hidden
  final bool isHidden;

  /// `display` property e.g., block, flex, grid
  final WindDisplayType? displayType;

  /// `width` property e.g., w-100, w-lg, w-[200px]
  final double? width;

  /// `height` property e.g., h-100, h-lg, h-[200px]
  final double? height;

  /// `widthFactor` property e.g., w-1/2
  final double? widthFactor;

  /// `heightFactor` property e.g., h-1/2
  final double? heightFactor;

  /// `decoration` property e.g., bg-red-500, bg-url(...)
  final BoxDecoration? decoration;

  /// `constraints` property e.g., min-w-100, max-h-200
  final BoxConstraints? constraints;

  /// `padding` property e.g., p-4, px-2, py-3
  final EdgeInsets? padding;

  /// `margin` property e.g., m-4, mx-2, my-3
  final EdgeInsets? margin;

  /// Whether horizontal margin is auto (mx-auto) for centering
  final bool marginXAuto;

  /// Flex direction for flex display type e.g., flex-row, flex-col
  final Axis? flexDirection;

  /// Justify content for flex display type e.g., justify-center, justify-between
  final MainAxisAlignment? mainAxisAlignment;

  /// Align items for flex display type e.g., items-center, items-start
  final CrossAxisAlignment? crossAxisAlignment;

  /// Wrap alignment for flex display type e.g., align-content-start, align-content-center
  final WrapAlignment? runAlignment;

  /// Gap between items in flex or grid display type e.g., gap-4, gap-x-2, gap-y-3
  final double? gapX;

  /// Gap between rows in flex or grid display type e.g., gap-4, gap-x-2, gap-y-3
  final double? gapY;

  /// Main axis size for flex display type e.g., axis-min, axis-max
  final MainAxisSize? mainAxisSize;

  /// Flex properties for flex display type e.g., flex-1, flex-grow
  final int? flex;

  /// Flex fit for flex display type e.g., flex-auto, flex-none
  final FlexFit? flexFit;

  /// Fractional flex-basis along the parent's MAIN axis e.g., `basis-1/2`,
  /// `basis-full`. Resolved by the parent flex (`WDiv`) into a width factor
  /// (row) or height factor (column). This approximates CSS `flex-basis`: it
  /// sets the initial main-axis size and ignores grow/shrink interplay.
  final double? basisFactor;

  /// Fixed flex-basis along the parent's MAIN axis e.g., `basis-[120px]`.
  /// Resolved by the parent flex (`WDiv`) into a fixed width (row) or height
  /// (column). Like [basisFactor], this approximates CSS `flex-basis` and
  /// ignores grow/shrink interplay.
  final double? basisSize;

  /// Alignment for flex or grid display type e.g., align-self-center, align-self-start
  final Alignment? alignment;

  /// Text baseline for baseline alignment (required when using items-baseline)
  final TextBaseline? textBaseline;

  /// Number of grid columns for grid display type e.g., grid-cols-3
  final int? gridCols;

  /// Child order for flex reordering e.g., order-1, order-first, order-[5].
  /// Children without an `order-*` class default to `0` during stable sort.
  final int? order;

  /// Whether the flex main axis should be mirrored (flex-row-reverse /
  /// flex-col-reverse). Applied by the parent at layout time.
  final bool flexReverse;

  /// Text color e.g., text-red-500
  final Color? color;

  /// Text size e.g., text-sm, text-lg, text-[20px]
  final double? fontSize;

  /// Font weight e.g., font-bold, font-light
  final FontWeight? fontWeight;

  /// Font style e.g., italic, not-italic
  final FontStyle? fontStyle;

  /// Text letter spacing e.g., tracking-wide, tracking-tight
  final double? letterSpacing;

  /// Text line height e.g., leading-[15px]
  final double? heightLine;

  /// Text line height factor e.g., leading-1.5
  final double? heightLineFactor;

  /// Text decoration e.g., underline, line-through
  final TextDecoration? textDecoration;

  /// Text decoration color e.g., decoration-red-500
  final Color? textDecorationColor;

  /// Text decoration style e.g., decoration-dashed, decoration-dotted
  final TextDecorationStyle? textDecorationStyle;

  /// Text decoration thickness e.g., decoration-2, decoration-4
  final double? textDecorationThickness;

  /// Text align e.g., text-left, text-center, text-right
  final TextAlign? textAlign;

  /// Text overflow e.g., truncate, overflow-ellipsis
  final TextOverflow? textOverflow;

  /// Max lines e.g., line-clamp-3
  final int? maxLines;

  /// White space e.g., whitespace-normal, whitespace-nowrap
  final bool? softWrap;

  /// Text transform e.g., uppercase, lowercase, capitalize
  final WindTextTransform? textTransform;

  /// Font family e.g., font-sans, font-serif
  final String? fontFamily;

  /// Box shadow e.g., shadow-sm, shadow-xl
  final List<BoxShadow>? boxShadow;

  /// Shadow color e.g., shadow-red-500
  final Color? shadowColor;

  /// Enable debug mode to log style details
  final bool debug;

  /// Widget opacity e.g., opacity-50, opacity-[0.5]
  final double? opacity;

  /// Z-index for Stack ordering e.g., z-10, z-[100]
  final int? zIndex;

  /// Overflow behavior e.g., overflow-hidden
  final WindOverflow? overflow;

  /// Horizontal overflow behavior e.g., overflow-x-hidden
  final WindOverflow? overflowX;

  /// Vertical overflow behavior e.g., overflow-y-hidden
  final WindOverflow? overflowY;

  /// Clip behavior for overflow-hidden
  final Clip? clipBehavior;

  /// Aspect ratio e.g., aspect-square, aspect-video, aspect-[4/3]
  final double? aspectRatio;

  /// Transition duration e.g., duration-300, duration-[500ms]
  final Duration? transitionDuration;

  /// Transition curve e.g., ease-in, ease-out, ease-in-out
  final Curve? transitionCurve;

  /// Ring shadow e.g., ring, ring-2
  final List<BoxShadow>? ringShadow;

  /// Ring color e.g., ring-blue-500
  final Color? ringColor;

  /// Ring width e.g., ring-2, ring-4
  final double? ringWidth;

  /// Ring offset e.g., ring-offset-2
  final double? ringOffset;

  /// Ring inset e.g., ring-inset
  final bool? ringInset;

  // ============== SVG PROPERTIES ==============

  /// SVG fill color e.g., fill-red-500, fill-current
  final Color? fillColor;

  /// SVG stroke color e.g., stroke-blue-500, stroke-current
  final Color? strokeColor;

  /// When true, no [ColorFilter] is applied to the SVG — the widget renders
  /// with its own embedded colors unchanged. Use `preserve-colors` in className.
  /// Ideal for QR codes, logos, and multi-colour illustrations.
  final bool preserveColors;

  // ============== ANIMATION PROPERTIES ==============

  /// Animation type e.g., animate-spin, animate-pulse, animate-bounce
  final WindAnimationType? animationType;

  // ============== POSITIONING PROPERTIES ==============

  /// Position type e.g., relative, absolute
  final WindPositionType? positionType;

  /// Top offset for positioned elements e.g., top-4, top-[10px]
  final double? positionTop;

  /// Right offset for positioned elements e.g., right-4, right-[10px]
  final double? positionRight;

  /// Bottom offset for positioned elements e.g., bottom-4, bottom-[10px]
  final double? positionBottom;

  /// Left offset for positioned elements e.g., left-4, left-[10px]
  final double? positionLeft;

  const WindStyle({
    this.isHidden = false,
    this.displayType = WindDisplayType.block,
    this.decoration,
    this.width,
    this.height,
    this.widthFactor,
    this.heightFactor,
    this.constraints,
    this.padding,
    this.margin,
    this.marginXAuto = false,
    this.flexDirection,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
    this.runAlignment,
    this.gapX,
    this.gapY,
    this.mainAxisSize,
    this.flex,
    this.flexFit,
    this.basisFactor,
    this.basisSize,
    this.alignment,
    this.textBaseline,
    this.gridCols,
    this.order,
    this.flexReverse = false,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.heightLine,
    this.heightLineFactor,
    this.textDecoration,
    this.textDecorationColor,
    this.textDecorationStyle,
    this.textDecorationThickness,
    this.textAlign,
    this.textOverflow,
    this.maxLines,
    this.softWrap,
    this.textTransform,
    this.fontFamily,
    this.boxShadow,
    this.shadowColor,
    this.debug = false,
    this.opacity,
    this.zIndex,
    this.overflow,
    this.overflowX,
    this.overflowY,
    this.clipBehavior,
    this.aspectRatio,
    this.transitionDuration,
    this.transitionCurve,
    this.ringShadow,
    this.ringColor,
    this.ringWidth,
    this.ringOffset,
    this.ringInset,
    this.fillColor,
    this.strokeColor,
    this.animationType,
    this.preserveColors = false,
    this.positionType,
    this.positionTop,
    this.positionRight,
    this.positionBottom,
    this.positionLeft,
  });

  WindStyle copyWith({
    bool? isHidden,
    WindDisplayType? displayType,
    BoxDecoration? decoration,
    double? width,
    double? height,
    double? widthFactor,
    double? heightFactor,
    BoxConstraints? constraints,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool? marginXAuto,
    Axis? flexDirection,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    WrapAlignment? runAlignment,
    double? gapX,
    double? gapY,
    MainAxisSize? mainAxisSize,
    int? flex,
    FlexFit? flexFit,
    double? basisFactor,
    double? basisSize,
    Alignment? alignment,
    TextBaseline? textBaseline,
    int? gridCols,
    int? order,
    bool? flexReverse,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? heightLine,
    double? heightLineFactor,
    TextDecoration? textDecoration,
    Color? textDecorationColor,
    TextDecorationStyle? textDecorationStyle,
    double? textDecorationThickness,
    TextAlign? textAlign,
    TextOverflow? textOverflow,
    int? maxLines,
    bool? softWrap,
    WindTextTransform? textTransform,
    String? fontFamily,
    List<BoxShadow>? boxShadow,
    Color? shadowColor,
    bool? debug,
    double? opacity,
    int? zIndex,
    WindOverflow? overflow,
    WindOverflow? overflowX,
    WindOverflow? overflowY,
    Clip? clipBehavior,
    double? aspectRatio,
    Duration? transitionDuration,
    Curve? transitionCurve,
    List<BoxShadow>? ringShadow,
    Color? ringColor,
    double? ringWidth,
    double? ringOffset,
    bool? ringInset,
    Color? fillColor,
    Color? strokeColor,
    WindAnimationType? animationType,
    bool? preserveColors,
    WindPositionType? positionType,
    double? positionTop,
    double? positionRight,
    double? positionBottom,
    double? positionLeft,
  }) {
    // Preserve null when neither side carries a decoration. Fabricating an
    // empty BoxDecoration here would flip the `decoration != null` gate that
    // widgets use to decide whether to wrap a Container, so a padding-only or
    // text-only style would needlessly wrap one. Only build a merged
    // decoration when the incoming copyWith actually supplies one.
    final BoxDecoration? updatedDecoration = decoration == null
        ? this.decoration
        : (this.decoration ?? const BoxDecoration()).copyWith(
            color: decoration.color,
            image: decoration.image,
            border: decoration.border,
            borderRadius: decoration.borderRadius,
            boxShadow: decoration.boxShadow,
            gradient: decoration.gradient,
            backgroundBlendMode: decoration.backgroundBlendMode,
            shape: decoration.shape,
          );

    return WindStyle(
      isHidden: isHidden ?? this.isHidden,
      displayType: displayType ?? this.displayType,
      decoration: updatedDecoration,
      width: width ?? this.width,
      height: height ?? this.height,
      widthFactor: widthFactor ?? this.widthFactor,
      heightFactor: heightFactor ?? this.heightFactor,
      constraints: constraints ?? this.constraints,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      marginXAuto: marginXAuto ?? this.marginXAuto,
      flexDirection: flexDirection ?? this.flexDirection,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      runAlignment: runAlignment ?? this.runAlignment,
      gapX: gapX ?? this.gapX,
      gapY: gapY ?? this.gapY,
      mainAxisSize: mainAxisSize ?? this.mainAxisSize,
      flex: flex ?? this.flex,
      flexFit: flexFit ?? this.flexFit,
      basisFactor: basisFactor ?? this.basisFactor,
      basisSize: basisSize ?? this.basisSize,
      alignment: alignment ?? this.alignment,
      textBaseline: textBaseline ?? this.textBaseline,
      gridCols: gridCols ?? this.gridCols,
      order: order ?? this.order,
      flexReverse: flexReverse ?? this.flexReverse,
      color: color ?? this.color,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      fontStyle: fontStyle ?? this.fontStyle,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      heightLine: heightLine ?? this.heightLine,
      heightLineFactor: heightLineFactor ?? this.heightLineFactor,
      textDecoration: textDecoration ?? this.textDecoration,
      textDecorationColor: textDecorationColor ?? this.textDecorationColor,
      textDecorationStyle: textDecorationStyle ?? this.textDecorationStyle,
      textDecorationThickness:
          textDecorationThickness ?? this.textDecorationThickness,
      textAlign: textAlign ?? this.textAlign,
      textOverflow: textOverflow ?? this.textOverflow,
      maxLines: maxLines ?? this.maxLines,
      softWrap: softWrap ?? this.softWrap,
      textTransform: textTransform ?? this.textTransform,
      fontFamily: fontFamily ?? this.fontFamily,
      boxShadow: boxShadow ?? this.boxShadow,
      shadowColor: shadowColor ?? this.shadowColor,
      debug: debug ?? this.debug,
      opacity: opacity ?? this.opacity,
      zIndex: zIndex ?? this.zIndex,
      overflow: overflow ?? this.overflow,
      overflowX: overflowX ?? this.overflowX,
      overflowY: overflowY ?? this.overflowY,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      transitionCurve: transitionCurve ?? this.transitionCurve,
      ringShadow: ringShadow ?? this.ringShadow,
      ringColor: ringColor ?? this.ringColor,
      ringWidth: ringWidth ?? this.ringWidth,
      ringOffset: ringOffset ?? this.ringOffset,
      ringInset: ringInset ?? this.ringInset,
      fillColor: fillColor ?? this.fillColor,
      strokeColor: strokeColor ?? this.strokeColor,
      animationType: animationType ?? this.animationType,
      preserveColors: preserveColors ?? this.preserveColors,
      positionType: positionType ?? this.positionType,
      positionTop: positionTop ?? this.positionTop,
      positionRight: positionRight ?? this.positionRight,
      positionBottom: positionBottom ?? this.positionBottom,
      positionLeft: positionLeft ?? this.positionLeft,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WindStyle &&
          runtimeType == other.runtimeType &&
          isHidden == other.isHidden &&
          displayType == other.displayType &&
          decoration == other.decoration &&
          width == other.width &&
          height == other.height &&
          widthFactor == other.widthFactor &&
          heightFactor == other.heightFactor &&
          constraints == other.constraints &&
          padding == other.padding &&
          margin == other.margin &&
          marginXAuto == other.marginXAuto &&
          flexDirection == other.flexDirection &&
          mainAxisAlignment == other.mainAxisAlignment &&
          crossAxisAlignment == other.crossAxisAlignment &&
          runAlignment == other.runAlignment &&
          gapX == other.gapX &&
          gapY == other.gapY &&
          mainAxisSize == other.mainAxisSize &&
          flex == other.flex &&
          flexFit == other.flexFit &&
          basisFactor == other.basisFactor &&
          basisSize == other.basisSize &&
          alignment == other.alignment &&
          textBaseline == other.textBaseline &&
          gridCols == other.gridCols &&
          order == other.order &&
          flexReverse == other.flexReverse &&
          color == other.color &&
          fontSize == other.fontSize &&
          fontWeight == other.fontWeight &&
          fontStyle == other.fontStyle &&
          letterSpacing == other.letterSpacing &&
          heightLine == other.heightLine &&
          heightLineFactor == other.heightLineFactor &&
          textDecoration == other.textDecoration &&
          textDecorationColor == other.textDecorationColor &&
          textDecorationStyle == other.textDecorationStyle &&
          textDecorationThickness == other.textDecorationThickness &&
          textAlign == other.textAlign &&
          textOverflow == other.textOverflow &&
          maxLines == other.maxLines &&
          softWrap == other.softWrap &&
          textTransform == other.textTransform &&
          fontFamily == other.fontFamily &&
          boxShadow == other.boxShadow &&
          shadowColor == other.shadowColor &&
          debug == other.debug &&
          opacity == other.opacity &&
          zIndex == other.zIndex &&
          overflow == other.overflow &&
          overflowX == other.overflowX &&
          overflowY == other.overflowY &&
          clipBehavior == other.clipBehavior &&
          aspectRatio == other.aspectRatio &&
          transitionDuration == other.transitionDuration &&
          transitionCurve == other.transitionCurve &&
          ringShadow == other.ringShadow &&
          ringColor == other.ringColor &&
          ringWidth == other.ringWidth &&
          ringOffset == other.ringOffset &&
          ringInset == other.ringInset &&
          fillColor == other.fillColor &&
          strokeColor == other.strokeColor &&
          animationType == other.animationType &&
          preserveColors == other.preserveColors &&
          positionType == other.positionType &&
          positionTop == other.positionTop &&
          positionRight == other.positionRight &&
          positionBottom == other.positionBottom &&
          positionLeft == other.positionLeft;

  @override
  int get hashCode =>
      isHidden.hashCode ^
      displayType.hashCode ^
      decoration.hashCode ^
      width.hashCode ^
      height.hashCode ^
      widthFactor.hashCode ^
      heightFactor.hashCode ^
      constraints.hashCode ^
      padding.hashCode ^
      margin.hashCode ^
      marginXAuto.hashCode ^
      flexDirection.hashCode ^
      mainAxisAlignment.hashCode ^
      crossAxisAlignment.hashCode ^
      runAlignment.hashCode ^
      gapX.hashCode ^
      gapY.hashCode ^
      mainAxisSize.hashCode ^
      flex.hashCode ^
      flexFit.hashCode ^
      basisFactor.hashCode ^
      basisSize.hashCode ^
      alignment.hashCode ^
      textBaseline.hashCode ^
      gridCols.hashCode ^
      order.hashCode ^
      flexReverse.hashCode ^
      color.hashCode ^
      fontSize.hashCode ^
      fontWeight.hashCode ^
      fontStyle.hashCode ^
      letterSpacing.hashCode ^
      heightLine.hashCode ^
      heightLineFactor.hashCode ^
      textDecoration.hashCode ^
      textDecorationColor.hashCode ^
      textDecorationStyle.hashCode ^
      textDecorationThickness.hashCode ^
      textAlign.hashCode ^
      textOverflow.hashCode ^
      maxLines.hashCode ^
      softWrap.hashCode ^
      textTransform.hashCode ^
      fontFamily.hashCode ^
      boxShadow.hashCode ^
      shadowColor.hashCode ^
      debug.hashCode ^
      opacity.hashCode ^
      zIndex.hashCode ^
      overflow.hashCode ^
      overflowX.hashCode ^
      overflowY.hashCode ^
      clipBehavior.hashCode ^
      aspectRatio.hashCode ^
      transitionDuration.hashCode ^
      transitionCurve.hashCode ^
      ringShadow.hashCode ^
      ringColor.hashCode ^
      ringWidth.hashCode ^
      ringOffset.hashCode ^
      ringInset.hashCode ^
      fillColor.hashCode ^
      strokeColor.hashCode ^
      animationType.hashCode ^
      preserveColors.hashCode ^
      positionType.hashCode ^
      positionTop.hashCode ^
      positionRight.hashCode ^
      positionBottom.hashCode ^
      positionLeft.hashCode;

  /// Calculates the effective line height as a multiplier for TextStyle.height.
  ///
  /// Flutter's TextStyle.height is a multiplier (e.g., 1.5 means 1.5x font size).
  /// - `heightLine` is stored as pixels, so we divide by fontSize to get multiplier
  /// - `heightLineFactor` is already a multiplier (e.g., from `leading-loose`)
  double? get effectiveLineHeight {
    if (heightLine != null && fontSize != null && fontSize! > 0) {
      // Convert pixel value to multiplier: 36px / 24px = 1.5
      return heightLine! / fontSize!;
    } else if (heightLineFactor != null) {
      // Already a factor like 1.5
      return heightLineFactor;
    }
    return null;
  }

  /// Converts the typography properties of this `WindStyle` into a
  /// Flutter `TextStyle`.
  ///
  /// This allows `WDiv` to pass these styles down to its children via
  /// `DefaultTextStyle`, enabling CSS-like inheritance.
  TextStyle toTextStyle() {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      height: effectiveLineHeight,
      decoration: textDecoration,
      decorationColor: textDecorationColor,
      decorationStyle: textDecorationStyle,
      decorationThickness: textDecorationThickness,
      fontFamily: fontFamily,
    );
  }

  @override
  String toString() {
    return 'WindStyle{'
        'isHidden: $isHidden, '
        'displayType: $displayType, '
        'decoration: $decoration, '
        'width: $width, '
        'height: $height, '
        'widthFactor: $widthFactor, '
        'heightFactor: $heightFactor, '
        'constraints: $constraints, '
        'padding: $padding, '
        'margin: $margin, '
        'marginXAuto: $marginXAuto, '
        'flexDirection: $flexDirection, '
        'mainAxisAlignment: $mainAxisAlignment, '
        'crossAxisAlignment: $crossAxisAlignment, '
        'runAlignment: $runAlignment, '
        'gapX: $gapX, '
        'gapY: $gapY, '
        'mainAxisSize: $mainAxisSize, '
        'flex: $flex, '
        'flexFit: $flexFit, '
        'basisFactor: $basisFactor, '
        'basisSize: $basisSize, '
        'alignment: $alignment, '
        'textBaseline: $textBaseline, '
        'gridCols: $gridCols, '
        'order: $order, '
        'flexReverse: $flexReverse, '
        'color: $color, '
        'fontSize: $fontSize, '
        'fontWeight: $fontWeight, '
        'fontStyle: $fontStyle, '
        'letterSpacing: $letterSpacing, '
        'heightLine: $heightLine, '
        'heightLineFactor: $heightLineFactor, '
        'textDecoration: $textDecoration, '
        'textDecorationColor: $textDecorationColor, '
        'textDecorationStyle: $textDecorationStyle, '
        'textDecorationThickness: $textDecorationThickness, '
        'textAlign: $textAlign, '
        'textOverflow: $textOverflow, '
        'maxLines: $maxLines, '
        'softWrap: $softWrap, '
        'textTransform: $textTransform, '
        'fontFamily: $fontFamily, '
        'boxShadow: $boxShadow, '
        'shadowColor: $shadowColor, '
        'debug: $debug, '
        'opacity: $opacity, '
        'zIndex: $zIndex, '
        'overflow: $overflow, '
        'overflowX: $overflowX, '
        'overflowY: $overflowY, '
        'clipBehavior: $clipBehavior, '
        'aspectRatio: $aspectRatio, '
        'transitionDuration: $transitionDuration, '
        'transitionCurve: $transitionCurve, '
        'ringShadow: $ringShadow, '
        'ringColor: $ringColor, '
        'ringWidth: $ringWidth, '
        'ringOffset: $ringOffset, '
        'ringInset: $ringInset, '
        'fillColor: $fillColor, '
        'strokeColor: $strokeColor, '
        'animationType: $animationType, '
        'preserveColors: $preserveColors, '
        'positionType: $positionType, '
        'positionTop: $positionTop, '
        'positionRight: $positionRight, '
        'positionBottom: $positionBottom, '
        'positionLeft: $positionLeft'
        '}';
  }
}
