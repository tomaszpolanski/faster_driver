library faster_driver;

import 'package:cli_util/cli_logging.dart';
import 'package:faster_driver/src/argument_parser.dart';
import 'package:faster_driver/src/test_writer.dart';
import 'package:faster_driver/src/utils/colorize/colorizing.dart';

Future<void> run(
  List<String> args, {
  required Logger logger,
  required TestWriter testWriter,
}) async {
  try {
    final arguments = ArgumentParser().parse(args);
    if (arguments is HelpArgs) {
      logger.stdout(arguments.message);
      return;
    } else if (arguments is MainArgs) {
      final testFileCount = await testWriter.generateMainTest(
        directory: arguments.directory,
        fileName: arguments.file,
      );
      if (testFileCount != 0) {
        logger.stdout(
          'Merged ${bold('$testFileCount')} test file(s) into '
          'one ${bold(arguments.file)}',
        );
      } else {
        logger.stdout(
          '${red('No test')} were found. '
          'Make sure the tests have postfix ${bold('_test.dart')}.',
        );
      }
    }
  } on ArgumentException catch (e) {
    logger.stderr(e.message);
  }
}
