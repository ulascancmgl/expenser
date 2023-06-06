import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'expense.dart';

class TotalExpensePage extends StatefulWidget {
  @override
  _TotalExpensePageState createState() => _TotalExpensePageState();
}

class _TotalExpensePageState extends State<TotalExpensePage> {
  List<ExpenseItem> expenses = [];
  double totalExpense = 0.0;

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
      body: ListView.builder(
        itemCount: expenses.length + 1, // Add 1 for the "Total Expense" item
        itemBuilder: (context, index) {
          if (index < expenses.length) {
            // Display expense items
            return ListTile(
              title: Text(expenses[index].expenseType),
              subtitle: Text(
                'Amount: \$${expenses[index].amount.toStringAsFixed(2)}\nDate: ${expenses[index].date}',
              ),
            );
          } else if (index == expenses.length) {
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
    );
  }

  void loadExpenses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? encodedExpenses = prefs.getStringList('expenses');

    if (encodedExpenses != null) {
      List<ExpenseItem> loadedExpenses = encodedExpenses.map((encodedExpense) {
        return ExpenseItem.fromJson(encodedExpense);
      }).toList();

      double sum = 0.0; // Initialize the sum

      for (var expense in loadedExpenses) {
        sum += expense.amount; // Add each expense amount to the sum
      }

      setState(() {
        expenses = loadedExpenses;
        totalExpense = sum; // Assign the calculated sum to totalExpense
      });
    }
  }
}
