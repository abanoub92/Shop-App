import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false
  });

  void setFavoriteValue(bool newValue){
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> isRealyFavorite() async {
    final oldValue = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    
    try{
      final url = 'https://onlinestoreapp-a44eb.firebaseio.com/products/$id.json';
      final response = await http.patch(url, body: json.encode({
        'isFavorite': isFavorite,
      }));   

      if (response.statusCode == 200){
        print('product become a favorite.');
      }else if (response.statusCode >= 400){
        setFavoriteValue(oldValue);
      }
    } catch(error){
      setFavoriteValue(oldValue);
    }
  }
}