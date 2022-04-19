import 'package:flutter/material.dart';
import 'package:the_shop/dummy_data.dart';
import 'package:the_shop/model/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = dummyProducts;

  List<Product> get items {
    return [..._items];
  }

  void addProduct() {
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
