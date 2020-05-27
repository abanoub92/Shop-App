import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/user_product_item.dart';
import '../providers/product_provider.dart';
import '../widgets/nav_drawer.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  
  static const route_name = '/user-products';
  
  @override
  Widget build(BuildContext context) {

    final productData = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: () => Navigator.of(context).pushNamed(EditProductScreen.route_name),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productData.items.length, 
          itemBuilder: (ctx, index){
            return UserProductItem(
              productData.items.elementAt(index).imageUrl, 
              productData.items.elementAt(index).title);        
          },
        ),
      ),
      drawer: NavDrawer(),
    );
  }
}