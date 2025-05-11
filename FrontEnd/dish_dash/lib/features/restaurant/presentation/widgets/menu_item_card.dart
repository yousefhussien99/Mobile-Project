import 'package:flutter/material.dart';
import 'package:dish_dash/features/restaurant/data/models/storeProduct_model.dart';

class ProductCardWidget extends StatelessWidget {
  final StoreProductModel product;

  const ProductCardWidget({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Product image
            Container(
              width: 100,
              height: 100,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(_fixEncoding(product.product.imgUrl)), // Use AssetImage for local assets
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    _fixEncoding(product.product.name),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF162B4D),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Price and Category
                  Row(
                    children: [
                      Text(
                        '\$${product.price}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFEF9E26),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _fixEncoding(product.store.name), // Store name fixed
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF7A869A),
                        ),
                      ),
                    ],
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

  String _fixEncoding(String text) {
    return text
        .replaceAll('Ã¨', 'è')
        .replaceAll('Ã©', 'é')
        .replaceAll('Ã¢', 'â')
        .replaceAll('Ãª', 'ê')
        .replaceAll('Ã®', 'î')
        .replaceAll('Ã´', 'ô')
        .replaceAll('Ã¹', 'ù')
        .replaceAll('Ã»', 'û')
        .replaceAll('Ã ', 'à')
        .replaceAll('Ã§', 'ç')
        .replaceAll('â', "'") // common apostrophe replacement
        .replaceAll('Â', '')    // remove extra encoding artifacts
        .replaceAll(' ', '');   // optional: remove space for CaffèLatte style
  }
}
