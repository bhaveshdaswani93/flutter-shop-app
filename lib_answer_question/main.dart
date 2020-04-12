import 'package:flutter/material.dart';

import './quiz.dart';
import './result.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var totalScore = 0;
  _answerQuestion(int score) {
    totalScore += score;
    setState(() {
      questionIndex = questionIndex + 1;
    });
    if (questionIndex < _questions.length) {
      print(questionIndex);
      print('yes we have more data');
    }
    // print(_questions[questionIndex]);
    print(questionIndex);
    print('hello ');
  }
  
  _resetScore () {
    setState(() {
      questionIndex = 0;
      totalScore = 0;
    });
  }

  final _questions = const [
    {
      'question': 'What is your name?',
      'answers': [
        {'text': 'max', 'score': 10},
        {'text': 'menu', 'score': 5},
        {'text': 'lorem', 'score': 3},
        {'text': 'ipsum', 'score': 1}
      ]
    },
    {
      'question': 'What is your fav language',
      'answers': [
        {'text': 'flutter', 'score': 10},
        {'text': 'go', 'score': 5},
        {'text': 'node', 'score': 3},
        {'text': 'laravel', 'score': 1}
      ]
    },
    {
      'question': 'Who is your fav instructor',
      'answers': [
        {'text': 'bhavesh', 'score': 1},
        {'text': 'bhavesh', 'score': 1},
        {'text': 'bhavesh', 'score': 1},
        {'text': 'bhavesh', 'score': 1}
      ]
    }
  ];

  var questionIndex = 0;

  Widget build(BuildContext context) {
    // questions.add({
    //   'question': 'What is your  elephant name?',
    //     'answers': ['max', 'menu', 'lorem', 'ipsum']
    // });
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My First App'),
        ),
        body: questionIndex < _questions.length
            ? Quiz(
                answerQuestion: _answerQuestion,
                questionIndex: questionIndex,
                questions: _questions,
              )
            : Result(this.totalScore,_resetScore),
      ),
    );
  }
}
