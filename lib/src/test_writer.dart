import 'package:faster_driver/src/file_system.dart';
import 'package:path/path.dart' as p;

class TestWriter {
  TestWriter(this._fileSystem);

  final FileSystem _fileSystem;

  Future<void> generateMainTest(String path) async {
    final files = _fileSystem.getFiles(
      Uri.directory(p.dirname(path)),
      predicate: (path) => path.contains('_test.dart'),
    );
    final sb = StringBuffer()
      ..writeln("import 'package:integration_test/integration_test.dart';")
      ..writeln('')
      ..writeln(_imports(files).join('\n'))
      ..writeln('')
      ..writeln('''
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();''')
      ..writeln(_mains(files).join('\n'))
      ..writeln('}');
    _fileSystem.createFile(Uri.file(path), content: sb.toString());
  }

  Iterable<String> _imports(List<String> files) sync* {
    for (final file in files) {
      final name = p.basename(file);
      yield "import '$name' as ${name.replaceAll('_test.dart', '')};";
    }
  }

  Iterable<String> _mains(List<String> files) sync* {
    for (final file in files) {
      final name = p.basename(file).replaceAll('_test.dart', '');
      yield "  $name.main();";
    }
  }
}
