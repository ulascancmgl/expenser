import 'package:expenser/calculate_buy.dart';
import 'package:expenser/total_expense.dart';
import 'package:flutter/material.dart';

import 'calc_to_buy.dart';
import 'exchange.dart';
import 'income.dart';
import 'expense.dart';
import 'inflation.dart';

void main() {
  runApp(ExpenseCalculatorApp());
}

class ExpenseCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Calculator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IncomePage(),
                  ),
                );
              },
              child: Text('Income'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpensePage(),
                  ),
                );
              },
              child: Text('Expense'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TotalExpensePage(),
                  ),
                );
              },
              child: Text('Total Expense'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InflationPage(),
                  ),
                );
              },
              child: Text('Inflation'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalcToBuyPage(),
                  ),
                );
              },
              child: Text('Calculate To Buy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalculateBuyPage(),
                  ),
                );
              },
              child: Text('Calculate Loan'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExchangePage(),
                  ),
                );
              },
              child: Text('Exchange'),
            ),
          ],
        ),
      ),
    );
  }
}
