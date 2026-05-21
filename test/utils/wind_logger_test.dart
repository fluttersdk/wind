import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttersdk_wind/fluttersdk_wind.dart';

void main() {
  late List<String> printLog;

  setUp(() {
    printLog = [];
    debugPrint = (String? message, {int? wrapWidth}) {
      printLog.add(message ?? '');
    };
  });

  tearDown(() {
    debugPrint = debugPrintThrottled;
  });

  group('WindLogger', () {
    // 1. Disabled mode no-op
    test('disabled mode suppresses all output', () {
      final logger = WindLogger(debug: false, widgetName: 'X');

      logger.setCoreWidget('Image.network(...)');
      logger.setFinalStyles(WindStyle());
      logger.wrapWith('SizedBox', 'width: 100');
      logger.logStep('ClassName', "'foo'");
      logger.printFinalCode();

      expect(printLog, isEmpty);
    });

    // 2. Enabled mode start banner
    test('enabled mode prints START banner on construction', () {
      WindLogger(debug: true, widgetName: 'WImage');

      expect(
        printLog.first,
        contains('--- [WIND DEBUG] START: WImage ---'),
      );
    });

    // 3. setCoreWidget reflected in printFinalCode output
    test('setCoreWidget value appears in printFinalCode output', () {
      final logger = WindLogger(debug: true, widgetName: 'WDiv');
      printLog.clear();

      logger.setCoreWidget('Image.network(...)');
      logger.printFinalCode();

      expect(printLog.join('\n'), contains('Image.network(...)'));
    });

    // 4. wrapWith inside-out order: later wrapWith call produces outer wrapper
    test(
        'wrapWith produces outer wrapper for later call (insert-at-0 semantics)',
        () {
      final logger = WindLogger(debug: true, widgetName: 'WDiv');
      printLog.clear();

      logger.wrapWith('SizedBox', 'width: 100');
      logger.wrapWith('Padding', 'all: 8');
      logger.printFinalCode();

      final output = printLog.join('\n');
      final paddingIndex = output.indexOf('Padding(');
      final sizedBoxIndex = output.indexOf('SizedBox(');

      expect(paddingIndex, isNot(-1),
          reason: 'Padding should appear in output');
      expect(sizedBoxIndex, isNot(-1),
          reason: 'SizedBox should appear in output');
      expect(
        paddingIndex < sizedBoxIndex,
        isTrue,
        reason: 'Padding (outer) must appear before SizedBox (inner)',
      );
    });

    // 5. printFinalCode renders all sections
    test('printFinalCode renders all expected section banners', () {
      final logger = WindLogger(debug: true, widgetName: 'WButton');
      printLog.clear();

      logger.setCoreWidget('TextButton(...)');
      logger.setFinalStyles(WindStyle());
      logger.wrapWith('Padding', 'all: 4');
      logger.printFinalCode();

      final output = printLog.join('\n');
      expect(output, contains('--- [WIND DEBUG] Composition Tree: ---'));
      expect(output, contains('--- [WIND DEBUG] Build Time:'));
      expect(output, contains('--- [WIND DEBUG] END: WButton ---'));
      expect(output, contains('--- [WIND DEBUG] Final Styles:'));
    });

    // 6. logStep with 3-space indent
    test("logStep prints '   Step: detail' with three-space prefix", () {
      final logger = WindLogger(debug: true, widgetName: 'WText');
      printLog.clear();

      logger.logStep('ClassName', "'foo'");

      expect(printLog, contains("   ClassName: 'foo'"));
    });

    // 7. Final styles null path: no Final Styles section when setFinalStyles is never called
    test(
        'printFinalCode omits Final Styles section when setFinalStyles not called',
        () {
      final logger = WindLogger(debug: true, widgetName: 'WDiv');
      printLog.clear();

      logger.setCoreWidget('const SizedBox.shrink()');
      logger.printFinalCode();

      final output = printLog.join('\n');
      expect(output, isNot(contains('Final Styles:')));
    });

    // Bonus: logStep is no-op when debug is false
    test('logStep is suppressed in disabled mode', () {
      final logger = WindLogger(debug: false, widgetName: 'WText');
      logger.logStep('ClassName', "'bar'");

      expect(printLog, isEmpty);
    });
  });
}
