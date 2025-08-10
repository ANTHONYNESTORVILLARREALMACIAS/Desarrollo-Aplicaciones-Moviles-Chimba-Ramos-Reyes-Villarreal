import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/search_viewmodel.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/settings_viewmodel.dart';
import 'views/login_view.dart';
import 'views/chat_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ✅ OPTIMIZADO: SettingsViewModel se inicializa rápido
        ChangeNotifierProvider(
          create: (context) {
            final settingsViewModel = SettingsViewModel();
            // Init inmediato sin await para no bloquear UI
            settingsViewModel.init();
            return settingsViewModel;
          },
        ),
        ChangeNotifierProvider(create: (context) => AuthViewModel()..checkSavedUser()),
        ChangeNotifierProvider(create: (context) => SearchViewModel()..loadHistory()),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsViewModel, child) {
          // ✅ OPTIMIZADO: Mostrar app inmediatamente con valores por defecto
          return MaterialApp(
            title: settingsViewModel.getText('appTitle'),
            debugShowCheckedModeBanner: false,
            theme: settingsViewModel.currentTheme,
            home: Consumer<AuthViewModel>(
              builder: (context, authViewModel, child) {
                if (authViewModel.isLoggedIn) {
                  return const ChatView();
                }
                return const LoginView();
              },
            ),
          );
        },
      ),
    );
  }
}