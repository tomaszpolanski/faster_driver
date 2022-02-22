import 'package:faster_driver/src/argument_parser.dart';
import 'package:faster_driver/src/shards.dart';
import 'package:test/test.dart';

void main() {
  group('totalShards', () {
    test('total shards cannot be smaller than 1', () {
      const shards = 0;
      final exception = throws<ArgumentException>(
        () => const Shard([], totalShards: shards).split(0),
      );

      expect(
        exception?.message,
        ArgumentException.shardInvalidTotal(shards).message,
      );
    });

    test('when total shard is 1', () {
      final exception = throws<ArgumentException>(
        () => const Shard([], totalShards: 1).split(0),
      );

      expect(exception, isNull);
    });
  });

  group('split', () {
    test('when index is too big', () {
      const shards = 1;
      const index = shards;
      final exception = throws<ArgumentException>(
        () => const Shard([], totalShards: shards).split(index),
      );

      expect(
        exception?.message,
        ArgumentException.shardOutOfBounds(shards: shards, index: index)
            .message,
      );
    });

    test('when index is too small', () {
      const shards = 1;
      const index = -1;
      final exception = throws<ArgumentException>(
        () => const Shard([], totalShards: shards).split(index),
      );

      expect(
        exception?.message,
        ArgumentException.shardOutOfBounds(shards: shards, index: index)
            .message,
      );
    });

    test('return entire list when only one shard', () {
      const expected = [1];
      final result = const Shard(expected, totalShards: 1).split(0);

      expect(result, expected);
    });

    test('return split shard when event', () {
      final result = const Shard([1, 2], totalShards: 2).split(1);

      expect(result, hasLength(1));
      expect(result, contains(2));
    });
    group('return split shard when not event', () {
      const tested = Shard([1, 2, 3, 4], totalShards: 3);

      <int, List<int>>{
        0: [1],
        1: [2],
        2: [3, 4],
      }.forEach((index, shard) {
        test('for index $index', () {
          final result = tested.split(index);

          expect(result, containsAll(shard));
          expect(result, hasLength(shard.length));
        });
      });
    });
  });
}

T? throws<T>(void Function() fn) {
  try {
    fn();
  } catch (e) {
    if (e is T) {
      // ignore: avoid_as
      return e as T;
    }
  }
  return null;
}
