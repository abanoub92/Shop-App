import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';

class ProductDetailsScreen extends StatelessWidget {

  static const route_name = '/product-details';

  @override
  Widget build(BuildContext context) {

    final productId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<ProductProvider>(context, listen: false).findById(productId);
    /**
     * listen: false
     * Because this screen created per click on products item
     * so it's not nessccary to listen to changes, becasue there
     * is no changes make after the widget is created
     */

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Center(
        child: Text('The product data ${product.imageUrl}'),
      ),
    );
  }
}