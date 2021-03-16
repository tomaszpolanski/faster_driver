library faster_driver;

import 'dart:io';

import 'package:faster_driver/src/file_system.dart';
import 'package:path/path.dart' as p;

void main(List<String> paths) async {
  final fs = FileSystem();
  print('WWW ${Directory.current.path}');
  print(fs.fullPath(
    p.join('subfoldsdaer'),
  ));
  // final testWriter = TestWriter(fs);
  // testWriter.generateMainTest(
  //   p.join(Directory.current.path, 'main_tests.dart'),
  // );
}
