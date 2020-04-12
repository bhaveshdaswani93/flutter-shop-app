import 'package:flutter/material.dart';

class TextControl extends StatelessWidget {
  final Function changeText;
  TextControl(this.changeText);

  @override
  Widget build(BuildContext context) {
    return  RaisedButton(
              onPressed: changeText,
              child: Text('Change me'),
            );
  }
}