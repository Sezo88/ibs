import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ibs_semptom_takip/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const IBSApp());
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // App should show loading state or main shell
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
