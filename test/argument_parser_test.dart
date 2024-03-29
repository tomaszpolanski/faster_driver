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

    group('template', () {
      test('reads template', () {
        const template = 'some_file.txt';
        final result =
            // ignore: avoid_as
            ArgumentParser().parse(['--template', template, defaultDir])
                as MainArgs;

        expect(result.template, template);
      });
    });

    group('test arguments', () {
      test('throws exception when unknown argument', () {
        final exception = throws<ArgumentException>(
          () => ArgumentParser().parse(['--unknown']),
        );

        expect(exception, isA<ArgumentException>());
        final ArgumentException e = exception!;
        expect(e.message, startsWith('Unknown arguments in'));
      });

      test('reads test arguments', () {
        const argument = 'argument.dart';
        final result =
            // ignore: avoid_as
            ArgumentParser().parse([defaultDir, '--test-args', argument])
                as MainArgs;

        expect(result.testArguments, [argument]);
      });

      test('reads multiple arguments', () {
        const argument1 = 'argument1';
        const argument2 = 'argument2';
        final result =
            // ignore: avoid_as
            ArgumentParser().parse([
          defaultDir,
          '--test-args',
          '$argument1 $argument2',
        ]) as MainArgs;

        expect(result.testArguments, [argument1, argument2]);
      });

      test('reads complex arguments', () {
        const argument1 = 'argument1';
        const argument2 = 'argument2 argument3';
        final result =
            // ignore: avoid_as
            ArgumentParser().parse([
          defaultDir,
          '--test-args',
          '$argument1 "$argument2"',
        ]) as MainArgs;

        expect(result.testArguments, [argument1, argument2]);
      });

      test('complex arguments can be passed with special character', () {
        const argument1 = 'argument1';
        const argument2 = 'argument2';
        final result =
            // ignore: avoid_as
            ArgumentParser().parse([
          defaultDir,
          '--test-args',
          '$argument1${ArgumentParser.separator}$argument2',
        ]) as MainArgs;

        expect(result.testArguments, [argument1, argument2]);
      });
    });

    group('shards', () {
      test('when only total is passed then complain', () {
        final exception =
            throws<ArgumentException>(() => ArgumentParser().parse(
                  ['--total-shards', '1', defaultDir],
                ));

        expect(
          exception?.message,
          ArgumentException.shardMissingShardArgument().message,
        );
      });

      test('when only index is passed then complain', () {
        final exception =
            throws<ArgumentException>(() => ArgumentParser().parse(
                  ['--shard-index', '1', defaultDir],
                ));

        expect(
          exception?.message,
          ArgumentException.shardMissingShardArgument().message,
        );
      });

      test('when both shard arguments are passed then create shard', () {
        const shards = 1;
        const index = 0;
        final result =
            // ignore: avoid_as
            ArgumentParser().parse([
          '--total-shards',
          '$shards',
          '--shard-index',
          '$index',
          defaultDir,
        ]) as MainArgs;

        expect(result.shard?.totalShards, shards);
        expect(result.shard?.shardIndex, index);
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
