import '../../domain/entities/order.dart';
import '../../domain/entities/order_detail.dart';
import '../../data/repositories/order_repositories_imp.dart';

class OrderUsecase {
  final OrderRepositoriesImp _orderRepository;

  OrderUsecase(this._orderRepository);

  Future<List<Order>> getOrders() async {
    return await _orderRepository.getOrders();
  }

  Future<Order> getOrderById(int id) async {
    return await _orderRepository.getOrderById(id);
  }

  Future<void> createOrder(Order order) async {
    await _orderRepository.createOrder(order);
  }

  Future<void> updateOrder(int id, Order order) async {
    await _orderRepository.updateOrder(id, order);
  }

  Future<void> deleteOrder(int id) async {
    await _orderRepository.deleteOrder(id);
  }

  Future<void> createOrderDetail(int orderId, OrderDetail detail) async {
    await _orderRepository.createOrderDetail(orderId, detail);
  }

  Future<void> updateOrderDetail(int orderId, int detailId, OrderDetail detail) async {
    await _orderRepository.updateOrderDetail(orderId, detailId, detail);
  }

  Future<void> deleteOrderDetail(int orderId, int detailId) async {
    await _orderRepository.deleteOrderDetail(orderId, detailId);
  }
}