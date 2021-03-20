library faster_driver;

import 'package:faster_driver/src/argument_parser.dart';
import 'package:faster_driver/src/file_system.dart';
import 'package:faster_driver/src/test_writer.dart';

Future<void> main(List<String> args) async {
  try {
    final arguments = ArgumentParser().parse(args);
    final fs = FileSystem();
    final testWriter = TestWriter(fs);
    await testWriter.generateMainTest(
      directory: arguments.directory,
      fileName: arguments.file,
    );
  } catch (e) {
    // TODO(tomek): log exception, show help
    rethrow;
  }
}
