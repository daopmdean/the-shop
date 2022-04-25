import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_shop/dummy_data.dart';
import 'package:the_shop/model/app_exception.dart';
import 'package:the_shop/model/product.dart';

class Products with ChangeNotifier {
  final uri = Uri.parse(
      'https://the-shop-48986-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');
  List<Product> _items = dummyProducts;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    final res = await http.get(uri);
    final resData = json.decode(res.body) as Map<String, dynamic>;
    final List<Product> loadedProducts = [];
    resData.forEach((prodId, prodData) {
      loadedProducts.add(Product(
        id: prodId,
        title: prodData['title'],
        description: prodData['description'],
        price: prodData['price'],
        imageUrl: prodData['imageUrl'],
        isFavorite: prodData['isFavorite'],
      ));
    });
    _items = loadedProducts;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
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

  Future<void> updateProduct(Product product) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == product.id);
    if (prodIndex >= 0) {
      final uri = Uri.parse(
          'https://the-shop-48986-default-rtdb.asia-southeast1.firebasedatabase.app/products/${product.id}.json');
      final body = json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
      });
      await http.patch(uri, body: body);

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
  }

  void deleteProduct(Product product) {
    final uri = Uri.parse(
        'https://the-shop-48986-default-rtdb.asia-southeast1.firebasedatabase.app/products/${product.id}.json');
    final prodIndex = _items.indexWhere((prod) => prod.id == product.id);
    var prod = _items[prodIndex];

    http.delete(uri).then((res) {
      if (res.statusCode >= 400) {
        throw AppException('Fail to delete product');
      }
      prod = null;
    }).catchError((error) {
      _items.insert(prodIndex, prod);
      notifyListeners();
    });

    _items.removeAt(prodIndex);
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
