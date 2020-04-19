import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  var _showFav = false;
  var _authToken;
  var _userId;

  Products(this._authToken,this._userId,this._items){
    print(this._authToken);
    print(this._userId);
  }

  List<Product> get items {
    if (_showFav) {
      return _items.where((item) {
        return item.isFavourite;
      }).toList();
    }
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((item) {
      return item.isFavourite;
    }).toList();
  }

  Future<void> add({
    @required String imageUrl,
    @required String title,
    @required String description,
    @required double price,
  }) async {
    final url = 'https://flutter-http-d86e5.firebaseio.com/products.json?auth=$_authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': title,
          'description': description,
          'imageUrl': imageUrl,
          'price': price,
          'creatorId':_userId
          // 'isFavourite': false
        }),
      );
      final newProdcuct = Product(
          id: json.decode(response.body)['name'],
          title: title,
          description: description,
          price: price,
          imageUrl: imageUrl);
      _items.add(newProdcuct);
      notifyListeners();
    } catch (e) {
      throw e;
    }

    //     .then((res) {

    // }).catchError((error){
    //   print(error);
    //   throw error;
    // });
  }

  Product findById(String id) {
    return items.firstWhere((product) => product.id == id);
  }

  Future<void> update(String id, Product product) async {
    // print(id);
    final url = 'https://flutter-http-d86e5.firebaseio.com/products/$id.json?auth=$_authToken';
    await http.patch(url,
        body: json.encode({
          'description': product.description,
          'title': product.title,
          'price': product.price,
          'imageUrl': product.imageUrl
        }));

    final index = _items.indexWhere((prod) => prod.id == id);
    // print(index);
    _items[index] = product;
    notifyListeners();
  }

  Future<void> delete(String id) async {
    // optimistic updating
    final toDeleteItemIndex = _items.indexWhere((product) => product.id == id);
    var toDeleteItem = _items[toDeleteItemIndex];
    _items.removeAt(toDeleteItemIndex);
    notifyListeners();
    final url = 'https://flutter-http-d86e5.firebaseio.com/products/$id.json?auth=$_authToken';
    final res = await http.delete(url);
    print(res.statusCode);
    if (res.statusCode >= 400) {
      _items.insert(toDeleteItemIndex, toDeleteItem);
      notifyListeners();
      throw HttpException('Failed to delete the product');
    }
    toDeleteItem = null;

    // _items.removeWhere((prod) => prod.id == id);
    // notifyListeners();
  }

  Future<void> fetchAndSetData([authOnly=false]) async {
    print(_userId);
    var query = authOnly == true ? 'orderBy="creatorId"&equalTo="$_userId"'  : '';
    var url = 'https://flutter-http-d86e5.firebaseio.com/products.json?auth=$_authToken&$query';
    print(query);
    try {
      final respone = await http.get(url);
      final extractedProduct =
          json.decode(respone.body) as Map<String, dynamic>;
      List<Product> loadedProducts = [];
      if(extractedProduct.isEmpty) {
         _items = [];
        notifyListeners();
        return;
      }
      print(extractedProduct);
      url = 'https://flutter-http-d86e5.firebaseio.com/userFav/$_userId.json?auth=$_authToken';
      var favResponse = await http.get(url);
      var extractFavRes = json.decode(favResponse.body);
      extractedProduct.forEach((key, value) {
        loadedProducts.add(Product(
          id: key,
          description: value['description'],
          imageUrl: value['imageUrl'],
          price: value['price'],
          title: value['title'],
          isFavourite: extractFavRes == null?false : extractFavRes[key] ?? false,
        ));
        _items = loadedProducts;
        notifyListeners();
      });
      // print(json.decode(respone.body));
    } catch (e) {
      throw e;
    }
  }

  // showFav() {
  //   _showFav = true;
  //   notifyListeners();
  // }

  // showAll() {
  //   _showFav = false;
  //   notifyListeners();
  // }
}
