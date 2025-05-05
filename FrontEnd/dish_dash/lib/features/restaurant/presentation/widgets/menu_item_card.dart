import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/product.dart';

class MenuItemCard extends StatelessWidget {
  final Product menuItem;

  const MenuItemCard({
    super.key,
    required this.menuItem,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () {
      //   // Show a snackbar when menu item is tapped
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('${menuItem.name} added to cart'),
      //       duration: const Duration(seconds: 1),
      //       action: SnackBarAction(
      //         label: 'View Cart',
      //         onPressed: () {
      //           // Navigate to cart page (not implemented)
      //         },
      //       ),
      //     ),
      //   );
      // },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Menu Item Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 80,
                height: 80,
                color: const Color(0xFFF8F5E4),
                child: Center(
                  child: Icon(
                    Icons.fastfood,
                    size: 30,
                    color: Colors.amber[800],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Menu Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menuItem.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$${menuItem.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[800],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        menuItem.subcategory,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
