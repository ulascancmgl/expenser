import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'langs/lang.dart';

class ExpensePage extends StatefulWidget {
  final String currentLanguage;

  ExpensePage({required this.currentLanguage});

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

  String _getTranslatedString(String key) {
    Map<String, String> translations =
        allTranslations[widget.currentLanguage] ?? {};
    return translations[key] ?? key;
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
        title: Text(_getTranslatedString('Expense Tracker')),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueGrey, Colors.deepPurple],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 50),
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
                            child: Text(
                              _getTranslatedString(getMonthName(month)),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: 12),
                    DropdownButton<int>(
                      value: selectedYear,
                      onChanged: (newValue) {
                        setState(() {
                          selectedYear = newValue!;
                        });
                      },
                      items: [
                        for (int year = DateTime.now().year;
                            year >= 2020;
                            year--)
                          DropdownMenuItem<int>(
                            value: year,
                            child: Text(
                              '$year',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: _getTranslatedString('Amount'),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedExpenseType,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedExpenseType = newValue;
                    });
                  },
                  items: expenseTypes
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(_getTranslatedString(value)),
                      ),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: _getTranslatedString('Expense Type'),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  isDense: true,
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _registerExpense,
                style: elevatedButtonStyle,
                child: Text(_getTranslatedString('Add Expense')),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              flex: 3,
              child: filteredExpenses.isNotEmpty
                  ? SfCircularChart(
                      series: _getExpenseSeries(filteredExpenses),
                      tooltipBehavior: TooltipBehavior(enable: true),
                    )
                  : Center(
                      child: Text(
                        _getTranslatedString('No expenses recorded'),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
            SizedBox(height: 16),
            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: filteredExpenses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _getTranslatedString(filteredExpenses[index].expenseType),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${_getTranslatedString('Amount')}: ${filteredExpenses[index].amount.toStringAsFixed(2)}\n${_getTranslatedString('Date')}: ${filteredExpenses[index].date}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () => _deleteExpense(filteredExpenses[index]),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              '${_getTranslatedString('Total Expense')}: ${totalExpense.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black87,
              ),
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
        xValueMapper: (ExpenseItem expense, _) =>
            _getTranslatedString(expense.expenseType),
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
