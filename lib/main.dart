import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_shop/provider/cart.dart';
import 'package:the_shop/provider/orders.dart';
import 'package:the_shop/provider/products.dart';
import 'package:the_shop/screen/OrdersScreen.dart';
import 'package:the_shop/screen/cart_screen.dart';
import 'package:the_shop/screen/edit_product_screen.dart';
import 'package:the_shop/screen/product_detail_screen.dart';
import 'package:the_shop/screen/products_overview_screen.dart';
import 'package:the_shop/screen/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        ),
      ],
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
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
