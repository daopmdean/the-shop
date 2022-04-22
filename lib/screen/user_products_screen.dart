import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_shop/provider/products.dart';
import 'package:the_shop/widget/app_drawer.dart';
import 'package:the_shop/widget/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/userProducts';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.items.length,
          itemBuilder: (ctx, i) => Column(
            children: [
              UserProductItem(
                prod: products.items[i],
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
