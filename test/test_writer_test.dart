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

    group('single', () {
      const content = '''
import 'package:integration_test/integration_test.dart';

import 'simple_test.dart' as simple;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  simple.main();
}
''';

      test('writes single test', () {
        fileSystem.mockGetFiles = ['simple_test.dart'];
        fileSystem.mockGetCurrentDir = '';
        tested = TestWriter(fileSystem);

        tested.generateMainTest('/main_tests.dart');

        expect(fileSystem.mockCreateFile, content);
      });

      test('parses path properly on windows', () {
        fileSystem.mockGetFiles = [
          r'C:\Android\faster_driver\example\integration_test\simple_test.dart',
        ];
        fileSystem.mockGetCurrentDir =
            r'C:\Android\faster_driver\example\integration_test\';
        tested = TestWriter(fileSystem);

        tested.generateMainTest(
            r'C:\Android\faster_driver\example\integration_test\main_tests.dart');

        expect(fileSystem.mockCreateFile, content);
      });

      test('removes first slash', () {
        fileSystem.mockGetFiles = [
          '/home/tomek/Documents/GitHub/faster_driver/example/integration_test/simple_test.dart',
        ];
        fileSystem.mockGetCurrentDir =
            '/home/tomek/Documents/GitHub/faster_driver/example/integration_test';
        tested = TestWriter(fileSystem);

        tested.generateMainTest(
            '/home/tomek/Documents/GitHub/faster_driver/example/integration_test/main_tests.dart');

        expect(fileSystem.mockCreateFile, content);
      });

      test('removes first backslash on windows', () {
        fileSystem.mockGetFiles = [
          r'C:\Android\faster_driver\example\integration_test\simple_test.dart',
        ];
        fileSystem.mockGetCurrentDir =
            r'C:\Android\faster_driver\example\integration_test';
        tested = TestWriter(fileSystem);

        tested.generateMainTest(
            r'C:\Android\faster_driver\example\integration_test\main_tests.dart');

        expect(fileSystem.mockCreateFile, content);
      });
    });

    test('writes recursive tests', () {
      const content = '''
import 'package:integration_test/integration_test.dart';

import 'simple_test.dart' as simple;
import 'inner/recursive_test.dart' as inner_recursive;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  simple.main();
  inner_recursive.main();
}
''';
      fileSystem.mockGetFiles = [
        'simple_test.dart',
        'inner/recursive_test.dart',
      ];
      fileSystem.mockGetCurrentDir = '';
      tested = TestWriter(fileSystem);

      tested.generateMainTest('./main_tests.dart');

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
    return mockGetFiles;
  }

  late String mockGetCurrentDir;

  @override
  String getCurrentDir(String file) {
    return mockGetCurrentDir;
  }

  @override
  String? fullPath(String path) {
    return null;
  }
}
