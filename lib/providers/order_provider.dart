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

  List<Order> orders = [];

  final authToken;
  final userId;

  OrderProvider({this.authToken, this.userId, this.orders});


  List<Order> get items{
    return orders;
  }

  Future<void> fetchOrders() async {
    final url = 'https://onlinestoreapp-a44eb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null){
      return;
    }

    List<Order> loadedData = [];
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

    orders = loadedData.reversed.toList(); //reversed.toList() to reverse data and show the new in first item
    notifyListeners();
  }

  /*
   * add order if products they are in shopping cart 
   */
  Future<void> addOrder(List<Cart> products, double amount) async {
    final url = 'https://onlinestoreapp-a44eb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    
    try {
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
      
      final order = Order(
        id: json.decode(response.body)['name'],
        amount: amount,
        dateTime: timeStamp,
        products: products,
      );

      orders.add(order);
      notifyListeners();
    } catch(error){
      print(error);
    }
  }

  void removeItem(productId){
    orders.remove(productId);
    notifyListeners();
  }

  void clearItems(){
    orders = [];
    notifyListeners();
  }

}