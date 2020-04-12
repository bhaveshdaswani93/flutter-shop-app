import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String buttonText;
  final Function handler;

  AdaptiveFlatButton(this.buttonText,this.handler);

  @override
  Widget build(BuildContext context) {
    return  Platform.isIOS? CupertinoButton(
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: handler,) :FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: handler,
                    );
  }
}