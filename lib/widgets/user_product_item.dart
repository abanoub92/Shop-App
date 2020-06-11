import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {

  final String productId;
  final String productImage;
  final String productTitle;

  UserProductItem(this.productId, this.productImage, this.productTitle);

  @override
  Widget build(BuildContext context) {

    final scaffold = Scaffold.of(context);

    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(productImage),),
      title: Text(productTitle),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit, color: Theme.of(context).accentColor), 
              onPressed: (){
                Navigator.of(context).pushNamed(EditProductScreen.route_name, arguments: productId);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Theme.of(context).errorColor), 
              onPressed: () async {
                try {
                  await Provider.of<ProductProvider>(context, listen: false)
                  .deleteProduct(productId);
                } catch (error){
                  scaffold.showSnackBar(SnackBar(content: Text('Delete operation failed.'),));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}