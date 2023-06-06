import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'expense.dart';

class TotalExpensePage extends StatefulWidget {
  @override
  _TotalExpensePageState createState() => _TotalExpensePageState();
}

class _TotalExpensePageState extends State<TotalExpensePage> {
  List<ExpenseItem> allExpenses = []; // Store all expenses
  List<ExpenseItem> filteredExpenses = []; // Store filtered expenses
  double totalExpense = 0.0;
  int selectedMonth =
      DateTime.now().month; // Initially set to the current month

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Expenses'),
      ),
      body: Column(
        children: [
          DropdownButton<int>(
            value: selectedMonth,
            onChanged: (newValue) {
              setState(() {
                selectedMonth = newValue!;
                filterExpensesByMonth();
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
          Expanded(
            child: ListView.builder(
              itemCount: filteredExpenses.length +
                  1, // Add 1 for the "Total Expense" item
              itemBuilder: (context, index) {
                if (index < filteredExpenses.length) {
                  // Display expense items
                  return ListTile(
                    title: Text(filteredExpenses[index].expenseType),
                    subtitle: Text(
                      'Amount: \$${filteredExpenses[index].amount.toStringAsFixed(2)}\nDate: ${filteredExpenses[index].date}',
                    ),
                  );
                } else if (index == filteredExpenses.length) {
                  // Display "Total Expense" item
                  return ListTile(
                    title: Center(
                      child: Text(
                        'Total Expense',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    subtitle: Center(
                      child: Text(
                        '\$${totalExpense.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                } else {
                  // Handle any additional cases
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ],
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

  void filterExpensesByMonth() {
    filteredExpenses = allExpenses.where((expense) {
      DateTime expenseDate = DateTime.parse(expense.date.substring(3) +
          "-" +
          expense.date.substring(0, 2) +
          "-01");
      return expenseDate.month == selectedMonth;
    }).toList();

    double sum = 0.0;
    for (var expense in filteredExpenses) {
      sum += expense.amount;
    }

    setState(() {
      totalExpense = sum;
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
