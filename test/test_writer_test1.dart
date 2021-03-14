import 'package:faster_driver/src/file_system.dart';
import 'package:faster_driver/src/test_writer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TestWriter tested;

  group('generateMainTest', () {
    late _MockFileSystem fileSystem;
    setUp(() {
      fileSystem = _MockFileSystem();
    });

    test('writes single test', () {
      const content = '''
import 'package:integration_test/integration_test.dart';

import 'simple_test.dart' as simple;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  simple.main();
}
''';
      fileSystem.mockGetFiles = ['simple_test.dart'];
      tested = TestWriter(fileSystem);

      tested.generateMainTest('main_tests.dart');

      expect(fileSystem.mockCreateFile, content);
    });
  });
}

class _MockFileSystem implements FileSystem {
  late String mockCreateFile;

  @override
  Future<void> createFile(Uri file, {required String content}) async {
    mockCreateFile = content;
  }

  late List<String> mockGetFiles;

  @override
  List<String> getFiles(
    Uri directory, {
    required bool Function(String path) predicate,
    bool recursive = true,
  }) {
    return [];
  }
}
