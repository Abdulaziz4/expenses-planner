import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String day;
  final double spending;
  // the percentage of spending to that day compare to total week
  final double spendingPctOgTotal;

  ChartBar(this.day, this.spending, this.spendingPctOgTotal);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: <Widget>[
          // to display the number without decimal number
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text("\$ ${spending.toStringAsFixed(0)}"),
            ),
          ),
          SizedBox(height: constraints.maxHeight * 0.05),
          Container(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPctOgTotal,
                  // heightFactor: 0.5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: constraints.maxHeight * 0.05),
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text(day),
            ),
          ),
        ],
      );
    });
  }
}
