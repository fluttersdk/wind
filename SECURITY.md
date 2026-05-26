# Security Policy

## Supported Versions

| Version         | Supported          |
| --------------- | ------------------ |
| 1.0.x           | :white_check_mark: |
| 0.0.x           | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability in Wind, please report it responsibly.

The preferred channel is GitHub's private vulnerability reporting:
**[Open a private vulnerability report](https://github.com/fluttersdk/wind/security/advisories/new)**

This keeps the disclosure confidential until a fix is ready and lets maintainers
coordinate a CVE assignment through GitHub's advisory workflow.

As a secondary route, you may also email **security@fluttersdk.dev** with:

- A description of the vulnerability
- Steps to reproduce
- Affected versions
- Any potential impact assessment

We will acknowledge receipt within 48 hours and aim to provide a fix or
mitigation plan within 7 days.

## Threat Model

Wind treats all className input as data. The parser tokenises and maps strings
to Flutter styling properties; it never evaluates code from user-supplied class
names.

The primary security boundary is the `WDynamic` JSON renderer:

- **Widget allowlist** (`WDynamicConfig.defaultWindWidgets` and
  `defaultFlutterWidgets` in `lib/src/dynamic/w_dynamic_config.dart`): only
  type strings present in these two sets (or in `config.builders`) are
  dispatched. The dispatch loop in `lib/src/dynamic/w_dynamic_renderer.dart`
  calls `config.isAllowed(type)` before constructing any widget.
- **Deny list** (`config.denyWidgets`): callers can shrink the allowed surface
  further by naming types that must be blocked even if they appear in the
  default sets.
- **Depth limit** (`config.maxDepth`, default 50): caps recursion to prevent
  deeply nested JSON from becoming a stack-exhaustion vector.

Consumers rendering JSON from untrusted sources should review the default
allowlist, tighten it with `denyWidgets`, and set an appropriate `maxDepth`.

## Scope

This policy covers the `fluttersdk_wind` Dart/Flutter package. Issues in
upstream dependencies (Flutter SDK, `flutter_svg`, and other transitive deps)
are out of scope and should be reported to their respective maintainers.

## Token Rotation

Two GitHub Actions secrets carry elevated access and should be rotated every
90 days:

- **`RELEASE_PLEASE_TOKEN`**: a GitHub Personal Access Token (PAT) used by the
  release-please workflow to create release PRs and push version commits.
  Regenerate at GitHub Settings > Developer settings > Personal access tokens,
  then update the secret under the repository's Settings > Secrets and
  variables > Actions.

- **`CLAUDE_CODE_OAUTH_TOKEN`**: an OAuth token used by Claude Code automation
  in CI. Regenerate through the Anthropic console or the Claude Code settings
  that issued the original token, then update the corresponding GitHub Actions
  secret in the same location as above.

After updating a secret, trigger the affected workflow manually to confirm the
new credential is accepted before the old one expires.
