import 'package:dish_dash/features/restaurant/presentation/screens/map_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class ProductSearchResultsScreen extends StatefulWidget {
  final String searchQuery;

  const ProductSearchResultsScreen({
    super.key,
    required this.searchQuery,
  });

  @override
  State<ProductSearchResultsScreen> createState() => _ProductSearchResultsScreenState();
}

class _ProductSearchResultsScreenState extends State<ProductSearchResultsScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger search when screen initializes
    context.read<ProductCubit>().searchProducts(widget.searchQuery);
  }
  
  @override
  Widget build(BuildContext context) {
    bool _showMap = false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          widget.searchQuery,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoaded) {
            return Column(
              children: [
                // Add this Container for the switch
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 8.0,
                  ),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Switch(                   
                        value: _showMap,
                        onChanged: (value) {
                          setState(() {
                            _showMap = value;
                          });
                          if (_showMap) {
                            // Navigate to map page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  MapScreen(), // change this to map
                              ),
                            ).then((_) {
                              // When returning from map page, reset the switch
                              setState(() {
                                _showMap = false;
                              });
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Map View',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  color: Colors.grey[100],
                  child: Row(
                    children: [
                      Text(
                        '${state.products.length} results found',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: state.products.isEmpty
                      ? const Center(
                          child: Text('No products found'),
                        )
                      : ListView.builder(
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            return ProductListItem(
                              product: state.products[index],
                            );
                          },
                        ),
                ),
              ],
            );
          
          } else if (state is ProductError) {
            return Center(child: Text(state.message));
          }
          print(state);
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Icon(
              Icons.fastfood,
              size: 40,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}