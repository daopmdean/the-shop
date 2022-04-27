import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:the_shop/model/app_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  final url = 'https://identitytoolkit.googleapis.com/v1/accounts';

  Future<void> signup(String email, String password) async {
    final uri =
        Uri.parse(url + ':signUp?key=AIzaSyArZw8sRnABUeAVuS1RASeMVQrjSJUsqk4');
    final body = json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });
    final res = await http.post(uri, body: body);
    if (res.statusCode >= 400) {
      print(res.body);
      throw AppException('Fail to sign up user');
    }

    print(res.body);
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
    if (res.statusCode >= 400) {
      print(res.body);
      throw AppException('Fail to login user');
    }

    print(res.body);
  }
}
