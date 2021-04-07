import 'package:faster_driver/src/default_template.dart';
import 'package:faster_driver/src/file_system.dart';
import 'package:path/path.dart' as p;

class TestWriter {
  TestWriter(this._fileSystem);

  final FileSystem _fileSystem;

  Future<int> generateMainTest({
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
    if (files.isNotEmpty) {
      final content = template
          .replaceFirst('<<imports>>', _imports(files).join('\n'))
          .replaceFirst('<<args>>', '')
          .replaceFirst('<<main body>>', _mains(files).join('\n'));
      await _fileSystem.createFile(Uri.file(path), content: content);
    }

    return files.length;
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
