import 'package:flutter/material.dart';
import 'package:practicapantallas/presentation/pages/product_form_page.dart';
// Importamos los archivos de las páginas
import 'presentation/pages/product_list_page.dart';
import 'presentation/pages/product_detail_page.dart';

void main() {
  runApp(const ProductApp()); // Inicia la app llamando al widget principal ProductApp
}

class ProductApp extends StatelessWidget {
  const ProductApp({super.key}); // Constructor del widget

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App', // Título de la app
      initialRoute: '/', // Ruta inicial que se mostrará al abrir la app
          routes: {
        '/': (context) => const ProductListPage(),
        '/form': (context) => const ProductFormPage(),
},
    );
  }
}
