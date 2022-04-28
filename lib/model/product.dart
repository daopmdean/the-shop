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

  Product.fromJson(Map<String, dynamic> json, {this.id, this.isFavorite})
      : title = json['title'],
        description = json['description'],
        price = json['price'],
        imageUrl = json['imageUrl'];

  Map<String, dynamic> toJson(String userId) => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'isFavorite': isFavorite,
        'creatorId': userId,
      };

  Map<String, dynamic> toJsonWithoutFav() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
      };

  Future<void> toggleFavorite(String token, String userId) async {
    final uri = Uri.parse(
        'https://the-shop-48986-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token');
    final body = json.encode(!isFavorite);

    try {
      final res = await http.put(uri, body: body);
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
