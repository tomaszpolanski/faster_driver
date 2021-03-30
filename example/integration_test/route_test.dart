import 'package:example/app.dart';
import 'package:example/pages/page_1.dart';
import 'package:example/pages/page_2.dart';
import 'package:example/pages/page_3.dart';
import 'package:example/pages/page_4.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Route navigation', () {
    [
      ...List.generate(
          20,
          (index) => [
                Page1.route,
                Page2.route,
                Page3.route,
                Page4.route,
              ]).expand((element) => element),
      // ignore: avoid_function_literals_in_foreach_calls
    ].forEach((route) {
      testWidgets(route, (tester) async {
        await tester.pumpWidget(ExampleApp(route: route));

        expect(find.text(route), findsOneWidget);
      });
    });
  });

  group('Small Route navigation', () {
    setUpAll(() {
      // appWindow
      //   ..size = Size(500, 900)
      //   ..show();
    });
    [
      ...List.generate(
          200,
          (index) => [
                Page1.route,
                Page2.route,
                Page3.route,
                Page4.route,
              ]).expand((element) => element),
      // ignore: avoid_function_literals_in_foreach_calls
    ].forEach((route) {
      testWidgets(route, (tester) async {
        await tester.pumpWidget(ExampleApp(route: route));

        expect(find.text(route), findsOneWidget);
      });
    });
  });
}
