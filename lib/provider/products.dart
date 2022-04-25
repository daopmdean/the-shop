import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_shop/dummy_data.dart';
import 'package:the_shop/model/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = dummyProducts;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    const url =
        'https://the-shop-48986-default-rtdb.asia-southeast1.firebasedatabase.app/products';
    final uri = Uri.parse(url);
    final body = json.encode({
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'isFavorite': product.isFavorite,
    });

    try {
      final res = await http.post(uri, body: body);
      final newProduct = Product(
        id: json.decode(res.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void updateProduct(Product product) {
    final prodIndex = _items.indexWhere((prod) => prod.id == product.id);
    if (prodIndex >= 0) {
      final newProduct = Product(
        id: product.id,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: _items[prodIndex].isFavorite,
      );
      _items[prodIndex] = newProduct;
    } else {
      print('No product found');
    }
    notifyListeners();
    const url =
        'https://the-shop-48986-default-rtdb.asia-southeast1.firebasedatabase.app/products.json';
    final uri = Uri.parse(url);
    final body = json.encode({
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'isFavorite': product.isFavorite,
    });
    http.post(uri, body: body);
  }

  void deleteProduct(Product product) {
    _items.removeWhere((prod) => prod.id == product.id);
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
