import 'package:faster_driver/src/argument_parser.dart';

class Shard<T> {
  const Shard(
    this.list, {
    required this.totalShards,
  });

  final List<T> list;
  final int totalShards;

  List<T> split(int shardIndex) {
    if (totalShards < 1) {
      throw ArgumentException.shardInvalidTotal(totalShards);
    }
    if (shardIndex >= totalShards || shardIndex < 0) {
      throw ArgumentException.shardOutOfBounds(
        shards: totalShards,
        index: shardIndex,
      );
    }
    final shardLength = list.length ~/ totalShards;

    final offsetList = list.skip(shardIndex * shardLength);
    return (shardIndex == totalShards - 1
            ? offsetList
            : offsetList.take(shardLength))
        .toList();
  }
}
