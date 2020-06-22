import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';

class ProductDetailsScreen extends StatelessWidget {

  static const route_name = '/product-details';

  /*
   * Consumer<Provider>{}
   * it's the same of Provider.of<Provider>(context) but there
   * is a tiny difference is when you use Consumer will rebuild 
   * the ui always with every change happend.
   * 
   * but the provider.of has the listen property you can make it
   * stop listen if it not necessary 
   * 
   * consumer must put it as a parent of the changable 
   * widget, else will rebuild the whole ui
   */

  @override
  Widget build(BuildContext context) {

    final productId = ModalRoute.of(context).settings.arguments as String;
    //final product = Provider.of<ProductProvider>(context, listen: false).findById(productId);
    /**
     * listen: false
     * Because this screen created per click on products item
     * so it's not nessccary to listen to changes, becasue there
     * is no changes make after the widget is created
     */

    return Consumer<ProductProvider>(
      builder: (ctx, data, child){
        return Scaffold(
          // appBar: AppBar(
          //   title: Text(data.findById(productId).title),
          // ),
          //how to make an image with appbar animation
          body: CustomScrollView(
            //slivers are scrollable area on screen
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(data.findById(productId).title),
                  background: Hero(
                    tag: productId,
                    child: Image.network(data.findById(productId).imageUrl, fit: BoxFit.cover,)
                  ),
                ),
              ),
              SliverList(delegate: SliverChildListDelegate([
                SizedBox(height: 10,),
                Text(
                  '\$ ${data.findById(productId).price}',
                  style: TextStyle(color: Colors.grey, fontSize: 20,),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,),
                  width: double.infinity,
                  child: Text(data.findById(productId).description, textAlign: TextAlign.center, softWrap: true,),
                ),

                //dummy widget to makes us scroll the screen
                SizedBox(height: 800,)
              ])),
            ],
          ),
        );
      },
    );
  }
}