import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterEx on WidgetTester {
  Future<void> takeScreenshot(String name) async {
    if (!kIsWeb) {
      final RenderRepaintBoundary boundary =
          firstRenderObject(find.byType(RepaintBoundary));
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData.buffer.asUint8List();

      final file = await File('${Directory.current.path}/screenshots/$name.png')
          .create(recursive: true);
      await file.writeAsBytes(pngBytes);
    }
  }
}
