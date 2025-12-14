import '../models/user.dart';
import '../models/order_model.dart';

abstract class DatabaseService {
  Future<void> init();
  Future<User?> login(String email, String password);
  Future<void> register(User user);
  Future<User?> getUserById(String id);
  Future<void> updateUser(User user);
  Future<void> saveOrder(OrderModel order);
  Future<List<OrderModel>> getOrders(String userId);
}
