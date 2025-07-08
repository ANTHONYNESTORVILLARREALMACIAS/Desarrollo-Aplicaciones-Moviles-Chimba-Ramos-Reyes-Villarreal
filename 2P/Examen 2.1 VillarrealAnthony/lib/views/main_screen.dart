import 'package:flutter/material.dart';
import '../views/age_calculator/age_calculator_screen.dart';
import '../views/api_consumer/api_consumer_screen.dart';
import '../views/triangle/triangle_screen.dart';
import '../viewmodels/main_viewmodel.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MainViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('VillApp'),
        actions: [
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.background,
            ],
          ),
        ),
        child: IndexedStack(
          index: viewModel.currentIndex,
          children: const [
            AgeCalculatorScreen(),
            TriangleScreen(),
            ApiConsumerScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: viewModel.currentIndex,
        onTap: viewModel.changeTab,
        backgroundColor: theme.colorScheme.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Edad',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.change_history),
            label: 'Triángulo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.api),
            label: 'API',
          ),
        ],
      ),
    );
  }
}