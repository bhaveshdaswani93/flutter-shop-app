import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';
import '../screens/user_product_screen.dart';
import '../providers/auth.dart';
import '../helpers/custom_route.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Shop App'),
            automaticallyImplyLeading: false,
          ),
          //  SizedBox(
          //   height: 20,
          // ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
            leading: Icon(
              Icons.shop,
              size: 26,
            ),
            title: Text(
              'Shop',
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              // Navigator.of(context)
              //     .pushReplacementNamed(OrdersScreen.routeName);

              Navigator.of(context).pushReplacement(
                CustomRoute(builder: (ctx) => OrdersScreen()),
              );
              // Navigator.of(context).pushReplacementNamed(FiltersScreen.routeName);
            },
            leading: Icon(
              Icons.payment,
              size: 26,
            ),
            title: Text(
              'Orders',
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
              // Navigator.of(context).pushReplacementNamed(FiltersScreen.routeName);
            },
            leading: Icon(
              Icons.edit,
              size: 26,
            ),
            title: Text(
              'Edit Product',
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();

              // Navigator.of(context).pushReplacementNamed(FiltersScreen.routeName);
            },
            leading: Icon(
              Icons.exit_to_app,
              size: 26,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'RobotoCondensed',
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
