import 'package:flutter/material.dart';
import '../controllers/vehiculo_controller.dart';

class PantallaResumen extends StatelessWidget {
  final VehiculoController _controller = VehiculoController();

  @override
  Widget build(BuildContext context) {
    double totalClave1 = _controller.totalPorClave(1);
    double totalClave2 = _controller.totalPorClave(2);
    double totalClave3 = _controller.totalPorClave(3);
    double totalGeneral = _controller.totalGeneral();

    return Scaffold(
      appBar: AppBar(title: Text('Resumen')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text('Resumen', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 10),
            Card(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text('Clave 1: \$${totalClave1.toStringAsFixed(2)}'),
                    Text('Clave 2: \$${totalClave2.toStringAsFixed(2)}'),
                    Text('Clave 3: \$${totalClave3.toStringAsFixed(2)}'),
                    Divider(),
                    Text(
                      'Total: \$${totalGeneral.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              child: Text('Volver al Inicio'),
            ),
          ],
        ),
      ),
    );
  }
}