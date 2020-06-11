import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../screens/product_details_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final product = Provider.of<Product>(context);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final scaffold = Scaffold.of(context);

    return ClipRRect(
       borderRadius: BorderRadius.circular(10),
       child: GridTile(
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).pushNamed(ProductDetailsScreen.route_name, arguments: product.id);
          },
          child: Image.network(product.imageUrl, fit: BoxFit.cover,)
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(product.title),
          leading: Consumer<Product>(
            builder: (ctx, product, _){
              return IconButton(
                icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
                color: Theme.of(context).accentColor, 
                onPressed: (){
                  product.isRealyFavorite();
                },
              );
            },
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor, 
            onPressed: (){
              cart.addItem(product.id, product.title, product.price);
              scaffold.hideCurrentSnackBar();
              scaffold.showSnackBar(
                SnackBar(
                  content: Text('Add item to the cart'),
                  duration: Duration(seconds: 2,),
                  action: SnackBarAction(
                    label: 'UNDO', 
                    onPressed: (){
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}