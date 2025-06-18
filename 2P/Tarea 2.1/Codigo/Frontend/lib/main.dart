import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/views/order_list_page.dart';
import 'presentation/views/order_form_page.dart';
import 'presentation/views/order_detail_page.dart';
import 'presentation/providers/order_providers_themes.dart';
import 'presentation/providers/order_providers.dart';

void main() {
  runApp(const ProviderScope(child: AlexGamesApp()));
}

class AlexGamesApp extends ConsumerWidget {
  const AlexGamesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observar el modo de tema actual
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Sistema de Pedidos',
      debugShowCheckedModeBanner: false,
      
      // Tema claro personalizado
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 4,
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepPurple,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      // Tema oscuro personalizado
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 4,
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.deepPurple,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      
      themeMode: themeMode,
      
      initialRoute: '/',
      routes: {
        '/': (_) => const OrderListPage(),
        '/form': (_) => const OrderFormPage(),
        '/details': (_) => const OrderDetailPage(),
      },
      navigatorObservers: [
        _OrdersRefreshObserver(ref),
      ],
    );
  }
}

// Observador personalizado para refrescar la lista de pedidos
class _OrdersRefreshObserver extends NavigatorObserver {
  final WidgetRef ref;
  
  _OrdersRefreshObserver(this.ref);
  
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute?.settings.name == '/') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedOrderIdProvider.notifier).state = null;
      });
    }
    super.didPop(route, previousRoute);
  }
}