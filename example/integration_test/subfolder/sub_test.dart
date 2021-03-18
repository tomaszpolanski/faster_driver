import 'package:example/app.dart';
import 'package:example/routes.dart' as routes;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../screenshots.dart';

void main() {
  group('Subfolder tests', () {
    testWidgets('- checking text on first page', (tester) async {
      await tester.pumpWidget(
        const RepaintBoundary(
          child: ExampleApp(route: routes.page1),
        ),
      );

      expect(find.text('/page1'), findsOneWidget);
      await tester.takeScreenshot('first');
    });
  });
}
