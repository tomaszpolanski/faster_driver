import 'package:faster_driver/src/argument_parser.dart';

class Shard {
  const Shard._({
    required this.totalShards,
    required this.shardIndex,
  });

  factory Shard.from({
    required int totalShards,
    required int shardIndex,
  }) {
    if (totalShards < 1) {
      throw ArgumentException.shardInvalidTotal(totalShards);
    }
    if (shardIndex >= totalShards || shardIndex < 0) {
      throw ArgumentException.shardOutOfBounds(
        shards: totalShards,
        index: shardIndex,
      );
    }
    return Shard._(totalShards: totalShards, shardIndex: shardIndex);
  }

  static Shard? fromString({
    required String? totalShards,
    required String? shardIndex,
  }) {
    final total = int.tryParse(totalShards ?? '');
    final index = int.tryParse(shardIndex ?? '');

    if (total != null && index != null) {
      return Shard.from(totalShards: total, shardIndex: index);
    } else if (total != null || index != null) {
      throw ArgumentException.shardMissingShardArgument();
    }
    return null;
  }

  final int totalShards;
  final int shardIndex;

  List<T> split<T>(List<T> list) {
    final shardLength = list.length ~/ totalShards;

    final offsetList = list.skip(shardIndex * shardLength);
    return (shardIndex == totalShards - 1
            ? offsetList
            : offsetList.take(shardLength))
        .toList();
  }
}
