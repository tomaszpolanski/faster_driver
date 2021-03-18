import 'package:example/app.dart';
import 'package:example/routes.dart' as routes;
import 'package:flutter_test/flutter_test.dart';

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
                routes.page1,
                routes.page2,
                routes.page3,
                routes.page4,
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
