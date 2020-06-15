import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

class NavDrawer extends StatelessWidget {

  Widget drawerItem(BuildContext context, IconData icon, String title, Function onClick){
    return ListTile(
      leading: Icon(icon, size: 26, color: Theme.of(context).accentColor,),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Anton',
          fontSize: 20,
        ),
      ),
      onTap: onClick,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 4,
      child: Column(
        children: <Widget>[
          Container(
            height: 180,
            width: double.infinity,
            padding: EdgeInsets.all(16),
            color: Theme.of(context).primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 60,
                  width: 60,
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).accentColor,
                    child: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 5,),
                Text('Username', style: TextStyle(fontSize: 18, color: Colors.white),),
                Text('Username@domin.com', style: TextStyle(fontSize: 18, color: Colors.white),),
              ],
            ),
          ),

          drawerItem(
            context,
            Icons.dashboard, 
            'Dashboard', 
            () => Navigator.of(context).pushReplacementNamed('/'),
          ),

          drawerItem(
            context,
            Icons.credit_card, 
            'Orders', 
            () => Navigator.of(context).pushReplacementNamed(OrderScreen.route_name),
          ),

          drawerItem(
            context,
            Icons.edit, 
            'Manage Products', 
            () => Navigator.of(context).pushReplacementNamed(UserProductScreen.route_name),
          ),

          drawerItem(
            context,
            Icons.exit_to_app, 
            'Logout', 
            () {
              //close drawer before logout 
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}