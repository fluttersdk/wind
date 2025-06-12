# Changelog
This project follows [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

## [0.0.4] - 2025-06-12

- Updated `platform_info` dependency to `^5.0.0` for improved platform detection.

## [0.0.3] - 2025-06-09

### Added
- **Display Control (`hide`, `show`)**: Added new utility classes for responsive visibility control. Widgets now support class-based display toggling using `hide`, `show`, `lg:show`, `md:hide`, etc.
- **`DisplayParser`**: New parser for handling display-related utility classes, with full support for screen breakpoints.
- **New Example Page**: `/layouts/display` added to demonstrate display utilities in action (`example/lib/pages/layout/display.dart`).
- **`applyBorderColor` & `applyBorderRadiusValue`**: New helper methods in `BorderParser` for parsing border color and border radius values.

### Changed
- **Widgets Logging**: Improved debug logging via `hasDebugClassName`, now prints parsed class names and widgets (`WText`, `WFlex`, `WFlexible`, `WContainer`, etc.).
- **`WFlexible`**: `child` is now nullable. Returns `Spacer` if `child` is `null`.
- **`WContainer`**: Now wraps `Container` with `ClipRRect` if a `borderRadius` is specified.
- **Shadow Color Logic**: Changed `BoxShadow` color alpha parsing from `.withValues(alpha: 25)` to `.withValues(alpha: 0.1)` for better consistency.

### Fixed
- Fixed alignment mapping by adding support for `alignment-left` and `alignment-right`.
- Fixed text alignment handling using `text-left`, `text-center`, etc., via `AlignmentParser.applyTextAlignment`.
- Improved padding parser to return the original widget if padding is zero (prevents unnecessary widget wrapping).

### Removed
- Deprecated custom `RenderObject` in `WGap` in favor of a simpler `StatelessWidget` using `SizedBox`.

This version introduces foundational support for display utilities and improves debugging and widget flexibility. It’s recommended to update to benefit from responsive visibility and streamlined layout logic.

## [0.0.2] - 2025-02-02
- Added Github workflow for publishing package to pub.dev
- Updated README.md with installation and usage instructions
- Added example application to demonstrate usage

## [0.0.1] - 2025-01-29
- Initial release
