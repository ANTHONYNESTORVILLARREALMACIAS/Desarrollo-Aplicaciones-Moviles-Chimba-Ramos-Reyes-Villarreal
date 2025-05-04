import 'package:flutter/material.dart';
import 'package:tarea_1_1/pantallas/analisis_100_numeros.dart';
import 'package:tarea_1_1/pantallas/pagina_inicial.dart'; // Asegúrate de importar correctamente

class CalculoSueldo extends StatefulWidget {
  const CalculoSueldo({super.key});

  @override
  State<CalculoSueldo> createState() => _CalculoSueldoState();
}

class _CalculoSueldoState extends State<CalculoSueldo> {
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _antiguedadController = TextEditingController();

  String _resultado = '';

  void _calcularSueldo() {
    final int? edad = int.tryParse(_edadController.text);
    final int? antiguedad = int.tryParse(_antiguedadController.text);

    if (edad == null || edad <= 0) {
      setState(() {
        _resultado = 'Por favor ingrese una edad válida (> 0).';
      });
      return;
    }

    if (antiguedad == null || antiguedad < 0) {
      setState(() {
        _resultado = 'Por favor ingrese una antigüedad válida (>= 0).';
      });
      return;
    }

    int sumaAntiguedad = (antiguedad * (antiguedad + 1)) ~/ 2;
    int sueldo = 35000 + edad + (100 * sumaAntiguedad);

    setState(() {
      _resultado = 'El sueldo semanal es: \$${sueldo.toString()}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Sueldo'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView( // Por si el teclado cubre los botones
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ingrese los datos del empleado:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _edadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Edad',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _antiguedadController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Años en la empresa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularSueldo,
                child: const Text('Calcular sueldo'),
              ),
              const SizedBox(height: 20),
              Text(
                _resultado,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const PaginaInicial()),
                            (Route<dynamic> route) => false, // Elimina el historial
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Atrás'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const PaginaInicial()),
                            (Route<dynamic> route) => false, // Elimina el historial
                      );
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Inicio'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Analisis100Numeros()),
                            (Route<dynamic> route) => false, // Elimina el historial
                      );
                    },
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Siguiente'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
