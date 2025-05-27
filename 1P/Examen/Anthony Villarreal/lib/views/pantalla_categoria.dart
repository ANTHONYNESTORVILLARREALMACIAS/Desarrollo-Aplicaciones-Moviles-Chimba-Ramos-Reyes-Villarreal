import 'package:flutter/material.dart';
import '../controllers/vehiculo_controller.dart';

class PantallaCategoria extends StatelessWidget {
  final VehiculoController _controller = VehiculoController();

  @override
  Widget build(BuildContext context) {
    final int clave = ModalRoute.of(context)!.settings.arguments as int;
    final vehiculos = _controller.obtenerPorClave(clave);

    return Scaffold(
      appBar: AppBar(title: Text('Vehículos Clave $clave')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: vehiculos.isEmpty
            ? Center(child: Text('Sin vehículos'))
            : ListView.builder(
          itemCount: vehiculos.length,
          itemBuilder: (context, index) {
            final vehiculo = vehiculos[index];
            return Card(
              child: ListTile(
                title: Text('Vehículo ${index + 1}: \$${vehiculo.valor.toStringAsFixed(2)}'),
                subtitle: Text('Impuesto: \$${vehiculo.calcularImpuesto().toStringAsFixed(2)}'),
                onTap: () {
                  Navigator.pushNamed(context, '/detalle',
                      arguments: {'clave': vehiculo.clave, 'valor': vehiculo.valor});
                },
              ),
            );
          },
        ),
      ),
    );
  }
}