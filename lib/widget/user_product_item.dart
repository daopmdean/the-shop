import 'package:flutter/material.dart';
import 'package:the_shop/model/product.dart';
import 'package:the_shop/screen/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final Product prod;

  const UserProductItem({
    Key key,
    this.prod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(prod.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(prod.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: prod.id,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
