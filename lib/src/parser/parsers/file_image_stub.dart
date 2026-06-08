import 'package:flutter/widgets.dart' show ImageProvider;

/// Returns null on web/WASM targets where the `File` API is unavailable.
///
/// The io arm in file_image_io.dart is selected instead on native VM targets
/// via the conditional import in background_parser.dart.
ImageProvider<Object>? fileImageProvider(String path) => null;
