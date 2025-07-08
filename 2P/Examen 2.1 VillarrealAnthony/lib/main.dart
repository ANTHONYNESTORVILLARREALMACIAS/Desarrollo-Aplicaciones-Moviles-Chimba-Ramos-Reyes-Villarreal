import 'package:flutter/material.dart';
import './viewmodels/main_viewmodel.dart';
import './views/main_screen.dart';
import 'package:provider/provider.dart';
import 'viewmodels/age_calculator_viewmodel.dart';
import 'viewmodels/triangle_viewmodel.dart';
import 'viewmodels/api_consumer_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainViewModel()),
        ChangeNotifierProvider(create: (_) => AgeCalculatorViewModel()),
        ChangeNotifierProvider(create: (_) => TriangleViewModel()),
        ChangeNotifierProvider(create: (_) => ApiConsumerViewModel()), // Asegúrate de esta línea
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VillApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32), // Verde principal
          primary: const Color(0xFF2E7D32), // Verde oscuro
          secondary: const Color(0xFF7CB342), // Verde claro
          surface: const Color(0xFFF5F5F5), // Fondo claro
          background: Colors.white,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xFF2E7D32),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(8),
        ),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}