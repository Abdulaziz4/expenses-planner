import 'package:expense_planner/Models/transaction.dart';
import 'package:expense_planner/Widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTrans;

  Chart(this.recentTrans);

  // return list containing 7 maps which is the day in week
  //each map represent a day containig the day symbol and the amount spent
  List<Map<String, Object>> get _groupedExpenseValues {
    // constrcuter for the class list which generate new list with
    //the given information (length, function called for every element)
    //( 7 == days in week)
    return List.generate(7, (index) {
      // return the date time now subtracted from duration
      // for example if index 1 : return yestadey
      final weekDay = DateTime.now().subtract(Duration(days: index));

      // to get all the amount from the transactions in the day
      double totalAmount = 0;
      for (int i = 0; i < recentTrans.length; i++) {
        if (weekDay.day == recentTrans[i].date.day &&
            weekDay.month == recentTrans[i].date.month &&
            weekDay.year == recentTrans[i].date.year) {
          totalAmount += recentTrans[i].amount;
        }
      }
      // dateFormat.E returns short cut for the week day
      return {
        "day": DateFormat.E().format(weekDay).substring(0, 1),
        "amount": totalAmount
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return _groupedExpenseValues.fold(0.0, (sum, item) {
      return sum + item["amount"];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_groupedExpenseValues);
    return Card(
      elevation: 7,
      // margin: EdgeInsets.all(15),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _groupedExpenseValues.map((data) {
            return ChartBar(
              data["day"],
              data["amount"],
              totalSpending == 0.0
                  ? 0.0
                  : (data['amount'] as double) / totalSpending,
            );
          }).toList(),
        ),
      ),
    );
  }
}
