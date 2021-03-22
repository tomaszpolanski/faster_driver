import 'package:faster_driver/src/argument_parser.dart';
import 'package:test/test.dart';

void main() {
  group('parse', () {
    const defaultDir = 'dir';
    group('directory', () {
      test('reads directory', () {
        const directory = '.';

        // ignore: avoid_as
        final result = ArgumentParser().parse([directory]) as MainArgs;

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
        final result =
            // ignore: avoid_as
            ArgumentParser().parse(['--file', file, defaultDir]) as MainArgs;

        expect(result.file, file);
      });

      test('file falls back to default', () {
        const file = 'main_tests.dart';
        // ignore: avoid_as
        final result = ArgumentParser().parse([defaultDir]) as MainArgs;

        expect(result.file, file);
      });
    });

    group('help', () {
      test('displays help', () {
        final result = ArgumentParser().parse(['--help']);

        expect(result, isA<HelpArgs>());
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
