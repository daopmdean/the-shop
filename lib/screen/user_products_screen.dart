import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_shop/provider/products.dart';
import 'package:the_shop/screen/edit_product_screen.dart';
import 'package:the_shop/widget/app_drawer.dart';
import 'package:the_shop/widget/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/userProducts';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _refreshProducts(context),
            child: Consumer<Products>(
              builder: (ctx, products, _) => Padding(
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
            ),
          );
        },
      ),
    );
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }
}
