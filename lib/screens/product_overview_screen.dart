import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
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

  static const route_name = '/product-overview';
  
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {

  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    //won't work because any .of(context) function does not work here
    // it could propably work if you add listen: false
    //Provider.of<ProductProvider>(context).fetchProductsList(); 

    //result for this problem, but it's not recommended
    //and this result will get an error, to avoid it add listen to false
    // Future.delayed(Duration.zero).then((_){
    //   Provider.of<ProductProvider>(context).fetchProductsList();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit){
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductProvider>(context).fetchProductsList()
      .then((_){
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
      body: _isLoading 
      ? Center(child: CircularProgressIndicator(),)
      : ProductGrid(_showOnlyFavorites),

      drawer: NavDrawer(),
    );
  }
}