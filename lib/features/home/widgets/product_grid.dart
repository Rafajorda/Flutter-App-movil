import 'package:flutter/material.dart';
import 'package:proyecto_1/core/models/product.dart';
import 'package:proyecto_1/core/widgets/products/card_product.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;

  const ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text('No hay productos disponibles 🛍️'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth == 0) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.45,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                title: product.name,
                description: product.description,
                price: product.price,
                imageUrl: 'assets/images/placeholder.png',
                product: product,
              );
            },
          ),
        );
      },
    );
  }
}
