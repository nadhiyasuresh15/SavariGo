// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:savarigo/main.dart';

void main() {
  testWidgets('App starts and navigates to login from splash', (WidgetTester tester) async {
    await tester.pumpWidget(const SavariGoApp());

    // Splash screen should show the tagline and loading dots
    expect(find.text('Share the Ride, Save the City 🚖🌿'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Advance past the splash delay and allow navigation
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Login screen should be visible with email and password fields
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsWidgets);
  });
}
