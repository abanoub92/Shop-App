import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/order_provider.dart' show Order;


/*
 * if we want to change data of widget that will change the whole
 * ui screen recommeded to use stateful widget
 * else if want to change one item in full widget
 * normally use provider class */ 
class OrderItem extends StatefulWidget {
  
  final Order order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  
  var _expanded = false;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$ ${widget.order.amount}'),
            subtitle: Text(DateFormat('dd MM yyyy  hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more), 
              onPressed: (){
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          _expanded ? Container(
            height: min(widget.order.products.length * 20.0 + 100, 180),
            child: ListView(
              children: widget.order.products.map((product){
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        product.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${product.quantity}x \$ ${product.price}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ) : Container(),
        ],
      ),
    );
  }
}