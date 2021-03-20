import 'package:args/args.dart';

class ArgumentParser {
  Args parse(List<String> args) {
    final params = _scriptParameters.parse(args);
    late String dir;
    if (params.rest.length == 1) {
      dir = params.rest.first;
    } else {
      throw ArgumentException.missingDirectory();
    }
    return Args(
      directory: dir,
      file: params[_fileArg],
    );
  }
}

class Args {
  const Args({
    required this.directory,
    required this.file,
  });

  final String directory;
  final String file;
}

class ArgumentException implements Exception {
  ArgumentException.missingDirectory()
      : message = 'Missing root directory for tests';

  final String message;
}

const _fileArg = 'file';
ArgParser _scriptParameters = ArgParser()
  ..addOption(
    _fileArg,
    abbr: _fileArg[0],
    help: 'Specifies aggregated file name to be generated',
    defaultsTo: 'main_tests.dart',
  );
