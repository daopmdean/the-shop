import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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
      print(res.body);
      throw AppException('Fail to login user');
    }

    _token = resData['idToken'];
    _userId = resData['localId'];
    print(resData['expiresIn'] is int);
    var expiresIn = int.parse(resData['expiresIn']);
    _expiryDate = DateTime.now().add(Duration(seconds: expiresIn));
    _autoLogout();

    notifyListeners();
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
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
