import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/pokemon_model.dart';
import '../../viewmodels/api_consumer_viewmodel.dart';

class ApiConsumerScreen extends StatefulWidget {
  const ApiConsumerScreen({super.key});

  @override
  State<ApiConsumerScreen> createState() => _ApiConsumerScreenState();
}

class _ApiConsumerScreenState extends State<ApiConsumerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApiConsumerViewModel>(context, listen: false).loadPokemonList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ApiConsumerViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon API'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.loadPokemonList(),
          ),
        ],
      ),
      body: _buildBody(viewModel, theme),
    );
  }

  Widget _buildBody(ApiConsumerViewModel viewModel, ThemeData theme) {
    if (viewModel.isLoading && viewModel.pokemonList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              viewModel.errorMessage!,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.loadPokemonList(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (viewModel.pokemonList.isEmpty) {
      return const Center(child: Text('No se encontraron Pokémon'));
    }

    return ListView.builder(
      itemCount: viewModel.pokemonList.length,
      itemBuilder: (context, index) {
        final pokemon = viewModel.pokemonList[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.secondary.withOpacity(0.2),
              child: Text(
                '${index + 1}',
                style: TextStyle(color: theme.colorScheme.secondary),
              ),
            ),
            title: Text(
              pokemon.name.toUpperCase(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await viewModel.loadPokemonDetails(pokemon.url);
              if (viewModel.selectedPokemon != null) {
                _showPokemonDetails(context, viewModel.selectedPokemon!);
              }
            },
          ),
        );
      },
    );
  }

  void _showPokemonDetails(BuildContext context, Pokemon pokemon) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          pokemon.name.toUpperCase(),
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                pokemon.imageUrl,
                height: 120,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.error_outline,
                  size: 60,
                  color: theme.colorScheme.error,
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 120,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                'ID: #${pokemon.id.toString().padLeft(3, '0')}',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Tipo(s): ${pokemon.types.join(', ')}',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Altura: ${pokemon.height / 10} m',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Peso: ${pokemon.weight / 10} kg',
                style: theme.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}