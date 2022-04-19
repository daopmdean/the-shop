import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_shop/provider/products.dart';
import 'package:the_shop/screen/product_detail_screen.dart';
import 'package:the_shop/screen/products_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Products(),
      child: MaterialApp(
        title: 'The Shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}
