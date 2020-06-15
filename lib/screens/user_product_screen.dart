import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/user_product_item.dart';
import '../providers/product_provider.dart';
import '../widgets/nav_drawer.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  
  static const route_name = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false).fetchProductsList(true);
  }


  @override
  Widget build(BuildContext context) {

    // we will use consumer instead of this 
    // (because with future builder it make an infinte build)
    //final productData = Provider.of<ProductProvider>(context);

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
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => 
        snapshot.connectionState == ConnectionState.waiting 
        ? Center(child: CircularProgressIndicator(),)
        : RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<ProductProvider> (
            builder: (ctx, product, child) => Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: product.items.length, 
                itemBuilder: (ctx, index){
                  return UserProductItem(
                    product.items.elementAt(index).id,
                    product.items.elementAt(index).imageUrl, 
                    product.items.elementAt(index).title);        
                },
              ),
            ),
          ),
        ),
      ),
      drawer: NavDrawer(),
    );
  }
}