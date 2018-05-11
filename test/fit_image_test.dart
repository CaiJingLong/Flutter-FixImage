import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fit_image/fit_image.dart';

void main() {
  testWidgets("FixImage", (WidgetTester tester) async {
    Widget image = new FitImage(
      child: new Image.asset("img/flutter-mark-square-100.png"),
      fit: BoxFit.cover,
    );
    tester.pumpWidget(image);
  });
}
