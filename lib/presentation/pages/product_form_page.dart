import 'package:flutter/material.dart';
import '../../core/api_service_product.dart';

class ProductFormPage extends StatefulWidget {
  final Map<String, dynamic>? product; // Si viene un producto, es editar

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final ApiServiceProduct apiServiceProduct = ApiServiceProduct();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!['name'] ?? '';
      final data = widget.product!['data'] ?? {};
      _brandController.text = data['brand'] ?? '';
      _priceController.text = data['price']?.toString() ?? '';
    }
  }

  void _submitForm() async {
    final name = _nameController.text;
    final brand = _brandController.text;
    final price = _priceController.text;

    final data = {
      'brand': brand,
      'price': price,
    };

    try {
      if (widget.product == null) {
        // Crear producto
        await apiServiceProduct.postProduct(name, data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto creado exitosamente')));
      } else {
        // Actualizar producto
        await apiServiceProduct.putProduct(widget.product!['id'], name, data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto actualizado exitosamente')));
      }
      Navigator.pop(context, true); // Devuelve true para refrescar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Producto' : 'Agregar Producto'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre del producto'),
            ),
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(labelText: 'Marca'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: Text(isEditing ? 'Actualizar' : 'Crear'),
            )
          ],
        ),
      ),
    );
  }
}
