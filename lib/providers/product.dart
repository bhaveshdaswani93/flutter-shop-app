import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

// import '../models/';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.imageUrl,
      @required this.description,
      this.isFavourite = false,
      @required this.price});

  toggleFav(String token,String userId) async {
    var oldIsfav = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        'https://flutter-http-d86e5.firebaseio.com/userFav/$userId/$id.json?auth=$token';
    final res = await http.put(
      url,
      body: json.encode(isFavourite),
    );
    if (res.statusCode > 400) {
      isFavourite = oldIsfav;
      notifyListeners();
      throw HttpException('Something went wrong.');
    }
  }

  Product copyWith({
    String id,
    String title,
    String description,
    double price,
    String imageUrl,
    bool isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavourite: isFavorite ?? this.isFavourite,
    );
  }
}
