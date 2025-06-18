import '../../domain/entities/order.dart';
import '../../domain/entities/order_detail.dart';
import '../datasource/order_api.dart';

class OrderRepositoriesImp {
  final OrderApi api;

  OrderRepositoriesImp(this.api);

  Future<List<Order>> getOrders() async {
    return await api.fetchOrders();
  }
  Future<Order> getOrderById(int id) async {
    return await api.fetchOrderById(id);
  }
  Future<void> createOrder(Order order) async {
    return await api.createOrder(order);
  }
  Future<void> updateOrder(int id, Order order) async {
    return await api.updateOrder(id, order);
  }
  Future<void> deleteOrder(int id) async {
    return await api.deleteOrder(id);
  }
  Future<void> createOrderDetail(int orderId, OrderDetail orderDetail) async {
    return await api.createOrderDetail(orderId, orderDetail);
  }
  Future<void> updateOrderDetail(int orderId, int detailId, OrderDetail orderDetail) async {
    return await api.updateOrderDetail(orderId, detailId, orderDetail);
  }
  Future<void> deleteOrderDetail(int orderId, int detailId) async {
    return await api.deleteOrderDetail(orderId, detailId);
  }
}