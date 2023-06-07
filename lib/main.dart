import 'package:expenser/calculate_buy.dart';
import 'package:expenser/how_much_spend.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Calculator'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IncomePage(),
                  ),
                );
              },
              style: elevatedButtonStyle,
              child: Text('Income'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpensePage(),
                  ),
                );
              },
              style: elevatedButtonStyle,
              child: Text('Expense'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TotalExpensePage(),
                  ),
                );
              },
              style: elevatedButtonStyle,
              child: Text('Total Expense'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InflationPage(),
                  ),
                );
              },
              style: elevatedButtonStyle,
              child: Text('Inflation'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HowMuchToSpend(),
                  ),
                );
              },
              style: elevatedButtonStyle,
              child: Text('How much to spend daily'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalcToBuyPage(),
                  ),
                );
              },
              style: elevatedButtonStyle,
              child: Text('Calculate To Buy'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalculateBuyPage(),
                  ),
                );
              },
              style: elevatedButtonStyle,
              child: Text('Calculate Loan'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExchangePage(),
                  ),
                );
              },
              style: elevatedButtonStyle,
              child: Text('Exchange'),
            ),
          ],
        ),
      ),
    );
  }
}
