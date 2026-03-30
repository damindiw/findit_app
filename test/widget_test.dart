import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findit_app/main.dart'; 

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Changed MyApp() to FinditApp() to fix the compilation error
    await tester.pumpWidget(const FinditApp()); 

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}