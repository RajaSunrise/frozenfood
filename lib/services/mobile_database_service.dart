import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/order_model.dart';
import 'database_service.dart';
import 'dart:convert';

class MobileDatabaseService implements DatabaseService {
  Database? _database;

  @override
  Future<void> init() async {
    if (_database != null) return;
    String path = join(await getDatabasesPath(), 'frozen_food.db');
    _database = await openDatabase(
      path,
      version: 2, // Incremented version
      onCreate: (db, version) {
        _createDb(db);
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('CREATE TABLE IF NOT EXISTS orders(id TEXT PRIMARY KEY, userId TEXT, totalAmount REAL, date TEXT, items TEXT)');
        }
      },
    );
  }

  void _createDb(Database db) {
    db.execute('CREATE TABLE users(id TEXT PRIMARY KEY, email TEXT, name TEXT, password TEXT)');
    db.execute('CREATE TABLE orders(id TEXT PRIMARY KEY, userId TEXT, totalAmount REAL, date TEXT, items TEXT)');
  }

  @override
  Future<User?> login(String email, String password) async {
    await init();
    final List<Map<String, dynamic>> maps = await _database!.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<void> register(User user) async {
    await init();
    await _database!.insert(
      'users',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> saveOrder(OrderModel order) async {
    await init();
    Map<String, dynamic> data = order.toJson();
    data['items'] = jsonEncode(data['items']); // Store items as JSON string
    await _database!.insert(
      'orders',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<OrderModel>> getOrders(String userId) async {
    await init();
    final List<Map<String, dynamic>> maps = await _database!.query(
      'orders',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return maps.map((e) {
      Map<String, dynamic> data = Map.from(e);
      data['items'] = jsonDecode(data['items']);
      return OrderModel.fromJson(data);
    }).toList();
  }
}
