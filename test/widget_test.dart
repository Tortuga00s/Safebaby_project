import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safebaby/main.dart';

void main() {
  testWidgets('SafeBabyApp initializes and pumps successfully',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const SafeBabyApp());
    expect(find.byType(SafeBabyApp), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
  });
}
