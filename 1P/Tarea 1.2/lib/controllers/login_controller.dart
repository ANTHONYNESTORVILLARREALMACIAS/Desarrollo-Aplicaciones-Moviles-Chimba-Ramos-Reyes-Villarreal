import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  String? validarUsuario(String? value) {
    if (value == null || value.isEmpty) return 'Se requiere usuario';
    return null;
  }

  String? validarClave(String? value) {
    if (value == null || value.length < 4) return 'Ingrese 4 caracteres';
    return null;
  }

  Future<String?> getPasswordForEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList('users') ?? [];
    for (var user in users) {
      final parts = user.split('|');
      if (parts.length == 9 && parts[6].trim() == email.trim()) {
        return parts[8]; // Password is the 9th field (index 8)
      }
    }
    return null;
  }

  Future<void> iniciarSesion(BuildContext context, String usuario, String clave, bool remember) async {
    final prefs = await SharedPreferences.getInstance();
    final users = prefs.getStringList('users') ?? [];
    bool isValid = false;
    String? userEmail;

    for (var user in users) {
      final parts = user.split('|');
      if (parts.length == 9 && parts[6].trim() == usuario.trim() && parts[8] == clave) {
        isValid = true;
        userEmail = parts[6];
        break;
      }
    }

    if (usuario == 'Anthony' && clave == '1234') {
      isValid = true;
      userEmail = 'anthony@example.com';
    }

    if (isValid) {
      if (remember) {
        await prefs.setString('last_username', usuario);
        await prefs.setString('last_password', clave);
      } else {
        await prefs.remove('last_username');
        await prefs.remove('last_password');
      }
      Navigator.pushNamed(context, '/user_info/${Uri.encodeComponent(usuario)}', arguments: {'email': userEmail ?? usuario, 'password': clave});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Credenciales Incorrectas')));
    }
  }
}