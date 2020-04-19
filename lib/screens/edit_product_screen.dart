import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _isInitial = true;
  var isEdit = false;
  var _isLoading = false;
  String editProductId;
  var _product =
      Product(id: null, description: '', imageUrl: '', price: 0, title: '');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageFocusNode.addListener(imageTapHandle);
  }

  imageTapHandle() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _imageFocusNode.removeListener(imageTapHandle);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageController.dispose();
    _imageFocusNode.dispose();
  }

  Future<void> _saveForm() async {
    var isvalid = _form.currentState.validate();
    if (!isvalid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (isEdit) {
      await Provider.of<Products>(context, listen: false)
          .update(editProductId, _product);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false).add(
            imageUrl: _product.imageUrl,
            title: _product.title,
            description: _product.description,
            price: _product.price);
      } catch (e) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Error Occured'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }

    // print(_product.title);
    // print(_product.price);
    // print(_product.imageUrl);
    // print(_product.description);
  }

  void _toEditProduct() {
    editProductId = ModalRoute.of(context).settings.arguments as String;
    if (editProductId == null) {
      return;
    }
    _product =
        Provider.of<Products>(context, listen: false).findById(editProductId);
    _imageController.text = _product.imageUrl;
    isEdit = true;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInitial) {
      _toEditProduct();
    }
    _isInitial = false;
  }

  @override
  Widget build(BuildContext context) {
    // print(_imageController.text);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _product.title,
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Title should not be empty';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _product = _product.copyWith(title: value);
                      },
                    ),
                    TextFormField(
                        initialValue: _product.price.toString(),
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _product =
                              _product.copyWith(price: double.parse(value));
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter valid price';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter valid price';
                          }
                          return null;
                        }),
                    TextFormField(
                      initialValue: _product.description,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      // textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) {
                        _product = _product.copyWith(description: value);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide description';
                        }
                        return null;
                      },
                      // onFieldSubmitted: (_){
                      //   FocusScope.of(context).requestFocus(_priceFocusNode);
                      // },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 8, right: 10),
                          height: 100,
                          width: 100,
                          child: _imageController.text.isEmpty
                              ? Text(
                                  'No Image',
                                  textAlign: TextAlign.center,
                                )
                              : FittedBox(
                                  child: Image.network(
                                    _imageController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageController,
                            focusNode: _imageFocusNode,
                            onFieldSubmitted: (_) {
                              setState(() {});
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please provide image url';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Invalid Image url';
                              }

                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Invalid Image url';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _product = _product.copyWith(imageUrl: value);
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )),
    );
  }
}
