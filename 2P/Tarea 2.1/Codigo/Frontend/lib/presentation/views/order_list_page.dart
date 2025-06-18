import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/order_title.dart';
import '../widgets/order_card.dart';
import '../providers/order_providers.dart';
import '../providers/order_providers_themes.dart';
import '../../domain/entities/order.dart';

// Cambiado a ConsumerStatefulWidget
class OrderListPage extends ConsumerStatefulWidget {
  const OrderListPage({super.key});

  @override
  ConsumerState<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends ConsumerState<OrderListPage> {
  @override
  void initState() {
    super.initState();
    // Programar la actualización para después de que el frame se haya dibujado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersProvider.notifier).fetchOrders();
    });
  }

  // También refrescar cuando la página vuelve a ser visible
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Esto detecta cuando esta página vuelve al frente en la navegación
    ModalRoute.of(context)?.addScopedWillPopCallback(() async {
      ref.read(ordersProvider.notifier).fetchOrders();
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(ordersProvider);
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Pedidos'),
        elevation: 2,
        actions: [
          // Botón para cambiar el tema
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDarkMode ? 'Modo Claro' : 'Modo Oscuro',
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: OrderTitle(title: 'Lista de Pedidos'),
          ),
          Expanded(
            child: ordersAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return const Center(
                    child: Text('No hay pedidos disponibles'),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.read(ordersProvider.notifier).fetchOrders();
                  },
                  child: ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return OrderCard(
                        order: order,
                        onTap: () => _viewOrderDetails(context, order),
                        onEdit: () => _editOrder(context, order),
                        onDelete: () => _confirmDeleteOrder(context, order),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (error, stackTrace) => Center(
                    child: Text('Error al cargar pedidos: ${error.toString()}'),
                  ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrder(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _viewOrderDetails(BuildContext context, Order order) {
    ref.read(selectedOrderIdProvider.notifier).state = order.id;
    Navigator.pushNamed(context, '/details');
  }

  void _editOrder(BuildContext context, Order order) async {
    ref.read(selectedOrderIdProvider.notifier).state = order.id;
    await Navigator.pushNamed(context, '/form');
    // Refrescar la lista después de regresar de la edición
    ref.refresh(ordersProvider);
  }

  void _confirmDeleteOrder(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: Text(
              '¿Está seguro que desea eliminar el pedido #${order.id}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteOrder(order);
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _deleteOrder(Order order) async {
    try {
      await ref.read(ordersProvider.notifier).deleteOrder(order.id!);
      ref.read(ordersProvider.notifier).fetchOrders();
    } catch (e) {
      print('Error al eliminar el pedido: $e');
    }
  }

  void _createOrder(BuildContext context) {
    // Limpiar explícitamente el ID seleccionado antes de navegar
    ref.read(selectedOrderIdProvider.notifier).state = null;
    Navigator.pushNamed(context, '/form').then((_) {
      // Refrescar al volver
      ref.read(ordersProvider.notifier).fetchOrders();
    });
  }
}
