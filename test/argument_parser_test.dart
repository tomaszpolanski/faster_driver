import 'package:faster_driver/src/argument_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parse', () {
    const defaultDir = 'dir';
    group('directory', () {
      test('reads directory', () {
        const directory = '.';

        final result = ArgumentParser().parse([directory]);

        expect(result.directory, directory);
      });

      test('reads directory', () {
        final exception = throws<ArgumentException>(
          () => ArgumentParser().parse([]),
        );

        expect(
            exception?.message, ArgumentException.missingDirectory().message);
      });
    });

    group('file', () {
      test('reads file', () {
        const file = 'some_file.dart';

        final result = ArgumentParser().parse(['--file', file, defaultDir]);

        expect(result.file, file);
      });

      test('file falls back to default', () {
        const file = 'main_tests.dart';

        final result = ArgumentParser().parse([defaultDir]);

        expect(result.file, file);
      });
    });
  });
}

T? throws<T>(void Function() fn) {
  try {
    fn();
  } catch (e) {
    if (e is T) {
      // ignore: avoid_as
      return e as T;
    }
  }
  return null;
}
