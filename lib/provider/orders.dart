import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:the_shop/model/app_exception.dart';
import 'package:the_shop/model/cart_item.dart';
import 'package:the_shop/model/order_item.dart';

class Orders with ChangeNotifier {
  final String token;
  final String userId;
  List<OrderItem> _orders = [];
  final url =
      'https://the-shop-48986-default-rtdb.asia-southeast1.firebasedatabase.app';

  Orders(this.token, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  int get countOrders {
    return _orders.length;
  }

  Future<void> fetchOrders() async {
    final uri = Uri.parse(url + '/orders/$userId.json?auth=$token');
    final res = await http.get(uri);
    if (res.statusCode >= 400) {
      throw AppException('Fail to get orders');
    }

    List<OrderItem> resOrders = [];
    final resData = json.decode(res.body) as Map<String, dynamic>;
    if (resData == null) {
      return;
    }

    resData.forEach((key, order) {
      List<CartItem> cartItems = (order['cartItems'] as List)
          .map((cartItem) => CartItem(
              id: cartItem['id'],
              title: cartItem['title'],
              price: cartItem['price'],
              quantity: cartItem['quantity']))
          .toList();

      resOrders.add(OrderItem(
        id: key,
        amount: order['amount'],
        cartItems: cartItems,
        dateTime: DateTime.parse(order['dateTime']),
      ));
    });

    _orders = resOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(double total, List<CartItem> cartItems) async {
    final uri = Uri.parse(url + '/orders/$userId.json?auth=$token');
    final timeNow = DateTime.now();
    final body = json.encode({
      'cartItems': cartItems
          .map((e) => {
                'id': e.id,
                'title': e.title,
                'price': e.price,
                'quantity': e.quantity,
              })
          .toList(),
      'amount': total,
      'dateTime': timeNow.toIso8601String(),
    });
    final res = await http.post(uri, body: body);

    if (res.statusCode >= 400) {
      throw AppException('Fail to create order');
    }

    OrderItem orderItem = OrderItem(
      id: json.decode(res.body)['name'],
      amount: total,
      cartItems: cartItems,
      dateTime: timeNow,
    );

    _orders.insert(0, orderItem);
    notifyListeners();
  }
}
