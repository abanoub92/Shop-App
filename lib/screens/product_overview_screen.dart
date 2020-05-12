import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_item.dart';

class ProductOverviewScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    final productData = Provider.of<ProductProvider>(context);
    final product = productData.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: product.length,
        itemBuilder: (context, index) => ChangeNotifierProvider(
            create: (ctx) => product[index],
            child: ProductItem(),
        ),
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