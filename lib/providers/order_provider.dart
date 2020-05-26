import 'package:flutter/foundation.dart';
import './cart_provider.dart' show Cart;

class Order {

  final String id;
  final double amount;
  final List<Cart> products;
  final DateTime dateTime; 

  Order({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime
  });

}

class OrderProvider with ChangeNotifier{

  List<Order> _items = [];

  List<Order> get items{
    return _items;
  }

  void addItem(List<Cart> products, double amount){
    _items.insert(0, 
      Order(
        id: DateTime.now().toString(),
        amount: amount,
        dateTime: DateTime.now(),
        products: products,
      )
    );

    notifyListeners();
  }

  void removeItem(productId){
    _items.remove(productId);
    notifyListeners();
  }

  void clearItems(){
    _items = [];
    notifyListeners();
  }

}