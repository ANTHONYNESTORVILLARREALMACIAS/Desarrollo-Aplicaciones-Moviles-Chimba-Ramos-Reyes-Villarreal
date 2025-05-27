import '../models/vehiculo.dart';

// Controlador simple para manejar vehículos
class VehiculoController {
  static final List<Vehiculo> _vehiculos = [];

  // Obtener todos los vehículos
  List<Vehiculo> get vehiculos => _vehiculos;

  // Agregar un vehículo
  void agregarVehiculo(int clave, double valor) {
    _vehiculos.add(Vehiculo(clave, valor));
  }

  // Obtener vehículos por clave
  List<Vehiculo> obtenerPorClave(int clave) {
    return _vehiculos.where((v) => v.clave == clave).toList();
  }

  // Calcular total de impuestos por clave
  double totalPorClave(int clave) {
    return obtenerPorClave(clave).fold(0.0, (sum, v) => sum + v.calcularImpuesto());
  }

  // Calcular total general de impuestos
  double totalGeneral() {
    return _vehiculos.fold(0.0, (sum, v) => sum + v.calcularImpuesto());
  }
}