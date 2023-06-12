import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'expense.dart';
import 'income.dart';
import 'langs/lang.dart';

class TotalExpensePage extends StatefulWidget {
  final String currentLanguage;

  TotalExpensePage({required this.currentLanguage});

  @override
  _TotalExpensePageState createState() => _TotalExpensePageState();
}

class _TotalExpensePageState extends State<TotalExpensePage> {
  List<ExpenseItem> allExpenses = [];
  List<ExpenseItem> filteredExpenses = [];
  List<Income> allIncomes = [];
  List<Income> filteredIncomes = [];
  double totalExpense = 0.0;
  double totalIncome = 0.0;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  String _getTranslatedString(String key) {
    Map<String, String> translations =
        allTranslations[widget.currentLanguage] ?? {};
    return translations[key] ?? key;
  }

  @override
  void initState() {
    super.initState();
    loadExpenses();
    loadIncomes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTranslatedString('Total Expenses')),
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
        padding: EdgeInsets.symmetric(horizontal: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<int>(
                      value: selectedMonth,
                      onChanged: (newValue) {
                        setState(() {
                          selectedMonth = newValue!;
                          filterExpensesByMonth();
                          filterIncomesByMonth();
                        });
                      },
                      items: [
                        for (int month = 1; month <= 12; month++)
                          DropdownMenuItem<int>(
                            value: month,
                            child: Text(
                              _getTranslatedString('${getMonthName(month)}'),
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<int>(
                      value: selectedYear,
                      onChanged: (newValue) {
                        setState(() {
                          selectedYear = newValue!;
                          filterExpensesByMonth();
                          filterIncomesByMonth();
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
                                fontSize: 18.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredExpenses.length + 2,
                itemBuilder: (context, index) {
                  if (index < filteredExpenses.length) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            _getTranslatedString(
                                filteredExpenses[index].expenseType),
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${_getTranslatedString('Amount: ')}${filteredExpenses[index].amount.toStringAsFixed(2)}\n${_getTranslatedString('Date: ')}${filteredExpenses[index].date}',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (index == filteredExpenses.length) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Center(
                            child: Text(
                              _getTranslatedString('Total Expense'),
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Center(
                            child: Text(
                              '${totalExpense.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (index == filteredExpenses.length + 1) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Center(
                            child: Text(
                              _getTranslatedString('Total Income'),
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Center(
                            child: Text(
                              '${totalIncome.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedExpenses = prefs.getStringList('expenses');

    if (encodedExpenses != null) {
      List<ExpenseItem> loadedExpenses = encodedExpenses.map((encodedExpense) {
        return ExpenseItem.fromJson(encodedExpense);
      }).toList();

      setState(() {
        allExpenses = loadedExpenses;
        filterExpensesByMonth();
      });
    }
  }

  void loadIncomes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedIncomes = prefs.getStringList('incomes');

    if (encodedIncomes != null) {
      List<Income> loadedIncomes = encodedIncomes.map((encodedIncome) {
        return Income.fromJson(jsonDecode(encodedIncome));
      }).toList();

      setState(() {
        allIncomes = loadedIncomes;
        filterIncomesByMonth();
      });
    }
  }

  void filterExpensesByMonth() {
    filteredExpenses = allExpenses.where((expense) {
      DateTime expenseDate = DateTime.parse(expense.date.substring(3) +
          "-" +
          expense.date.substring(0, 2) +
          "-01");
      return expenseDate.month == selectedMonth &&
          expenseDate.year == selectedYear;
    }).toList();

    double sum = 0.0;
    for (var expense in filteredExpenses) {
      sum += expense.amount;
    }

    setState(() {
      totalExpense = sum;
    });
  }

  void filterIncomesByMonth() {
    filteredIncomes = allIncomes.where((income) {
      DateTime incomeStartDate = DateTime.parse(income.startDate);
      return incomeStartDate.month == selectedMonth &&
          incomeStartDate.year == selectedYear;
    }).toList();

    double sum = 0.0;
    for (var income in filteredIncomes) {
      sum += income.amount;
    }

    setState(() {
      totalIncome = sum;
    });
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
