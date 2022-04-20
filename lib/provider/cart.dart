import 'package:flutter/foundation.dart';
import 'package:the_shop/model/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _cart;

  Map<String, CartItem> get cart {
    return {..._cart};
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
  }
}
