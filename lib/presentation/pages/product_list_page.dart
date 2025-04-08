import 'package:flutter/material.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    // Lista de productos ficticios
    final products = ['Laptop', 'Smartphone', 'Audífonos'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Productos'), // Barra superior con título
        backgroundColor: Colors.teal, // Color del AppBar
      ),
      backgroundColor: const Color(0xFFE0F7FA), // Fondo celeste pálido para toda la pantalla
      body: Column( // Permite colocar varios widgets en vertical
        crossAxisAlignment: CrossAxisAlignment.start, // Alinea el contenido a la izquierda
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0), // Espacio alrededor del texto
            child: Text(
              'Presione un Producto', // Título que indica al usuario qué hacer
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Estilo del texto
            ),
          ),
          Expanded( // Hace que la lista ocupe el espacio restante de la pantalla
            child: ListView.builder( // Crea una lista que se puede desplazar
              itemCount: products.length, // Cantidad de elementos en la lista
              itemBuilder: (context, index) {
                return Card( // Decoración para cada elemento (tarjeta)
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Espaciado entre tarjetas
                  child: ListTile(
                    title: Text(products[index]), // Muestra el nombre del producto
                    trailing: const Icon(Icons.arrow_forward_ios), // Ícono de flecha al final
                    onTap: () {
                      // Al tocar un producto, se navega a la pantalla de detalle
                      Navigator.pushNamed(
                        context,
                        '/detail', // Ruta a la que se desea ir
                        arguments: products[index], // Se envía el nombre del producto como parámetro
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
