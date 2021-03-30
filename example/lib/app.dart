import 'dart:math';

import 'package:example/pages/base_page.dart';
import 'package:example/pages/page_1.dart';
import 'package:example/pages/page_2.dart';
import 'package:example/pages/page_3.dart';
import 'package:example/pages/page_4.dart';
import 'package:example/pages/page_test.dart';
import 'package:flutter/material.dart';

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key, this.route}) : super(key: key);

  final String? route;

  @override
  Widget build(BuildContext context) {
    final r = route ?? PageTest.route;
    return MaterialApp(
      title: 'Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: r,
      onUnknownRoute: (settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => BasePage(
            title: r,
            color: Color.lerp(
              Colors.red,
              Colors.orange,
              Random().nextDouble(),
            )!,
          ),
        );
      },
      routes: {
        Page1.route: (_) => const Page1(),
        Page2.route: (_) => const Page2(),
        Page3.route: (_) => const Page3(),
        Page4.route: (_) => const Page4(),
        PageTest.route: (_) => const PageTest(),
      },
    );
  }
}
