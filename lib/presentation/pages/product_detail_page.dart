import 'package:flutter/material.dart';

class ProductDetailSheet extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final data = product['data'] ?? {};

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 3, blurRadius: 6),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nombre: ${product['name']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          const Text('Características:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (data is Map<String, dynamic> && data.isNotEmpty)
            ...data.entries.map((e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${e.key}: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Expanded(child: Text('${e.value}', style: TextStyle(fontSize: 14))),
                  ],
                ),
              );
            }).toList()
          else
            const Text('Sin características disponibles.', style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
