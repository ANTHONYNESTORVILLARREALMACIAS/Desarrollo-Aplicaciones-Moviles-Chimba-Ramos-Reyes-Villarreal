import 'package:flutter/material.dart';
import 'views/pantalla_inicio.dart';
import 'views/pantalla_categoria.dart';
import 'views/pantalla_detalle.dart';
import 'views/pantalla_resumen.dart';
import 'themes/tema.dart';

// Punto de entrada de la aplicación
void main() {
  // Inicia la aplicación Flutter
  runApp(AppImpuestos());
}

// Clase principal de la aplicación
class AppImpuestos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Impuestos Automotriz', // Título de la aplicación
      theme: Tema.claro, // Aplica el tema definido en tema.dart
      initialRoute: '/', // Ruta inicial (pantalla de inicio)
      routes: {
        // Define las rutas nombradas para la navegación
        '/': (context) => PantallaInicio(), // Ruta para la pantalla de inicio
        '/categoria': (context) => PantallaCategoria(), // Ruta para la pantalla de categoría
        '/detalle': (context) => PantallaDetalle(), // Ruta para la pantalla de detalles
        '/resumen': (context) => PantallaResumen(), // Ruta para la pantalla de resumen
      },
    );
  }
}