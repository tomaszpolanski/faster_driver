import 'package:args/args.dart';
import 'package:faster_driver/src/utils/colorize/colorizing.dart';

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
      testArguments: params.wasParsed(_testArgumentsArg)
          ? [params[_testArgumentsArg]]
          : [],
    );
  }
}

abstract class Args {}

class MainArgs implements Args {
  const MainArgs({
    required this.directory,
    required this.file,
    required this.testArguments,
  });

  final String directory;
  final String file;
  final List<String> testArguments;
}

class HelpArgs implements Args {
  HelpArgs(String message)
      : message = 'Merges new flutter driver tests into one main test file.\n'
            'Usage: ${bold('fasterdriver <directory>')}\n'
            'E.g. ${green('fasterdriver .')}\n\n'
            '$message';

  final String message;
}

final String _help = '\nUse ${green('--help')} for support.';

class ArgumentException implements Exception {
  ArgumentException.missingDirectory()
      : message = 'Missing root directory for tests.$_help';

  final String message;
}

const _fileArg = 'file';
const _helpArg = 'help';
const _testArgumentsArg = 'test-args';
ArgParser _scriptParameters = ArgParser()
  ..addOption(
    _fileArg,
    abbr: _fileArg[0],
    help: 'Specifies aggregated file name to be generated',
    defaultsTo: 'main_tests.dart',
  )
  ..addOption(
    _testArgumentsArg,
    help: 'Specifies arguments passed to tests',
  )
  ..addFlag(
    _helpArg,
    abbr: _helpArg[0],
    help: 'Displays this help',
    negatable: false,
  );
