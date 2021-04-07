import 'dart:io';

import 'package:faster_driver/src/default_template.dart';
import 'package:faster_driver/src/file_system.dart';
import 'package:faster_driver/src/test_writer.dart';
import 'package:test/test.dart';

void main() {
  group('generateMainTest', () {
    late _MockFileSystem fileSystem;
    setUp(() {
      fileSystem = _MockFileSystem();
    });

    group('none', () {
      test('when no tests found', () async {
        fileSystem
          ..mockGetFiles = []
          ..mockGetCurrentDir = '';

        final result = await TestWriter(fileSystem).generateMainTest(
          directory: '/',
          fileName: 'main_tests.dart',
        );

        expect(result, 0);
        expect(fileSystem.mockCreateFile, isNull);
      });
    });

    group('single', () {
      final content = template
          .replaceAll('<<imports>>', "import 'simple_test.dart' as simple;")
          .replaceAll('<<main body>>', '  simple.main();');

      test('writes single test', () {
        fileSystem
          ..mockGetFiles = ['simple_test.dart']
          ..mockGetCurrentDir = '';

        TestWriter(fileSystem).generateMainTest(
          directory: '/',
          fileName: 'main_tests.dart',
        );

        expect(fileSystem.mockCreateFile, content);
      });

      test('returns number of test files found', () async {
        fileSystem
          ..mockGetFiles = ['simple_test.dart']
          ..mockGetCurrentDir = '';

        final result = await TestWriter(fileSystem).generateMainTest(
          directory: '/',
          fileName: 'main_tests.dart',
        );

        expect(result, 1);
      });

      test(
        'parses path properly on windows',
        () {
          fileSystem
            ..mockGetFiles = [
              r'C:\Android\faster_driver\example\integration_test\simple_test.dart',
            ]
            ..mockGetCurrentDir =
                r'C:\Android\faster_driver\example\integration_test\';

          TestWriter(fileSystem).generateMainTest(
            directory: r'C:\Android\faster_driver\example\integration_test\',
            fileName: 'main_tests.dart',
          );

          expect(fileSystem.mockCreateFile, content);
        },
        skip: !Platform.isWindows,
      );

      test('removes first slash', () {
        fileSystem
          ..mockGetFiles = [
            '/home/tomek/Documents/GitHub/faster_driver/example/integration_test/simple_test.dart',
          ]
          ..mockGetCurrentDir =
              '/home/tomek/Documents/GitHub/faster_driver/example/integration_test';
        TestWriter(fileSystem).generateMainTest(
          directory:
              '/home/tomek/Documents/GitHub/faster_driver/example/integration_test/',
          fileName: 'main_tests.dart',
        );

        expect(fileSystem.mockCreateFile, content);
      });

      test(
        'removes first backslash on windows',
        () {
          fileSystem
            ..mockGetFiles = [
              r'C:\Android\faster_driver\example\integration_test\simple_test.dart',
            ]
            ..mockGetCurrentDir =
                r'C:\Android\faster_driver\example\integration_test';

          TestWriter(fileSystem).generateMainTest(
            directory: r'C:\Android\faster_driver\example\integration_test\',
            fileName: 'main_tests.dart',
          );

          expect(fileSystem.mockCreateFile, content);
        },
        skip: !Platform.isWindows,
      );

      test('uses current . dir properly', () {
        fileSystem
          ..mockGetFiles = [
            '/home/tomek/Documents/GitHub/faster_driver/example/integration_test/simple_test.dart',
          ]
          ..mockGetCurrentDir =
              '/home/tomek/Documents/GitHub/faster_driver/example/integration_test/.';
        TestWriter(fileSystem).generateMainTest(
          directory: '.',
          fileName: 'main_tests.dart',
        );

        expect(fileSystem.mockCreateFile, content);
      });
    });

    test('writes recursive tests', () {
      final content = template
          .replaceAll(
            '<<imports>>',
            "import 'simple_test.dart' as simple;\n"
                "import 'inner/recursive_test.dart' as inner_recursive;",
          )
          .replaceAll(
              '<<main body>>',
              '  simple.main();\n'
                  '  inner_recursive.main();');

      fileSystem
        ..mockGetFiles = [
          'simple_test.dart',
          'inner/recursive_test.dart',
        ]
        ..mockGetCurrentDir = '';

      TestWriter(fileSystem)
          .generateMainTest(directory: '.', fileName: 'main_tests.dart');

      expect(fileSystem.mockCreateFile, content);
    });
  });
}

class _MockFileSystem implements FileSystem {
  String? mockCreateFile;

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
