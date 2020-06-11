import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart' show OrderProvider;
import '../widgets/order_item.dart';
import '../widgets/nav_drawer.dart';

class OrderScreen extends StatelessWidget {

  static const route_name = '/orders';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      
      //improve code by using FutureBuilder widget
      body: FutureBuilder(
        future: Provider.of<OrderProvider>(context, listen: false).fetchOrders(),
        builder: (ctx, dataSnapshot){
          if (dataSnapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }else {
            if (dataSnapshot.error != null){
              return Center(child: Text(dataSnapshot.error.toString()));
            }else {
              return Consumer<OrderProvider> (
                builder: (ctx, orderData, child){
                  return ListView.builder(
                    itemCount: orderData.items.length,
                    itemBuilder: (ctx, index){
                      return OrderItem(orderData.items[index]);
                    },
                  );
                },
              );
            }
          }
        }
      ),
      drawer: NavDrawer(),
    );
  }
}
