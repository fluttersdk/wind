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

What the allowlist does not restrict is what an allowed widget loads. A className such as `bg-[url(https://host/x.png)]` becomes a `NetworkImage` and `bg-[url(/path)]` a file image on native platforms (`lib/src/parser/parsers/background_parser.dart`), and `WImage` fetches its `src` with `Image.network` (`lib/src/widgets/w_image.dart`). Untrusted JSON can therefore make the app request arbitrary hosts or read local image files. Sanitise `className` and `src` values from untrusted sources, or add `WImage` to `denyWidgets`.

Consumers rendering JSON from untrusted sources should review the default allowlist, tighten it with `denyWidgets`, and set an appropriate `maxDepth`.

## Scope

This policy covers the `wind_kit` package. Issues in `flutter_svg`, the Flutter SDK and other dependencies belong to their maintainers.
