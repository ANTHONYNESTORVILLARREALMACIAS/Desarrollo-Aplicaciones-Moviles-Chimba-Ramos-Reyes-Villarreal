import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/order.dart';
import '../../domain/entities/order_detail.dart';

class OrderApi {
  // URL correcta para el emulador Android o dispositivos reales
  final String baseUrl = 'http://localhost:8082/api/pedidos';

  Future<List<Order>> fetchOrders() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((order) => Order.fromJson(order)).toList();
      } else {
        throw Exception('Error al cargar pedidos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching orders: $e');
      rethrow;
    }
  }

  Future<Order> fetchOrderById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return Order.fromJson(json.decode(response.body));
      } else {
        throw Exception('Error al cargar pedido: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching order: $e');
      rethrow;
    }
  }

  Future<void> createOrder(Order order) async {
    try {
      print('Enviando: ${jsonEncode(order.toJson())}');
      
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(order.toJson()),
      );

      print('Status code: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al crear pedido: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  Future<void> updateOrder(int id, Order order) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(order.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar pedido: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating order: $e');
      rethrow;
    }
  }

  Future<void> deleteOrder(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al eliminar pedido: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting order: $e');
      rethrow;
    }
  }

  Future<void> createOrderDetail(int orderId, OrderDetail detail) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$orderId/detalles'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(detail.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al crear detalle: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating detail: $e');
      rethrow;
    }
  }

  Future<void> updateOrderDetail(int orderId, int detailId, OrderDetail detail) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$orderId/detalles/$detailId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(detail.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar detalle: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating detail: $e');
      rethrow;
    }
  }

  Future<void> deleteOrderDetail(int orderId, int detailId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$orderId/detalles/$detailId'),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al eliminar detalle: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting detail: $e');
      rethrow;
    }
  }
}