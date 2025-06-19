import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pry_caso4_villarreal_ramos_prueba/presentation/providers/user_provider.dart';
import 'package:pry_caso4_villarreal_ramos_prueba/presentation/views/user_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Villa Ramos Web',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[100],
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            bodyMedium: TextStyle(fontFamily: 'Poppins', color: Colors.black87),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const UserListView(),
      ),
    );
  }
}