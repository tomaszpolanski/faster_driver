import 'package:example/pages/base_page.dart';
import 'package:flutter/material.dart';

class Page4 extends StatelessWidget {
  const Page4({Key? key}) : super(key: key);
  static const route = '/page4';

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      title: route,
      color: Colors.red,
    );
  }
}
