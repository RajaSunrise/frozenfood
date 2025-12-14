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
    String path = join(await getDatabasesPath(), 'frozen_food_v4.db'); // Bumped DB version
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        _createDb(db);
      },
    );
  }

  void _createDb(Database db) {
    db.execute('CREATE TABLE users(id TEXT PRIMARY KEY, email TEXT, name TEXT, password TEXT, address TEXT, phoneNumber TEXT, avatarUrl TEXT)');
    db.execute('CREATE TABLE orders(id TEXT PRIMARY KEY, userId TEXT, totalAmount REAL, date TEXT, status TEXT, shippingMethod TEXT, paymentMethod TEXT, shippingAddress TEXT, items TEXT)');
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
  Future<void> updateUser(User user) async {
    await init();
    await _database!.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  @override
  Future<void> saveOrder(OrderModel order) async {
    await init();
    Map<String, dynamic> data = order.toJson();
    data['items'] = jsonEncode(data['items']);
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
