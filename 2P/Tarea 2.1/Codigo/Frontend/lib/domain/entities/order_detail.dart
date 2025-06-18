class OrderDetail {
  final int? id; // Cambia a nulleable
  final String nombreProducto;
  final int cantidad;
  final double precioUnitario;

  OrderDetail({
    this.id, // Ahora puede ser null
    required this.nombreProducto,
    required this.cantidad,
    required this.precioUnitario,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['id'],
      nombreProducto: json['nombreProducto'] ?? '',
      cantidad: json['cantidad'] ?? 0,
      precioUnitario: (json['precioUnitario'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id, // Solo incluye el ID si no es null
      'nombreProducto': nombreProducto,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
    };
  }
}
