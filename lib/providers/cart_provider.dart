//import 'dart:convert';
//import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class Cart {
  final String id;
  final String title;
  final int quantity;
  final double price;

  Cart({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price
  });
}


class CartProvider with ChangeNotifier {

  Map<String, Cart> _items = {};

  Map<String, Cart> get items{
    return _items;
  }

  int get itemsCount{
    return _items.length;
  }

  double get totalAmount{
    var total = 0.0;
    _items.forEach((key, cart) { 
      total += cart.price * cart.quantity;
    }); 

    return total;
  }

  void addItem(String id, String title, double price){
    if (_items.containsKey(id)){
      //change quantity
      _items.update(id, (existingCart) {
        return Cart(
          id: existingCart.id, 
          title: existingCart.title, 
          quantity: existingCart.quantity + 1, 
          price: existingCart.price
        );
      });
    } else {
      _items.putIfAbsent(id, () {
        return Cart(
          id: DateTime.now().toString(), 
          title: title, 
          quantity: 1, 
          price: price,
        );
      });
    }

    notifyListeners();
  }

  /*
   * fitch all products in shopping cart 
   */
  // Future<void> fetchProductsCart() async {
  //   const url = 'https://onlinestoreapp-a44eb.firebaseio.com/cart.json';

  //   try {
  //     final response = await http.get(url);
  //     final extratingData = json.decode(response.body) as Map<String, dynamic>;
  //     Map<String, Cart> loadedData = {};
  //     extratingData.forEach((cartId, cart) {
  //       loadedData = {
  //         cartId: Cart(
  //           id: cart['id'], 
  //           title: cart['title'], 
  //           quantity: cart['quantity'], 
  //           price: cart['price']
  //         ),
  //       };
  //     });
  //     _items = loadedData;
  //     notifyListeners();
  //   } catch(error){
  //     print(error);
  //   }
  // }

  /*
   * add product to cart or update it's quantity if the 
   * product is already exists 
   */
  // Future<void> addProductToCart(String id, String title, double price) async {
  //   final updateUrl = 'https://onlinestoreapp-a44eb.firebaseio.com/cart/$id.json'; //.json added for firebase endpoint only
    
  //   if (_items.containsKey(id)){
  //     try {
  //       final response = await http.patch(updateUrl, 
  //       body: json.encode({
  //         'title': _items[id].title, 
  //         'quantity': _items[id].quantity + 1, 
  //         'price': _items[id].price,
  //       }));

  //       if (response.statusCode == 200){
  //         //change quantity
  //         _items.update(id, (existingCart) {
  //           return Cart(
  //             id: existingCart.id, 
  //             title: existingCart.title, 
  //             quantity: existingCart.quantity + 1, 
  //             price: existingCart.price
  //           );
  //         });
  //       }
        
  //     } catch(error){
  //       print(error);
  //     }
      
  //   }else {
  //     const addUrl = 'https://onlinestoreapp-a44eb.firebaseio.com/cart.json';

  //     try {
  //       final response = await http.post(addUrl, 
  //       body: json.encode({
  //         'title': title, 
  //         'quantity': 1, 
  //         'price': price,
  //       }));

  //       if (response.statusCode == 200){
  //         _items.putIfAbsent(id, () {
  //           return Cart(
  //             id: json.decode(response.body)['name'], 
  //             title: title, 
  //             quantity: 1, 
  //             price: price,
  //           );
  //         });
  //       }
  //     } catch(error){
  //       print(error);
  //     }

  //   }

  //   notifyListeners();
  // }


  void removeItem(String id){
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String productId){
    if (!_items.containsKey(productId)){
      return;
    }
    if (_items[productId].quantity > 1){
      _items.update(productId, (existingCart) {
        return Cart(
          id: existingCart.id, 
          title: existingCart.title, 
          quantity: existingCart.quantity - 1, 
          price: existingCart.price
        );
      });
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void clearItems(){
    _items = {};
    notifyListeners();
  }
}