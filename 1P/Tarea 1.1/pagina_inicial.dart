import 'package:flutter/material.dart';
import 'package:tarea_1_1/pantallas/analisis_100_numeros.dart';
import 'package:tarea_1_1/pantallas/calculo_2_numeros.dart';
import 'package:tarea_1_1/pantallas/calculo_serie_taylor.dart';
import 'package:tarea_1_1/pantallas/calculo_sueldo.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});
  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AlexGames Studios'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 60, bottom: 20),
              child: Text(
                'Bienvenido a AlexGames Studios!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(height: 60),

            SizedBox(
              width: 400,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalculoSueldo()),
                  );
                },
                child: const Text('Cálculo de Sueldo'),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: 400,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Analisis100Numeros(),
                    ),
                  );
                },
                child: const Text('Análisis de 100 Números'),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: 400,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Calculo2Numeros()),
                  );
                },
                child: const Text('Cálculo de 2 Números'),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: 400,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalculoSerieTaylor(),
                    ),
                  );
                },
                child: const Text('Cálculo de Serie de Taylor'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
