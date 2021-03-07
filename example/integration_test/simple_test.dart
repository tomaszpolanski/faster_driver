import 'package:example/app.dart';
import 'package:example/pages/page_1.dart';
import 'package:example/routes.dart' as routes;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Set of simple tests', () {
    testWidgets('- checking text on first page', (tester) async {
      await tester.pumpWidget(ExampleApp(route: routes.page1));

      expect(find.text('/page1'), findsOneWidget);
    });

    testWidgets('- checking text on second page', (tester) async {
      await tester.pumpWidget(ExampleApp(route: routes.page2));

      expect(find.text('/page2'), findsOneWidget);
    });
  });

  group('using setup to restart every test', () {
    testWidgets('- checking text', (tester) async {
      await tester.pumpWidget(ExampleApp(route: routes.page1));
      expect(find.text('/page1'), findsOneWidget);
    });

    testWidgets('- checking type', (tester) async {
      await tester.pumpWidget(ExampleApp(route: routes.page1));
      expect(find.byType(Page1), findsOneWidget);
    });
  });
}
