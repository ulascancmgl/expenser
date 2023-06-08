import 'package:expenser/calculate_buy.dart';
import 'package:expenser/how_much_spend.dart';
import 'package:expenser/total_expense.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentLanguage = 'en';

  Map<String, String> translations = {
    'Income': 'Gelir',
    'Expense': 'Gider',
    'Total Expense': 'Toplam Gider',
    'Inflation': 'Enflasyon',
    'How much to spend daily': 'Günlük harcamanız ne kadar olmalı',
    'Calculate To Buy': 'Almak ne kadar sürer',
    'Calculate Loan': 'Kredi Hesapla',
    'Exchange': 'Döviz Hesaplama',
  };


  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedLanguage = prefs.getString('selectedLanguage');
    if (selectedLanguage != null) {
      setState(() {
        currentLanguage = selectedLanguage;
      });
    }
  }

  Future<void> _saveSelectedLanguage(String selectedLanguage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', selectedLanguage);
  }

  String _getTranslatedString(String originalString) {
    return currentLanguage == 'en'
        ? originalString
        : translations[originalString] ?? originalString;
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTranslatedString('Expense Calculator')),
        backgroundColor: Colors.indigo,
        actions: [
          PopupMenuButton<String>(
            onSelected: (selectedLanguage) {
              setState(() {
                currentLanguage = selectedLanguage;
              });
              _saveSelectedLanguage(selectedLanguage);
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'en',
                child: Text('English'),
              ),
              PopupMenuItem(
                value: 'tr',
                child: Text('Türkçe'),
              ),
            ],
          ),
        ],
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
                    builder: (context) => IncomePage(currentLanguage: currentLanguage),
                  ),
                );
              },
              style: elevatedButtonStyle,
              child: Text(_getTranslatedString('Income')),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpensePage(currentLanguage: currentLanguage),
                  ),
                );
              },
              style: elevatedButtonStyle,
              child: Text(_getTranslatedString('Expense')),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TotalExpensePage(currentLanguage: currentLanguage),
                  ),
                );
              },
              style: elevatedButtonStyle,
              child: Text(_getTranslatedString('Total Expense')),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InflationPage(currentLanguage: currentLanguage),
                  ),
                );
              },
              style: elevatedButtonStyle,
              child: Text(_getTranslatedString('Inflation')),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HowMuchToSpend(currentLanguage: currentLanguage),
                  ),
                );
              },
              style: elevatedButtonStyle,
              child: Text(_getTranslatedString('How much to spend daily')),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalcToBuyPage(currentLanguage: currentLanguage),
                  ),
                );
              },
              style: elevatedButtonStyle,
              child: Text(_getTranslatedString('Calculate To Buy')),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalculateBuyPage(currentLanguage: currentLanguage),
                  ),
                );
              },
              style: elevatedButtonStyle,
              child: Text(_getTranslatedString('Calculate Loan')),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExchangePage(currentLanguage: currentLanguage),
                  ),
                );
              },
              style: elevatedButtonStyle,
              child: Text(_getTranslatedString('Exchange')),
            ),
          ],
        ),
      ),
    );
  }
}
