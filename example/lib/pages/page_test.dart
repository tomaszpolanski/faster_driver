import 'package:example/pages/base_page.dart';
import 'package:flutter/material.dart';

class PageTest extends StatelessWidget {
  const PageTest({Key? key}) : super(key: key);
  static const route = '/page-test';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('AlertDialog Title'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: const <Widget>[
                        Text('This is a demo alert dialog.'),
                        Text('Would you like to approve of this message?'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Approve'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('Show dialog'),
        ),
      ),
    );
  }
}
