import 'package:flutter/material.dart';

// Tema simple para la aplicación
class Tema {
  static final ThemeData claro = ThemeData(
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey[100],
    textTheme: TextTheme(
      bodyMedium: TextStyle(fontSize: 16, color: Colors.black),
      headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(12),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 4),
    ),
  );
}