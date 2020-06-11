import 'dart:convert';
import 'package:http/http.dart' as http;
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

  Future<void> fetchOrders() async {
    const url = 'https://onlinestoreapp-a44eb.firebaseio.com/orders.json';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null){
      return;
    }

    final List<Order> loadedData = [];
    extractedData.forEach((orderId, orderData) {
      loadedData.add(Order(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
        .map((item) => Cart(
          id: item['id'], 
          title: item['title'], 
          quantity: item['quantity'], 
          price: item['price']
         )
        ).toList(),
      ));
    });

    _items = loadedData.reversed.toList(); //reversed.toList() to reverse data and show the new in first item
    notifyListeners();
  }

  /*
   * add order if products they are in shopping cart 
   */
  Future<void> addOrder(List<Cart> products, double amount) async {
    const url = 'https://onlinestoreapp-a44eb.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();
    
    final response = await http.post(url, 
    body: json.encode({
      'amount': amount,
      'dateTime': timeStamp.toIso8601String(),
      'products': products.map((cp) => {
        'id': cp.id,
        'title': cp.title,
        'quantity': cp.quantity,
        'price': cp.price,
      }).toList(),
    }));
    
    _items.insert(0, 
      Order(
        id: json.decode(response.body)['name'],
        amount: amount,
        dateTime: timeStamp,
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