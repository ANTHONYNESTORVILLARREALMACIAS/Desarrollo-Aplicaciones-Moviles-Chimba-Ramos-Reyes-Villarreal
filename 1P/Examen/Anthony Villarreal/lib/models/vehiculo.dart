// Clase simple para un vehículo
class Vehiculo {
  final int clave;
  final double valor;

  Vehiculo(this.clave, this.valor);

  // Calcula el impuesto según la clave
  double calcularImpuesto() {
    if (clave == 1) return valor * 0.10;
    if (clave == 2) return valor * 0.07;
    if (clave == 3) return valor * 0.05;
    return 0.0;
  }
}