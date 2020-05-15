import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';

class ProductDetailsScreen extends StatelessWidget {

  static const route_name = '/product-details';

  /*
   * Consumer<Provider>{}
   * it's the same of Provider.of<Provider>(context) but there
   * is a tiny difference is when you use Consumer will rebuild 
   * the ui always with every change happend.
   * 
   * but the provider.of has the listen property you can make it
   * stop listen if it not necessary 
   * 
   * consumer must put it as a parent of the changable 
   * widget, else will rebuild the whole ui
   */

  @override
  Widget build(BuildContext context) {

    final productId = ModalRoute.of(context).settings.arguments as String;
    //final product = Provider.of<ProductProvider>(context, listen: false).findById(productId);
    /**
     * listen: false
     * Because this screen created per click on products item
     * so it's not nessccary to listen to changes, becasue there
     * is no changes make after the widget is created
     */

    return Consumer<ProductProvider>(
      builder: (ctx, data, child){
        return Scaffold(
          appBar: AppBar(
            title: Text(data.findById(productId).title),
          ),
          body: Center(
            child: Text('The product data ${data.findById(productId).imageUrl}'),
          ),
        );
      },
    );
  }
}