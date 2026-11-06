import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker_app/database/database_helper.dart';
import 'package:personal_expense_tracker_app/main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    // Ensure DB is initialized
    await DatabaseHelper.instance.database;
  });

  testWidgets('Expense Tracker app renders dashboard correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ExpenseTrackerApp());

    // Allow async load to complete
    await tester.runAsync(() async {
      await DatabaseHelper.instance.getAllTransactions();
    });
    await tester.pump();

    // Verify app bar title
    expect(find.text('Expense Tracker'), findsOneWidget);

    // Verify FAB for adding transaction is present
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Verify summary cards title
    expect(find.text('Total Income'), findsOneWidget);
    expect(find.text('Total Expense'), findsOneWidget);
    expect(find.text('Current Balance'), findsOneWidget);
  });
}
