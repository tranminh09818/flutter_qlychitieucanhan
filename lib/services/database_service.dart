// trang database
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//import 'package:sqflite/sqflite.dart';
//import 'package:path/path.dart';
import '../models/transaction.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expense.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        type TEXT,
        icon TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL,
        note TEXT,
        date TEXT,
        type TEXT,
        category_id INTEGER,
        user_id INTEGER
      )
    ''');
    Future<int> insertTransaction(TransactionModel transaction) async {
      final db = await database;
      return await db.insert(
        'transactions',
        transaction.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> insertTransaction(TransactionModel transaction) async {}
}
