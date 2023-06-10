import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'langs/lang.dart';

class CalculateBuyPage extends StatefulWidget {
  final String currentLanguage;

  CalculateBuyPage({required this.currentLanguage});

  @override
  _CalculateBuyPageState createState() => _CalculateBuyPageState();
}

class _CalculateBuyPageState extends State<CalculateBuyPage> {
  double salary = 0.0;
  double downPayment = 0.0;
  double originalLoanAmount = 0.0;
  double loanAmount = 0.0;
  double interestRate = 0.0;
  int loanPeriod = 0;
  double monthlyPayment = 0.0;
  double totalPayment = 0.0;
  bool isCalculated = false;
  bool isLoanAvailable = false;

  String _getTranslatedString(String key) {
    Map<String, String> translations =
        allTranslations[widget.currentLanguage] ?? {};
    return translations[key] ?? key;
  }

  void calculateLoan() {
    double remainingAmount = originalLoanAmount - downPayment;
    loanAmount = remainingAmount;

    double monthlyInterest = interestRate / 100;
    int totalMonths = loanPeriod * 12;
    monthlyPayment = (loanAmount * monthlyInterest) /
        (1 - math.pow(1 + monthlyInterest, -totalMonths));

    totalPayment = monthlyPayment * totalMonths;

    setState(() {
      isCalculated = true;
      isLoanAvailable = monthlyPayment <= salary * 0.35;
    });
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
        title: Text(_getTranslatedString('Calculate Loan Page')),
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
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.0),
              Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _getTranslatedString('Salary'),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      salary = double.parse(value);
                    });
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _getTranslatedString('Loan Amount'),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      originalLoanAmount = double.parse(value);
                    });
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _getTranslatedString('Down Payment'),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      downPayment = double.parse(value);
                    });
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _getTranslatedString('Interest Rate (%)'),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      interestRate = double.parse(value);
                    });
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _getTranslatedString('Loan Period (years)'),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      loanPeriod = int.parse(value);
                    });
                  },
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: elevatedButtonStyle,
                child: Text(_getTranslatedString('Calculate')),
                onPressed: calculateLoan,
              ),
              SizedBox(height: 20.0),
              if (isCalculated)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      if (isCalculated && loanAmount != 0.0)
                        Text(
                          _getTranslatedString('Loan Amount: ') +
                              loanAmount.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      if (isCalculated && monthlyPayment != 0.0)
                        Text(
                          _getTranslatedString('Monthly Payment: ') +
                              monthlyPayment.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      if (isCalculated && totalPayment != 0.0)
                        Text(
                          _getTranslatedString('Total Payment: ') +
                              totalPayment.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      SizedBox(height: 20.0),
                      if (isCalculated)
                        Text(
                          isLoanAvailable
                              ? _getTranslatedString('You can get this loan.')
                              : _getTranslatedString(
                                  'You cannot get this loan because the monthly payment exceeds 35% of your salary.'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: isLoanAvailable ? Colors.green : Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
