import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your App'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text(
                      '\$${cart.cartTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartItem(
                id: cart.item.values.toList()[i].id,
                title: cart.item.values.toList()[i].title,
                price: cart.item.values.toList()[i].price,
                quantity: cart.item.values.toList()[i].quantity,
                productId: cart.item.keys.toList()[i],
              ),
              itemCount: cart.cartCount,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: _isLoading ? CircularProgressIndicator() :Text(
          'Order Now',
          // style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        onPressed: (widget.cart.item.isEmpty || _isLoading) ?null: () async {
          setState(() {
            _isLoading = true;
          });
          await Provider.of<Orders>(context, listen: false).addOrder(
            widget.cart.item.values.toList(),
            widget.cart.cartTotal,
          );
          setState(() {
            _isLoading = false;
          });
          widget.cart.clear();
        });
  }
}
