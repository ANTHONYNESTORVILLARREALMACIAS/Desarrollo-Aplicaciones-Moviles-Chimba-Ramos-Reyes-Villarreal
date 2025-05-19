import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import '../themes/text_styles.dart';
import '../themes/button_styles.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailCtrl = TextEditingController();
  final _controller = LoginController();
  String? _password;
  bool _hasSearched = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Forgot Password', style: TextStyle(color: Colors.white)),
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(Icons.lock_open, size: 100, color: Colors.white),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailCtrl,
                  style: AppTextStyles.input,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  ),
                  validator: (value) => !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value ?? '')
                      ? 'Email no válido'
                      : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_emailCtrl.text.isNotEmpty) {
                      final password = await _controller.getPasswordForEmail(_emailCtrl.text);
                      setState(() {
                        _password = password;
                        _hasSearched = true;
                      });
                      if (password != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contraseña recuperada exitosamente')),
                        );
                      }
                    }
                  },
                  style: AppButtonStyles.primary,
                  child: const Text('Recover Password', style: TextStyle(color: Colors.purple)),
                ),
                const SizedBox(height: 20),
                if (_hasSearched)
                  _password != null
                      ? Text(
                    'Tu contraseña es: $_password',
                    style: AppTextStyles.input,
                  )
                      : const Text(
                    'Correo no encontrado',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}