import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem(this.id, this.productId, this.title, this.quantity, this.price);
  
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),

      /**
       * We pass true and false to Navigator.of(ctx).pop(bool)
       * because confirmDismiss method return a Future.value(bool).
       * means confirm or cancel
       * and the alertDialog do the same so we pass the return value
       * to pop navigator, because the alert dialog reurn the value 
       * after closing the dialog.
       */
      confirmDismiss: (direction){
        return showDialog(context: context, builder: (ctx){
          return AlertDialog(
            title: Text('Delete Product'),
            content: Text('Do you want to delete item from cart?'),
            actions: <Widget>[
              FlatButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('No')),
              FlatButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Yes'))
            ],
          );
        });
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, color: Colors.white, size: 40,),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction){
        Provider.of<CartProvider>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(child: Text('\$ $price')),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$ ${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}