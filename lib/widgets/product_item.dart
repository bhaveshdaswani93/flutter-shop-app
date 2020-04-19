import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../screens/product_detail_screen.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return GridTile(
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Hero(
            tag: product.id,
                      child: FadeInImage(
              placeholder: AssetImage('assets/images/placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          )),
      footer: GridTileBar(
        backgroundColor: Colors.black87,
        title: Text(
          product.title,
          textAlign: TextAlign.center,
        ),
        leading: Consumer<Product>(
          builder: (ctx, product, child) => IconButton(
            icon: product.isFavourite
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_border),
            color: Theme.of(context).accentColor,
            onPressed: () async {
              try {
                await product.toggleFav(Provider.of<Auth>(context).token,
                    Provider.of<Auth>(context).userId);
              } catch (e) {
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                  ),
                );
              }
            },
          ),
          child: Text('1234'),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.shopping_cart,
            color: Theme.of(context).accentColor,
          ),
          onPressed: () {
            cart.addToCart(product.id, product.title, product.price);
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 2),
                content: Text('Product added to cart.'),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
