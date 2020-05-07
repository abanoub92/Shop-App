import 'package:flutter/material.dart';
import 'package:shop_app/widgets/product_item.dart';
import '../dummy_products_data.dart';
import '../models/product.dart';

class ProductOverviewScreen extends StatelessWidget {
  
  final List<Product> _loadedProducts = dummyProducts; 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: _loadedProducts.length,
        itemBuilder: (context, index){
          return ProductItem(_loadedProducts[index]);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}