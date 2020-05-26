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
    }else {
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

  void removeItem(String id){
    _items.remove(id);
    notifyListeners();
  }

  void clearItems(){
    _items = {};
    notifyListeners();
  }
}