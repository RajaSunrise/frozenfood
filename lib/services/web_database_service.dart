import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/order_model.dart';
import 'database_service.dart';

class WebDatabaseService implements DatabaseService {
  final String _usersKey = 'users_data';
  final String _ordersKey = 'orders_data';

  @override
  Future<void> init() async {
    // Shared preferences init is synchronous in usage but we ensure instance is ready
  }

  Future<List<User>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    String? usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return [];
    List<dynamic> list = jsonDecode(usersJson);
    return list.map((e) => User.fromJson(e)).toList();
  }

  Future<void> _saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    String usersJson = jsonEncode(users.map((e) => e.toJson()).toList());
    await prefs.setString(_usersKey, usersJson);
  }

  @override
  Future<User?> login(String email, String password) async {
    List<User> users = await _getUsers();
    try {
      return users.firstWhere((u) => u.email == email && u.password == password);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> register(User user) async {
    List<User> users = await _getUsers();
    if (users.any((u) => u.email == user.email)) {
      throw Exception('User already exists');
    }
    users.add(user);
    await _saveUsers(users);
  }

  Future<List<OrderModel>> _getAllOrders() async {
    final prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString(_ordersKey);
    if (json == null) return [];
    List<dynamic> list = jsonDecode(json);
    return list.map((e) => OrderModel.fromJson(e)).toList();
  }

  @override
  Future<void> saveOrder(OrderModel order) async {
    List<OrderModel> orders = await _getAllOrders();
    orders.add(order);
    final prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(orders.map((e) => e.toJson()).toList());
    await prefs.setString(_ordersKey, json);
  }

  @override
  Future<List<OrderModel>> getOrders(String userId) async {
    List<OrderModel> orders = await _getAllOrders();
    return orders.where((o) => o.userId == userId).toList();
  }
}
