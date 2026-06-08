import 'dart:io';

import 'package:flutter/widgets.dart' show FileImage, ImageProvider;

/// Returns a [FileImage] for the given filesystem [path].
///
/// This arm is compiled only on native VM targets where dart:io File
/// is available. The stub arm in file_image_stub.dart is selected for
/// web and WASM targets via the conditional import in background_parser.dart.
ImageProvider<Object>? fileImageProvider(String path) => FileImage(File(path));
