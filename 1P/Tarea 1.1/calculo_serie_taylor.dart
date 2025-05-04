import 'package:flutter/material.dart';
import 'package:tarea_1_1/pantallas/calculo_2_numeros.dart';
import 'dart:math';
import 'package:tarea_1_1/pantallas/pagina_inicial.dart';

class CalculoSerieTaylor extends StatefulWidget {
  const CalculoSerieTaylor({super.key});

  @override
  State<CalculoSerieTaylor> createState() => _CalculoSerieTaylorState();
}

class _CalculoSerieTaylorState extends State<CalculoSerieTaylor> {
  final TextEditingController _xController = TextEditingController();
  final TextEditingController _nController = TextEditingController();
  String _resultado = '';

  double calcularFactorial(int numero) {
    double factorial = 1;
    for (int i = 1; i <= numero; i++) {
      factorial *= i;
    }
    return factorial;
  }

  void calcularSerieTaylor() {
    final double? x = double.tryParse(_xController.text);
    final int? n = int.tryParse(_nController.text);

    if (x == null || n == null || n < 0) {
      setState(() {
        _resultado = 'Por favor ingrese valores válidos:\n- x puede ser cualquier número.\n- n debe ser entero positivo o cero.';
      });
      return;
    }

    double suma = 1; // primer término
    for (int i = 1; i <= n; i++) {
      suma += (pow(x, i) / calcularFactorial(i));
    }

    setState(() {
      _resultado = 'Resultado de la serie para x=$x y n=$n es:\n$suma';
    });
  }

  void reiniciar() {
    setState(() {
      _xController.clear();
      _nController.clear();
      _resultado = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Serie de Taylor'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Ingrese los valores de x y n:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _xController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Valor de x',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Valor de n (entero ≥ 0)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: calcularSerieTaylor,
                child: const Text('Calcular Serie'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: reiniciar,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                child: const Text('Reiniciar'),
              ),
              const SizedBox(height: 20),
              Text(
                _resultado,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Calculo2Numeros()),
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
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Inicio'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const PaginaInicial()),
                        (route) => false,
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
