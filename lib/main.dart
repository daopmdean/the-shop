import 'package:flutter/material.dart';
import 'package:the_shop/screen/products_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductsOverviewScreen(),
    );
  }
}
