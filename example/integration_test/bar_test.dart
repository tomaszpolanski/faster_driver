import 'package:example/app.dart';
import 'package:example/routes.dart' as routes;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Route navigation', () {
    [
      routes.page1,
      routes.page2,
      routes.page3,
      routes.page4,
    ].forEach((route) {
      testWidgets(route, (tester) async {
        await tester.pumpWidget(ExampleApp(route: route));

        expect(find.text(route), findsOneWidget);
      });
    });
  });

  // group('Speed test', () {
  //   List.generate(30, (index) => '/generated_page_$index').forEach((route) {
  //     test(route, () async {
  //       await restart(route);
  //
  //       await driver.waitFor(find.text(route));
  //     });
  //   });
  //
  //   group('with screenshots', () {
  //     late Screenshot screenshot;
  //
  //     setUpAll(() async {
  //       screenshot = await Screenshot.create(driver, 'route_test',
  //           enabled: properties.screenshotsEnabled);
  //     });
  //
  //     List.generate(30, (index) => '/generated_page_$index').forEach((route) {
  //       test(route, () async {
  //         await restart(route);
  //
  //         await driver.waitFor(find.text(route));
  //         await screenshot.takeScreenshot(route);
  //       });
  //     });
  //   });
  // });
}
