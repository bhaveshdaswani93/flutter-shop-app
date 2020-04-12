import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final Function answerQuestion;
  final String answerText;

  Answer(this.answerQuestion,this.answerText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      
      child:  RaisedButton(
              child: Text(answerText),
              onPressed: answerQuestion,
              color: Colors.blue,
            ),
    );
  }
}