import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {

  final String productImage;
  final String productTitle;

  UserProductItem(this.productImage, this.productTitle);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(productImage),),
      title: Text(productTitle),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit, color: Theme.of(context).accentColor), 
              onPressed: (){},
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Theme.of(context).errorColor), 
              onPressed: (){},
            ),
          ],
        ),
      ),
    );
  }
}