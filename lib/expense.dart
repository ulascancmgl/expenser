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

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

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

  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
    textStyle: TextStyle(fontSize: 16),
    fixedSize: Size(250, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  @override
  Widget build(BuildContext context) {
    List<ExpenseItem> filteredExpenses = expenses.where((expense) {
      DateTime expenseDate = DateTime.parse(expense.date.substring(3) +
          "-" +
          expense.date.substring(0, 2) +
          "-01");
      return expenseDate.month == selectedMonth &&
          expenseDate.year == selectedYear;
    }).toList();

    double totalExpense =
        filteredExpenses.fold(0, (sum, expense) => sum + expense.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DropdownButton<int>(
                  value: selectedMonth,
                  onChanged: (newValue) {
                    setState(() {
                      selectedMonth = newValue!;
                    });
                  },
                  items: [
                    for (int month = 1; month <= 12; month++)
                      DropdownMenuItem<int>(
                        value: month,
                        child: Text(getMonthName(month)),
                      ),
                  ],
                ),
                SizedBox(width: 16),
                DropdownButton<int>(
                  value: selectedYear,
                  onChanged: (newValue) {
                    setState(() {
                      selectedYear = newValue!;
                    });
                  },
                  items: [
                    for (int year = DateTime.now().year; year >= 2020; year--)
                      DropdownMenuItem<int>(
                        value: year,
                        child: Text('$year'),
                      ),
                  ],
                ),
              ],
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
            ElevatedButton(
              onPressed: _registerExpense,
              style: elevatedButtonStyle,
              child: Text('Add Expense'),
            ),
            SizedBox(height: 16),
            Expanded(
              flex: 3,
              child: filteredExpenses.isNotEmpty
                  ? SfCircularChart(
                      series: _getExpenseSeries(filteredExpenses),
                      tooltipBehavior: TooltipBehavior(enable: true),
                    )
                  : Center(child: Text('No expenses recorded')),
            ),
            SizedBox(height: 16),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: filteredExpenses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredExpenses[index].expenseType),
                    subtitle: Text(
                      'Amount: ${filteredExpenses[index].amount.toStringAsFixed(2)}\nDate: ${filteredExpenses[index].date}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteExpense(filteredExpenses[index]),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Total Expense: ${totalExpense.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  List<PieSeries<ExpenseItem, String>> _getExpenseSeries(
      List<ExpenseItem> expenses) {
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
    String date =
        DateFormat('MM/yyyy').format(DateTime(selectedYear, selectedMonth));

    ExpenseItem? existingExpense = expenses.firstWhereOrNull(
      (expense) => expense.expenseType == expenseType && expense.date == date,
    );

    if (existingExpense != null) {
      setState(() {
        existingExpense.amount += amount;
      });
    } else {
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

  void _deleteExpense(ExpenseItem expense) {
    setState(() {
      expenses.remove(expense);
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

  String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
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
