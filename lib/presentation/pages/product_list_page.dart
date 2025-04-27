import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:practicapantallas/presentation/pages/product_detail_page.dart';
import '../../core/api_service_product.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ApiServiceProduct apiServiceProduct = ApiServiceProduct();
  late Future<List<dynamic>> futureProducts;
  Map<String, dynamic>? selectedProduct;
  final List<Map<String, TextEditingController>> characteristics = [];
  List<dynamic> productList = [];  // Store products locally

  @override
  void initState() {
    super.initState();
    futureProducts = apiServiceProduct.getProducts();
    _loadProducts();
  }

  // Load products initially
  void _loadProducts() async {
    final products = await apiServiceProduct.getProducts();
    setState(() {
      productList = products;
    });
  }

  void _refreshProducts() {
    setState(() {
      futureProducts = apiServiceProduct.getProducts();
      selectedProduct = null;
    });
  }

  void _deleteProduct(dynamic id) async {
  final idStr = id.toString();
  await apiServiceProduct.deleteProduct(idStr);
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Producto eliminado')),
  );

  // Eliminar el producto de la lista local (sin recargar desde la API)
  setState(() {
    productList.removeWhere((product) => product['id'] == id);
  });
}

  void _openProductForm({Map<String, dynamic>? existingProduct}) {
    final nameController = TextEditingController(
        text: existingProduct != null ? existingProduct['name'] : '');
    final dataController = TextEditingController(
        text: existingProduct != null ? jsonEncode(existingProduct['data']) : '');

    // Clear the characteristics list
    characteristics.clear();

    // If existingProduct is not null, populate the characteristics from the existing data
    if (existingProduct != null && existingProduct['data'] != null) {
      Map<String, dynamic> data = existingProduct['data'];
      data.forEach((key, value) {
        characteristics.add({
          'key': TextEditingController(text: key),
          'value': TextEditingController(text: value.toString()),
        });
      });
    } else {
      // Add one empty row if it's a new product
      characteristics.add({
        'key': TextEditingController(),
        'value': TextEditingController(),
      });
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre del producto'),
                ),
                const SizedBox(height: 10),
                // Display the characteristic rows
                ...characteristics.map((item) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: item['key'],
                          decoration: const InputDecoration(labelText: 'Nombre de la característica'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: item['value'],
                          decoration: const InputDecoration(labelText: 'Descripción de la característica'),
                        ),
                      ),
                    ],
                  );
                }).toList(),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text('Agregar característica'),
                  onPressed: () {
                    // Add new row for additional characteristic
                    setState(() {
                      characteristics.add({
                        'key': TextEditingController(),
                        'value': TextEditingController(),
                      });
                    });
                    // Hide keyboard when adding new row
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: Text(existingProduct == null ? 'Agregar' : 'Actualizar'),
                  onPressed: () async {
                    final name = nameController.text.trim();

                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('El nombre no puede estar vacío')),
                      );
                      return;
                    }

                    Map<String, String> dataMap = {};
                    for (var item in characteristics) {
                      if (item['key']!.text.trim().isNotEmpty &&
                          item['value']!.text.trim().isNotEmpty) {
                        dataMap[item['key']!.text.trim()] = item['value']!.text.trim();
                      }
                    }

                    try {
                      if (existingProduct == null) {
                        // Crear un nuevo producto
                        final newProduct = await apiServiceProduct.postProduct(name, dataMap);

                        // Agregar el nuevo producto a la lista local
                        setState(() {
                          productList.insert(0, newProduct);  // Add new product to the start
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Producto agregado exitosamente')),
                        );
                      } else {
                        // Actualizar un producto existente
                        await apiServiceProduct.putProduct(
                          existingProduct['id'].toString(),
                          name,
                          dataMap,
                        );

                        // Actualizar el producto en la lista local
                        setState(() {
                          final index = productList.indexWhere((product) =>
                              product['id'] == existingProduct['id']);
                          if (index != -1) {
                            productList[index] = {
                              'id': existingProduct['id'],
                              'name': name,
                              'data': dataMap
                            };
                          }
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Producto actualizado exitosamente')),
                        );
                      }

                      Navigator.pop(context); // Cerrar BottomSheet
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Productos'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: const Color(0xFFE0F7FA),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];
                final name = product['name'] ?? 'Sin nombre';
                final id = product['id'];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(name),
                    trailing: Wrap(
                      spacing: 12,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            _openProductForm(existingProduct: product);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProduct(id),
                        ),
                      ],
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => ProductDetailSheet(product: product),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          if (selectedProduct != null)
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Producto seleccionado:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Nombre: ${selectedProduct!['name']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Características:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        if (selectedProduct!['data'] != null &&
                            selectedProduct!['data'] is Map)
                          ...((selectedProduct!['data'] as Map<String, dynamic>)
                              .entries
                              .map((entry) => Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: Text('${entry.key}: ${entry.value}'),
                                  ))
                              .toList())
                        else
                          const Text('Sin detalles'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
        onPressed: () {
          _openProductForm();
        },
      ),
    );
  }
}
