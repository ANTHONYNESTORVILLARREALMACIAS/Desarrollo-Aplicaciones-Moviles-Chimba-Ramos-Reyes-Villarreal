import 'package:flutter/material.dart';
import 'pantalla/primos_pantalla.dart';

// Punto de entrada de la aplicación
void main() {
  runApp(const MyApp());
}

// Widget principal que define la configuración global de la app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Números Primos', // Título de la app mostrado en la pantalla
      theme: ThemeData(
        // Color primario vibrante (púrpura) para la AppBar y botones
        primaryColor: const Color(0xFF6C63FF),
        // Fondo oscuro para un diseño moderno y elegante
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        // Texto blanco para alto contraste contra el fondo oscuro
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
        // Estilo de botones elevados con bordes redondeados y color púrpura
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C63FF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        // Estilo de campos de texto con fondo gris oscuro y bordes redondeados
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF2A2A40),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          labelStyle: TextStyle(color: Colors.white70),
        ),
      ),
      home: const PrimosPantalla(), // Pantalla principal de la app
    );
  }
}
