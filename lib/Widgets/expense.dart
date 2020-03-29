import 'package:expense_planner/Models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Expense extends StatelessWidget {
  final Transaction tx;
  final Function deleteTx;

  Expense(this.tx, this.deleteTx);
  IconData get categoryIcon {
    IconData myIcon;
    if (tx.category == Category.car)
      myIcon = Icons.directions_car;
    else if (tx.category == Category.shopping)
      myIcon = Icons.local_grocery_store;
    else if (tx.category == Category.food)
      myIcon = Icons.fastfood;
    else if (tx.category == Category.travel)
      myIcon = Icons.airplanemode_active;
    else if (tx.category == Category.health)
      myIcon = Icons.favorite;
    else if (tx.category == Category.fun) myIcon = Icons.mood;

    return myIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ListTile(
          trailing: SizedBox(
            width: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("\$${tx.amount.toStringAsFixed(2)}"),
                    ),
                  ),
                ),
                IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () => deleteTx(tx.id))
              ],
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.white54,
            radius: 25,
            child: Icon(
              categoryIcon,
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(tx.title),
          subtitle: Text(
            DateFormat.yMd().add_jm().format(tx.date),
          ),
        ),
      ),
    );
  }
}
