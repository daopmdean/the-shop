import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_shop/provider/orders.dart';
import 'package:the_shop/widget/app_drawer.dart';
import 'package:the_shop/widget/order_cart.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
    super.initState();
    _ordersFuture = _obtainOrdersFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error occurred'));
          }
          return Consumer<Orders>(
            builder: (ctx, orders, child) => ListView.builder(
              itemCount: orders.countOrders,
              itemBuilder: (ctx, i) => OrderCard(
                order: orders.orders[i],
              ),
            ),
          );
        },
      ),
    );
  }
}
