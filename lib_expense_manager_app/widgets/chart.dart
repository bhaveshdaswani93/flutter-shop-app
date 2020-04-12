import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  Chart(this.recentTransaction);

  List<Map<String, Object>>  get generateChartData {
    final List<Map<String, Object>> chartData = List.generate(7, (index) {
      final week = DateTime.now().subtract(Duration(days: index));
      var amount = 0.0;

      for (var i = 0; i < recentTransaction.length; i++) {
        if(week.day == recentTransaction[i].date.day && 
        week.month == recentTransaction[i].date.month &&
        week.year == recentTransaction[i].date.year
        ) {
          amount += recentTransaction[i].amount;
        }
      }

      return {'weekDay': DateFormat.E().format(week).substring(0,1), 'amount': amount};
    }).reversed.toList();
    return chartData;
  }
  double get totalTransactionAmt {
    return recentTransaction.fold(0.0, (sum,item){
      return sum + item.amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    // print(totalTransactionAmt);
    return Card(
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: generateChartData.map((data){
            // print(data);
            return Flexible(fit: FlexFit.tight,child: ChartBar(data['weekDay'],data['amount'],totalTransactionAmt == 0.0 ? 0.0:( data['amount'] as double)/totalTransactionAmt));
          }).toList(),
        ),
      ),
    );
  }
}
