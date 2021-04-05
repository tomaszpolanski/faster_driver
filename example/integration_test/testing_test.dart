import 'package:example/app.dart';
import 'package:example/pages/page_1.dart';
import 'package:example/pages/page_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

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

  group('http test', () {
    testWidgets('End to End', (tester) async {
      await tester.pumpWidget(const _HttpWidget(http.get));

      final finder = find.text('Done');
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(seconds: 1));
        if (findsOneWidget.matches(finder, {})) {
          break;
        }
      }

      expect(finder, findsOneWidget);
    });

    testWidgets('mocked', (tester) async {
      await tester.pumpWidget(
        _HttpWidget((url, {headers}) async => http.Response('', 200)),
      );

      await tester.pump();

      expect(find.text('Done'), findsOneWidget);
    });
  });
}

typedef GetCall = Future<http.Response> Function(
  Uri url, {
  Map<String, String>? headers,
});

class _HttpWidget extends StatelessWidget {
  const _HttpWidget(this.httpGet, {Key? key}) : super(key: key);

  final GetCall httpGet;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FutureBuilder(
        future: httpGet(Uri.parse('https://pub.dev/')),
        builder: (context, sn) {
          return sn.connectionState == ConnectionState.done
              ? const Text('Done')
              : const Text('Waiting');
        },
      ),
    );
  }
}
