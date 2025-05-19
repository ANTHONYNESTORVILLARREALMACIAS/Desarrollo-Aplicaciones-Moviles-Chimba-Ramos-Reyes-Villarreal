import 'package:flutter/material.dart';
import '../themes/text_styles.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String username = Uri.decodeComponent(ModalRoute.of(context)!.settings.name!.replaceFirst('/user_info/', ''));
    final Map<String, String>? args = ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
    final String email = args?['email'] ?? 'No email available';
    final String password = args?['password'] ?? 'No password available';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('User Info - $username', style: const TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              Text(
                'Bienvenido!',
                style: AppTextStyles.heading,
              ),
              const SizedBox(height: 20),
              Text(
                'Email: $email',
                style: AppTextStyles.input,
              ),
              const SizedBox(height: 10),
              Text(
                'Contraseña: $password',
                style: AppTextStyles.input,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.purple)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}