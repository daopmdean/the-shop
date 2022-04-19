import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static final routeName = '/productDetail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('product title'),
      ),
      body: Container(
        child: Text('body'),
      ),
    );
  }
}
