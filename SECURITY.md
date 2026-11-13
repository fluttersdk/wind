# Security Policy

## Supported Versions

Only the latest published version receives fixes.

## Reporting a Vulnerability

Report it through GitHub's private vulnerability reporting:
**[Open a private vulnerability report](https://github.com/anilcancakir/wind_kit/security/advisories/new)**

The report stays confidential until a fix is ready, and GitHub's advisory workflow can assign a CVE. Include the affected version, the platform and the steps to reproduce.

## Threat Model

wind_kit treats all className input as data. The parser tokenises and maps strings to Flutter styling properties; it never evaluates code from user-supplied class names.

The primary security boundary is the `WDynamic` JSON renderer:

- **Widget allowlist** (`WDynamicConfig.defaultWindWidgets` and `defaultFlutterWidgets` in `lib/src/dynamic/w_dynamic_config.dart`): only type strings present in these two sets (or in `config.builders`) are dispatched. The dispatch loop in `lib/src/dynamic/w_dynamic_renderer.dart` calls `config.isAllowed(type)` before constructing any widget.
- **Deny list** (`config.denyWidgets`): callers can shrink the allowed surface further by naming types that must be blocked even if they appear in the default sets.
- **Depth limit** (`config.maxDepth`, default 50): caps recursion to prevent deeply nested JSON from becoming a stack-exhaustion vector.

What the allowlist does not restrict is what an allowed widget loads. A `className` on any widget that accepts one (`WDiv` is allowed by default) is parsed by `WindParser`, and `bg-[url(...)]` and the bare `bg-[...]` form become a file (a path starting with `/`, native platforms only) or an asset image (`lib/src/parser/parsers/background_parser.dart`), while `WImage` fetches its `src` with `Image.network` (`lib/src/widgets/w_image.dart`). Untrusted JSON can therefore make the app read local image files through a `className` on any allowed widget, and request a host through `WImage`. The background parser itself also accepts an `http(s)` URL, but the class-prefix split on `:` drops such a token today, so do not rely on that. `denyWidgets` filters widget types only, so denying `WImage` stops the `src` fetch and does not stop a `className` on another widget: sanitise `className` and `src` values from untrusted sources before they reach `WDynamic`.

Consumers rendering JSON from untrusted sources should review the default allowlist, tighten it with `denyWidgets`, and set an appropriate `maxDepth`.

## Scope

This policy covers the `wind_kit` package. Issues in `flutter_svg`, the Flutter SDK and other dependencies belong to their maintainers.
