import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    // Obtiene el argumento enviado desde la pantalla anterior (nombre del producto)
    final productName = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Producto'), // Barra superior
        backgroundColor: Colors.teal, // Color del AppBar
      ),
      backgroundColor: const Color(0xFFE0F7FA), // Fondo celeste pálido para la pantalla
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centra los elementos verticalmente
          children: [
            Text(
              'Producto: $productName', // Muestra el nombre del producto
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold), // Estilo del texto
            ),
            const SizedBox(height: 20), // Espacio entre el texto y el botón
            ElevatedButton(
              onPressed: () => Navigator.pop(context), // Regresa a la pantalla anterior
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Color del botón
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Tamaño del botón
              ),
              child: const Text(
                'Regresar', // Texto del botón
                style: TextStyle(color: Colors.white), // Color del texto
              ),
            )
          ],
        ),
      ),
    );
  }
}


