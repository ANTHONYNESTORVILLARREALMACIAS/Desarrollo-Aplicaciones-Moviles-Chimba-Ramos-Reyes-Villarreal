import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/order_title.dart';
import '../providers/order_providers.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_detail.dart';

class OrderDetailPage extends ConsumerWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderId = ref.watch(selectedOrderIdProvider);

    if (orderId == null) {
      return const Scaffold(
        body: Center(child: Text('No se seleccionó ningún pedido')),
      );
    }

    return ref
        .watch(selectedOrderProvider)
        .when(
          data: (order) {
            if (order == null) {
              return const Scaffold(
                body: Center(child: Text('Pedido no encontrado')),
              );
            }
            return _buildScaffold(context, ref, order);
          },
          loading:
              () => const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
          error:
              (error, stackTrace) => Scaffold(
                body: Center(child: Text('Error: ${error.toString()}')),
              ),
        );
  }

  Widget _buildScaffold(BuildContext context, WidgetRef ref, Order order) {
    // Calcular el total del pedido
    final total = order.detalles.fold<double>(
      0.0,
      (sum, detail) => sum + (detail.precioUnitario * detail.cantidad),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido #${order.id}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editOrder(context, ref, order),
            tooltip: 'Editar pedido',
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmDeleteOrder(context, ref, order),
            tooltip: 'Eliminar pedido',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Eliminamos la flecha duplicada cambiando showBackButton a false
            const Text(
              'Detalles del Pedido',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Cliente', order.nombreCliente),
                    _buildInfoRow('Fecha', _formatDate(order.fechaPedido)),
                    _buildInfoRow('Total', '\$${total.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Productos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildDetailsList(ref, order),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _addDetail(context, ref, order),
                icon: const Icon(Icons.add),
                label: const Text('Agregar Producto'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildDetailsList(WidgetRef ref, Order order) {
    final details = order.detalles;

    if (details.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No hay productos en este pedido'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: details.length,
      itemBuilder: (context, index) {
        final detail = details[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(detail.nombreProducto),
            subtitle: Text('Cantidad: ${detail.cantidad}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '\$${(detail.precioUnitario * detail.cantidad).toStringAsFixed(2)}',
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                  onPressed:
                      () => _editDetail(context, ref, order, detail, index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  onPressed:
                      () => _confirmDeleteDetail(context, ref, order, detail),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _editOrder(BuildContext context, WidgetRef ref, Order order) async {
    await Navigator.pushNamed(context, '/form');
    // Refrescar los datos después de regresar
    ref.refresh(selectedOrderProvider);
  }

  void _confirmDeleteOrder(BuildContext context, WidgetRef ref, Order order) {
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
                  _deleteOrder(context, ref, order);
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

  void _deleteOrder(BuildContext context, WidgetRef ref, Order order) async {
    try {
      await ref.read(ordersProvider.notifier).deleteOrder(order.id!);
      if (context.mounted) {
        Navigator.pop(context); // Volver a la lista
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pedido eliminado exitosamente')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
      }
    }
  }

  void _addDetail(BuildContext context, WidgetRef ref, Order order) {
    showDialog(
      context: context,
      builder: (context) {
        String nombreProducto = '';
        String precioUnitario = '';
        String cantidad = '';

        return AlertDialog(
          title: const Text('Agregar Producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Nombre del Producto',
                  hintText: 'Ej: PlayStation 5',
                ),
                onChanged: (value) => nombreProducto = value,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Precio Unitario',
                  hintText: 'Ej: 499.99 o 499,99',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (value) {
                  // Validación: reemplazar comas por puntos
                  precioUnitario = value.replaceAll(',', '.');
                },
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                  hintText: 'Ej: 1',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => cantidad = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (nombreProducto.isEmpty ||
                    precioUnitario.isEmpty ||
                    cantidad.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Todos los campos son obligatorios'),
                    ),
                  );
                  return;
                }

                try {
                  final price = double.parse(precioUnitario);
                  final qty = int.parse(cantidad);

                  if (price <= 0 || qty <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Precio y cantidad deben ser mayores a 0',
                        ),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context);

                  final detail = OrderDetail(
                    nombreProducto: nombreProducto,
                    precioUnitario: price,
                    cantidad: qty,
                  );

                  try {
                    await ref
                        .read(ordersProvider.notifier)
                        .addOrderDetail(order.id!, detail);
                    ref.refresh(selectedOrderProvider);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Por favor, ingrese valores numéricos válidos',
                      ),
                    ),
                  );
                }
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  void _editDetail(
    BuildContext context,
    WidgetRef ref,
    Order order,
    OrderDetail detail,
    int index,
  ) {
    // Controladores con valores actuales
    final nombreController = TextEditingController(text: detail.nombreProducto);
    final precioController = TextEditingController(
      text: detail.precioUnitario.toString(),
    );
    final cantidadController = TextEditingController(
      text: detail.cantidad.toString(),
    );

    // Variable para almacenar el precio con posibles comas reemplazadas
    String precioFormateado = detail.precioUnitario.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Producto',
                ),
              ),
              TextField(
                controller: precioController,
                decoration: const InputDecoration(
                  labelText: 'Precio Unitario',
                  hintText: 'Ej: 499.99 o 499,99',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (value) {
                  // Reemplazar comas por puntos
                  precioFormateado = value.replaceAll(',', '.');
                  // No actualizamos el controlador para no mover el cursor
                },
              ),
              TextField(
                controller: cantidadController,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                try {
                  final updatedDetail = OrderDetail(
                    id: detail.id,
                    nombreProducto: nombreController.text,
                    precioUnitario: double.parse(precioFormateado),
                    cantidad: int.parse(cantidadController.text),
                  );

                  if (updatedDetail.precioUnitario <= 0 ||
                      updatedDetail.cantidad <= 0) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Precio y cantidad deben ser mayores a 0',
                          ),
                        ),
                      );
                    }
                    return;
                  }

                  try {
                    await ref
                        .read(ordersProvider.notifier)
                        .updateOrderDetail(
                          order.id!,
                          detail.id!,
                          updatedDetail,
                        );
                    ref.refresh(selectedOrderProvider);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al actualizar: $e')),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Por favor, ingrese valores numéricos válidos',
                        ),
                      ),
                    );
                  }
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteDetail(
    BuildContext context,
    WidgetRef ref,
    Order order,
    OrderDetail detail,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: Text(
              '¿Está seguro que desea eliminar ${detail.nombreProducto}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await ref
                        .read(ordersProvider.notifier)
                        .deleteOrderDetail(order.id!, detail.id!);
                    ref.refresh(selectedOrderProvider); // Actualizar
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al eliminar: $e')),
                      );
                    }
                  }
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

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
