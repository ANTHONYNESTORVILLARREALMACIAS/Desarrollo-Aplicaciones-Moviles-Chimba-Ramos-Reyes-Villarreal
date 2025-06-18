import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/order_title.dart';
import '../providers/order_providers.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_detail.dart';

class OrderFormPage extends ConsumerStatefulWidget {
  const OrderFormPage({super.key});

  @override
  ConsumerState<OrderFormPage> createState() => _OrderFormPageState();
}

class _OrderFormPageState extends ConsumerState<OrderFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _clienteController;
  final List<OrderDetail> _detalles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _clienteController = TextEditingController();
  }

  @override
  void dispose() {
    _clienteController.dispose();
    // Asegurarse de limpiar el ID al cerrar la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(selectedOrderIdProvider.notifier).state = null;
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedOrderId = ref.watch(selectedOrderIdProvider);
    final isEditing = selectedOrderId != null;

    // Si estamos editando, necesitamos cargar los datos del pedido
    if (isEditing) {
      return ref
          .watch(selectedOrderProvider)
          .when(
            data: (order) {
              if (order == null) {
                return const Scaffold(
                  body: Center(child: Text('Pedido no encontrado')),
                );
              }

              // Pre-llenar el formulario si no se ha llenado aún
              if (_clienteController.text.isEmpty) {
                _clienteController.text = order.nombreCliente;
              }

              return _buildScaffold(isEditing, order);
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

    // Si estamos creando un nuevo pedido
    return _buildScaffold(false, null);
  }

  Widget _buildScaffold(bool isEditing, Order? existingOrder) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          // Limpiar el ID seleccionado al salir
          ref.read(selectedOrderIdProvider.notifier).state = null;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Editar Pedido' : 'Nuevo Pedido'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Limpiar ID al volver atrás manualmente
              ref.read(selectedOrderIdProvider.notifier).state = null;
              Navigator.pop(context);
            },
          ),
        ),
        body:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Eliminamos el OrderTitle con la flecha duplicada
                        Text(
                          isEditing ? 'Editar Pedido' : 'Nuevo Pedido',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _clienteController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre del Cliente',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese el nombre del cliente';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        if (!isEditing) ...[
                          const Text(
                            'Productos a añadir',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildDetailsList(null),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _addDetail,
                              icon: const Icon(Icons.add),
                              label: const Text('Agregar Producto'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _saveOrder(existingOrder),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15.0,
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              isEditing ? 'Actualizar Pedido' : 'Crear Pedido',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildDetailsList(Order? order) {
    final details = order?.detalles ?? _detalles;

    if (details.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No hay productos agregados'),
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
                if (order == null) // Solo permitir eliminar en nuevos pedidos
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    onPressed: () {
                      setState(() {
                        _detalles.removeAt(index);
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addDetail() {
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
              onPressed: () {
                // Validación adicional antes de crear el detalle
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
                  // Intentar parsear los valores numéricos
                  final price = double.parse(precioUnitario);
                  final qty = int.parse(cantidad);

                  if (price <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('El precio debe ser mayor a 0'),
                      ),
                    );
                    return;
                  }

                  if (qty <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('La cantidad debe ser mayor a 0'),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    _detalles.add(
                      OrderDetail(
                        nombreProducto: nombreProducto,
                        precioUnitario: price,
                        cantidad: qty,
                      ),
                    );
                  });
                  Navigator.pop(context);
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

  Future<void> _saveOrder(Order? existingOrder) async {
    if (!_formKey.currentState!.validate()) return;

    // Si estamos creando un nuevo pedido, verificar que tenga al menos un detalle
    if (_detalles.isEmpty && existingOrder == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agregue al menos un producto')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final orderNotifier = ref.read(ordersProvider.notifier);

      if (existingOrder != null) {
        // Actualizar pedido existente
        final updatedOrder = Order(
          id: existingOrder.id,
          nombreCliente: _clienteController.text,
          fechaPedido: existingOrder.fechaPedido,
          detalles: existingOrder.detalles,
        );

        await orderNotifier.updateOrder(existingOrder.id!, updatedOrder);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pedido actualizado exitosamente')),
          );
        }
      } else {
        // Crear nuevo pedido
        final newOrder = Order(
          nombreCliente: _clienteController.text,
          fechaPedido: DateTime.now().toIso8601String(),
          detalles: _detalles,
        );

        await orderNotifier.createOrder(newOrder);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pedido creado exitosamente')),
          );
        }
      }

      // IMPORTANTE: Limpiar el ID seleccionado después de guardar
      if (mounted) {
        ref.read(selectedOrderIdProvider.notifier).state = null;
        await ref.read(ordersProvider.notifier).fetchOrders();
        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
