import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './adaptive_flat_button.dart';

class TransactionAdd extends StatefulWidget {
  final addTransaction;

  TransactionAdd(this.addTransaction) {
    print('Transaction Add Constructor'); //1
  }

  @override
  _TransactionAddState createState() {
    print('Create State method'); //2
    return _TransactionAddState();
  }
}

class _TransactionAddState extends State<TransactionAdd> {
  final titleController = TextEditingController();

  _TransactionAddState() {
    print('Transaction State Constructor'); //3
  }

  final amountController = TextEditingController();
  DateTime dateSelected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('init State called'); //4
  }

  @override
  void didUpdateWidget(TransactionAdd oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print('Did update called');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('dispose called');
  }

  void submit() {
    var titleInput = titleController.text;
    var amountInput = double.parse(amountController.text);
    if (titleInput.isEmpty || amountInput <= 0 || dateSelected == null) {
      return;
    }
    widget.addTransaction(titleInput, amountInput, dateSelected);
    Navigator.of(context).pop();
  }

  void _showDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((DateTime date) {
      if (date == null) {
        return;
      }
      setState(() {
        dateSelected = date;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build method called.'); //5
    // print(MediaQuery.of(context).viewInsets.bottom);
    return SingleChildScrollView(
      child: Card(
        child: Container(
          margin: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        dateSelected == null
                            ? 'No Date Chosen!'
                            : 'Picked Date: ${DateFormat.yMd().format(dateSelected)}',
                      ),
                    ),
                    AdaptiveFlatButton('Choose Date', _showDate),
                  ],
                ),
              ),

              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
                onSubmitted: (_) => submit,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                onSubmitted: (_) => submit,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              // SizedBox(
              //   height: 20,
              // ),

              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                child: Text('Add Transaction'),
                onPressed: submit,
              )
            ],
          ),
        ),
      ),
    );
  }
}
