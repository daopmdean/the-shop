import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_shop/provider/orders.dart';
import 'package:the_shop/widget/app_drawer.dart';
import 'package:the_shop/widget/order_cart.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orders.countOrders,
        itemBuilder: (ctx, i) => OrderCard(
          order: orders.orders[i],
        ),
      ),
    );
  }
}
