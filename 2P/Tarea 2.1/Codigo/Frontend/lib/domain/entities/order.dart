import 'order_detail.dart';

class Order {
  final int? id; // Cambia a nulleable
  final String nombreCliente;
  final String fechaPedido;
  final List<OrderDetail> detalles;
  
  Order({
    this.id, // Ahora puede ser null
    required this.nombreCliente,
    required this.fechaPedido,
    required this.detalles,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var detallesFromJson = json['detalles'] as List;
    List<OrderDetail> detallesList = detallesFromJson.map((i) => OrderDetail.fromJson(i)).toList();

    return Order(
      id: json['id'],
      nombreCliente: json['nombreCliente'] as String,
      fechaPedido: json['fechaPedido'] as String,
      detalles: detallesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id, // Solo incluye el ID si no es null
      'nombreCliente': nombreCliente,
      'fechaPedido': fechaPedido,
      'detalles': detalles.map((detalle) => detalle.toJson()).toList(),
    };
  }
}