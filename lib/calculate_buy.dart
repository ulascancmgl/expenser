import 'dart:math' as math;
import 'package:flutter/material.dart';

class CalculateBuyPage extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculate Loan Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Salary'),
                onChanged: (value) {
                  setState(() {
                    salary = double.parse(value);
                  });
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Loan Amount'),
                onChanged: (value) {
                  setState(() {
                    originalLoanAmount = double.parse(value);
                  });
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Down Payment'),
                onChanged: (value) {
                  setState(() {
                    downPayment = double.parse(value);
                  });
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Interest Rate (%)'),
                onChanged: (value) {
                  setState(() {
                    interestRate = double.parse(value);
                  });
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Loan Period (years)'),
                onChanged: (value) {
                  setState(() {
                    loanPeriod = int.parse(value);
                  });
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: Text('Calculate'),
                onPressed: calculateLoan,
              ),
              SizedBox(height: 20.0),
              if (isCalculated && loanAmount != 0.0)
                Text('Loan Amount: \$${loanAmount.toStringAsFixed(2)}'),
              if (isCalculated && monthlyPayment != 0.0)
                Text('Monthly Payment: \$${monthlyPayment.toStringAsFixed(2)}'),
              if (isCalculated && totalPayment != 0.0)
                Text('Total Payment: \$${totalPayment.toStringAsFixed(2)}'),
              SizedBox(height: 20.0),
              if (isCalculated)
                Text(
                  isLoanAvailable
                      ? 'You can get this loan.'
                      : 'You cannot get this loan because the monthly payment exceeds 35% of your salary.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isLoanAvailable ? Colors.green : Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
