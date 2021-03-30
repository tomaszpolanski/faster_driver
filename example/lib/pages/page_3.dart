import 'package:example/pages/base_page.dart';
import 'package:flutter/material.dart';

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);
  static const route = '/page3';

  @override
  Widget build(BuildContext context) {
    return const BasePage(
      title: route,
      color: Colors.red,
    );
  }
}
