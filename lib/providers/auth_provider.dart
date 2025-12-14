import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/order_model.dart';
import '../services/database_service.dart';
import '../services/mobile_database_service.dart';
import '../services/web_database_service.dart';

class AuthProvider with ChangeNotifier {
  late DatabaseService _dbService;
  User? _currentUser;
  bool _isRestoringAuth = true;
  static const String _authKey = 'auth_user_id';

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isRestoringAuth => _isRestoringAuth;

  AuthProvider() {
    if (kIsWeb) {
      _dbService = WebDatabaseService();
    } else {
      _dbService = MobileDatabaseService();
    }
    _dbService.init();
  }

  Future<bool> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey(_authKey)) {
        _isRestoringAuth = false;
        notifyListeners();
        return false;
      }

      final userId = prefs.getString(_authKey);
      if (userId == null) {
        _isRestoringAuth = false;
        notifyListeners();
        return false;
      }

      _currentUser = await _dbService.getUserById(userId);
    } catch (e) {
      print("Auto login error: $e");
    }

    _isRestoringAuth = false;
    notifyListeners();
    return _currentUser != null;
  }

  Future<bool> login(String email, String password) async {
    try {
      _currentUser = await _dbService.login(email, password);
      if (_currentUser != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_authKey, _currentUser!.id);
      }
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

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_authKey, newUser.id);

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

  Future<void> addPoints(int amount) async {
    if (_currentUser != null) {
      User updatedUser = _currentUser!.copyWith(points: _currentUser!.points + amount);
      await updateUser(updatedUser);
    }
  }

  Future<List<OrderModel>> getOrders() async {
    if (_currentUser != null) {
      return await _dbService.getOrders(_currentUser!.id);
    }
    return [];
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authKey);
    notifyListeners();
  }
}
