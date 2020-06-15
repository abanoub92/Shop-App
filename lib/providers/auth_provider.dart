import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier {

  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _timerLogout;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null){
      return _token;
    }

    return null;
  }

  String get userId{
    if (_userId != null){
      return _userId;
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

      _autoLogout();
      notifyListeners();

      final pref = await SharedPreferences.getInstance();
      //store data as json if we have a huge data to store
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryData': _expiryDate.toIso8601String(),
      });
      pref.setString('userData', userData);

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

  /*
   * keep it login
   * still login will the data in saved in
   * shared preferences
   */
  Future<bool> autoLoginWithStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')){
      return false;
    }

    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiredDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiredDate.isBefore(DateTime.now())){
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiredDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_timerLogout != null){
      _timerLogout.cancel();
      _timerLogout = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // use remove if multi data parts
    //prefs.remove('userData');
    prefs.clear(); //clear to clear all data stored
  }

  void _autoLogout(){
    if (_timerLogout != null){
      _timerLogout.cancel();
    }

    final timeDiff = _expiryDate.difference(DateTime.now()).inSeconds;
    _timerLogout = Timer(Duration(seconds: timeDiff), logout);
  }
}