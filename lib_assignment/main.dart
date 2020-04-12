import 'package:flutter/material.dart';

import './textcontrol.dart';
import './textshow.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  var textToshow = 'hello world';
  changeText() {
    setState(() {
      textToshow = '123';
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hello World'),
        ),
        body: Column(
          children: <Widget>[
            TextShow(textToshow),
            TextControl(changeText),
          ],
        ),
      ),
    );
  }
}
