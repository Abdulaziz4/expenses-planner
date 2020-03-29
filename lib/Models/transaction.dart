import 'package:flutter/foundation.dart';

class Transaction {
  final String title;
  final String id;
  final double amount;
  final DateTime date;
  final Category category;

  Transaction(
      {@required this.id,
      @required this.title,
      @required this.amount,
      @required this.category,
      @required this.date});
}

enum Category {
  fun,
  health,
  travel,
  food,
  shopping,
  car,
}
