import 'package:flutter/material.dart';

class TextShow extends StatelessWidget {
  final String textToshow;

  TextShow(this.textToshow);

  @override
  Widget build(BuildContext context) {
    return Text(textToshow);
  }
}
