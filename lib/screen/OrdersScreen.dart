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
  var _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    Provider.of<Orders>(context, listen: false).fetchOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orders.countOrders,
              itemBuilder: (ctx, i) => OrderCard(
                order: orders.orders[i],
              ),
            ),
    );
  }
}
