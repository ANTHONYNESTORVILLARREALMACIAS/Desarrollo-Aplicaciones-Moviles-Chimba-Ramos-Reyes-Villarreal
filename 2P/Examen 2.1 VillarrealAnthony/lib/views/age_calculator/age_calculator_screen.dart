import 'package:flutter/material.dart';
import '../../viewmodels/age_calculator_viewmodel.dart';
import 'package:provider/provider.dart';

class AgeCalculatorScreen extends StatelessWidget {
  const AgeCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AgeCalculatorViewModel>(context);
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
                    'Calculadora de Edad',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDatePickerField(context, viewModel, theme),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: viewModel.calculateAge,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'CALCULAR EDAD',
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
          if (viewModel.age != null) _buildResultCard(viewModel, theme),
        ],
      ),
    );
  }

  Widget _buildDatePickerField(BuildContext context,
      AgeCalculatorViewModel viewModel, ThemeData theme) {
    return TextField(
      controller: viewModel.birthDateController,
      decoration: InputDecoration(
        labelText: 'Fecha de nacimiento',
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
        suffixIcon: Icon(
          Icons.calendar_today,
          color: theme.colorScheme.primary,
        ),
      ),
      readOnly: true,
      onTap: () => viewModel.selectDate(context),
    );
  }

  Widget _buildResultCard(AgeCalculatorViewModel viewModel, ThemeData theme) {
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
              'Tu edad exacta es:',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAgeBox(
                    'Años', viewModel.age!.years.toString(), theme),
                _buildAgeBox(
                    'Meses', viewModel.age!.months.toString(), theme),
                _buildAgeBox(
                    'Días', viewModel.age!.days.toString(), theme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeBox(String label, String value, ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}