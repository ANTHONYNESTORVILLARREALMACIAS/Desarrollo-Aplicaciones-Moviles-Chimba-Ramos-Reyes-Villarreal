import 'package:flutter/material.dart';
import '../controllers/vehiculo_controller.dart';

class PantallaInicio extends StatefulWidget {
  @override
  _PantallaInicioState createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  final _valorController = TextEditingController();
  int _clave = 1;
  final VehiculoController _controller = VehiculoController();

  // Agregar vehículo
  void _agregarVehiculo() {
    double valor = double.tryParse(_valorController.text) ?? 0.0;
    if (valor > 0) {
      _controller.agregarVehiculo(_clave, valor);
      _valorController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Impuestos Automotriz')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text('Agregar Vehículo', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 10),
            DropdownButton<int>(
              value: _clave,
              items: [
                DropdownMenuItem(value: 1, child: Text('Clave 1 (10%)')),
                DropdownMenuItem(value: 2, child: Text('Clave 2 (7%)')),
                DropdownMenuItem(value: 3, child: Text('Clave 3 (5%)')),
              ],
              onChanged: (valor) => setState(() => _clave = valor!),
            ),
            TextField(
              controller: _valorController,
              decoration: InputDecoration(
                labelText: 'Valor del Vehículo',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _agregarVehiculo,
              child: Text('Agregar'),
            ),
            SizedBox(height: 20),
            Text('Ver Categorías', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/categoria', arguments: 1),
                  child: Text('Clave 1'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/categoria', arguments: 2),
                  child: Text('Clave 2'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/categoria', arguments: 3),
                  child: Text('Clave 3'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/resumen'),
              child: Text('Ver Resumen'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}