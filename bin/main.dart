library faster_driver;

import 'package:cli_util/cli_logging.dart';
import 'package:faster_driver/faster_driver.dart';
import 'package:faster_driver/src/file_system.dart';
import 'package:faster_driver/src/test_writer.dart';

Future<void> main(List<String> args) async {
  final logger = Logger.standard();
  final fs = FileSystem();
  final testWriter = TestWriter(fs);
  await run(
    args,
    testWriter: testWriter,
    logger: logger,
  );
}
