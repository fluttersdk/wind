import 'package:flutter/material.dart';

import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';
import '../state/wind_flex_overflow_scope.dart';
import '../utils/wind_logger.dart';
import '../utils/wind_perf_counters.dart';

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
///
/// See also:
///
///  * [WDiv], which is the primary container for composing layouts around `WText` nodes.
///  * [WAnchor], which wraps `WText` when interactive states (hover, focus) are needed.
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

  /// Inline text color for **runtime-dynamic** values (e.g. a user-picked
  /// brand color).
  ///
  /// Use `className: 'text-*'` for static design tokens. Reach for this prop
  /// only when the color is a runtime value that would otherwise bloat the
  /// parser cache via `text-[#\$hex]` interpolation.
  ///
  /// When non-null, this overrides any `text-*` / `dark:text-*` resolved
  /// from [className]. Does NOT participate in the parser cache key.
  final Color? foregroundColor;

  const WText(
    this.data, {
    super.key,
    this.className,
    this.style,
    this.textStyle,
    this.selectable = false,
    this.states,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // WText has no _buildImpl indirection: build() resolves styles directly,
    // so this is its equivalent of WDiv's counting site.
    WindPerfCounters.recordWTextBuild();

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
  ///
  /// Guarantees two baseline requirements when no Material/Scaffold ancestor
  /// is present so Flutter's debug yellow-underline fallback never appears:
  ///   1. A non-null text color (brightness-aware fallback: [Colors.white] on
  ///      dark platforms, [Colors.black] on light).
  ///   2. A [Directionality] ancestor (defaults to [TextDirection.ltr]).
  Widget _buildCoreContent({
    required BuildContext context,
    required WindStyle styles,
    required WindLogger logger,
  }) {
    // A. Build TextStyle from className tokens.
    // This style contains `null` for properties not set in the className.
    final TextStyle windTextStyle = styles.toTextStyle();

    // Merge with the explicit `textStyle` prop so callers can supply
    // additional Flutter-native properties (e.g. letterSpacing).
    TextStyle finalTextStyle = windTextStyle.merge(textStyle);

    // Inline foregroundColor wins over any parsed text-* / dark:text-*.
    if (foregroundColor != null) {
      finalTextStyle = finalTextStyle.copyWith(color: foregroundColor);
    }

    // Color resolution when className, foregroundColor, and textStyle leave
    // the color unset, in CSS-cascade order:
    //   1. Inherit an ancestor DefaultTextStyle color when one exists. A parent
    //      `WDiv` with a `text-*` class publishes one (via DefaultTextStyle.merge),
    //      and so does a Material ancestor. Leaving the color null lets Flutter's
    //      Text merge that ancestor color, exactly like text color cascades in CSS.
    //      Without this, a colorless WText inside a styled container (e.g. a
    //      secondary button whose text color lives on the container) was painted
    //      with the platform-brightness fallback instead of the container color,
    //      so it vanished whenever the app theme disagreed with the OS theme.
    //   2. Only when no ancestor supplies a color (bare text with no Material
    //      ancestor, which would otherwise render Flutter's debug yellow
    //      underline) fall back to a brightness-aware neutral so the text stays
    //      legible. Explicitly supplied colors always win.
    if (finalTextStyle.color == null &&
        DefaultTextStyle.of(context).style.color == null) {
      final isDark =
          MediaQuery.maybePlatformBrightnessOf(context) == Brightness.dark;
      finalTextStyle = finalTextStyle.copyWith(
        color: isDark ? Colors.white : Colors.black,
      );
    }

    // B. Apply Text Transformation (uppercase, lowercase)
    final String transformedData = _applyTextTransform(
      context,
      data,
      styles.textTransform,
    );

    // C. Determine Text Widget Type
    // Check if 'selectable' class is present in addition to the prop
    final bool isSelectable =
        selectable || (className?.contains('selectable') ?? false);

    Widget textWidget;
    if (isSelectable) {
      logger.setCoreWidget("SelectableText('$transformedData')");
      textWidget = SelectableText(
        transformedData,
        style: finalTextStyle,
        textAlign: styles.textAlign,
        maxLines: styles.maxLines,
        // SelectableText doesn't support overflow directly in the same way
      );
    } else {
      logger.setCoreWidget("Text('$transformedData')");
      textWidget = Text(
        transformedData,
        style: finalTextStyle,
        textAlign: styles.textAlign,
        overflow: styles.textOverflow,
        maxLines: styles.maxLines,
        softWrap: styles.softWrap,
      );
    }

    // D. Directionality guarantee: provide a default TextDirection.ltr when
    // no ancestor supplies one, so bare usages outside MaterialApp/WidgetsApp
    // do not throw "No Directionality widget found".
    if (Directionality.maybeOf(context) == null) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: textWidget,
      );
    }

    return textWidget;
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

    // Step E: Flex (Expanded/Flexible), skipped inside a scrollable main axis.
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

  /// The language codes whose usual alphabet distinguishes a dotted from a
  /// dotless `i`, and whose casing therefore cannot go through Dart's
  /// locale-independent `String.toUpperCase` / `toLowerCase`.
  ///
  /// Matched on `languageCode` alone, so Azerbaijani in Cyrillic script
  /// (`az-Cyrl`, which has no dotless `i`) takes this path too. That is not a
  /// defect and is why the set is not narrowed by `scriptCode`: Cyrillic text
  /// contains no `i` or `ı` for the swaps to find, so the result is identical to
  /// the locale-independent one. Only Latin-script loanwords inside otherwise
  /// Cyrillic copy would differ, and a locale that mixes them is better served
  /// by the Turkish mapping than by neither.
  static const Set<String> _dottedIlanguages = <String>{'tr', 'az'};

  /// Applies text transformations (uppercase, lowercase, capitalize) under the
  /// AMBIENT locale's casing rules.
  ///
  /// `String.toUpperCase()` is locale-independent and maps `i` to `I`. In
  /// Turkish and Azerbaijani the uppercase of `i` is `İ` and the uppercase of
  /// `ı` is `I`, so `uppercase` on a Turkish heading produced `IZLEYICILER` and
  /// `GÜVENLIK`, which are not words. This is user COPY rather than a wire
  /// token, so it is the one casing site in this package that must follow the
  /// locale; every other `toUpperCase` / `toLowerCase` here normalises a class
  /// name or a key and must stay locale-independent.
  ///
  /// [Localizations.maybeLocaleOf] rather than `localeOf`, so a widget pumped
  /// with no `Localizations` ancestor (which every bare widget test does) keeps
  /// today's behaviour instead of throwing.
  String _applyTextTransform(
    BuildContext context,
    String text,
    WindTextTransform? transform,
  ) {
    if (transform == null || transform == WindTextTransform.none) return text;

    final String? language = Localizations.maybeLocaleOf(context)?.languageCode;
    final bool dottedI = _dottedIlanguages.contains(language);

    switch (transform) {
      case WindTextTransform.uppercase:
        return dottedI ? _upperTr(text) : text.toUpperCase();
      case WindTextTransform.lowercase:
        return dottedI ? _lowerTr(text) : text.toLowerCase();
      case WindTextTransform.capitalize:
        return _capitalizeWords(text, dottedI: dottedI);
      case WindTextTransform.none:
        return text;
    }
  }

  /// A letter that opens a word: any letter not preceded by a character that
  /// keeps the previous word going.
  ///
  /// The lookbehind class is what browsers do rather than what the spec reads
  /// like, measured in Chromium over 27 strings. A letter, a digit, connector
  /// punctuation and an apostrophe continue a word, so the letter behind one
  /// stays as typed: `3rd party` is `3rd Party`, `wind_ui` is `Wind_ui` and
  /// `l'orange` is `L'orange`. Everything else separates, so the quote in
  /// `"quoted words"` and the hyphen, slash, period and plus in `well-known`,
  /// `read/write`, `u.s.a.` and `a+b=c` all open a new word.
  ///
  /// Combining marks and format characters continue a word too, and they are
  /// the arm that has to be deliberate: a decomposed `naïve` is `n a i U+0308
  /// v e`, so without `\p{M}` the `v` reads as a word initial and NFD text
  /// capitalises mid-word (`NaïVe`). macOS hands back NFD and Flutter does not
  /// normalise, so it takes no unusual input to hit. `\p{Cf}` is the same case
  /// for an invisible character: `co` + U+00AD + `operate` renders `Cooperate`
  /// in a browser, not `CoOperate`.
  ///
  /// The match is the letter alone, so whitespace never enters the replacement
  /// and the original spacing survives untouched.
  static final RegExp _wordInitialPattern = RegExp(
    r"(?<![\p{L}\p{N}\p{Pc}\p{M}\p{Cf}'’])\p{L}",
    unicode: true,
  );

  /// Uppercases the first letter of every word, leaving the rest as typed.
  ///
  /// This is what CSS `text-transform: capitalize` does, and the word is the
  /// unit rather than the string: `the HTTP client` becomes `The HTTP Client`,
  /// with the acronym the caller typed intact. [_wordInitialPattern] carries
  /// what counts as a word here.
  ///
  /// [dottedI] routes each word initial through the Turkish mapping, so
  /// `izleyici ışıkları` capitalises to `İzleyici Işıkları` rather than
  /// `Izleyici Işıkları`.
  static String _capitalizeWords(String text, {required bool dottedI}) {
    return text.replaceAllMapped(
      _wordInitialPattern,
      (Match match) => dottedI ? _upperTr(match[0]!) : match[0]!.toUpperCase(),
    );
  }

  /// Uppercases under Turkish rules.
  ///
  /// Measured, because only one of the two mappings is actually missing:
  /// `'izleyici'.toUpperCase()` is `IZLEYICI` (wrong, the fix), while
  /// `'Kullanılan'.toUpperCase()` is already `KULLANILAN` (right, so the `ı`
  /// arm is belt-and-braces for a mixed string rather than a correction).
  /// Every other Turkish letter (`ş`, `ğ`, `ö`, `ü`, `ç`) casts correctly on its
  /// own, and `İ` survives the second pass unchanged.
  static String _upperTr(String text) =>
      text.replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();

  /// Lowercases under Turkish rules.
  ///
  /// `I` is the mapping that is missing: Dart lowers it to `i` where Turkish
  /// needs `ı`. The swap therefore has to run BEFORE `toLowerCase`, or the `I`
  /// is already an `i` by the time it is looked for. `'İZLEYİCİ'.toLowerCase()`
  /// is measured to give a clean `izleyici` with no combining dot, so that arm
  /// is the belt-and-braces one here.
  static String _lowerTr(String text) =>
      text.replaceAll('I', 'ı').replaceAll('İ', 'i').toLowerCase();
}
