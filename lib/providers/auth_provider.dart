import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class AuthProvider with ChangeNotifier {

  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null){
      return _token;
    }

    return null;
  }


  Future<void> _authentication(String email, String password, String urlSegment) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyB7NjGjpmhjFPnxSlUnMnKxACQYw2R0Epc';

    try {
      final response = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }));

      final responseData = json.decode(response.body);
      if (response.statusCode == 200){
        _token = responseData['idToken'];
        _userId = responseData['localId'];
        _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      }else if (responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }

      notifyListeners();

    } catch(error){
      throw error;
    }
  }

  /*
   * Sign up user by user email and password
   * with firebase restful API
   */
  Future<void> signUp(String email, String password) async {
    return _authentication(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authentication(email, password, 'signInWithPassword');
  }
}