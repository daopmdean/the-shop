import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_shop/model/app_exception.dart';
import 'package:the_shop/model/product.dart';

class Products with ChangeNotifier {
  final String token;
  List<Product> _items = [];
  final url =
      'https://the-shop-48986-default-rtdb.asia-southeast1.firebasedatabase.app';

  Products(this.token, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    final uri = Uri.parse('$url/products.json?auth=$token');

    final res = await http.get(uri);
    final resData = json.decode(res.body) as Map<String, dynamic>;
    if (resData == null) {
      return;
    }
    final List<Product> loadedProducts = [];
    resData.forEach((prodId, prodData) {
      loadedProducts.add(Product.fromJson(prodData, prodId));
    });
    _items = loadedProducts;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final uri = Uri.parse('$url/products.json?auth=$token');

    final body = json.encode(product.toJson());

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
      final uri = Uri.parse('$url/products/${product.id}.json?auth=$token');
      final body = json.encode(product.toJsonWithoutFav());
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
      throw AppException('No product found');
    }
    notifyListeners();
  }

  void deleteProduct(Product product) {
    final uri = Uri.parse('$url/products/${product.id}.json?auth=$token');
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
