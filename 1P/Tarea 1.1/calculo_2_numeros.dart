import 'package:flutter/material.dart';
import 'package:tarea_1_1/pantallas/analisis_100_numeros.dart';
import 'package:tarea_1_1/pantallas/calculo_serie_taylor.dart';
import 'package:tarea_1_1/pantallas/pagina_inicial.dart';

class Calculo2Numeros extends StatefulWidget {
  @override
  State<Calculo2Numeros> createState() => _Calculo2NumerosState();
}

class _Calculo2NumerosState extends State<Calculo2Numeros> {
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _bController = TextEditingController();
  String _resultado = '';

  int sumaDivisoresPropios(int numero) {
    int suma = 0;
    for (int i = 1; i < numero; i++) {
      if (numero % i == 0) {
        suma += i;
      }
    }
    return suma;
  }

  void _verificarNumerosAmigos() {
    final int? a = int.tryParse(_aController.text);
    final int? b = int.tryParse(_bController.text);

    if (a == null || b == null || a <= 0 || b <= 0) {
      setState(() {
        _resultado = 'Por favor ingrese dos números enteros positivos válidos.';
      });
      return;
    }

    int sumaA = sumaDivisoresPropios(a);
    int sumaB = sumaDivisoresPropios(b);

    if (sumaA == b && sumaB == a) {
      setState(() {
        _resultado =
            'Los números $a y $b SON amigos.\nSuma de divisores de $a = $sumaA\nSuma de divisores de $b = $sumaB';
      });
    } else {
      setState(() {
        _resultado =
            'Los números $a y $b NO son amigos.\nSuma de divisores de $a = $sumaA\nSuma de divisores de $b = $sumaB';
      });
    }
  }

  void _reiniciar() {
    setState(() {
      _aController.clear();
      _bController.clear();
      _resultado = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Números Amigos'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Ingrese dos números enteros positivos:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _aController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número A',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _bController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número B',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _verificarNumerosAmigos,
                child: const Text('Verificar'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _reiniciar,
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
                        MaterialPageRoute(builder: (context) => Analisis100Numeros()),
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
                        MaterialPageRoute(builder: (context) => CalculoSerieTaylor()),
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
