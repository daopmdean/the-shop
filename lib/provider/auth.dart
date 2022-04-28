import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_shop/model/app_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _timer;

  final url = 'https://identitytoolkit.googleapis.com/v1/accounts';

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signup(String email, String password) async {
    final uri =
        Uri.parse(url + ':signUp?key=AIzaSyArZw8sRnABUeAVuS1RASeMVQrjSJUsqk4');
    final body = json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });
    final res = await http.post(uri, body: body);
    final resData = json.decode(res.body);
    if (res.statusCode >= 400) {
      var errorMessage = resData['error']['message'] as String;
      if (errorMessage.contains('EMAIL_EXISTS')) {
        throw AppException('Email already exist');
      }
      throw AppException('Fail to sign up user');
    }
    _token = resData['idToken'];
    _userId = resData['localId'];
    var expiresIn = resData['expiresIn'] as int;
    _expiryDate = DateTime.now().add(Duration(seconds: expiresIn));
    _autoLogout();

    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final uri = Uri.parse(url +
        ':signInWithPassword?key=AIzaSyArZw8sRnABUeAVuS1RASeMVQrjSJUsqk4');
    final body = json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });
    final res = await http.post(uri, body: body);
    final resData = json.decode(res.body);
    if (res.statusCode >= 400) {
      throw AppException('Fail to login user');
    }

    _token = resData['idToken'];
    _userId = resData['localId'];
    var expiresIn = int.parse(resData['expiresIn']);
    _expiryDate = DateTime.now().add(Duration(seconds: expiresIn));
    _autoLogout();

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'expiryDate': _expiryDate.toIso8601String(),
      'userId': _userId,
    });
    prefs.setString('userData', userData);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final userData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expireDate = DateTime.parse(userData['expiryDate']);
    if (expireDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = userData['token'];
    _userId = userData['userId'];
    _expiryDate = expireDate;

    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    if (_timer != null) {
      _timer.cancel();
    }
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeToExpire), logout);
  }
}
