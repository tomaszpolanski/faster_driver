import 'dart:io';

import 'package:faster_driver/src/file_system.dart';
import 'package:path/path.dart' as p;

class TestWriter {
  TestWriter(this._fileSystem);

  final FileSystem _fileSystem;

  Future<int> generateMainTest({
    required String directory,
    required String fileName,
    required List<String> arguments,
    String? templateOrPath,
  }) async {
    var path = p.join(directory, fileName);
    var root = p.canonicalize(_fileSystem.getCurrentDir(path));
    String? relativeRoot;

    if (!_fileSystem.existsSync(path)) {
      final singlePath = _fileSystem.fullPath(fileName);
      final singleRoot = _fileSystem.fullPath(directory);
      if (singlePath != null && singleRoot != null) {
        path = p.canonicalize(singlePath);
        root = p.canonicalize(singleRoot);
        relativeRoot = _fileSystem.getCurrentDir(path);
      }
    }

    final files = _fileSystem
        .getFiles(
          Uri.directory(root),
          predicate: (path) => path.contains('_test.dart'),
        )
        .map((f) => p.relative(f, from: relativeRoot ?? root))
        .map((f) => f.replaceAll(r'\', '/'))
        .map((f) => f[0] == '/' ? f.substring(1) : f)
        .toList()
      ..sort((a, b) => a.compareTo(b));
    final template = _template(templateOrPath);
    if (files.isNotEmpty) {
      final expressions = template
          .split('\n')
          .where((line) => line.startsWith('#'))
          .map(Expression.fromTemplate)
          .where((e) => e != null)
          .whereType<Expression>()
          .toList();
      Iterable<String> _line(String line) sync* {
        yield line
            .replaceFirst('{{imports}}', _imports(files).join('\n'))
            .replaceFirst('{{arguments}}', _arguments(arguments))
            .replaceFirst(
                '{{main-body}}', _mains(files, expressions).join('\n'));
      }

      final content = template
          .split('\n')
          .where((line) => !line.startsWith('#'))
          .expand(_line)
          .join('\n');
      await _fileSystem.createFile(Uri.file(path), content: content);
    }

    return files.length;
  }

  String _template(String? templateOrPath) {
    if (templateOrPath != null) {
      final fullPath = _fileSystem.fullPath(templateOrPath);
      if (fullPath != null) {
        return File(fullPath).readAsStringSync();
      }
      return templateOrPath;
    }
    return defaultTemplate;
  }

  Iterable<String> _imports(List<String> files) sync* {
    for (final file in files) {
      yield "import '$file' as ${_testName(file)};";
    }
  }

  String _testName(String file) =>
      file.replaceAll('/', '_').replaceAll('_test.dart', '');

  Iterable<String> _mains(
    List<String> files,
    List<Expression> expressions,
  ) sync* {
    const mainTag = '{{main-body}}';
    const importNameTag = '{{import-name}}';
    final mainLine = expressions.firstWhere(
      (e) => e.tag == mainTag,
      orElse: () => const Expression(mainTag, '  $importNameTag.main();'),
    );
    for (final file in files) {
      yield mainLine.value.replaceAll('{{import-name}}', _testName(file));
    }
  }

  String _arguments(List<String> arguments) {
    return arguments.isEmpty
        ? '[]'
        : '[${arguments.map((a) => "'$a'").join(', ')}]';
  }
}

const defaultTemplate = '''
// ignore_for_file: directives_ordering
/// This file is autogenerated and should not be committed
/// to source control
import 'package:integration_test/integration_test.dart';
{{imports}}

void main() {
  final List<String> args = {{arguments}};
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
{{main-body}}
}
''';

class Expression {
  const Expression(this.tag, this.value);

  final String tag;
  final String value;

  static Expression? fromTemplate(String line) {
    final regExp = RegExp(r'#(\{\{.+\}\}) = (.+)');
    final match = regExp.firstMatch(line);
    if (match != null) {
      return Expression(match.group(1)!, match.group(2)!);
    }
    return null;
  }
}
