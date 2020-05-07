import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductItem extends StatelessWidget {

  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
       borderRadius: BorderRadius.circular(10),
       child: GridTile(
        child: Image.network(product.imageUrl, fit: BoxFit.cover,),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(product.title),
          leading: IconButton(
            icon: Icon(Icons.favorite_border),
            color: Theme.of(context).accentColor, 
            onPressed: (){},
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor, 
            onPressed: (){},
          ),
        ),
      ),
    );
  }
}