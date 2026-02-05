import 'package:flutter/widgets.dart';

import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';
import '../utils/wind_logger.dart';

/// Signature for building a custom error widget.
typedef ImageErrorBuilder = Widget Function(
    BuildContext context, Object error, StackTrace? stackTrace);

/// Signature for building a custom loading widget.
typedef ImageLoadingBuilder = Widget Function(
  BuildContext context,
  Widget child,
  ImageChunkEvent? loadingProgress,
);

/// **The Utility-First Image Component**
///
/// `WImage` brings HTML `<img>` semantics to Flutter with Tailwind-like
/// utility classes for styling.
///
/// ### Supported Features:
/// - **Sources:** Network URLs or `asset://` paths
/// - **Sizing:** `w-32`, `h-32`, `w-full`, `max-w-md`
/// - **Fit:** `object-cover`, `object-contain`, `object-fill`
/// - **Aspect Ratio:** `aspect-video`, `aspect-square`, `aspect-[4/3]`
/// - **Decoration:** `rounded-lg`, `shadow-md`, `border-2`, `opacity-90`
///
/// ### Example Usage:
///
/// ```dart
/// WImage(
///   src: 'https://example.com/photo.jpg',
///   alt: 'User Avatar',
///   className: 'w-24 h-24 rounded-full object-cover border-2 border-white shadow-sm',
/// )
/// ```
///
/// ### Asset Image:
///
/// ```dart
/// WImage(
///   src: 'asset://assets/images/logo.png',
///   className: 'w-24 h-24',
/// )
/// ```
class WImage extends StatelessWidget {
  /// The image source URL.
  ///
  /// For network images, use a standard URL.
  /// For asset images, prefix with `asset://` (e.g., `asset://assets/logo.png`)
  final String? src;

  /// The image provider.
  ///
  /// If `src` is provided, it will be used to create an `ImageProvider`.
  /// If `image` is provided, it will be used as the image source.
  final ImageProvider? image;

  /// Alternative text for accessibility.
  final String? alt;

  /// Tailwind-like utility classes for styling.
  ///
  /// Supports:
  /// - **Dimensions:** `w-full`, `h-64`, `min-h-[200px]`
  /// - **Object Fit:** `object-cover` (default), `object-contain`
  /// - **Aspect Ratio:** `aspect-video`, `aspect-square`
  /// - **Appearance:** `rounded-lg`, `shadow-xl`, `opacity-75`
  ///
  /// Example: `'w-full aspect-video object-cover rounded-xl shadow-sm'`
  final String? className;

  /// Custom states for dynamic styling.
  final Set<String>? states;

  /// Widget to show while the image is loading.
  final Widget? placeholder;

  /// Builder for custom error handling.
  final ImageErrorBuilder? errorBuilder;

  /// Builder for custom loading indicator.
  final ImageLoadingBuilder? loadingBuilder;

  /// Creates a new [WImage] instance.
  const WImage({
    super.key,
    this.src,
    this.image,
    this.alt,
    this.className,
    this.states,
    this.placeholder,
    this.errorBuilder,
    this.loadingBuilder,
  }) : assert(src != null || image != null);

  /// Check if the source is an asset image
  bool get _isAsset => src != null && src!.startsWith('asset://');

  /// Get the actual path for asset images
  String get _assetPath => src != null ? src!.replaceFirst('asset://', '') : '';

  @override
  Widget build(BuildContext context) {
    // Parse styles from className
    final WindStyle styles = className != null
        ? WindParser.parse(className!, context, states: states)
        : const WindStyle();

    // Parse object-fit from className
    final BoxFit fit = _parseObjectFit(className);

    // Build the image widget
    Widget imageWidget = image != null
        ? Image(
            image: image!,
            fit: fit,
            semanticLabel: alt,
            errorBuilder: errorBuilder,
          )
        : (_isAsset
            ? Image.asset(
                _assetPath,
                fit: fit,
                semanticLabel: alt,
                errorBuilder: errorBuilder,
              )
            : Image.network(
                src!,
                fit: fit,
                semanticLabel: alt,
                errorBuilder: errorBuilder,
                loadingBuilder: loadingBuilder ??
                    (placeholder != null
                        ? (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return placeholder!;
                          }
                        : null),
              ));

    // Apply decoration (rounded corners) immediately via ClipRRect
    final BorderRadius borderRadius =
        (styles.decoration?.borderRadius as BorderRadius?) ?? BorderRadius.zero;

    if (styles.decoration != null && borderRadius != BorderRadius.zero) {
      imageWidget = ClipRRect(borderRadius: borderRadius, child: imageWidget);
    }

    // Apply border
    if (styles.decoration != null) {
      imageWidget = Container(
        decoration: styles.decoration,
        child: imageWidget,
      );
    }

    // Apply aspect ratio (must be inside sized container)
    if (styles.aspectRatio != null) {
      imageWidget = AspectRatio(
        aspectRatio: styles.aspectRatio!,
        child: imageWidget,
      );
    }

    // Apply sizing (outermost wrapper to provide constraints)
    if (styles.width != null || styles.height != null) {
      imageWidget = SizedBox(
        width: styles.width,
        height: styles.height,
        child: imageWidget,
      );
    }

    // Apply opacity
    if (styles.opacity != null) {
      imageWidget = Opacity(opacity: styles.opacity!, child: imageWidget);
    }

    // Logger integration
    final logger = WindLogger(
      debug: styles.debug,
      widgetName: runtimeType.toString(),
    );

    if (styles.debug) {
      logger.logStep("ClassName", "'$className'");
      logger.logStep("Source", "'$src'");
      logger.setCoreWidget(
        _isAsset ? "Image.asset('$_assetPath')" : "Image.network('$src')",
      );
      logger.setFinalStyles(styles);
      if (styles.width != null || styles.height != null) {
        logger.wrapWith("SizedBox", "w: ${styles.width}, h: ${styles.height}");
      }
      if (styles.decoration?.borderRadius != null) {
        logger.wrapWith(
          "ClipRRect",
          "radius: ${styles.decoration!.borderRadius}",
        );
      }
      logger.printFinalCode();
    }

    return imageWidget;
  }

  /// Parse object-fit classes from className
  BoxFit _parseObjectFit(String? className) {
    if (className == null) return BoxFit.cover;

    final classes = className.split(RegExp(r'\s+'));
    for (final cls in classes) {
      switch (cls) {
        case 'object-cover':
          return BoxFit.cover;
        case 'object-contain':
          return BoxFit.contain;
        case 'object-fill':
          return BoxFit.fill;
        case 'object-none':
          return BoxFit.none;
        case 'object-scale-down':
          return BoxFit.scaleDown;
      }
    }
    return BoxFit.cover; // Default like CSS background-size: cover
  }
}
