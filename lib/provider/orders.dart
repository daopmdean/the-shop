import 'package:flutter/foundation.dart';
import 'package:the_shop/model/cart_item.dart';
import 'package:the_shop/model/order_item.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(double total, List<CartItem> cartItems) {
    OrderItem orderItem = OrderItem(
      id: DateTime.now().toString(),
      amount: total,
      cartItems: cartItems,
      dateTime: DateTime.now(),
    );

    _orders.insert(0, orderItem);
    notifyListeners();
  }
}
