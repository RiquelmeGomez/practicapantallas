import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServiceProduct {
  final String baseUrl = 'https://api.restful-api.dev/objects';

  // GET - Obtener todos los productos
  Future<List<dynamic>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener productos');
    }
  }

  // POST - Crear un producto
  Future<Map<String, dynamic>> postProduct(String name, Map<String, dynamic>? data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'data': data,
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al crear producto');
    }
  }

  // PUT - Actualizar un producto por ID
  Future<Map<String, dynamic>> putProduct(String id, String name, Map<String, dynamic>? data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'data': data,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al actualizar producto');
    }
  }

  // DELETE - Eliminar un producto por ID
  Future<void> deleteProduct(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar producto');
    }
  }
}
