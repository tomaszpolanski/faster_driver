library faster_driver;

import 'package:cli_util/cli_logging.dart';
import 'package:faster_driver/src/argument_parser.dart';
import 'package:faster_driver/src/file_system.dart';
import 'package:faster_driver/src/test_writer.dart';

Future<void> run(
  List<String> args, {
  required Logger logger,
}) async {
  try {
    final arguments = ArgumentParser().parse(args);
    if (arguments is HelpArgs) {
      logger.stdout(arguments.message);
      return;
    } else if (arguments is MainArgs) {
      final fs = FileSystem();
      final testWriter = TestWriter(fs);
      await testWriter.generateMainTest(
        directory: arguments.directory,
        fileName: arguments.file,
      );
    }
  } on ArgumentException catch (e) {
    logger.stderr(e.message);
  }
}
