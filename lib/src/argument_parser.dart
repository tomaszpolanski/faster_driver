import 'package:args/args.dart';
import 'package:faster_driver/src/shards.dart';
import 'package:faster_driver/src/utils/colorize/colorizing.dart';

class ArgumentParser {
  static const separator = ',,,';

  Args parse(List<String> args) {
    final separated = args
        .map((a) => a.replaceAll(separator, ' ')) //
        .toList(growable: false);
    final params = _parse(separated);

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
      template: params[_templateArg],
      testArguments: params.wasParsed(_testArgumentsArg)
          ? _splitTestArguments(params[_testArgumentsArg])
          : [],
      shard: Shard.fromString(
        totalShards: params[_totalShardsArg],
        shardIndex: params[_shardIndexArg],
      ),
    );
  }

  ArgResults _parse(List<String> args) {
    try {
      return _scriptParameters.parse(args);
    } on FormatException catch (e) {
      throw ArgumentException.unknownArguments(args, e);
    }
  }

  List<String> _splitTestArguments(String args) {
    return _split(args, '"')
        .expand(
          (split) => split.contained
              ? [split.value] //
              : split.value.split(' '),
        )
        .where((str) => str.isNotEmpty)
        .toList(growable: false);
  }

  Iterable<Split> _split(String str, String separator) sync* {
    String current = '';
    bool contained = false;
    for (final rune in str.runes) {
      final char = String.fromCharCode(rune);
      if (char == separator) {
        yield Split(current, contained: contained);
        current = '';
        contained = !contained;
      } else {
        current += char;
      }
    }
    yield Split(current, contained: contained);
  }
}

class Split {
  const Split(this.value, {required this.contained});

  final String value;
  final bool contained;
}

abstract class Args {}

class MainArgs implements Args {
  const MainArgs({
    required this.directory,
    required this.file,
    required this.testArguments,
    required this.shard,
    required this.template,
  });

  final String directory;
  final String file;
  final List<String> testArguments;
  final Shard? shard;
  final String? template;
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

  ArgumentException.unknownArguments(List<String> args, FormatException e)
      : message = 'Unknown arguments in $args\n$e';

  ArgumentException.shardMissingShardArgument()
      : message = 'You have only passed one shard argument, you need to pass '
            'both --$_totalShardsArg and --$_shardIndexArg';

  ArgumentException.shardInvalidTotal(int shards)
      : message = 'Total shards argument has to be 1 or greater, '
            'the current is $shards';

  ArgumentException.shardOutOfBounds({required int shards, required int index})
      : message = 'The index of a shard ($index) it out of bounds. '
            'Should be between 0 and ${shards - 1}';

  final String message;
}

const _fileArg = 'file';
const _templateArg = 'template';
const _totalShardsArg = 'total-shards';
const _shardIndexArg = 'shard-index';
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
  ..addOption(
    _templateArg,
    help: 'Template for aggregated test file',
  )
  ..addOption(
    _totalShardsArg,
    help: 'Tests can be sharded with the "--total-shards" and "--shard-index" '
        'arguments, allowing you to split up your test suites '
        'and run them separately.',
  )
  ..addOption(
    _shardIndexArg,
    help: 'Tests can be sharded with the "--total-shards" and "--shard-index" '
        'arguments, allowing you to split up your test suites '
        'and run them separately.',
  )
  ..addFlag(
    _helpArg,
    abbr: _helpArg[0],
    help: 'Displays this help',
    negatable: false,
  );
