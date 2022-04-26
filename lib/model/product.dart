import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:the_shop/model/app_exception.dart';

class Product with ChangeNotifier {
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
    this.isFavorite = false,
  });

  Future<void> toggleFavorite() async {
    final uri = Uri.parse(
        'https://the-shop-48986-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');
    final body = json.encode({
      'isFavorite': !isFavorite,
    });

    try {
      final res = await http.patch(uri, body: body);
      if (res.statusCode >= 400) {
        throw AppException('Fail to update product favorite status');
      }
      isFavorite = !isFavorite;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
