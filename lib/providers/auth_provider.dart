import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/order_model.dart';
import '../services/database_service.dart';
import '../services/mobile_database_service.dart';
import '../services/web_database_service.dart';

class AuthProvider with ChangeNotifier {
  late DatabaseService _dbService;
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    if (kIsWeb) {
      _dbService = WebDatabaseService();
    } else {
      _dbService = MobileDatabaseService();
    }
    _dbService.init();
  }

  Future<bool> login(String email, String password) async {
    try {
      _currentUser = await _dbService.login(email, password);
      notifyListeners();
      return _currentUser != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      User newUser = User(id: id, email: email, name: name, password: password);
      await _dbService.register(newUser);
      _currentUser = newUser;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateUser(User user) async {
    try {
      await _dbService.updateUser(user);
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> saveOrder(OrderModel order) async {
    if (_currentUser != null) {
      await _dbService.saveOrder(order);
    }
  }

  Future<List<OrderModel>> getOrders() async {
    if (_currentUser != null) {
      return await _dbService.getOrders(_currentUser!.id);
    }
    return [];
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
