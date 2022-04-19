import 'package:flutter/material.dart';
import 'package:the_shop/dummy_data.dart';
import 'package:the_shop/model/product.dart';
import 'package:the_shop/widget/product_item.dart';

class ProductsOverviewScreen extends StatelessWidget {
  final List<Product> products = dummyProducts;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Shop'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        itemBuilder: (ctx, i) => ProductItem(
          id: products[i].id,
          title: products[i].title,
          description: products[i].description,
          imageUrl: products[i].imageUrl,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
