import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:expense_planner/Widgets/chart.dart';
import 'package:expense_planner/Widgets/expenses_list.dart';
import 'package:expense_planner/Widgets/new_expense.dart';
import './Models/transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Personal Expenses",
      theme: ThemeData(
        primaryColor:
            Platform.isIOS ? Colors.deepPurpleAccent : Color(0xFFfeeae6),
        accentColor: Colors.brown[600],
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'Exo2',
                fontSize: 24,
              ),
            ),
        fontFamily: 'Exo2',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];
  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;

    // store appBar in var to use because var have info about the height
    final PreferredSizeWidget appBar =
        Platform.isIOS ? _builderIOSNavigationBar() : _builderAppBar();

    final expanseList = Padding(
      padding: const EdgeInsets.only(left: 7, right: 8),
      child: Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.75,
        child: ExpensesList(_userTransactions, removeExpense),
      ),
    );

    final pagebody = SafeArea(
      child: SingleChildScrollView(
        // to prevent yellow box in keybord
        child: Column(
          children: <Widget>[
            if (!isLandScape)
              ..._builderPortraitContent(mediaQuery, appBar, expanseList),
            if (isLandScape)
              ..._builderLandscapeContent(mediaQuery, appBar, expanseList),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pagebody,
          )
        : Scaffold(
            appBar: appBar,
            body: pagebody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    backgroundColor: Theme.of(context).accentColor,
                    child: Icon(
                      Icons.add,
                    ),
                    onPressed: () => _startAddingNewExpense(context),
                  ),
          );
  }

  Widget _builderAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFE8CBC0),
              Color(0xFF636FA4),
              // Color(0xFFec38bc),
              // Color(0xFFfdeff9)
            ],
          ),
        ),
      ),
      centerTitle: true,
      title: Text("Expense Planner"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddingNewExpense(context),
        )
      ],
    );
  }

  Widget _builderIOSNavigationBar() {
    return CupertinoNavigationBar(
      middle: Text("Personal Expenses"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap: () => _startAddingNewExpense(context),
          ),
        ],
      ),
    );
  }

  List<Widget> _builderLandscapeContent(
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget expanseList,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Show Chart",
            style: Theme.of(context).textTheme.title,
          ),
          Switch.adaptive(
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              })
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransactions),
            )
          : expanseList,
    ];
  }

  List<Widget> _builderPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget expanseList) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.25,
        child: Chart(_recentTransactions),
      ),
      expanseList
    ];
  }

  //returns the transactions that ocuur in the last 7 days
  List<Transaction> get _recentTransactions {
    // where returns a new list of elements that satesfie the condition in  the method body
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addExpense(
      String exTitle, double exAmount, DateTime exDate, Category category) {
    setState(() {
      _userTransactions.add(new Transaction(
          title: exTitle,
          amount: exAmount,
          category: category,
          id: DateTime.now().toString(),
          date: exDate));
    });
  }

  void _startAddingNewExpense(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewExpense(_addExpense),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void removeExpense(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }
}
