import 'package:cli_util/cli_logging.dart';
import 'package:faster_driver/faster_driver.dart';
import 'package:test/test.dart';

void main() {
  group('help', () {
    late _MockLogger logger;

    setUp(() {
      logger = _MockLogger();
    });

    test('is shown on error', () async {
      await run([], logger: logger);

      expect(logger.stderrMock, startsWith('Missing root directory for tests'));
    });

    test('show help', () async {
      await run(['-h'], logger: logger);

      expect(
        logger.stdoutMock,
        startsWith(
          'Merges new flutter driver tests into one main test file.',
        ),
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
