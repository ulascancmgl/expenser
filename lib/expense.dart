import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpensePage extends StatefulWidget {
  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  String? _selectedExpenseType;
  TextEditingController _amountController = TextEditingController();
  List<ExpenseItem> expenses = [];

  List<String> expenseTypes = [
    'Food',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Bills',
    'Others'
  ];

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedExpenseType,
              onChanged: (newValue) {
                setState(() {
                  _selectedExpenseType = newValue;
                });
              },
              items: expenseTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Expense Type',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _registerExpense,
              child: Text('Add Expense'),
            ),
            SizedBox(height: 16),
            Expanded(
              flex: 3,
              child: expenses.isNotEmpty
                  ? SfCircularChart(
                      series: _getExpenseSeries(),
                      tooltipBehavior: TooltipBehavior(enable: true),
                    )
                  : Center(child: Text('No expenses recorded')),
            ),
            SizedBox(height: 16),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(expenses[index].expenseType),
                    subtitle: Text(
                      'Amount: \$${expenses[index].amount.toStringAsFixed(2)}\nDate: ${expenses[index].date}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteExpense(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieSeries<ExpenseItem, String>> _getExpenseSeries() {
    List<ExpenseItem> filteredExpenses =
        expenses.where((expense) => expense.amount > 0).toList();

    return <PieSeries<ExpenseItem, String>>[
      PieSeries<ExpenseItem, String>(
        dataSource: filteredExpenses,
        xValueMapper: (ExpenseItem expense, _) => expense.expenseType,
        yValueMapper: (ExpenseItem expense, _) => expense.amount,
        dataLabelSettings: DataLabelSettings(
          isVisible: true,
          labelPosition: ChartDataLabelPosition.inside,
          useSeriesColor: true,
        ),
      )
    ];
  }

  void _registerExpense() {
    String? expenseType = _selectedExpenseType;
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    String date = DateFormat('MM/yyyy').format(DateTime.now());

    // Check if an expense of the same type exists in the same month
    ExpenseItem? existingExpense = expenses.firstWhereOrNull(
      (expense) => expense.expenseType == expenseType && expense.date == date,
    );

    if (existingExpense != null) {
      // Expense of the same type exists in the same month, update its amount
      setState(() {
        existingExpense.amount += amount;
      });
    } else {
      // Expense of the same type doesn't exist in the same month, add a new expense
      ExpenseItem newExpense = ExpenseItem(
        expenseType: expenseType ?? '',
        amount: amount,
        date: date,
      );

      setState(() {
        expenses.add(newExpense);
      });
    }

    _selectedExpenseType = null;
    _amountController.clear();

    saveExpenses();
  }

  void saveExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedExpenses =
        expenses.map((expense) => expense.toJson()).toList();
    prefs.setStringList('expenses', encodedExpenses);
  }

  void _deleteExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });
    saveExpenses();
  }

  void loadExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedExpenses = prefs.getStringList('expenses');

    if (encodedExpenses != null) {
      List<ExpenseItem> loadedExpenses = encodedExpenses.map((encodedExpense) {
        return ExpenseItem.fromJson(encodedExpense);
      }).toList();

      setState(() {
        expenses = loadedExpenses;
      });
    }
  }
}

class ExpenseItem {
  final String expenseType;
  late double amount;
  final String date;

  ExpenseItem({
    required this.expenseType,
    required this.amount,
    required this.date,
  });

  String toJson() {
    return '{ "expenseType": "$expenseType", "amount": $amount, "date": "$date" }';
  }

  factory ExpenseItem.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return ExpenseItem(
      expenseType: json['expenseType'],
      amount: json['amount'],
      date: json['date'],
    );
  }
}
