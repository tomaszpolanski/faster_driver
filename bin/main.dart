library faster_driver;

import 'package:cli_util/cli_logging.dart';
import 'package:faster_driver/faster_driver.dart';

Future<void> main(List<String> args) async {
  final logger = Logger.standard();
  await run(args, logger: logger);
}
