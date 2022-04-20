import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_shop/provider/products.dart';
import 'package:the_shop/widget/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFav;

  const ProductGrid({
    Key key,
    this.showFav,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final products =
        showFav ? productsProvider.favoriteItems : productsProvider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
