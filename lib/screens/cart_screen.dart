import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item.dart';

/*
 * if your class has multi classes
 * there's a couple solutions, the first one:
 * example on CartProvider has two classes
 * the cart model and cart provider
 * if you want the model:
 * 1- import '../providers/cart_provider.dart' as ci;
 * 2- and inside the code use ci.card model then flutter
 *    will know the request inner class
 * or 
 * 1- import '../providers/cart_provider.dart' show Card;
 * 2- and the flutter will know the required class and 
 *    will imported only
 */

class CartScreen extends StatelessWidget {

  static const route_name = '/cart';

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total: ', style: TextStyle(fontSize: 20),),
                  SizedBox(width: 8,),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Theme.of(context).primaryTextTheme.bodyText1.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  FlatButton(
                    onPressed: (){
                      Provider.of<OrderProvider>(context, listen: false).addItem(
                        cart.items.values.toList(), 
                        cart.totalAmount
                      );
                      cart.clearItems();
                    }, 
                    child: Text('Order Now', style: TextStyle(color: Theme.of(context).primaryColor),),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index){
                return CartItem(
                  cart.items.values.toList()[index].id,
                  cart.items.keys.toList()[index],
                  cart.items.values.toList()[index].title,
                  cart.items.values.toList()[index].quantity,
                  cart.items.values.toList()[index].price,
                );
              },
              itemCount: cart.items.length,
            ),
          ),
        ],
      ),
    );
  }
}