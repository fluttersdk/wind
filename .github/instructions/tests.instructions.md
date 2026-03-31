---
name: 'Testing Conventions'
description: 'Test structure, helpers, and patterns for Wind framework tests'
applyTo: 'test/**/*.dart'
---

# Testing Domain

- Test structure mirrors `lib/src/` exactly: `test/parser/parsers/`, `test/widgets/`, `test/theme/`, `test/dynamic/`
- Every Wind widget test needs `wrapWithTheme()` helper — wraps in `MaterialApp > WindTheme > Scaffold`
- Parser tests use `createTestContext()` helper with named params: `brightness`, `activeBreakpoint`, `isHovering`, etc.
- Always `WindParser.clearCache()` in `setUp()` — cache persists between tests and causes false positives
- Use `group()` for logical grouping by feature, `testWidgets()` for widget tests, `test()` for pure logic
- Always `await tester.pumpWidget()`, `await tester.tap()`, `await tester.pump()` — missing await = flaky test
- Use `pumpAndSettle()` only for animations, `pump()` for single-frame rebuilds
- Parser tests: initialize parser + context in `setUp()` with `late` keyword
- Widget tests: test behavior (taps, state changes), not implementation details
- Expect patterns: `findsOneWidget`, `findsNothing`, `findsWidgets`, `isTrue`, `isA<Type>()`
- Test both theme-scale values (`p-4`) and arbitrary values (`p-[10px]`) for parser coverage
- Test dark mode: pass `brightness: Brightness.dark` to `createTestContext()`
- Test edge cases: null classes, empty string, conflicting classes (last wins), unknown tokens (ignored)
