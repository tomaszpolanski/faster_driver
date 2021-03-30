import 'package:example/pages/base_page.dart';
import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({Key key}) : super(key: key);

  static const route = '/page1';

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      title: route,
      color: Colors.orange,
    );
  }
}
