import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './screens/splash_screen.dart';
import './helpers/custom_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        child: Consumer<Auth>(
          builder: (ctx, authData, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.orange,
                fontFamily: 'Lato',
                // pageTransitionsTheme: PageTransitionsTheme(builders: {
                //   TargetPlatform.android: CustomPageTransitionBuilder(),
                //   TargetPlatform.iOS: CustomPageTransitionBuilder()
                // })
                ),
            // home: ProductsOverViewScreen(),
            home: authData.isAuth
                ? ProductsOverViewScreen()
                : FutureBuilder(
                    future: authData.tryAutoLogin(),
                    builder: (_, dataSnap) =>
                        dataSnap.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ),
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products(null, null, []),
            update: (_, auth, previousProducts) =>
                Products(auth.token, auth.userId, previousProducts.items),
          ),
          // ChangeNotifierProvider.value(
          //   value: Products(),
          // ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders(null, null, []),
            update: (_, auth, previousOrder) =>
                Orders(auth.token, auth.userId, previousOrder.orders),
          ),
          // ChangeNotifierProvider.value(
          //   value: Orders(),
          // )
        ]);
  }
}
