import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/product_grid.dart';

enum FilterOptions{
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {

  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (selectedValue){
              setState(() {
                if (selectedValue == FilterOptions.Favorite){
                  _showOnlyFavorites = true;
                }else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(child: Text('Favorite'), value: FilterOptions.Favorite,),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All,)
            ],
          ),
          Consumer<CartProvider> (
            builder: (_, cart, ch){
              return Badge(
                child: ch, 
                value: cart.itemsCount.toString(),
              );
            },
            child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){}),
          ),
        ],
      ),
      body: ProductGrid(_showOnlyFavorites),
    );
  }
}