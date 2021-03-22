import 'package:args/args.dart';

class ArgumentParser {
  Args parse(List<String> args) {
    final params = _scriptParameters.parse(args);

    if (params[_helpArg] == true) {
      return HelpArgs(_scriptParameters.usage);
    }
    late String dir;
    if (params.rest.length == 1) {
      dir = params.rest.first;
    } else {
      throw ArgumentException.missingDirectory();
    }
    return MainArgs(
      directory: dir,
      file: params[_fileArg],
    );
  }
}

abstract class Args {}

class MainArgs implements Args {
  const MainArgs({
    required this.directory,
    required this.file,
  });

  final String directory;
  final String file;
}

class HelpArgs implements Args {
  const HelpArgs(String message)
      : message =
            'This is script that merges new flutter driver tests into one main '
                'test file.\n'
                'Usage: fasterdriver <directory>\n'
                'E.g. fasterdriver .\n\n'
                '$message';

  final String message;
}

class ArgumentException implements Exception {
  ArgumentException.missingDirectory()
      : message = 'Missing root directory for tests.$_help';

  final String message;

  static const String _help = '\nUse --help for support.';
}

const _fileArg = 'file';
const _helpArg = 'help';
ArgParser _scriptParameters = ArgParser()
  ..addOption(
    _fileArg,
    abbr: _fileArg[0],
    help: 'Specifies aggregated file name to be generated',
    defaultsTo: 'main_tests.dart',
  )
  ..addFlag(
    _helpArg,
    abbr: _helpArg[0],
    help: 'Displays this help',
  );
