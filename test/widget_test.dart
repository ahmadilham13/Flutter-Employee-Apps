import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:employeeapps/main.dart';

void main() {
  testWidgets('App splash screen rendering test', (WidgetTester tester) async {
    // Build the SplashScreen directly since MyApp requires SharedPreferences initialization
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(),
      ),
    );

    // Verify that the title 'EMPLOYEE PORTAL' is displayed on splash screen
    expect(find.text('EMPLOYEE PORTAL'), findsOneWidget);
    expect(find.byIcon(Icons.fingerprint_rounded), findsOneWidget);
  });
}
