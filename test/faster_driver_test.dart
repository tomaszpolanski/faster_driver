import 'package:cli_util/cli_logging.dart';
import 'package:faster_driver/faster_driver.dart';
import 'package:test/test.dart';
import 'package:faster_driver/src/test_writer.dart';

void main() {
  late _MockLogger logger;
  late _MockTestWriter testWriter;

  setUp(() {
    logger = _MockLogger();
    testWriter = _MockTestWriter()..generateMainTestMock = 1;
  });

  group('help', () {
    test('is shown on error', () async {
      await run([], logger: logger, testWriter: testWriter);

      expect(logger.stderrMock, startsWith('Missing root directory for tests'));
    });

    test('show help', () async {
      await run(['-h'], logger: logger, testWriter: testWriter);

      expect(
        logger.stdoutMock,
        startsWith(
          'Merges new flutter driver tests into one main test file.',
        ),
      );
    });
  });

  group('output', () {
    test('displays if there were tests found', () async {
      await run(['.'], logger: logger, testWriter: testWriter);

      expect(
        logger.stdoutMock,
        'Merged \x1B[1m1\x1B[0m test file(s) into '
        'one \x1B[1mmain_tests.dart\x1B[0m',
      );
    });

    test('displays warning if no tests were found', () async {
      await run(
        ['.'],
        logger: logger,
        testWriter: testWriter..generateMainTestMock = 0,
      );

      expect(
        logger.stdoutMock,
        '\x1B[91mNo test\x1B[0m were found. Make sure the tests have '
        'postfix \x1B[1m_test.dart\x1B[0m.',
      );
    });
  });
}

class _MockLogger implements Logger {
  @override
  Ansi get ansi => throw UnimplementedError();

  @override
  void flush() {}

  @override
  bool get isVerbose => throw UnimplementedError();

  @override
  Progress progress(String message) {
    throw UnimplementedError();
  }

  late String stderrMock;

  @override
  void stderr(String message) => stderrMock = message;

  late String stdoutMock;

  @override
  void stdout(String message) => stdoutMock = message;

  @override
  void trace(String message) {}

  @override
  void write(String message) {}

  @override
  void writeCharCode(int charCode) {}
}

class _MockTestWriter implements TestWriter {
  late int generateMainTestMock;

  @override
  Future<int> generateMainTest({
    required String directory,
    required String fileName,
    required List<String> arguments,
  }) async {
    return generateMainTestMock;
  }
}
