import 'package:flutter_test/flutter_test.dart';
import 'package:personal_expense_tracker_app/models/transaction_model.dart';
import 'package:personal_expense_tracker_app/database/database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('TransactionModel Tests', () {
    test('toMap and fromMap conversion', () {
      final transaction = TransactionModel(
        id: 1,
        title: 'Salary',
        amount: 5000.0,
        category: 'Salary',
        type: 'Income',
        date: '2025-02-27',
      );

      final map = transaction.toMap();
      expect(map['id'], 1);
      expect(map['title'], 'Salary');
      expect(map['amount'], 5000.0);
      expect(map['category'], 'Salary');
      expect(map['type'], 'Income');
      expect(map['date'], '2025-02-27');

      final fromMapTx = TransactionModel.fromMap(map);
      expect(fromMapTx.id, 1);
      expect(fromMapTx.title, 'Salary');
      expect(fromMapTx.amount, 5000.0);
      expect(fromMapTx.category, 'Salary');
      expect(fromMapTx.type, 'Income');
      expect(fromMapTx.date, '2025-02-27');
    });

    test('copyWith works correctly', () {
      final transaction = TransactionModel(
        id: 1,
        title: 'Groceries',
        amount: 150.0,
        category: 'Food',
        type: 'Expense',
        date: '2025-02-27',
      );

      final updated = transaction.copyWith(amount: 175.5);
      expect(updated.id, 1);
      expect(updated.title, 'Groceries');
      expect(updated.amount, 175.5);
    });
  });

  group('DatabaseHelper Tests', () {
    test('Insert, fetch, update, and delete transaction', () async {
      final dbHelper = DatabaseHelper.instance;

      final newTx = TransactionModel(
        title: 'Freelance Design',
        amount: 1200.0,
        category: 'Freelance',
        type: 'Income',
        date: '2025-02-27',
      );

      final insertedId = await dbHelper.insertTransaction(newTx);
      expect(insertedId, greaterThan(0));

      final allTx = await dbHelper.getAllTransactions();
      expect(allTx.any((tx) => tx.id == insertedId), isTrue);

      final fetched = await dbHelper.getTransactionById(insertedId);
      expect(fetched, isNotNull);
      expect(fetched!.title, 'Freelance Design');

      final updatedTx = fetched.copyWith(amount: 1300.0);
      final updateRows = await dbHelper.updateTransaction(updatedTx);
      expect(updateRows, 1);

      final fetchedUpdated = await dbHelper.getTransactionById(insertedId);
      expect(fetchedUpdated!.amount, 1300.0);

      final deleteRows = await dbHelper.deleteTransaction(insertedId);
      expect(deleteRows, 1);

      final fetchedDeleted = await dbHelper.getTransactionById(insertedId);
      expect(fetchedDeleted, isNull);
    });
  });
}
