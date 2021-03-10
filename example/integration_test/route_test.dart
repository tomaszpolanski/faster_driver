import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:example/app.dart';
import 'package:example/routes.dart' as routes;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  group('Route navigation', () {
    [
      ...List.generate(
          20,
          (index) => [
                routes.page1,
                routes.page2,
                routes.page3,
                routes.page4,
              ]).expand((element) => element),
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
          20,
          (index) => [
                routes.page1,
                routes.page2,
                routes.page3,
                routes.page4,
              ]).expand((element) => element),
    ].forEach((route) {
      testWidgets(route, (tester) async {
        await tester.pumpWidget(ExampleApp(route: route));

        expect(find.text(route), findsOneWidget);
      });
    });
  });
}
