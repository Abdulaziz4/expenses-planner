//this widget will allow users to enter expense information to be added to expense_list
import 'dart:io';

import 'package:expense_planner/Models/transaction.dart';
import 'package:expense_planner/Widgets/adaptive_flat_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewExpense extends StatefulWidget {
  final Function passExpenxse;
  NewExpense(this.passExpenxse);

  @override
  _NewExpenseState createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final titleController = TextEditingController();
  DateTime _selectedDate;
  final amountController = TextEditingController();
  Category category;

  void submitData() {
    final enteredTitle = titleController.text;
    //check null before accessing .text
    if (amountController.text == null) return;
    final enteredAmount = double.parse(amountController.text);

    //checking
    if (enteredTitle == null ||
        enteredAmount <= 0 ||
        _selectedDate == null ||
        category == null) return;

    widget.passExpenxse(enteredTitle, enteredAmount, _selectedDate, category);
    // to close the bottom sheet when press done from the keybord
    //close the top most screen displayed which is the bottom sheet
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      //user cancel
      if (pickedDate == null)
        return;
      else
        setState(() {
          _selectedDate = pickedDate;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                //flutter connect the controller to the text field and will listen and save user input
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => submitData(),
                autofocus: false,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: "amount",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                // pass function that accept String and we plan to not use it, it's convention to name it _ if you will not use it
                onSubmitted: (_) => submitData(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_selectedDate == null
                      ? "No Date Chosen!"
                      : "Picked Date : ${DateFormat.yMd().format(_selectedDate)}"),
                  AdaptiveFlatButton("Choose Date", _presentDatePicker),
                ],
              ),
              DropdownButton<Category>(
                underline: Container(
                  height: 2,
                  color: Theme.of(context).primaryColor,
                ),
                icon: Icon(Icons.arrow_downward),
                iconEnabledColor: Theme.of(context).primaryColor,
                hint: Text("Category"),
                value: category,
                items: Category.values.map((Category c) {
                  return DropdownMenuItem<Category>(
                    child: Text(c.toString().split(".").last),
                    value: c,
                  );
                }).toList(),
                onChanged: (Category selected) {
                  setState(() {
                    category = selected;
                  });
                },
              ),
              FlatButton(
                child: Text("Add"),
                onPressed: submitData,
                color: Colors.blueGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
