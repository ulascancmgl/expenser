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
  String? selectedOption;
  String selectedDuration = 'Month';

  final List<String> durationOptions = [
    'Month',
    'Year',
  ];

  String _getTranslatedString(String key) {
    Map<String, String> translations =
        allTranslations[widget.currentLanguage] ?? {};
    return translations[key] ?? key;
  }

  double calculateTotalInterestPayment(
      double loanAmount, double monthlyInterest, int loanPeriod,
      {double totalInterestPayment = 0}) {
    if (loanPeriod == 0) {
      return totalInterestPayment;
    } else {
      double monthlyPayment = loanAmount / loanPeriod;
      double monthlyInterestPayment = loanAmount *
          (monthlyInterest * (1 + monthlyInterest) * loanPeriod) /
          ((1 + monthlyInterest) * loanPeriod);
      totalInterestPayment += monthlyInterestPayment;
      loanAmount -= monthlyPayment;
      return calculateTotalInterestPayment(
        loanAmount,
        monthlyInterest,
        loanPeriod - 1,
        totalInterestPayment: totalInterestPayment,
      );
    }
  }

  void calculateLoan() {
    double remainingAmount = originalLoanAmount - downPayment;
    loanAmount = remainingAmount;

    double monthlyInterest = interestRate / 100;
    double totalInterestPayment =
        calculateTotalInterestPayment(loanAmount, monthlyInterest, loanPeriod);
    totalPayment = loanAmount + totalInterestPayment;
    monthlyPayment = totalPayment / loanPeriod;

    setState(() {
      isCalculated = true;
      isLoanAvailable = monthlyPayment <= salary * 0.35;
    });
  }

  void calculateLoanYear() {
    double remainingAmount = originalLoanAmount - downPayment;
    loanAmount = remainingAmount;

    double monthlyInterest = interestRate / 100 / 12;
    double totalInterestPayment =
        calculateTotalInterestPayment(loanAmount, monthlyInterest, loanPeriod);
    totalPayment = loanAmount + totalInterestPayment;
    monthlyPayment = totalPayment / loanPeriod;

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
                child: Row(
                  children: [
                    Expanded(
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
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
                    SizedBox(width: 16.0),
                    Container(
                      width: 90.0,
                      height: 45.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.center,
                          child: DropdownButton<String>(
                            value: selectedOption,
                            onChanged: (newValue) {
                              setState(() {
                                selectedOption = newValue;
                              });
                            },
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                            underline: SizedBox(),
                            icon: Icon(Icons.arrow_drop_down),
                            items: <String?>[
                              null,
                              _getTranslatedString('Yearly'),
                              _getTranslatedString('Monthly')
                            ].map<DropdownMenuItem<String>>((String? value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.center,
                                  child: Container(
                                    color: selectedOption == value
                                        ? Colors.white
                                        : null,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(value ??
                                        _getTranslatedString('Select')),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                width: 250.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: _getTranslatedString('Loan Period'),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 16.0),
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
                        SizedBox(width: 10.0),
                        Container(
                          width: 95.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.center,
                              child: DropdownButton<String>(
                                value: selectedDuration,
                                onChanged: (value) {
                                  setState(() {
                                    selectedDuration = value!;
                                    if (selectedDuration ==
                                        _getTranslatedString('Year')) {
                                      loanPeriod *= 12;
                                    }
                                  });
                                },
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                                underline: SizedBox(),
                                items: durationOptions
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Container(
                                      color: Colors.white,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      child: Text(_getTranslatedString(value)),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                style: elevatedButtonStyle,
                child: Text(_getTranslatedString('Calculate')),
                onPressed: selectedOption != null
                    ? (_getTranslatedString(selectedOption!) ==
                            _getTranslatedString('Yearly')
                        ? calculateLoanYear
                        : calculateLoan)
                    : null,
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
