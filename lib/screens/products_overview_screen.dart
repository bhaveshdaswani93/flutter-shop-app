import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_grid.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import './cart_screen.dart';
import '../widgets/main_drawer.dart';
import '../providers/products.dart';

enum FilterOption { Favourites, All }

class ProductsOverViewScreen extends StatefulWidget {
  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  bool showFav = false;
  bool isInit = true;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    // Provider.of<Products>(context).fetchAndSetData();
    // Future.delayed(Duration.zero).then((_){
    //   Provider.of<Products>(context).fetchAndSetData();
    //   print('init called');
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetData().then((_) {
        setState(() {
          isLoading = false;
        });
      });
      // print('did change called');
    }
    isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    // print('build called');
    final productData = Provider.of<Products>(context, listen: false);
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: Text('Shop App'),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (FilterOption selectedValue) {
                setState(() {
                  if (selectedValue == FilterOption.All) {
                    showFav = false;
                  } else {
                    showFav = true;
                  }
                });
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Only Favourite'),
                  value: FilterOption.Favourites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOption.All,
                ),
              ],
              icon: Icon(Icons.more_vert),
            ),
            Consumer<Cart>(
              builder: (_, cart, child) {
                return Badge(
                  child: child,
                  value: cart.cartCount.toString(),
                );
              },
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            )
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductGrid(showFav));
  }
}
