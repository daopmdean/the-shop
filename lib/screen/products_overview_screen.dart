import 'package:flutter/material.dart';
import 'package:the_shop/widget/product_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Shop'),
      ),
      body: ProductGrid(),
    );
  }
}
