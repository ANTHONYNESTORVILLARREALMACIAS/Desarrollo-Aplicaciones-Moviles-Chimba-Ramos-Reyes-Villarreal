import 'package:flutter/material.dart';
import '../models/vehiculo.dart';

class PantallaDetalle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int clave = args['clave'];
    final double valor = args['valor'];
    final vehiculo = Vehiculo(clave, valor);

    return Scaffold(
      appBar: AppBar(title: Text('Detalles')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Detalles', style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 10),
                Text('Clave: $clave'),
                Text('Valor: \$${valor.toStringAsFixed(2)}'),
                Text('Impuesto: \$${vehiculo.calcularImpuesto().toStringAsFixed(2)}'),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Volver'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}