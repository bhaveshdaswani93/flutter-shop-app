import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _tokenId;
  String _userId;
  DateTime _expireTime;
  Timer _logoutTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expireTime != null &&
        _expireTime.isAfter(DateTime.now()) &&
        _tokenId != null) {
      return _tokenId;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyC1ezkith94RtqEkurrXwNu14d2p1ENnyc';
    final response = await http.post(
      url,
      body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true}),
    );

    final extractedResponse = json.decode(response.body);
    if (extractedResponse['error'] != null) {
      throw HttpException(extractedResponse['error']['message']);
    }
    print(extractedResponse['localId']);
    _tokenId = extractedResponse['idToken'];
    _userId = extractedResponse['localId'];
    _expireTime = DateTime.now().add(
      Duration(
        seconds: int.parse(extractedResponse['expiresIn']),
      ),
    );
    autoLogout();
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    var userData = json.encode({
      '_userId': _userId,
      '_tokenId': _tokenId,
      '_expireTime': _expireTime.toIso8601String()
    });
    pref.setString('userData', userData);
    // print(response.statusCode);
    // print(json.decode(response.body));
  }

  Future<bool> tryAutoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if(!pref.containsKey('userData'))
    {
      return false;
    }
    final userData = json.decode(pref.getString('userData')) as Map<String,Object>;
    // if (userData == null) {
    //   return false;
    // }
    _tokenId = userData['_tokenId'];
    _userId = userData['_userId'];
    _expireTime = DateTime.parse(userData['_expireTime']);
    if(_expireTime.isBefore(DateTime.now()))
    {
      return false;
    }
    autoLogout();
    notifyListeners();
    return true;


    
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
    // final url =
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyC1ezkith94RtqEkurrXwNu14d2p1ENnyc';

    // final response = await http.post(
    //   url,
    //   body: json.encode({
    //     'email':email,
    //     'password':password,
    //     'returnSecureToken':true
    //   }),
    // );
    // print(json.decode(response.body));
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
    // final url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyC1ezkith94RtqEkurrXwNu14d2p1ENnyc';
    //  final response = await http.post(
    //   url,
    //   body: json.encode({
    //     'email':email,
    //     'password':password,
    //     'returnSecureToken':true
    //   }),
    // );
    // print(json.decode(response.body));
  }

  void logout() async {
    _tokenId = null;
    _userId = null;
    _expireTime = null;
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
      _logoutTimer = null;
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    // pref.remove('userData');
    pref.clear();
  }

  void autoLogout() {
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
    }

    var diffInseconds = _expireTime.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: diffInseconds), logout);
  }
}
