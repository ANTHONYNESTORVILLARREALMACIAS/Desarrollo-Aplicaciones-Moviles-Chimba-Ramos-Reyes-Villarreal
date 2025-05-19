import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import '../themes/text_styles.dart';
import '../themes/button_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioCtrl = TextEditingController();
  final _claveCtrl = TextEditingController();
  final _controller = LoginController();
  bool recordar = false;

  @override
  void dispose() {
    _usuarioCtrl.dispose();
    _claveCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Login', style: TextStyle(color: Colors.white)),
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(Icons.person, size: 100, color: Colors.white),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _usuarioCtrl,
                    style: AppTextStyles.input,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                    validator: _controller.validarUsuario,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _claveCtrl,
                    obscureText: true,
                    style: AppTextStyles.input,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    ),
                    validator: _controller.validarClave,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: recordar,
                            onChanged: (val) => setState(() => recordar = val!),
                          ),
                          const Text('Remember me', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot_password');
                        },
                        child: const Text('Forgot password?', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _controller.iniciarSesion(context, _usuarioCtrl.text, _claveCtrl.text, recordar);
                      }
                    },
                    style: AppButtonStyles.primary,
                    child: const Text('Sign In', style: TextStyle(color: Colors.purple)),
                  ),
                  const SizedBox(height: 20),
                  const Text('Not a member?', style: TextStyle(color: Colors.white)),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/create_account');
                    },
                    style: AppButtonStyles.outline,
                    child: const Text('Create account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}