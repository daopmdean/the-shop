import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_shop/provider/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/productDetail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final prod = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(prod.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Hero(
                tag: prod.id,
                child: Image.network(
                  prod.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              '\$${prod.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                prod.description,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
