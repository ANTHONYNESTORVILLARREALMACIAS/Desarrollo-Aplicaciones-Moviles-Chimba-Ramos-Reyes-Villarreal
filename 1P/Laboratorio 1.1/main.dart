// Importación de la biblioteca 'dart:io' para manejar entrada/salida en consola.
import 'dart:io';
// La función main es el punto de entrada de cualquier programa en Dart.
void main() {
  // print() es una función de dart:io que imprime texto en la consola.
  print('--- Cálculo de Consumo de Energía Eléctrica (CLS) ---');
  // En Dart, los strings pueden incluir variables usando $variable o ${expresión}.
  print('Tarifa por KW: \$0.85');
  print('Ingrese el consumo en kilowatts (KW):');
  // Leemos la entrada del usuario desde la consola usando stdin.readLineSync().
  // stdin es parte de dart:io y permite leer datos del teclado.
  // readLineSync() devuelve un String?, donde el '?' indica que puede ser nulo (nullable).
  // El operador '!' (non-null assertion) asegura que la entrada no es nula, ya que confiamos en que el usuario ingresará algo.
  // double.parse() convierte el texto ingresado (String) en un número decimal (double).
  double consumoKW = double.parse(stdin.readLineSync()!);
  // En Dart, 'double' es un tipo de dato para números con decimales.
  double tarifaPorKW = 0.85;
  // En Dart, los operadores aritméticos son similares a otros lenguajes (+, -, *, /).
  double costoConsumo = consumoKW * tarifaPorKW;
  // toStringAsFixed(2) formatea el número con 2 decimales para mostrarlo como moneda.
  print('\nResultados del Consumo:');
  print('Consumo ingresado: $consumoKW KW');
  print('Tarifa aplicada por KW: \$${tarifaPorKW.toStringAsFixed(2)}');
  print('Costo total: \$${costoConsumo.toStringAsFixed(2)}');
  print('Cálculo verificado: Consumo ($consumoKW KW) x Tarifa (\$${tarifaPorKW.toStringAsFixed(2)}) = \$${costoConsumo.toStringAsFixed(2)}');
  print('\n--- Cálculo de Precio de un Artículo ---');
  print('Descuento: 20%');
  print('IVA: 15%');
  print('Ingrese el precio original del artículo:');
  double precioOriginal = double.parse(stdin.readLineSync()!);
  double porcentajeDescuento = 20.0;
  double porcentajeIVA = 15.0;
  double montoDescuento = precioOriginal * (porcentajeDescuento / 100);
  double precioConDescuento = precioOriginal - montoDescuento;
  double montoIVA = precioConDescuento * (porcentajeIVA / 100);
  double precioFinal = precioConDescuento + montoIVA;
  print('\nResultados del Artículo:');
  print('Precio original: \$${precioOriginal.toStringAsFixed(2)}');
  print('Descuento (20%): \$${montoDescuento.toStringAsFixed(2)}');
  print('Precio con descuento: \$${precioConDescuento.toStringAsFixed(2)}');
  print('IVA (15%): \$${montoIVA.toStringAsFixed(2)}');
  print('Precio final: \$${precioFinal.toStringAsFixed(2)}');
  print('Cálculo verificado: Precio con descuento (\$${precioConDescuento.toStringAsFixed(2)}) + IVA (\$${montoIVA.toStringAsFixed(2)}) = \$${precioFinal.toStringAsFixed(2)}');
}