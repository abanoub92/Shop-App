import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import './cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/product_grid.dart';
import '../widgets/nav_drawer.dart';

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
        title: const Text('Shop App'),
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
            child: IconButton(
              icon: Icon(Icons.shopping_cart), 
              onPressed: (){
                Navigator.of(context).pushNamed(CartScreen.route_name);
              }),
          ),
        ],
      ),
      body: ProductGrid(_showOnlyFavorites),
      drawer: NavDrawer(),
    );
  }
}