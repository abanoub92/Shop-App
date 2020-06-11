import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';


class OrderButton extends StatefulWidget {

  final CartProvider cart;

  OrderButton(this.cart);

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading) 
      ? null 
      : () async {
        setState(() {
          _isLoading = true;
        });

        await Provider.of<OrderProvider>(context, listen: false).addOrder(
          widget.cart.items.values.toList(), 
          widget.cart.totalAmount
        );

        setState(() {
          _isLoading = false;
        });

        widget.cart.clearItems();
      }, 
      child: _isLoading ? CircularProgressIndicator() : Text('Order Now', style: TextStyle(color: Theme.of(context).primaryColor),),
    );
  }
}