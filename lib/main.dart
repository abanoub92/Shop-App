import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/product_provider.dart';
import './screens/product_details_screen.dart';
import './screens/product_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  /**
   * first way to implement ChangeNotifierProvider
   * ChangeNotifierProvider( create: (context) => //... )
   * 
   * but there is another way to implement ChangeNotifierProvider
   * without create method that gives us context if we don't needed
   * ChangeNotifierProvider.value( value: //... )
   */

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ProductProvider(),
      child: MaterialApp(
        title: 'Shop App',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato'
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailsScreen.route_name: (context) => ProductDetailsScreen(),
        },
      ),
    );
  }
}