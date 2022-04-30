import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_shop/helper/custom_page_transition_builder.dart';
import 'package:the_shop/provider/auth.dart';
import 'package:the_shop/provider/cart.dart';
import 'package:the_shop/provider/orders.dart';
import 'package:the_shop/provider/products.dart';
import 'package:the_shop/screen/OrdersScreen.dart';
import 'package:the_shop/screen/auth_screen.dart';
import 'package:the_shop/screen/cart_screen.dart';
import 'package:the_shop/screen/edit_product_screen.dart';
import 'package:the_shop/screen/product_detail_screen.dart';
import 'package:the_shop/screen/products_overview_screen.dart';
import 'package:the_shop/screen/splash_screen.dart';
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
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, previous) => Products(
            auth.token,
            auth.userId,
            previous == null ? [] : previous.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, previous) => Orders(
            auth.token,
            auth.userId,
            previous == null ? [] : previous.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'The Shop',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              })),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SplashScreen();
                    }
                    return AuthScreen();
                  },
                ),
          routes: {
            AuthScreen.routeName: (ctx) => AuthScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
