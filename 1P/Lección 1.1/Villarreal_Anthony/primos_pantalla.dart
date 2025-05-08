import 'package:flutter/material.dart';

// Widget principal de la pantalla para calcular números primos
class PrimosPantalla extends StatefulWidget {
  const PrimosPantalla({super.key});

  @override
  _PrimosPantallaState createState() => _PrimosPantallaState();
}

// Estado de la pantalla, maneja la lógica y la UI
class _PrimosPantallaState extends State<PrimosPantalla> {
  // Controlador para el campo de texto
  final TextEditingController _controller = TextEditingController();
  // Variable para almacenar el resultado mostrado en pantalla
  String _result = '';

  // Función que verifica si un número es primo
  bool esPrimo(int num) {
    // Números menores a 2 no son primos
    if (num < 2) return false;
    // Comprueba divisores hasta la raíz cuadrada del número
    for (int i = 2; i * i <= num; i++) {
      if (num % i == 0) return false;
    }
    return true;
  }

  // Función para calcular y mostrar los números primos
  void calcularPrimos() {
    setState(() {
      // Convierte la entrada a entero
      int n = int.parse(_controller.text);
      // Buffer para construir la cadena de resultados
      StringBuffer primos = StringBuffer('Números primos hasta $n: ');
      // Itera desde 1 hasta n para encontrar primos
      for (int i = 1; i <= n; i++) {
        if (esPrimo(i)) {
          primos.write('$i ');
        }
      }
      // Actualiza el resultado en la UI
      _result = primos.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior con título
      appBar: AppBar(
        title: const Text(
          'Números Primos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(
          0xFF6C63FF,
        ), // Color púrpura para la AppBar
      ),
      // Cuerpo de la pantalla con padding
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo de texto para ingresar el número
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Ingresa un número'),
            ),
            const SizedBox(height: 16), // Espacio vertical
            // Botón para calcular los primos
            ElevatedButton(
              onPressed: calcularPrimos,
              child: const Text(
                'Calcular Primos',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 24,
            ), // Espacio vertical mayor para separación
            // Área desplazable para mostrar los resultados
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _result,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Libera recursos al cerrar la pantalla
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
