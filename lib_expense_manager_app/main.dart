import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/transaction_add.dart';

import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

// import './transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Expense Manager',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Quicksand',
        accentColor: Colors.yellow,
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    print(state);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }


  final List<Transaction> transactions = [
    // Transaction(
    //     amount: 23, date: DateTime.now(), title: 'New Cloth', id: 's43t6'),
    // Transaction(
    //     amount: 13.65, date: DateTime.now(), title: 'Purse', id: 's93t7'),
  ];

  _addTransaction(String txTitle, double txAmount, DateTime selectedDate) {
    final newTransaction = Transaction(
      title: txTitle,
      amount: txAmount,
      id: DateTime.now().toString(),
      date: selectedDate,
    );
    setState(() {
      transactions.add(newTransaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      transactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  


  void _startAddNewTransaction(BuildContext ctx) {
    //  showModalBottomSheet(
    // shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
    // backgroundColor: Colors.black,
    // context: context,
    // isScrollControlled: true,
    // builder: (context) => Padding(
    //   padding: const EdgeInsets.symmetric(horizontal:18 ),
    //   child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         mainAxisSize: MainAxisSize.min,
    //         children: <Widget>[
    //           Padding(
    //             padding: const EdgeInsets.symmetric(horizontal: 12.0),
    //             child: TransactionAdd(_addTransaction),
    //           ),
    //           SizedBox(
    //             height: 8.0,
    //           ),
    //           // Padding(
    //           //   padding: EdgeInsets.only(
    //           //       bottom: MediaQuery.of(context).viewInsets.bottom),
    //           //   child: TextField(
    //           //     decoration: InputDecoration(
    //           //       hintText: 'adddrss'
    //           //     ),
    //           //     autofocus: true,
    //           //     controller: _newMediaLinkAddressController,
    //           //   ),
    //           // ),

    //           SizedBox(height: 10),
    //         ],
    //       ),
    // ));

    showModalBottomSheet(
        isScrollControlled: true,
        context: ctx,
        builder: (_) {
          return FractionallySizedBox(
            heightFactor:
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? 0.8
                    : 0.8,
            child: TransactionAdd(_addTransaction),
          );
        });
  }

  List<Transaction> get recentransaction {
    return transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  List<Widget> _getPortraitContent(MediaQueryData mediaQuery,PreferredSizeWidget _appBar,Widget txList) {
    return [Container(
                height: (mediaQuery.size.height -
                        _appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(recentransaction),
              ),
              txList];
  }

  List<Widget> _getLandscapeContent(MediaQueryData mediaQuery,PreferredSizeWidget _appBar,txList) {
      return  [Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('To Show Chart',style: Theme.of(context).textTheme.title,),
                  Switch.adaptive(
                    activeColor: Theme.of(context).accentColor,
                    value: _toShowChart,
                    onChanged: (bool val) {
                      setState(() {
                        _toShowChart = val;
                      });
                    },
                  ),
                ],
              ),_toShowChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              _appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(recentransaction),
                    )
                  : txList,];
  }

  Widget _appBarIos() {
    return CupertinoNavigationBar(
            middle: Text(
              'Expense Manager',
            ),
            trailing: GestureDetector(
              child: Icon(CupertinoIcons.add),
              onTap: () => _startAddNewTransaction(context),
            ),
          );
  }

  Widget _appBarAndroid() {
    return AppBar(
            title: Text(
              'Expense Manager',
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.add,
                ),
                onPressed: () => _startAddNewTransaction(context),
              )
            ],
          );
  }



  var _toShowChart = false;
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final _showLandscape = mediaQuery.orientation == Orientation.landscape;

    // print(_toShowChart);
    PreferredSizeWidget _appBar = Platform.isIOS
        ? _appBarIos()
        : _appBarAndroid();
    final txList = Container(
      height: (mediaQuery.size.height -
              _appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      width: double.infinity,
      child: TransactionList(transactions, _deleteTransaction),
    );
    var _body = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (_showLandscape)
            ..._getLandscapeContent(mediaQuery,_appBar,txList),
            
              
            if (!_showLandscape)
            ..._getPortraitContent(mediaQuery,_appBar,txList),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: _body,
            navigationBar: _appBar,
          )
        : Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
            appBar: _appBar,
            body: _body,
          );
  }
}
