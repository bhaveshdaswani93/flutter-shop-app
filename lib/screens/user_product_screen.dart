import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product.dart';
import '../widgets/main_drawer.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';
  Future<void> fetchNewData(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetData(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: Text('Your Product'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: fetchNewData(context),
          builder: (_, dataSnap) =>
              dataSnap.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => fetchNewData(context),
                      child: Consumer<Products>(
                        builder: (_, productData, child) => Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemBuilder: (_, i) => Column(
                              children: <Widget>[
                                UserProduct(
                                  productData.items[i].id,
                                  productData.items[i].title,
                                  productData.items[i].imageUrl,
                                ),
                                Divider(),
                              ],
                            ),
                            itemCount: productData.items.length,
                          ),
                        ),
                      ),
                    ),
        ));
  }
}
