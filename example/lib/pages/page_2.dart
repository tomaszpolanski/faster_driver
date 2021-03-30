import 'package:example/pages/base_page.dart';
import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  static const route = '/page2';

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      title: route,
      color: Colors.purpleAccent,
    );
  }
}
