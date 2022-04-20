import 'package:flutter/material.dart';
import 'package:the_shop/widget/product_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var showFav = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('The Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                if (value == FilterOptions.Favorites) {
                  showFav = true;
                } else if (value == FilterOptions.All) {
                  showFav = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      body: ProductGrid(
        showFav: showFav,
      ),
    );
  }
}
