import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_shop/model/app_exception.dart';
import 'package:the_shop/model/product.dart';

class Products with ChangeNotifier {
  final String token;
  final String userId;
  List<Product> _items = [];
  final url =
      'https://the-shop-48986-default-rtdb.asia-southeast1.firebasedatabase.app';

  Products(this.token, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    Uri uri = Uri.parse('$url/products.json?auth=$token');
    if (filterByUser) {
      uri = Uri.parse(
          '$url/products.json?auth=$token&orderBy="creatorId"&equalTo="$userId"');
    }

    var productsRes = await http.get(uri);
    final productsData = json.decode(productsRes.body) as Map<String, dynamic>;
    if (productsData == null) {
      return;
    }

    uri = Uri.parse('$url/userFavorites/$userId.json?auth=$token');
    var userFavRes = await http.get(uri);
    final userFavData = json.decode(userFavRes.body) as Map<String, dynamic>;

    final List<Product> loadedProducts = [];
    productsData.forEach((prodId, prodData) {
      loadedProducts.add(Product.fromJson(
        prodData,
        id: prodId,
        isFavorite: userFavData == null ? false : userFavData[prodId] ?? false,
      ));
    });
    _items = loadedProducts;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final uri = Uri.parse('$url/products.json?auth=$token');

    final body = json.encode(product.toJson(userId));

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
