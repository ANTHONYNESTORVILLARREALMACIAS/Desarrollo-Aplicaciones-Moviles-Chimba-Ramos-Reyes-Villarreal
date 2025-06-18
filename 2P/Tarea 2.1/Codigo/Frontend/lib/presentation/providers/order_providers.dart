import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_detail.dart';
import '../../data/datasource/order_api.dart';
import '../../data/repositories/order_repositories_imp.dart';
import '../../application/usecases/order_usecase.dart';

// Dependency providers
final orderApiProvider = Provider<OrderApi>((ref) {
  return OrderApi();
});

final orderRepositoryProvider = Provider<OrderRepositoriesImp>((ref) {
  final api = ref.watch(orderApiProvider);
  return OrderRepositoriesImp(api);
});

final orderUsecaseProvider = Provider<OrderUsecase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return OrderUsecase(repository);
});

// State providers
final ordersProvider =
    StateNotifierProvider<OrderNotifier, AsyncValue<List<Order>>>((ref) {
      final orderUsecase = ref.watch(orderUsecaseProvider);
      return OrderNotifier(orderUsecase);
    });

class OrderNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  final OrderUsecase useCase;

  OrderNotifier(this.useCase) : super(const AsyncValue.loading()) {
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      state = const AsyncValue.loading();
      final orders = await useCase.getOrders();
      state = AsyncValue.data(orders);
    } catch (e, stackTrace) {
      print('Error fetching orders: $e');
      print('Stack trace: $stackTrace');
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> createOrder(Order order) async {
    try {
      await useCase.createOrder(order);
      fetchOrders();
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  Future<void> updateOrder(int id, Order order) async {
    try {
      await useCase.updateOrder(id, order);
      fetchOrders();
    } catch (e) {
      print('Error updating order: $e');
      rethrow;
    }
  }

  Future<void> deleteOrder(int id) async {
    try {
      await useCase.deleteOrder(id);
      fetchOrders();
    } catch (e) {
      print('Error deleting order: $e');
      rethrow;
    }
  }

  Future<void> addOrderDetail(int orderId, OrderDetail detail) async {
    try {
      await useCase.createOrderDetail(orderId, detail);
      fetchOrders();
    } catch (e) {
      print('Error adding detail: $e');
      rethrow;
    }
  }

  Future<void> updateOrderDetail(
    int orderId,
    int detailId,
    OrderDetail detail,
  ) async {
    try {
      await useCase.updateOrderDetail(orderId, detailId, detail);
      fetchOrders();
    } catch (e) {
      print('Error updating detail: $e');
      rethrow;
    }
  }

  Future<void> deleteOrderDetail(int orderId, int detailId) async {
    try {
      await useCase.deleteOrderDetail(orderId, detailId);
      fetchOrders();
    } catch (e) {
      print('Error deleting detail: $e');
      rethrow;
    }
  }
}

// Selected order provider
final selectedOrderIdProvider = StateProvider<int?>((ref) => null);

final selectedOrderProvider = FutureProvider.autoDispose<Order?>((ref) async {
  final id = ref.watch(selectedOrderIdProvider);
  if (id == null) return null;

  final orderUsecase = ref.watch(orderUsecaseProvider);
  return await orderUsecase.getOrderById(id);
});

// Método para resetear el ID seleccionado
extension SelectedOrderResetExtension on ProviderContainer {
  void resetSelectedOrderId() {
    read(selectedOrderIdProvider.notifier).state = null;
  }
}

// O como alternativa, un provider específico para resetear
final resetSelectedOrderProvider = Provider<void Function()>((ref) {
  return () => ref.read(selectedOrderIdProvider.notifier).state = null;
});
