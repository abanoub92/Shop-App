import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_page_transition_builder.dart';
import 'package:shop_app/screens/splash_screen.dart';

import './screens/product_overview_screen.dart';
import './screens/auth_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/order_screen.dart';
import './screens/user_product_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_details_screen.dart';

import './providers/auth_provider.dart';
import './providers/order_provider.dart';
import './providers/product_provider.dart';
import './providers/cart_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  /*
   * first way to implement ChangeNotifierProvider
   * ChangeNotifierProvider( create: (context) => //... )
   * 
   * but there is another way to implement ChangeNotifierProvider
   * without create method that gives us context if we don't needed
   * ChangeNotifierProvider.value( value: //... )
   */

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          update: (context, auth, previousProducts) => ProductProvider(
            authToken: auth.token, 
            userId: auth.userId,
            products: previousProducts == null ? [] : previousProducts.items
          ), 
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          update: (ctx, auth, previousOrder) => OrderProvider(
            authToken: auth.token,
            userId: auth.userId,
            orders: previousOrder == null ? [] : previousOrder.items,
          ),
          create: (_) => OrderProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CartProvider(),
        ),
      ],
      child: Consumer<AuthProvider> (
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop App',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            //apply a transition on all page routes in android and ios
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }),
          ),
          home: auth.isAuth 
          ? ProductOverviewScreen() 
          : FutureBuilder(
            future: auth.autoLoginWithStoredData(),
            builder: (ctx, autoResultSnapshot) => 
              autoResultSnapshot.connectionState == ConnectionState.waiting
              ? SplashScreen() : AuthScreen()
          ),
          routes: {
            ProductOverviewScreen.route_name: (_) => ProductOverviewScreen(),
            ProductDetailsScreen.route_name: (_) => ProductDetailsScreen(),
            CartScreen.route_name: (_) => CartScreen(),
            OrderScreen.route_name: (_) => OrderScreen(),
            UserProductScreen.route_name: (_) => UserProductScreen(),
            EditProductScreen.route_name: (_) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}