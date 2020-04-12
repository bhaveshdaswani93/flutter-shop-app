import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int totalScore;
  final Function resetScore;

  Result(this.totalScore, this.resetScore);
  String get textPhrase {
    String text;
    if (totalScore < 8) {
      text = 'you are awesome';
    } else if (totalScore < 12) {
      text = 'you are good';
    } else if (totalScore < 16) {
      text = 'you are little bit ok';
    } else {
      text = 'you are bad. which need to be learn.';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    print(totalScore);
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            textPhrase,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          FlatButton(
            child: Text(
              'Reset',
             
            ),
            onPressed: resetScore,
            textColor: Colors.blue,
          )
        ],
      ),
    );
  }
}
