---
applyTo: test/**
---
# Test conventions (`test/`)

## Layout mirror

`test/` mirrors `lib/src/` exactly. One production file → one test file:
- `lib/src/widgets/w_button.dart` → `test/widgets/w_button_test.dart`
- `lib/src/parser/parsers/padding_parser.dart` → `test/parser/parsers/padding_parser_test.dart`

For widgets with large surface area, sub-directory: `test/widgets/w_div/spacing_test.dart`, `test/widgets/w_div/overflow_test.dart`, etc. Mirror that under `test/widgets/<name>/`.

## Required setUp

**Parser tests + every widget test that pumps className-styled widgets:**

```dart
setUp(() {
  WindParser.clearCache();
});
```

Skipping `WindParser.clearCache()` is the single biggest source of false-positive cross-test pollution. The parser cache persists between tests; a sibling test priming the cache makes the next test report PASS even when the production logic regressed.

## Canonical helpers (duplicate per file, no shared extraction)

**Widget tests** define `wrapWithTheme` at the top:

```dart
Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: WindTheme(
      data: WindThemeData(),
      child: Scaffold(body: child),
    ),
  );
}
```

**Parser tests** define `createTestContext` at the top with 7-8 named params:

```dart
WindContext createTestContext({
  bool isHovering = false,
  bool isFocused = false,
  bool isDisabled = false,
  String activeBreakpoint = 'md',
  Brightness brightness = Brightness.light,
  String platform = 'web',
  bool isMobile = false,
}) => WindContext(
      theme: testTheme,
      screenWidth: 400,
      screenHeight: 800,
      activeBreakpoint: activeBreakpoint,
      brightness: brightness,
      platform: platform,
      isMobile: isMobile,
      activeStates: {
        if (isHovering) 'hover',
        if (isFocused) 'focus',
        if (isDisabled) 'disabled',
      },
    );
```

Duplicate is intentional — keeps each file's helper trivially editable for local tweaks. Do not extract into `test/test_utils.dart`.

## No mockito

Wind tests use NO mocking library. Fake via:
- Constructor injection (`WActionHandler(actions: {'foo': (args) => ...}, state: WDynamicState())`)
- Stub widgets that implement the contract
- `debugDefaultTargetPlatformOverride` for `Platform.is*` paths (inside `try/finally` — reset is mandatory)

```dart
testWidgets('iOS-only behavior', (tester) async {
  debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  try {
    // pump + assert
  } finally {
    debugDefaultTargetPlatformOverride = null;
  }
});
```

## Lifecycle discipline

- `FocusNode` / `TextEditingController` / `AnimationController`: capture, dispose via `addTearDown(controller.dispose)`. Multiple disposals stack; do not consolidate.
- `tester.createGesture(kind: PointerDeviceKind.mouse)`: pair with `addTearDown(gesture.removePointer)`.
- `tester.view.physicalSize`: pair with `addTearDown(() { tester.view.resetPhysicalSize(); tester.view.resetDevicePixelRatio(); })`.

## Group structure

Two levels maximum:

```dart
group('WFoo Widget Tests', () {
  group('Rendering', () {
    testWidgets('renders child content', ...);
    testWidgets('applies className styling', ...);
  });
  group('Interaction', () {
    testWidgets('fires onTap when pressed', ...);
  });
});
```

Test names: verb + object (`'renders child content'`, not `'rendering'` or `'WFoo state'`).

Assertions: behavioral (`find.text`, `find.byType`, callback fired, `tester.widget<X>(...).field`). Avoid asserting on internal private state.

## Async pump rules

- `await tester.tap(...); await tester.pump();` — single frame
- `await tester.enterText(...); await tester.pump();` — both required
- `await tester.pumpAndSettle()` — ONLY when an animation actually settles (avoid for repeating animations like `spin`)
- Double pump for hover state changes that defer via `addPostFrameCallback`

## Coverage gate

Adding code MUST keep total line coverage at or above 90% — the CI gate enforces `./tool/coverage.sh 90`. When new code drops coverage, write tests in the SAME change set to land back at ≥ 90%.

`// coverage:ignore-line` only for lines structurally unreachable from `flutter test` (kDebugMode-only branches; `Platform.isWindows` body when CI is Linux + dev is macOS). Pragma on the SAME line as the statement; one-line WHY comment above.

## What never goes in `test/`

- Production code — even temporary helpers; if it ships with `lib/`, write it in `lib/`.
- Network calls — pump returns; assert tree shape only.
- Image bytes — `errorBuilder` on `WImage` swallows the unavoidable load failure in the test binding.
