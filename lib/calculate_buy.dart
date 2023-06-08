import 'dart:math' as math;
import 'package:flutter/material.dart';

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

  Map<String, Map<String, String>> allTranslations = {
    'en': {
      'Calculate Loan Page': 'Calculate Loan Page',
      'Salary': 'Salary',
      'Loan Amount': 'Loan Amount',
      'Down Payment': 'Down Payment',
      'Interest Rate (%)': 'Interest Rate (%)',
      'Loan Period (years)': 'Loan Period (years)',
      'Calculate': 'Calculate',
      'Loan Amount: ': 'Loan Amount: ',
      'Monthly Payment: ': 'Monthly Payment: ',
      'Total Payment: ': 'Total Payment: ',
      'You can get this loan.': 'You can get this loan.',
      'You cannot get this loan because the monthly payment exceeds 35% of your salary.':
          'You cannot get this loan because the monthly payment exceeds 35% of your salary.',
    },
    'tr': {
      'Calculate Loan Page': 'Kredi Hesapla',
      'Salary': 'Maaş',
      'Loan Amount': 'Kredi Tutarı',
      'Down Payment': 'Peşinat',
      'Interest Rate (%)': 'Faiz Oranı (%)',
      'Loan Period (years)': 'Kredi Süresi (yıl)',
      'Calculate': 'Hesapla',
      'Loan Amount: ': 'Kredi Tutarı: ',
      'Monthly Payment: ': 'Aylık Ödeme: ',
      'Total Payment: ': 'Toplam Ödeme: ',
      'You can get this loan.': 'Bu krediyi alabilirsiniz.',
      'You cannot get this loan because the monthly payment exceeds 35% of your salary.':
          'Aylık ödeme, maaşınızın %35\'ini aştığı için bu krediyi alamazsınız.',
    },
    'fr': {
      'Calculate Loan Page': 'Calculer le prêt',
      'Salary': 'Salaire',
      'Loan Amount': 'Montant du prêt',
      'Down Payment': 'Paiement initial',
      'Interest Rate (%)': 'Taux d\'intérêt (%)',
      'Loan Period (years)': 'Durée du prêt (années)',
      'Calculate': 'Calculer',
      'Loan Amount: ': 'Montant du prêt : ',
      'Monthly Payment: ': 'Paiement mensuel : ',
      'Total Payment: ': 'Paiement total : ',
      'You can get this loan.': 'Vous pouvez obtenir ce prêt.',
      'You cannot get this loan because the monthly payment exceeds 35% of your salary.':
      'Vous ne pouvez pas obtenir ce prêt car le paiement mensuel dépasse 35% de votre salaire.',
    },
  };

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
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: _getTranslatedString('Salary')),
                onChanged: (value) {
                  setState(() {
                    salary = double.parse(value);
                  });
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: _getTranslatedString('Loan Amount')),
                onChanged: (value) {
                  setState(() {
                    originalLoanAmount = double.parse(value);
                  });
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: _getTranslatedString('Down Payment')),
                onChanged: (value) {
                  setState(() {
                    downPayment = double.parse(value);
                  });
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: _getTranslatedString('Interest Rate (%)')),
                onChanged: (value) {
                  setState(() {
                    interestRate = double.parse(value);
                  });
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: _getTranslatedString('Loan Period (years)')),
                onChanged: (value) {
                  setState(() {
                    loanPeriod = int.parse(value);
                  });
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: elevatedButtonStyle,
                child: Text(_getTranslatedString('Calculate')),
                onPressed: calculateLoan,
              ),
              SizedBox(height: 20.0),
              if (isCalculated && loanAmount != 0.0)
                Text(_getTranslatedString('Loan Amount: ') +
                    loanAmount.toStringAsFixed(2)),
              if (isCalculated && monthlyPayment != 0.0)
                Text(_getTranslatedString('Monthly Payment: ') +
                    monthlyPayment.toStringAsFixed(2)),
              if (isCalculated && totalPayment != 0.0)
                Text(_getTranslatedString('Total Payment: ') +
                    totalPayment.toStringAsFixed(2)),
              SizedBox(height: 20.0),
              if (isCalculated)
                Text(
                  isLoanAvailable
                      ? _getTranslatedString('You can get this loan.')
                      : _getTranslatedString(
                          'You cannot get this loan because the monthly payment exceeds 35% of your salary.'),
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
