import 'package:example/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/pages/page_1.dart';

import '../screenshots.dart';

void main() {
  group('Subfolder tests', () {
    testWidgets('- checking text on first page', (tester) async {
      await tester.pumpWidget(
        const RepaintBoundary(
          child: ExampleApp(route: Page1.route),
        ),
      );

      expect(find.text('/page1'), findsOneWidget);
      await tester.takeScreenshot('first');
    });
  });
}
