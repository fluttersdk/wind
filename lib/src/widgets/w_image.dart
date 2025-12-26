import 'package:flutter/widgets.dart';

import '../parser/wind_parser.dart';
import '../parser/wind_style.dart';

/// Signature for building a custom error widget.
typedef ImageErrorBuilder =
    Widget Function(BuildContext context, Object error, StackTrace? stackTrace);

/// Signature for building a custom loading widget.
typedef ImageLoadingBuilder =
    Widget Function(
      BuildContext context,
      Widget child,
      ImageChunkEvent? loadingProgress,
    );

/// **The Utility-First Image Component**
///
/// `WImage` brings HTML `<img>` semantics to Flutter with Tailwind-like
/// utility classes for styling.
///
/// ### Features:
/// - **Network & Asset:** Use `src` for network URLs or `asset://` prefix for assets
/// - **Object Fit:** Parse `object-cover`, `object-contain`, `object-fill`, `object-none`
/// - **Aspect Ratio:** Use `aspect-video`, `aspect-square`, `aspect-[4/3]`
/// - **Sizing:** Use `w-*`, `h-*` for dimensions
/// - **Decoration:** Use `rounded-*`, `shadow-*` for styling
///
/// ### Basic Usage:
///
/// ```dart
/// WImage(
///   src: 'https://example.com/image.jpg',
///   alt: 'Profile picture',
///   className: 'w-32 h-32 rounded-full object-cover',
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
  final String src;

  /// Alternative text for accessibility.
  final String? alt;

  /// Tailwind-like utility classes for styling.
  ///
  /// Supports:
  /// - `w-*`, `h-*` → dimensions
  /// - `rounded-*` → corner radius
  /// - `object-cover`, `object-contain`, `object-fill`, `object-none` → fit mode
  /// - `aspect-video`, `aspect-square`, `aspect-[ratio]` → aspect ratio
  /// - `opacity-*` → image opacity
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
    required this.src,
    this.alt,
    this.className,
    this.states,
    this.placeholder,
    this.errorBuilder,
    this.loadingBuilder,
  });

  /// Check if the source is an asset image
  bool get _isAsset => src.startsWith('asset://');

  /// Get the actual path for asset images
  String get _assetPath => src.replaceFirst('asset://', '');

  @override
  Widget build(BuildContext context) {
    // Parse styles from className
    final WindStyle styles = className != null
        ? WindParser.parse(className!, context, states: states)
        : const WindStyle();

    // Parse object-fit from className
    final BoxFit fit = _parseObjectFit(className);

    // Build the image widget
    Widget imageWidget = _isAsset
        ? Image.asset(
            _assetPath,
            fit: fit,
            semanticLabel: alt,
            errorBuilder: errorBuilder,
          )
        : Image.network(
            src,
            fit: fit,
            semanticLabel: alt,
            errorBuilder: errorBuilder,
            loadingBuilder:
                loadingBuilder ??
                (placeholder != null
                    ? (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return placeholder!;
                      }
                    : null),
          );

    // Apply decoration (rounded corners) immediately via ClipRRect
    final BorderRadius borderRadius =
        (styles.decoration?.borderRadius as BorderRadius?) ?? BorderRadius.zero;

    if (styles.decoration != null && borderRadius != BorderRadius.zero) {
      imageWidget = ClipRRect(borderRadius: borderRadius, child: imageWidget);
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
