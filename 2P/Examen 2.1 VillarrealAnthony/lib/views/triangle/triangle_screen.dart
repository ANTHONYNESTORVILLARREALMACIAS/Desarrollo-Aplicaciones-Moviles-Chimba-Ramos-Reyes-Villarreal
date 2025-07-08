import 'package:flutter/material.dart';
import '../../models/triangle_model.dart';
import '../../viewmodels/triangle_viewmodel.dart';
import 'package:provider/provider.dart';

class TriangleScreen extends StatelessWidget {
  const TriangleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TriangleViewModel>(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Identificador de Triángulos',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSideInput('Lado A', viewModel.sideAController, theme),
                  const SizedBox(height: 15),
                  _buildSideInput('Lado B', viewModel.sideBController, theme),
                  const SizedBox(height: 15),
                  _buildSideInput('Lado C', viewModel.sideCController, theme),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: viewModel.identifyTriangle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'IDENTIFICAR',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (viewModel.triangle != null)
            _buildResultCard(viewModel.triangle!, theme),
        ],
      ),
    );
  }

  Widget _buildSideInput(
      String label, TextEditingController controller, ThemeData theme) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.colorScheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
        ),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildResultCard(TriangleModel triangle, ThemeData theme) {
    Color getTriangleColor(String type) {
      switch (type) {
        case 'Equilátero':
          return Colors.green;
        case 'Isósceles':
          return Colors.orange;
        case 'Escaleno':
          return Colors.red;
        default:
          return theme.colorScheme.primary;
      }
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: theme.colorScheme.secondary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Resultado:',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: getTriangleColor(triangle.type),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                triangle.type.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Lados: ${triangle.sideA}, ${triangle.sideB}, ${triangle.sideC}',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}