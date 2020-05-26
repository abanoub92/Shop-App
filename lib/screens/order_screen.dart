import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart' show OrderProvider;
import '../widgets/order_item.dart';
import '../widgets/nav_drawer.dart';

class OrderScreen extends StatelessWidget {

  static const route_name = '/orders';

  @override
  Widget build(BuildContext context) {

    final order = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: ListView.builder(
        itemCount: order.items.length,
        itemBuilder: (ctx, index){
          return OrderItem(order.items[index]);
        },
      ),
      drawer: NavDrawer(),
    );
  }
}