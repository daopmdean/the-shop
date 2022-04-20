import 'package:flutter/foundation.dart';
import 'package:the_shop/model/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _cart = {};

  Map<String, CartItem> get cartMap {
    return {..._cart};
  }

  List<CartItem> get cartItems {
    return cartMap.values.toList();
  }

  int get countItems {
    return _cart.length;
  }

  double get totalAmount {
    var total = 0.0;
    _cart.forEach((productId, cartItem) {
      total += cartItem.quantity * cartItem.price;
    });

    return total;
  }

  void addItem(String productId, String title, double price) {
    if (_cart.containsKey(productId)) {
      _cart.update(
          productId,
          (existItem) => CartItem(
                id: existItem.id,
                title: existItem.title,
                price: existItem.price,
                quantity: existItem.quantity + 1,
              ));
    } else {
      _cart.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _cart.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_cart.containsKey(productId)) {
      return;
    }
    if (_cart[productId].quantity > 1) {
      _cart.update(
          productId,
          (existItem) => CartItem(
                id: existItem.id,
                title: existItem.title,
                price: existItem.price,
                quantity: existItem.quantity - 1,
              ));
    } else {
      _cart.remove(productId);
    }

    notifyListeners();
  }

  String cartKey(CartItem cartItem) {
    return _cart.keys.firstWhere((key) => _cart[key].id == cartItem.id);
  }

  void clearCart() {
    _cart = {};
    notifyListeners();
  }
}
