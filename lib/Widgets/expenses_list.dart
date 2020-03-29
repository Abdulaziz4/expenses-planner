import 'package:expense_planner/Models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:expense_planner/Widgets/expense.dart';
import 'package:flutter/rendering.dart';

//Widget display the current user expenses

class ExpensesList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function removeTx;
  ExpensesList(this.transactions, this.removeTx);

  @override
  Widget build(BuildContext context) {
    //column containing the expenses spent
    return transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: <Widget>[
                Container(
                  height: constraints.maxHeight * 0.1,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "No expenses added yet !",
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.1,
                ),
                Image.asset(
                  "assets/images/waiting.png",
                  height: constraints.maxHeight * 0.55,
                ),
              ],
            );
          })
        : ListView.builder(
            // flutter provide the index
            itemBuilder: (ctx, index) {
              return Expense(transactions[index], removeTx);
            },
            itemCount: transactions.length,
          );
  }
}
