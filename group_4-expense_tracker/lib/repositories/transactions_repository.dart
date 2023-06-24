import 'package:expense_app/models/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqf;

import '../models/budget.dart';

class TransactionsRepository {
  static const _budgetTable = 'budget';
  static const _expenseTable = 'expense';
  String? _dbPath;
  sqf.Database? _db;

  Future<List<Transaction>> loadTransactions(Budget budget) async {
    _dbPath = join(await sqf.getDatabasesPath(), 'expense.db');
    try {
      final dbAlreadyExists = await sqf.databaseExists(_dbPath!);
      if (dbAlreadyExists) {
        _db = await sqf.openDatabase(_dbPath!, version: 1);
        return await getAllTransactions(budget);
      } else {
        // _db = await sqf.openDatabase(
        //   _dbPath!,
        //   version: 1,
        //   onCreate: (db, version) async {
        //     await db.execute('CREATE TABLE $_budgetTable ("id"	TEXT,	"title"	TEXT,"amount"	TEXT, "createdOn"	INTEGER, PRIMARY KEY("id"))');
        //     await db.execute('CREATE TABLE $_expenseTable ("id"	TEXT,	"title"	INTEGER,	"amount"	TEXT,	"date"	INTEGER,	"createdOn"	INTEGER,	"imagePath"	TEXT,	"category"	TEXT,	FOREIGN KEY("category") REFERENCES "budget"("id"),	PRIMARY KEY("id"));');
        //   },
        //   // onConfigure: (db) => db.,
        // );
        return [];
      }
    } catch (e) {
      throw Exception('Unable to create/get database.');
    }
  }

  Future<List<Transaction>> getAllTransactions(Budget budget) async {
    try {
      final List<Map> tList = await _db!.query(_expenseTable, orderBy: 'date', where: 'category = ?', whereArgs: [budget.id]);
      final List<Transaction> transactions =
          tList.map((tMap) => Transaction.fromMap(tMap as Map<String, dynamic>)).toList();
      return transactions;
    } catch (e) {
      throw Exception('Unable to get transactions.');
    }
  }

  Future<List<Transaction>> addTransaction(
      {required List<Transaction> list, required Transaction addT, required Budget budget}) async {
    try {
      await _db!.insert(_expenseTable, addT.toMap(),
          conflictAlgorithm: sqf.ConflictAlgorithm.replace);
      return await getAllTransactions(budget);
    } catch (e) {
      throw Exception('Unable to get add transaction.');
    }
  }

  Future<List<Transaction>> removeTransaction(
      {required List<Transaction> list, required String remTID, required Budget budget}) async {
    try {
      await _db!.delete(_expenseTable, where: 'id = ?', whereArgs: [remTID]);
      return await getAllTransactions(budget);
    } catch (e) {
      throw Exception('Unable to get delete transaction.');
    }
  }

  Future<List<Transaction>> filterTransactions(
      {required String keyword}) async {
    try {
      final filtered = await _db!
          .query(_budgetTable, where: 'title LIKE ?', whereArgs: ['%$keyword%']);
      final list = filtered.map((e) => Transaction.fromMap(e)).toList();
      return list;
    } catch (e) {
      throw Exception('Unable to filter transactions.');
    }
  }

  Future<bool> updateTransaction({required Transaction transaction}) async {
    try {
      await _db!.update(_expenseTable, transaction.toMap(),
          where: 'id = ?', whereArgs: [transaction.id]);
      return true;
    } catch (e) {
      throw Exception('Unable to update transaction.');
    }
  }

  
  Future<List<Budget>> loadBudgets() async {
    _dbPath = join(await sqf.getDatabasesPath(), 'expense.db');
    try {
      final dbAlreadyExists = await sqf.databaseExists(_dbPath!);
      if (dbAlreadyExists) {
        _db = await sqf.openDatabase(_dbPath!, version: 1);
        return await getAllBudgets();
      } else {
        _db = await sqf.openDatabase(
          _dbPath!,
          version: 1,
          onCreate: (db, version) async {
            await db.execute('CREATE TABLE $_budgetTable ("id"	TEXT,	"title"	TEXT,"amount"	TEXT, "createdOn"	INTEGER, PRIMARY KEY("id"))');
            await db.execute('CREATE TABLE $_expenseTable ("id"	TEXT,	"title"	INTEGER,	"amount"	TEXT,	"date"	INTEGER,	"createdOn"	INTEGER,	"imagePath"	TEXT,	"category"	TEXT,	FOREIGN KEY("category") REFERENCES "budget"("id"),	PRIMARY KEY("id"));');
          },
          onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
        );
        return [];
      }
    } catch (e) {
      throw Exception('Unable to create/get database.');
    }
  }

  Future<List<Budget>> getAllBudgets() async {
    try {
      final List<Map> tList = await _db!.query(_budgetTable, orderBy: 'createdOn');
      final List<Budget> budgets =
          tList.map((tMap) => Budget.fromMap(tMap as Map<String, dynamic>)).toList();
      return budgets;
    } catch (e) {
      throw Exception('Unable to get budgets.');
    }
  }

  Future<List<Budget>> addBudget(
      {required List<Budget> list, required Budget addB}) async {
    try {
      await _db!.insert(_budgetTable, addB.toMap(),
          conflictAlgorithm: sqf.ConflictAlgorithm.replace);
      return await getAllBudgets();
    } catch (e) {
      throw Exception('Unable to get add budget.');
    }
  }

  Future<List<Budget>> removeBudget(
      {required List<Budget> list, required String remTID}) async {
    try {
      await _db!.delete(_budgetTable, where: 'id = ?', whereArgs: [remTID]);
      return await getAllBudgets();
    } catch (e) {
      throw Exception('Unable to get delete transaction.');
    }
  }

  Future<bool> updateBudget({required Budget budget}) async {
    try {
      await _db!.update(_budgetTable, budget.toMap(),
          where: 'id = ?', whereArgs: [budget.id]);
      return true;
    } catch (e) {
      throw Exception('Unable to update budget.');
    }
  }
}
