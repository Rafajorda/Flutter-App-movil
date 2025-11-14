import 'package:flutter/material.dart';
import 'package:proyecto_1/features/details/details_product.dart';
import '../../models/product.dart';

/// Card de producto para mostrar en grids o listas.
///
/// Muestra:
/// - Imagen del producto (con loading y manejo de errores)
/// - Precio destacado en verde
/// - Nombre del producto (bold)
/// - Descripción (máx 2 líneas con ellipsis)
///
/// Características:
/// - Navegación a ProductDetailPage al hacer tap
/// - Loading progresivo de imágenes
/// - Fallback a placeholder si no hay imagen
/// - Error handling elegante con icono y mensaje
/// - Elevación y bordes redondeados para mejor estética
class ProductCard extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final String? imageUrl;
  final Product product;

  const ProductCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      // Navegar a detalles del producto al hacer tap
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼 Imagen del producto con manejo de estados
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.network(
                      imageUrl!,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      // Estado de carga con progress indicator
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 160,
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      // Estado de error con icono y mensaje
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 160,
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.broken_image,
                                size: 60,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Error al cargar',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  // Fallback a imagen placeholder si no hay URL
                  : Image.asset(
                      'assets/images/placeholder.png',
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),

            // 🧱 Contenido de la tarjeta
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.green[700]),
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
