import 'package:faster_driver/src/file_system.dart';
import 'package:path/path.dart' as p;

class TestWriter {
  TestWriter(this._fileSystem);

  final FileSystem _fileSystem;

  Future<void> generateMainTest({
    required String directory,
    required String fileName,
  }) async {
    final path = p.join(directory, fileName);
    final root = p.canonicalize(_fileSystem.getCurrentDir(path));

    final files = _fileSystem
        .getFiles(
          Uri.directory(root),
          predicate: (path) => path.contains('_test.dart'),
        )
        .map((f) => p.relative(f, from: root))
        .map((f) => f.replaceAll(r'\', '/'))
        .map((f) => f[0] == '/' ? f.substring(1) : f)
        .toList();
    final sb = StringBuffer()
      ..writeln("import 'package:integration_test/integration_test.dart';")
      ..writeln()
      ..writeln(_imports(files).join('\n'))
      ..writeln()
      ..writeln(
        'void main() {\n'
        '  IntegrationTestWidgetsFlutterBinding.ensureInitialized();',
      )
      ..writeln(_mains(files).join('\n'))
      ..writeln('}');
    await _fileSystem.createFile(Uri.file(path), content: sb.toString());
  }

  Iterable<String> _imports(List<String> files) sync* {
    for (final file in files) {
      yield "import '$file' as ${_testName(file)};";
    }
  }

  String _testName(String file) =>
      file.replaceAll('/', '_').replaceAll('_test.dart', '');

  Iterable<String> _mains(List<String> files) sync* {
    for (final file in files) {
      yield '  ${_testName(file)}.main();';
    }
  }
}
