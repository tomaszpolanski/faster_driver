library faster_driver;

import 'dart:io';

import 'package:faster_driver/src/file_system.dart';
import 'package:faster_driver/src/test_writer.dart';
import 'package:path/path.dart' as p;

void main() async {
  final fs = FileSystem();
  final testWriter = TestWriter(fs);
  testWriter.generateMainTest(
    p.join(Directory.current.path, 'main_tests.dart'),
  );
}
