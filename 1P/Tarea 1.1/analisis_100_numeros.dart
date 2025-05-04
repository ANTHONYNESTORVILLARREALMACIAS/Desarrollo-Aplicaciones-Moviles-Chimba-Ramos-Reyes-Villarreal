import 'package:flutter/material.dart';
import 'package:tarea_1_1/pantallas/calculo_2_numeros.dart';
import 'package:tarea_1_1/pantallas/calculo_sueldo.dart';
import 'package:tarea_1_1/pantallas/pagina_inicial.dart'; // Asegúrate de importar correctamente

class Analisis100Numeros extends StatefulWidget {
  @override
  State<Analisis100Numeros> createState() => _Analisis100NumerosState();
}

class _Analisis100NumerosState extends State<Analisis100Numeros> {
  final TextEditingController _numeroController = TextEditingController();
  final List<int> _numeros = [];

  String _resultado = '';

  void _agregarNumerosDesdeTexto() {
  final texto = _numeroController.text;
  final partes = texto.split(',');
  final nuevosNumeros = <int>[];

  for (var parte in partes) {
    final numeroStr = parte.trim();
    if (numeroStr.isEmpty) continue;

    final numero = int.tryParse(numeroStr);
    if (numero == null || numero < 0) {
      setState(() {
        _resultado = 'Todos los valores deben ser números naturales (0 o mayores).';
      });
      return;
    }

    nuevosNumeros.add(numero);
  }

  if (_numeros.length + nuevosNumeros.length > 100) {
    setState(() {
      _resultado = 'El total excede los 100 números permitidos.';
    });
    return;
  }

  setState(() {
    _numeros.addAll(nuevosNumeros);
    _numeroController.clear();
    _resultado = 'Se agregaron ${nuevosNumeros.length} números. Total actual: ${_numeros.length}.';
  });
}


  void _calcularResultados() {
    if (_numeros.length != 100) {
      setState(() {
        _resultado = 'Debes ingresar exactamente 100 números antes de calcular.';
      });
      return;
    }

    int menores15 = _numeros.where((n) => n < 15).length;
    int mayores50 = _numeros.where((n) => n > 50).length;
    int entre25y45 = _numeros.where((n) => n >= 25 && n <= 45).length;
    double promedio = _numeros.reduce((a, b) => a + b) / 100;

    setState(() {
      _resultado = '''
Resultados:
- Menores que 15: $menores15
- Mayores que 50: $mayores50
- Entre 25 y 45: $entre25y45
- Promedio: ${promedio.toStringAsFixed(2)}
''';
    });
  }

  void _reiniciar() {
    setState(() {
      _numeros.clear();
      _resultado = '';
      _numeroController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Análisis de 100 Números'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Ingrese número ${_numeros.length + 1} de 100:',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _numeroController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número natural',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _agregarNumerosDesdeTexto,
                child: const Text('Agregar número(s)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularResultados,
                child: const Text('Calcular resultados'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _reiniciar,
                child: const Text('Reiniciar todo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
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
                        MaterialPageRoute(builder: (context) => CalculoSueldo()),
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
                        (Route<dynamic> route) => false,
                      );
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Inicio'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Calculo2Numeros()),
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
