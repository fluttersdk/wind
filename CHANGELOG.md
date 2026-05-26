# Changelog

All notable changes to this project will be documented in this file.

This project follows [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html).

---

## [2.0.0](https://github.com/fluttersdk/wind/compare/fluttersdk_wind-v1.0.0...fluttersdk_wind-v2.0.0) (2026-05-26)


### ⚠ BREAKING CHANGES

* **w_keyboard_actions:** the barrel re-export of package:keyboard_actions is removed, so KeyboardActions, KeyboardActionsConfig, KeyboardActionsItem, and KeyboardActionsPlatform leave Wind's public API. Impact-map research during planning confirmed zero consumers (uptizm-app and Wind's own code both consumed only the WKeyboardActions wrapper). The barrel adds the new WKeyboardPlatform enum in their place. Consumers that imported the package types via Wind's barrel switch to importing package:keyboard_actions directly (and add it to their own pubspec) OR migrate to the WKeyboardPlatform enum + WKeyboardActions wrapper.
* **diagnostics:** decouple wind from fluttersdk_dusk via wind_diagnostics_contracts (alpha-10) ([#62](https://github.com/fluttersdk/wind/issues/62))

### Features

* Add .gitignore, update pubspec.yaml with mcp_toolkit dependency, and enhance theme tests and documentation ([afdd1c8](https://github.com/fluttersdk/wind/commit/afdd1c8dec78ff608aaf9ad95de35c92ec702b41))
* Add `onDoubleTap` callback to `WButton` and improve custom state management with a `WindAnchorState` hashing fix. ([a8a68ff](https://github.com/fluttersdk/wind/commit/a8a68ff981a74058e62ece5490c91975325f6e46))
* Add animation, opacity, transition, and z-index theme defaults, integrate logger into widgets, and update parsers to use theme values. ([28fda14](https://github.com/fluttersdk/wind/commit/28fda149cb3f7d96c384a5831005a097599beca8))
* Add aspect ratio utility classes for controlling element propor… ([93bf548](https://github.com/fluttersdk/wind/commit/93bf548af80b01c72a306a661f52cc837fd53de3))
* Add aspect ratio utility classes for controlling element proportions. ([efed494](https://github.com/fluttersdk/wind/commit/efed4945eeb44ca4cdf08364e5d0005ba892f9b5))
* add CSS positioning utilities — relative/absolute + inset offsets ([#49](https://github.com/fluttersdk/wind/issues/49)) ([44747b5](https://github.com/fluttersdk/wind/commit/44747b58f04581c52d40fa8408927e9412c2b67a))
* add customIcons support to WDynamic for user-defined icon mappings ([399a6e1](https://github.com/fluttersdk/wind/commit/399a6e1f250a387af00b06d48d03b12ff4ec991a))
* add extended icon map to playground for WDynamic customIcons ([c55a501](https://github.com/fluttersdk/wind/commit/c55a5010e2c993d379c19bd4ff2e1e6969491559))
* Add font family utilities and parsing for `font-` classes with … ([82a196e](https://github.com/fluttersdk/wind/commit/82a196ea618d93e39aa7bdbd3f92c1d9e38fd2b9))
* Add font family utilities and parsing for `font-` classes with theme customization and examples. ([9ce1ec1](https://github.com/fluttersdk/wind/commit/9ce1ec19bca3c652d2a27caebd8f6be139ad32e9))
* add GitHub issue templates and skill community features ([059614f](https://github.com/fluttersdk/wind/commit/059614f429a85026075190f50a0f0c2ae84444c2))
* Add helper functions and BuildContext extensions for programmat… ([bde9004](https://github.com/fluttersdk/wind/commit/bde9004686c10b7e569977304c924fcc43a2ccb4))
* Add helper functions and BuildContext extensions for programmatic theme access and style parsing, along with documentation and tests. ([835fe50](https://github.com/fluttersdk/wind/commit/835fe50fbf2dce12f4f36383f0350f71316a41bc))
* Add Hero Card and Blog Section examples and align dark mode col… ([af91bb1](https://github.com/fluttersdk/wind/commit/af91bb189ef7cc4822a79e34a082b34b4deb7ebc))
* Add Hero Card and Blog Section examples and align dark mode color resolution with Tailwind. ([88b8bdd](https://github.com/fluttersdk/wind/commit/88b8bdd28d52131ab6ba5ff7436e9d317dbee27e))
* Add new parsers for aspect ratio, opacity, z-index, overflow, shadow, and transition, and refine transition parsing logic. ([ffe1b1e](https://github.com/fluttersdk/wind/commit/ffe1b1efc5ed36d9792eb2d434e51ae20af55c65))
* add onThemeChanged callback, resetToSystem, and button spinner contrast color ([5774d0f](https://github.com/fluttersdk/wind/commit/5774d0f5c670af85065f36276d428a69370987cd))
* Add opacity utility classes with parsing, styling, and widget application. ([2095823](https://github.com/fluttersdk/wind/commit/2095823064e2718a18e9285b3019ddfe38c36b55))
* Add overflow utility classes (e.g., overflow-hidden, overflow-s… ([c2c6112](https://github.com/fluttersdk/wind/commit/c2c61121ccd09d9d569a01a647155d0f0918f093))
* Add overflow utility classes (e.g., overflow-hidden, overflow-scroll) with dedicated parser, style properties, widget integration, documentation, and tests. ([6c06473](https://github.com/fluttersdk/wind/commit/6c06473ae44e5c57064395cb60d4720bb04caab4))
* add shadow utilities and corresponding documentation, examples, and tests ([89163ee](https://github.com/fluttersdk/wind/commit/89163ee9bd20cd11a75803cf98cddae30c2140f4))
* Add support for `overflow-x-auto`, `overflow-x-visible`, `overflow-y-auto`, and `overflow-y-visible` properties. ([2cd212d](https://github.com/fluttersdk/wind/commit/2cd212d3a363884dc1fd4ceb98f820c90e541cac))
* Add support for arbitrary shadow hex colors and `shadow-none` utility, and refine shadow color application logic. ([47b3346](https://github.com/fluttersdk/wind/commit/47b334668391ebf9653e25d6c4f49f22b5c5115f))
* add theme customization for border values ([57cf018](https://github.com/fluttersdk/wind/commit/57cf018ae7d47170bcc8419f5d5b1fdf5740fffc))
* Add transition duration and easing properties, integrating them into `WDiv` via `AnimatedContainer` and fixing padding application. ([b254fe8](https://github.com/fluttersdk/wind/commit/b254fe8353a5b1c130ab877a5a937842999bd2b2))
* Add transition duration and easing properties, integrating them… ([f4a2405](https://github.com/fluttersdk/wind/commit/f4a2405aedf3fb404c1f01835b7e52903800a993))
* Add WButton widget with hover, focus, disabled, and loading sta… ([e8784cd](https://github.com/fluttersdk/wind/commit/e8784cd3acdeef9db4c75c3efab6ad0ee1176962))
* Add WButton widget with hover, focus, disabled, and loading states, and introduce custom state propagation for WAnchor. ([09ba550](https://github.com/fluttersdk/wind/commit/09ba5508139d5ac985a1ad63a3785f98d2b60df9))
* add WDynamic example page with actions, state, and custom builders ([f1403b1](https://github.com/fluttersdk/wind/commit/f1403b16818ff3a0f2b7827ae10e49fb07a9bb3d))
* Add WImage, WIcon, WSvg, WCheckbox, WSelect widgets with animat… ([20dcf57](https://github.com/fluttersdk/wind/commit/20dcf575e0f82cceb09754b4daba2fa3311a6704))
* Add WImage, WIcon, WSvg, WCheckbox, WSelect widgets with animation and SVG parsing capabilities, and update documentation and examples. ([b9456e3](https://github.com/fluttersdk/wind/commit/b9456e3059b2ead972c8371dd3630dbff3e9ec7b))
* Add WPopover widget, update parsers and theme defaults, and introduce new agent workflow and AI system prompt documentation. ([889a07e](https://github.com/fluttersdk/wind/commit/889a07e6c3b1d2f6055ce356b1c1bf164357c019))
* centralize color opacity parsing, add new ring styles, and enhance WindContext state management with additional states. ([8c96777](https://github.com/fluttersdk/wind/commit/8c967773a2eef5d7378f449947fbdf6554401918))
* CSS positioning utilities — relative/absolute + inset offsets ([cfe9c7a](https://github.com/fluttersdk/wind/commit/cfe9c7a010bf97b5281a53acf7364520eda83a01))
* **datepicker:** add tests, examples, and documentation ([97bfc0c](https://github.com/fluttersdk/wind/commit/97bfc0c63f13c2a56a92b840e9d1c89f6e0425cf))
* **diagnostics:** decouple wind from fluttersdk_dusk via wind_diagnostics_contracts (alpha-10) ([#62](https://github.com/fluttersdk/wind/issues/62)) ([9a28748](https://github.com/fluttersdk/wind/commit/9a28748c2b1d3c55cc9f80d9d737bf67b7e0242f))
* Document ShadowParser and DebugParser, add shadow effects, and optimize example routes with `const` keyword. ([dd396ab](https://github.com/fluttersdk/wind/commit/dd396ab7d33b55be01a50f65ab814400fbb156f6))
* enhance utility class parsing and styling capabilities for various widgets with updated documentation ([97ad07a](https://github.com/fluttersdk/wind/commit/97ad07a27dbcc77b2087d375b4b91e58a54d33f1))
* enhance WInput with improved multiline minLines, textInputAction, controller lifecycle, cursor preservation, and update ring style parsing and documentation." ([dec42ef](https://github.com/fluttersdk/wind/commit/dec42ef9a54de7aa9630548ea4c1080e4c51b82c))
* **example:** add ExampleScaffold + ExampleSection for unified page layout ([b6c4b74](https://github.com/fluttersdk/wind/commit/b6c4b74851255345ff89b6090b85a1d8b30cb8ac))
* **example:** add utility + dynamic-rendering example pages, fix route casing ([336d924](https://github.com/fluttersdk/wind/commit/336d924726cdeed43b13c60beb0a117e11acfb1e))
* **examples:** add 28 widget example pages ([82e9200](https://github.com/fluttersdk/wind/commit/82e92008f2da968a923305506175e3cf47e6fec6))
* **examples:** add borders and spacing example pages ([f283ae2](https://github.com/fluttersdk/wind/commit/f283ae24f285b7cbb4d1e786c6655099bf436bc4))
* **examples:** add core concepts example pages ([8c68a8f](https://github.com/fluttersdk/wind/commit/8c68a8f77951afa4b32a1dcb3b0dc09ba1ea3cc0))
* **examples:** add form date picker examples ([dfebecc](https://github.com/fluttersdk/wind/commit/dfebecc502d29950bb2c19b203638e1b7c81824e))
* **examples:** add installation showcase page ([6257194](https://github.com/fluttersdk/wind/commit/62571946f15bb2e7a9bbd263e65651a24c689ac9))
* **examples:** add interactivity example pages ([23876a3](https://github.com/fluttersdk/wind/commit/23876a32b6a56e71854b7850d25c38da09847f9d))
* **examples:** add layout example pages ([d2f8ab1](https://github.com/fluttersdk/wind/commit/d2f8ab1bb8d9eeb531af4446705ef8da4fda1eff))
* **examples:** add styling example pages ([4178e65](https://github.com/fluttersdk/wind/commit/4178e6571085d382961576d0148ab50d389f9766))
* **examples:** add typography example pages ([454aed4](https://github.com/fluttersdk/wind/commit/454aed4bdc5a8cb94093059fa2032b0d627c3534))
* Implement `aspect-auto` and robustly handle invalid arbitrary aspect ratio values in `AspectRatioParser`. ([0f0a516](https://github.com/fluttersdk/wind/commit/0f0a516ba18012cd61e521b146fafbbe82d9543b))
* implement BorderParser for border and rounded utilities ([36ddbcf](https://github.com/fluttersdk/wind/commit/36ddbcf3ada71aaab876c3cc005e59414ab5e0e7))
* implement BorderParser for border and rounded utilities ([#12](https://github.com/fluttersdk/wind/issues/12)) ([207ad0d](https://github.com/fluttersdk/wind/commit/207ad0d7ff2e85d6eedd6314670ada94b7650b71))
* implement z-index parsing for `z-` utility classes ([e79c09d](https://github.com/fluttersdk/wind/commit/e79c09d29c60f9fba7a988e8d959509589e36287))
* implement z-index parsing for `z-` utility classes ([a090f75](https://github.com/fluttersdk/wind/commit/a090f75fa9ebc4acbc6e720013eca670a61294af))
* Introduce comprehensive typography, sizing, effects, and developer experience utilities, update documentation, and resolve font parsing issues. ([ba5ca99](https://github.com/fluttersdk/wind/commit/ba5ca99aa5c7a545edf98df073cf2dab096c95ca))
* Introduce configurable default font family application in WindTheme and update documentation. ([963de1e](https://github.com/fluttersdk/wind/commit/963de1ef5be43cfec9351fda8d769f9b87a4b56d))
* Introduce ring utilities, add state variants for hover, focus, … ([80d2498](https://github.com/fluttersdk/wind/commit/80d24984db6c37dacd332efe8618edc46947c9b9))
* Introduce ring utilities, add state variants for hover, focus, and disabled, and support color opacity modifiers for shadows and rings. ([b6f6c78](https://github.com/fluttersdk/wind/commit/b6f6c7832ca4e894fbca20299a674f5ea60dd491))
* Introduce WFormInput, WFormSelect, and WFormCheckbox widgets with documentation and tests, alongside updates to existing components and utilities. ([02338eb](https://github.com/fluttersdk/wind/commit/02338eb77682c51b46d375689ea85da686756da0))
* introduce WInput widget with Tailwind-like styling, examples, t… ([65c5597](https://github.com/fluttersdk/wind/commit/65c559756dee84730edbe5b04223419236a399a8))
* introduce WInput widget with Tailwind-like styling, examples, tests, and documentation ([94171d8](https://github.com/fluttersdk/wind/commit/94171d86f7a5fbf35edade651d351db5f9b39229))
* **layout:** add order-* and flex-*-reverse for flex child reordering ([#57](https://github.com/fluttersdk/wind/issues/57)) ([7477621](https://github.com/fluttersdk/wind/commit/74776214c2e0b99d7303355f2be0415feda1d95a))
* **popover:** add autoFlip parameter for automatic direction detection ([ec956bb](https://github.com/fluttersdk/wind/commit/ec956bb9ef628fd185f2268d757811c4236b2c40))
* Refactor Debug feature & Fix Responsive Display ([#29](https://github.com/fluttersdk/wind/issues/29)) ([8333203](https://github.com/fluttersdk/wind/commit/833320384bdaeb04db92b42c418657b6dc5cb9d0))
* Refactor Debug feature & Fix Responsive Display ([#29](https://github.com/fluttersdk/wind/issues/29)) ([3249cfc](https://github.com/fluttersdk/wind/commit/3249cfccd78f57328155c66273b98eccbc1bab9b))
* **routes:** register all new example routes ([f86ee26](https://github.com/fluttersdk/wind/commit/f86ee26e98788bf1d113051b07e66b668d407c99))
* **skill:** upgrade wind-ui with design culture, theming, and enforcement gates ([b77370a](https://github.com/fluttersdk/wind/commit/b77370ac4f032daf35ff2d99b0782620e61230d8))
* **skill:** upgrade wind-ui with design culture, theming, enforcement gates, and CC optimization ([2aec7a9](https://github.com/fluttersdk/wind/commit/2aec7a9819f4edefc33e993a830c76ec15b097dc))
* Update `wScreen` to return null for invalid breakpoints, adjust `wScreenIs` accordingly, add new helper extension tests, and update documentation. ([b979af1](https://github.com/fluttersdk/wind/commit/b979af17b707d2e95763f1b5d0e5a5fb1414ffb3))
* **w_keyboard_actions:** add WKeyboardPlatform enum ([9e4d91d](https://github.com/fluttersdk/wind/commit/9e4d91dbace08276d6a513b27fe4c3e4a7507f69))
* **widgets:** add WBreakpoint for per-breakpoint widget trees ([#58](https://github.com/fluttersdk/wind/issues/58)) ([6caffb6](https://github.com/fluttersdk/wind/commit/6caffb62f98d6805bc1436bbcf02ff5d1e856b21))
* **widgets:** implement WDatePicker with single and range mode ([994649c](https://github.com/fluttersdk/wind/commit/994649ced8bfb5c930a4732c59b90c357f2005f6))
* **widgets:** implement WFormDatePicker and add WDatePicker tests ([bdc3990](https://github.com/fluttersdk/wind/commit/bdc3990ff13e09aa4244d5e740b0fed2583ef6aa))
* **widgets:** inline backgroundColor/foregroundColor for dynamic colors ([#59](https://github.com/fluttersdk/wind/issues/59)) ([#60](https://github.com/fluttersdk/wind/issues/60)) ([4cbb0af](https://github.com/fluttersdk/wind/commit/4cbb0af2d0c27845908d6ad3e046479f5066529a))
* **WSvg:** add preserve-colors utility class to skip ColorFilter ([5bc721f](https://github.com/fluttersdk/wind/commit/5bc721fa003a8f56486cd43da715f08d4efb8721))


### Bug Fixes

* add widthFactor/heightFactor to WPopover Align widget ([0686c8a](https://github.com/fluttersdk/wind/commit/0686c8a250ac5ae577d057c7e2f8082f5acb26fd))
* add widthFactor/heightFactor to WSelect Align widget ([d0d5b66](https://github.com/fluttersdk/wind/commit/d0d5b66fa84d088b9885613337f91abec06da2c5))
* address Copilot PR review comments ([d3ccd11](https://github.com/fluttersdk/wind/commit/d3ccd116991df000f8e5ec0e770bee5664d58f8f))
* address Copilot review — context-aware positioning, drop % offsets, dark mode ([aa8b74e](https://github.com/fluttersdk/wind/commit/aa8b74e64c81c83d77190c172bf0fc423eadb5cf))
* address Copilot review — token-based matching, dedup tests, RenderBox assertion ([0bdbcb1](https://github.com/fluttersdk/wind/commit/0bdbcb1c8ca1fabe26b60c5f900a5ec8f35615df))
* **anchor:** remove postFrameCallback race condition in hover handler ([e8f708b](https://github.com/fluttersdk/wind/commit/e8f708b66708082854bb0dfe6567fc4869ffd917))
* **button:** delegate cursor to WAnchor, remove nested MouseRegion ([1a104e7](https://github.com/fluttersdk/wind/commit/1a104e7171c32d6e7f85ef3633e47e9acc1c3237))
* **ci:** release-please recursive guard scope is 'master' not 'main' ([112d412](https://github.com/fluttersdk/wind/commit/112d412e9ff4d3839b5ef55f07c57a03c98b9ffc))
* **ci:** replace reusable publish workflow with custom one ([4facade](https://github.com/fluttersdk/wind/commit/4facade0071d8feb85091e79fe12b37372084cfc))
* **ci:** skip Claude PR review on Dependabot-authored PRs ([1c861e4](https://github.com/fluttersdk/wind/commit/1c861e496014f95bbf62a8068c11f42ea634873f))
* **ci:** use tag push trigger for pub.dev OIDC publish ([2207f5d](https://github.com/fluttersdk/wind/commit/2207f5d072ecec20437897499d79abf2d6ceae8e))
* **ci:** wire zizmor-action output via steps.&lt;id&gt;.outputs.sarif-file ([36774a7](https://github.com/fluttersdk/wind/commit/36774a74785f8e3a2b6a1ed1a6459cf3a9821a13))
* **ci:** zizmor output is 'output-file' not 'sarif-file' ([87c2f70](https://github.com/fluttersdk/wind/commit/87c2f70cd6cb856220c865f8cb919c6883d4a463))
* correct w_div_test.dart unbounded constraint issue ([d8e2d98](https://github.com/fluttersdk/wind/commit/d8e2d981a97c65717f65d6fc185e09987d8a5424))
* **datepicker:** add dynamic open direction based on screen space ([790cc17](https://github.com/fluttersdk/wind/commit/790cc17d3493e604757111691296776ecaaa75e4))
* **datepicker:** increase popover width to 320px to fit long month names ([96f1c4a](https://github.com/fluttersdk/wind/commit/96f1c4a4aa1f738f8fe72d58c3c68ca51843dade))
* **datepicker:** pass explicit maxHeight to WPopover for overflow detection ([dec91f1](https://github.com/fluttersdk/wind/commit/dec91f17c1500a49835ef1b5b81032eccd698972))
* **datepicker:** prevent month/year text from wrapping to 2 lines ([b11d33d](https://github.com/fluttersdk/wind/commit/b11d33ddfaf02545b35bd2241021afa2a4fb534a))
* **example:** merge default colors with primary color in main.dart ([c24a103](https://github.com/fluttersdk/wind/commit/c24a103e07405d23d87996015a30abf8935c9c7d))
* format background_gradient_stops.dart to resolve CI failure ([f334237](https://github.com/fluttersdk/wind/commit/f334237b9c2ba95dd346dbb8ac5c068c4f88c903))
* minor updates to overflow example and flexbox test ([85cbd12](https://github.com/fluttersdk/wind/commit/85cbd123ed70e09d83b886aea1f6d89fc50cd191))
* only flip popover when destination has more space ([a9769ee](https://github.com/fluttersdk/wind/commit/a9769ee7fe861a03b4cbc94dd7fe9839d711d07e))
* prevent Flexible wrapping on shrink-0 children in justify-between rows ([cd5700c](https://github.com/fluttersdk/wind/commit/cd5700cda09d69c42c6260faea1abc42e4ac2645))
* prevent Flexible wrapping on shrink-0 children in justify-between rows ([#45](https://github.com/fluttersdk/wind/issues/45)) ([9b2b06a](https://github.com/fluttersdk/wind/commit/9b2b06ad8cb2a2ae8d9610208f14c4320b4e3bcc))
* Refine font weight parsing logic to prevent misinterpretation and add a combined font-weight/family test. ([aee3038](https://github.com/fluttersdk/wind/commit/aee303805ae2a1d0d2522f42ac9a6aee0ef640fd))
* replace toARGB32() with .value for compatibility ([829759c](https://github.com/fluttersdk/wind/commit/829759c5fe9d67f2389628e66bc8ed675f661d02))
* **skill:** remove HTML anchors, fix Copilot review findings ([3e018c1](https://github.com/fluttersdk/wind/commit/3e018c1d2660a412a67cbd982a030d1e04d30810))
* **w_div:** skip Expanded wrap for flex-* children inside overflow-x/y scroll ([#56](https://github.com/fluttersdk/wind/issues/56)) ([29546f0](https://github.com/fluttersdk/wind/commit/29546f0e265b67954599a3d5a09998a409bd0656))
* **w_input:** clear OutlineInputBorder gapPadding so px-* matches inset ([#63](https://github.com/fluttersdk/wind/issues/63)) ([847d5f4](https://github.com/fluttersdk/wind/commit/847d5f4cf04b144dde7097ae8b91657c06452b05))


### Code Refactoring

* **w_keyboard_actions:** inline implementation; drop keyboard_actions package ([8c0b1e6](https://github.com/fluttersdk/wind/commit/8c0b1e6294b2f5f393c4bb93d1ec8f23c9aa82b5))

## [1.0.0] - 2026-05-21

The first stable release. Wind ships a complete utility-first styling layer for Flutter with className syntax, theming, responsive breakpoints, dark mode, dynamic JSON rendering, and a contracts-based debug bridge for external tooling. All public APIs in this release are considered stable; the surface follows Semantic Versioning from this point on.

### What's in the v1 surface

**Widgets (19 user-facing):** `WDiv`, `WText`, `WButton`, `WInput`, `WSelect`, `WCheckbox`, `WIcon`, `WImage`, `WSvg`, `WPopover`, `WAnchor`, `WBreakpoint`, `WSpacer`, `WDatePicker`, `WDynamic`, plus the FormField wrappers `WFormInput`, `WFormSelect`, `WFormMultiSelect`, `WFormCheckbox`, `WFormDatePicker`.

**Parsers (17):** background (color, gradient, image), border, ring, shadow, opacity, padding, margin, sizing, flexbox + grid, position (relative + absolute + insets), order, overflow, aspect-ratio, z-index, text (font-size / weight / family / tracking / leading / decoration / transform / align / overflow), animation, transition (duration + easing), svg fill/stroke + preserve-colors, debug.

**Theme (`WindThemeData` exposes 23 configurable fields):** brightness, colors, screens, containers, fontSizes, fontWeights, tracking, leading, borderWidths, borderRadius, fontFamilies, ringWidths, ringOffsets, applyDefaultFontFamily, syncWithSystem, baseSpacingUnit, ringColor, opacities, zIndices, shadows, transitionDurations, transitionCurves, animations.

**External integrations:** `Wind.installDebugResolver()` for the new `fluttersdk_wind_diagnostics_contracts` bridge (used by `fluttersdk_dusk` for E2E and any runtime inspector). The canonical `wind-ui` skill ships at `skills/wind-ui/`; AI agent distribution (MCP server, Claude Code, Cursor, OpenCode, Gemini, VS Code Copilot, Codex, Cline, Roo) is handled by [fluttersdk/ai](https://github.com/fluttersdk/ai) via `npx skills add fluttersdk/ai --skill wind-ui`.

### Fixed (since the last published alpha, 1.0.0-alpha.6)

- `WInput`: `px-*` horizontal padding now matches the requested value on both single-line and multiline. Previously every `OutlineInputBorder` defaulted to `gapPadding: 4.0` (Material's reservation for a floating-label cutout), adding a phantom `+4px` on each horizontal edge. Wind routes labels through the parser and never uses `InputDecoration.labelText`, so the gap had no purpose. Setting `gapPadding: 0.0` on the built border yields exact `px-*` semantics: `px-3` now produces a 12 px inset instead of 16 px. Multiline `minLines`/`maxLines` geometry unchanged. (#61)

### Added (since 1.0.0-alpha.6)

The intermediate alphas 1.0.0-alpha.7 through 1.0.0-alpha.10 were not published to pub.dev. Their work is summarized here and laid out in detail in the per-alpha sections below.

- **`WBreakpoint` widget**: declarative per-breakpoint widget tree builder. Use it as an escape hatch when className prefixes (`sm:`, `md:`, `lg:`) are not enough because the widget structure itself changes between breakpoints. (alpha-9, #58)
- **CSS positioning utilities**: `relative`, `absolute`, `top-*`, `right-*`, `bottom-*`, `left-*`, `inset-*` plus negative variants and arbitrary-px values (`top-[24px]`). Layers a `Stack` / `Positioned` over the existing rendering. (alpha-6, #49)
- **Child order utilities**: `order-0` through `order-12`, `order-first`, `order-last`, `order-none`, and arbitrary `order-[n]` for reordering flex children without changing source order. (alpha-9, #57)
- **Reverse flex direction**: `flex-row-reverse` and `flex-col-reverse` map to `Row.textDirection` / `Column.verticalDirection`, so `justify-start` mirrors per CSS semantics. (alpha-9, #57)
- **Inline color props**: `WDiv.backgroundColor` and `WText.foregroundColor` for runtime-dynamic colors (per-tenant brand, color picker, etc.). Overrides any `bg-*` / `text-*` from className and stays out of the parser cache key, so a dragging color picker no longer bloats the cache the way `bg-[#$hex]` interpolation would. (alpha-9, #60)
- **Accessibility / Semantics on 6 interactive widgets**: `WAnchor`, `WButton`, `WInput`, `WFormInput`, `WCheckbox`, `WSelect`, `WDatePicker` now emit `Semantics` nodes (`button: true`, `textField: true`, `obscured` for passwords, etc.) so the Flutter web accessibility tree surfaces a role + label per widget. Enables Playwright `getByRole` / `getByLabel` / `getByText` resolution against Flutter web. New optional `WInput.semanticLabel` parameter for form wrappers. (alpha-9)
- **Contracts-based debug bridge**: new production dep `fluttersdk_wind_diagnostics_contracts: ^1.0.0`. Call `Wind.installDebugResolver()` inside `kDebugMode` to expose Wind state per widget (className, breakpoint, brightness, platform, states, bgColor, textColor) to any consumer of `WindDebugRegistry.current`. Used by `fluttersdk_dusk` for E2E snapshot capture; works for any inspector / IDE tool that wants the same data. (alpha-10, #62)

### Removed (BREAKING since 1.0.0-alpha.6)

- `WindDuskIntegration` class and `lib/dusk_integration.dart` sub-barrel are gone. Replaced by `Wind.installDebugResolver()` from the main barrel. (alpha-9 + alpha-10)
- `fluttersdk_dusk` is no longer a Wind dependency at any level (was a prod dep in alpha-8 and earlier, briefly a dev_dep in alpha-9, fully dropped in alpha-10). Consumers that need Dusk for their own E2E tests add it to their own pubspec. (alpha-10)
- The 50+ optional `WindStyle` fields the old dusk integration emitted in snapshot YAML are reduced to the 6 core fields the contracts package codifies: `className`, `breakpoint`, `brightness`, `platform`, `states`, `bgColor`, `textColor`. The provenance flag (`WindParser.parse(... trackProvenance: true)`) is dropped; revisit in v1.x if consumer demand surfaces.

### Quality

- Line coverage measured via `flutter test --coverage` raised from **81.4% to 93.4%** (~+520 covered lines across 16 source files). 9 new test files (`w_image_test.dart`, `w_dynamic_test.dart`, `wind_logger_test.dart`, `wind_facade_test.dart`, `platform_service_test.dart`, `wind_animation_wrapper_test.dart`, plus `test/widgets/w_div/coverage_padding_test.dart`), 5 extended files (`w_icon`, `w_text`, `w_svg`, `w_popover`, `w_date_picker`, `w_select`, `w_dynamic_renderer`). 149 new test cases (1081 → 1230).
- Coverage infrastructure: `tool/coverage.sh` (portable threshold-aware lcov wrapper) and a GitHub Actions gate in `.github/workflows/deploy.yml` that fails any PR dropping below 90% line coverage.
- Surgical `// coverage:ignore-line` pragmas applied to lines genuinely unreachable from `flutter test` (dart:io `Platform.isIOS/Android/Windows` branches in `lib/src/core/platform_service.dart`). Each pragma carries a one-line WHY comment.

### Migration from 1.0.0-alpha.6

If your app already runs against `1.0.0-alpha.6`, the only mandatory change is the debug-bridge wiring. The W-widget surface, theming, and parser-token set are source-compatible additions on top of alpha-6.

If you were using `WindDuskIntegration` (only consumers running Dusk against their own apps):

```dart
// Before (alpha-8 and earlier):
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
if (kDebugMode) {
  WindDuskIntegration.install();
}

// After (1.0.0):
import 'package:fluttersdk_wind/fluttersdk_wind.dart';
if (kDebugMode) {
  Wind.installDebugResolver();
}
```

If you do not use Dusk: no migration needed. Drop in `1.0.0`, update your pubspec, run `flutter pub get`.

### Documentation

Full documentation moved to **[fluttersdk.com/wind](https://fluttersdk.com/wind)**. Every widget, parser, and theme field has a dedicated page with live examples and an LLM-friendly cheat-sheet under `skills/wind-ui/`.

---

## [1.0.0-alpha.10] - 2026-05-21

### BREAKING

- Removed `fluttersdk_dusk` dev_dependency entirely (was a dev_dep in alpha-9). Wind no longer compile-time depends on dusk for diagnostics; the new neutral bridge package `fluttersdk_wind_diagnostics_contracts` replaces that coupling.
- DELETED `lib/src/dusk_integration.dart` (503 LoC, the old enricher), `lib/dusk_integration.dart` (sub-barrel), `test/dusk_integration_test.dart` (750 LoC, 43 tests; 40 reborn as `test/debug_resolver_test.dart`, 3 dropped).
- `WindDuskIntegration.install()` REMOVED. Consumers migrate to `Wind.installDebugResolver()`.
- Lost vs alpha-9: 50+ optional WindStyle fields in the snapshot YAML (alpha-10 emits only 6 core: className, breakpoint, brightness, platform, states, bgColor, textColor). Provenance feature dropped (revisit V1.x with consumer signal).

### Added

- New production dep `fluttersdk_wind_diagnostics_contracts: ^1.0.0-alpha.1`: abstract `WindDebugResolver` contract + static `WindDebugRegistry`. Bridge between Wind and any debug-tooling package without compile-time coupling.
- `lib/src/debug_resolver.dart`: concrete `WindDebugResolverImpl` implementing the contract.
- `lib/src/wind_facade.dart`: `Wind` static facade exposing `Wind.installDebugResolver()` (kDebugMode-gated, idempotent).

### Migration

```dart
// alpha-9:
import 'package:fluttersdk_wind/dusk_integration.dart';
if (kDebugMode) {
  DuskPlugin.install();
  WindDuskIntegration.install();
}

// alpha-10:
import 'package:fluttersdk_wind/fluttersdk_wind.dart';  // main barrel only
if (kDebugMode) {
  DuskPlugin.install();
  Wind.installDebugResolver();
}
```

---

## [1.0.0-alpha.9] - 2026-04-17

> Internal alpha — not published to pub.dev. Content rolled into 1.0.0.

### BREAKING

- Dependency migration: `fluttersdk_dusk` moved from `dependencies:` to `dev_dependencies:`. Vanilla wind consumers no longer pull dusk transitively. Consumers wanting the WindDuskIntegration enricher must add `fluttersdk_dusk` to their own pubspec and switch their import path (see migration below).
- Barrel removal: `WindDuskIntegration` and `windClassNameEnricher` are no longer exported from the main `package:fluttersdk_wind/fluttersdk_wind.dart` barrel. The class and function names are unchanged; only the import path moves.
- New opt-in sub-barrel at `lib/dusk_integration.dart`. Consumer migration:

  Replace:
  ```dart
  import 'package:fluttersdk_wind/fluttersdk_wind.dart';
  // ... WindDuskIntegration.install();
  ```
  With:
  ```dart
  import 'package:fluttersdk_wind/fluttersdk_wind.dart';
  import 'package:fluttersdk_wind/dusk_integration.dart';
  // ... WindDuskIntegration.install();
  ```

  The `package:fluttersdk_wind/fluttersdk_wind.dart` import stays for the W-widget surface (WDiv, WButton, WindParser, etc.).

- Version bumped to `1.0.0-alpha.9` (BREAKING removal allowed in alpha cycle).

### Added
- **Accessibility / Semantics**: 6 interactive widgets now wrap their build tree with a `Semantics(...)` node so the Flutter web accessibility tree surfaces a role + label for each. `WAnchor` (and therefore the entire `WButton` family that wraps it) emits `button: true` with a merged label from its child Text/WText subtree via `MergeSemantics`. `WInput` and `WFormInput` emit `textField: true` with the placeholder (or the form-field `label`) as the Semantics label, the current text as Semantics value, and `obscured: true` for password inputs. `WCheckbox` emits a `checked` state. `WSelect` emits `button: true` with the placeholder or selected option label. `WDatePicker` emits `textField: true` with the placeholder as label and the ISO-formatted date as value. The wraps are additive: no existing styling, className, state, or callback behavior changes. New optional `WInput.semanticLabel` parameter lets form wrappers override the placeholder-derived Semantics label without changing the visual placeholder. Enables Playwright `getByRole` / `getByLabel` / `getByText` to resolve against the Flutter web build without per-widget caller-side annotation.
- **Child Order**: `order-0` through `order-12`, `order-first`, `order-last`, `order-none`, and arbitrary `order-[n]` (including negatives) for reordering flex children without changing source order. Stable-sort preserves insertion order among equal-order children. (#53)
- **Reverse Flex Direction**: `flex-row-reverse` and `flex-col-reverse` flip the main-axis direction via `Row.textDirection` / `Column.verticalDirection`, so `justify-start` mirrors to match CSS semantics (not just a visual list reversal). Applied after `order-*` sorting and works with responsive prefixes. (#53)
- **WBreakpoint**: New widget for declarative breakpoint-keyed widget trees. Takes `base` plus optional `sm`/`md`/`lg`/`xl`/`xxl` builders and a `custom` map for user-defined screens from `WindThemeData.screens`. Walks the screen chain descending, returns the builder for the highest breakpoint ≤ active width, falls back to `base`. Escape hatch for cases where className prefixes aren't enough (different widget types, different child counts). (#55)
- **Inline Color Props**: `WDiv.backgroundColor` and `WText.foregroundColor` for runtime-dynamic colors (color picker, per-tenant brand). Overrides any `bg-*` / `text-*` from `className` and does not participate in the parser cache key, so a dragging color picker no longer bloats the cache the way `bg-[#$hex]` interpolation would. Added `WindParser.cacheSize` for cache-behavior assertions in tests. (#59)
- **Dusk Integration Enrichment (Wave 2)**: `WindStyle` gains an optional nullable `resolvedVia` field (debug metadata; excluded from `==` / `hashCode`, included in `toString`). `WindParser.parse()` gains an opt-in `bool trackProvenance = false` named argument (default OFF; dead-branch eliminated via const propagation at release; cache bypassed when flag is true to preserve stable cache identity). Wind dusk integration enricher now emits 60+ `WindStyle` fields additively under the existing YAML snapshot key (the 6 original field names are fully preserved). `WindDuskIntegration.enableProvenance(bool)` toggle gates `resolvedVia:` emission per enricher call. New `test/dusk_integration_test.dart` with 43 test cases covering enricher output, provenance toggle, and zero-cost default.

### 🐛 Bug Fixes

- **Flex in Scrollable Axis**: `flex-1` / `flex-N` children inside `flex-row` + `overflow-x-auto|scroll` (or `flex-col` + `overflow-y-auto|scroll`) no longer throw "RenderFlex children have non-zero flex but incoming constraints are unbounded." The parent now signals via `WindFlexOverflowScope` so direct flex children skip `Expanded`/`Flexible` wrapping for that render pass. Responsive variants (`base:overflow-x-auto sm:overflow-visible` + `sm:flex-1`) work end-to-end. (#54)

---

## [1.0.0-alpha.6] - 2026-04-04

### Added
- **CSS Positioning**: `relative` and `absolute` position types with Stack/Positioned rendering
- **Offset Utilities**: `top-*`, `right-*`, `bottom-*`, `left-*` offset tokens using spacing scale
- **Inset Shortcuts**: `inset-*`, `inset-x-*`, `inset-y-*` for multi-side offsets
- **Negative Offsets**: `-top-*`, `-inset-*` for negative positioning
- **Arbitrary Position Values**: `top-[24px]`, `left-[12px]` bracket syntax (px only)

---

## [1.0.0-alpha.5] - 2026-03-31

### 🐛 Bug Fixes

- **Flex Space Distribution**: flex-1 + justify-between no longer breaks layout — shrink-0 children are skipped during container-level Flexible wrapping (#45)
- **shrink-0 Semantics**: shrink-0 no longer creates a Flexible wrapper — correctly preserves intrinsic size matching CSS flex-shrink: 0 behavior (#45)

### 🔧 Improvements

- **GitHub Copilot Config**: Added Copilot instructions converted from Claude Code configuration (#46)

---

## [1.0.0-alpha.4] - 2026-03-24

### ✨ New Features

- **WDynamic Custom Icons**: `customIcons` prop for user-defined icon mappings in dynamic rendering
- **Theme Callbacks**: `onThemeChanged` callback on `WindTheme` — fires on user-initiated theme toggles for persistence
- **Reset to System Theme**: `resetToSystem()` method on `WindThemeController` — re-enables automatic system brightness sync
- **SVG Preserve Colors**: `preserve-colors` utility class to skip ColorFilter on `WSvg`, ideal for QR codes and multi-color logos

### 🐛 Bug Fixes

- **WButton Spinner Size**: Increased default loading spinner size from 16 to 20 for better visibility
- **WButton Spinner Color**: Spinner now falls back to text color, then auto-computes contrast via W3C luminance when no color is resolvable

### 🔧 Improvements

- **CI/CD**: Replaced ci.yml with deploy.yml for web build and SSH deployment pipeline
- **Security**: Added SECURITY.md and Dependabot configuration
- **Developer Experience**: Added CLAUDE.md, path-scoped rules, and editor hooks for AI-assisted development
- **Community**: Added GitHub issue templates (bug report, feature request, documentation) and LLM skill community features

---

## [1.0.0-alpha.2] - 2026-02-05

### 📦 Package Improvements

- **Description**: Shortened package description to comply with pub.dev 180-character limit
- **Publishing**: Enhanced pub.dev compatibility and package metadata

---

## [1.0.0-alpha.1] - 2026-02-05

### 🎉 First Alpha Release

Wind v1.0.0-alpha.1 is the first public preview of the complete architectural rewrite. This release focuses on code quality, CI/CD infrastructure, and a solid foundation for v1 stable.

### ✨ Core Features

**Widgets:**
- `WDiv` - Utility-first container (flex, grid, wrap, overflow)
- `WText` - Typography with cascading styles
- `WInput` / `WFormInput` - Form inputs with validation
- `WButton` - Interactive button with loading states
- `WCheckbox` / `WFormCheckbox` - Styled checkboxes
- `WSelect` / `WFormSelect` / `WFormMultiSelect` - Dropdowns with search & tagging
- `WDatePicker` / `WFormDatePicker` - Calendar date picker
- `WPopover` - Overlay positioning system
- `WIcon`, `WImage`, `WSvg`, `WSpacer` - Media & spacing
- `WAnchor` - State management for hover/focus/custom states
- `WKeyboardActions` - iOS keyboard toolbar

**Utility Classes:**
- Layout: `flex`, `grid`, `wrap`, `gap-*`, sizing, spacing
- Typography: `text-*`, `font-*`, `uppercase`, `underline`
- Colors: `bg-*`, `text-*`, `border-*` with opacity modifiers
- Effects: `shadow-*`, `opacity-*`, `ring-*`, `rounded-*`
- States: `hover:`, `focus:`, `disabled:`, `loading:`, custom states
- Responsive: `sm:`, `md:`, `lg:`, `xl:`, `2xl:`
- Platform: `ios:`, `android:`, `web:`, `mobile:`
- Dark Mode: `dark:` prefix support

**Theme System:**
- `WindTheme` / `WindThemeData` - Customizable design tokens
- Runtime theme toggling
- Tailwind-compatible color palette

### 🔧 Quality & Infrastructure

- **Zero Analyzer Issues**: Full `flutter_lints` 5.0.0 compliance
- **835 Tests Passing**: Comprehensive coverage
- **CI/CD**: GitHub Actions with OIDC publishing
- **Flutter 3.29+**: Latest stable APIs

### 📦 Dependencies

- `flutter_svg: ^2.0.0` - SVG rendering
- `keyboard_actions: ^4.2.1` - iOS keyboard management
- `flutter_lints: ^5.0.0` - Code quality

### ⚠️ Breaking Changes

Complete rewrite from v0. Migration requires updating all widget names and class syntax.

### 📚 Documentation

- Full docs: [fluttersdk.com/wind](https://fluttersdk.com/wind)
- Example app: `/example`

---

## Previous Versions

See [full changelog](https://github.com/fluttersdk/wind/blob/v1/CHANGELOG.md) for alpha.9 through 0.0.1 release notes.
