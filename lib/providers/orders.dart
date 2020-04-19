import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class OrderItem {
  final String id;
  final double totalAmount;
  final DateTime dateTime;
  final List<CartItem> products;

  OrderItem({this.dateTime, this.id, this.products, this.totalAmount});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  var _token;
  var _userId;

  Orders(this._token,this._userId,this._orders);


  addOrder(List<CartItem> products, double amount) async {
    final url = 'https://flutter-http-d86e5.firebaseio.com/orders/$_userId.json?auth=$_token';
    final time = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'totalAmount': amount,
        'dateTime': time.toIso8601String(),
        'products': products.map((prod) {
          return {
            'id': prod.id,
            'title': prod.title,
            'price': prod.price,
            'quantity': prod.quantity
          };
        }).toList()
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        dateTime: time,
        products: products,
        totalAmount: amount,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrder() async {
    final url = 'https://flutter-http-d86e5.firebaseio.com/orders/$_userId.json?auth=$_token';
    final response = await http.get(url);
    final extratedData = json.decode(response.body) as Map<String, dynamic>;
    print(extratedData);
    if (!extratedData.isEmpty) {
      List<OrderItem> formatedOrders = [];
      extratedData.forEach((key, order) {
        formatedOrders.add(
          OrderItem(
            id: key,
            dateTime: DateTime.parse(order['dateTime']),
            totalAmount: order['totalAmount'],
            products: (order['products'] as List<dynamic>).map((product){
              return CartItem(
                id: product['id'],
                price: product['price'],
                quantity: product['quantity'],
                title: product['title']
              );
            }).toList()
          ),
        );
      });
      _orders = formatedOrders;
      notifyListeners();
    }
  }
}
