import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {

  String _token;
  DateTime _expiryDate;
  String userId;


  /*
   * Sign up user by user email and password
   * with firebase restful API 
   */
  Future<void> signUp(String email, String password) async {
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyB7NjGjpmhjFPnxSlUnMnKxACQYw2R0Epc';

    try {
      final response = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }));

      if (response.statusCode == 200){
        print(response.body);
      }
    } catch(error){
      print(error);
    }
  }
}