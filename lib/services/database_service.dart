import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  // Singleton
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  // Nullable Database
  Database? _database;

  // Getter للوصول للقاعدة
  Future<Database> get database async {
    // إذا كانت القاعدة موجودة بالفعل أرجعها
    if (_database != null) return _database!;

    // وإلا أنشئها
    _database = await _initDatabase();
    return _database!;
  }

  // اسم القاعدة والإصدار
  static const String _dbName = 'expense_tracker.db';
  static const int _dbVersion = 1;

  // تهيئة القاعدة
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  // إنشاء الجداول
  Future<void> _onCreate(Database db, int version) async {
    // Users
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');

    // Categories
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon TEXT,
        user_id INTEGER NOT NULL
      )
    ''');

    // Payment Methods
    await db.execute('''
      CREATE TABLE payment_methods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        user_id INTEGER NOT NULL
      )
    ''');

    // Expenses
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL NOT NULL,
        note TEXT,
        date TEXT NOT NULL,
        user_id INTEGER NOT NULL,
        category_id INTEGER NOT NULL,
        payment_method_id INTEGER NOT NULL
      )
    ''');
  }
}
