import 'dart:io';

class FileSystem {
  List<String> getFiles(
    Uri directory, {
    required bool Function(String path) predicate,
    bool recursive = true,
  }) {
    return Directory.fromUri(directory)
        .listSync(recursive: true)
        .where((file) => predicate(file.path))
        .map((file) => file.path)
        .toList(growable: false);
  }

  Future<void> createFile(
    Uri file, {
    required String content,
  }) async {
    final f = File.fromUri(file).openWrite()..writeln(content);
    await f.close();
  }
}
