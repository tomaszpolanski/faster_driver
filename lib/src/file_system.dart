import 'dart:io';

class FileSystem {
  String? fullPath(String path) {
    final dir = Directory(path);
    if (dir.existsSync()) {
      return dir.absolute.path;
    } else {
      final file = File(path);
      if (file.existsSync()) {
        return file.absolute.path;
      }
    }
    return null;
  }

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

  String getCurrentDir(String file) {
    return File(file).parent.absolute.path;
  }

  Future<void> createFile(
    Uri file, {
    required String content,
  }) async {
    final f = File.fromUri(file).openWrite()..writeln(content);
    await f.close();
  }
}
