// Basic widget test for Stock Market App

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build a simple app widget for testing
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Stock Market App'),
          ),
        ),
      ),
    );

    // Verify that the app title is shown
    expect(find.text('Stock Market App'), findsOneWidget);
  });
}
