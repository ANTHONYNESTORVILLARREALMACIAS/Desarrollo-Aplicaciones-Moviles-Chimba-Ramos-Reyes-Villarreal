import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/login_page.dart';
import 'views/welcome_page.dart';
import 'views/create_account_page.dart';
import 'views/forgot_password_page.dart';
import 'views/user_info_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final String? lastUsername = prefs.getString('last_username');
  final String? lastPassword = prefs.getString('last_password');

  String initialRoute = '/login';
  Object? initialArguments;

  // Si hay sesión guardada, ir directamente a user_info con argumentos
  if (lastUsername != null && lastPassword != null) {
    initialRoute = '/user_info/${Uri.encodeComponent(lastUsername)}';
    initialArguments = {
      'email': lastUsername,
      'password': lastPassword,
    };
  }

  runApp(MyApp(
    initialRoute: initialRoute,
    initialArguments: initialArguments,
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final Object? initialArguments;

  const MyApp({
    super.key,
    required this.initialRoute,
    this.initialArguments,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: initialRoute,
      onGenerateInitialRoutes: (initialRoute) {
        return [
          MaterialPageRoute(
            builder: (context) {
              if (initialRoute.startsWith('/user_info/')) {
                return const UserInfoPage();
              } else if (initialRoute == '/login') {
                return const LoginPage();
              } else {
                return const WelcomePage(); // fallback
              }
            },
            settings: RouteSettings(
              name: initialRoute,
              arguments: initialArguments,
            ),
          ),
        ];
      },
      routes: {
        '/login': (context) => const LoginPage(),
        'bienvenido': (context) => const WelcomePage(),
        '/create_account': (context) => const CreateAccountPage(),
        '/forgot_password': (context) => const ForgotPasswordPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name!.startsWith('/user_info/')) {
          return MaterialPageRoute(
            builder: (context) => const UserInfoPage(),
            settings: settings, // ✅ Mantener argumentos originales
          );
        }
        return null;
      },
    );
  }
}
