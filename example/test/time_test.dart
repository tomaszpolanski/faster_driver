import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('time test', (tester) async {
    const done = Key('done');
    const pending = Key('pending');
    await tester.pumpWidget(
      FutureBuilder(
        future: Future<void>.delayed(const Duration(seconds: 10)),
        builder: (context, sn) {
          return sn.connectionState == ConnectionState.done
              ? const SizedBox(key: done)
              : const SizedBox(key: pending);
        },
      ),
    );

    await tester.pump(const Duration(seconds: 10));

    expect(find.byKey(done), findsOneWidget);
  });
}
