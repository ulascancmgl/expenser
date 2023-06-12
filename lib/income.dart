import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'langs/lang.dart';

class IncomePage extends StatefulWidget {
  final String currentLanguage;

  IncomePage({required this.currentLanguage});

  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  late TextEditingController _amountController;
  late DateTime _startDate;
  List<Income> _incomes = [];

  String _getTranslatedString(String key) {
    Map<String, String> translations =
        allTranslations[widget.currentLanguage] ?? {};
    return translations[key] ?? key;
  }

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _startDate = DateTime.now();
    _loadIncomes();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  int _getIncomeMonth(DateTime startDate) {
    return startDate.month;
  }

  Future<void> _loadIncomes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> incomeList = prefs.getStringList('incomes') ?? [];

    setState(() {
      _incomes =
          incomeList.map((json) => Income.fromJson(jsonDecode(json))).toList();
    });
  }

  Future<void> _saveIncomes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> incomeList = _incomes.map((income) {
      Map<String, dynamic> incomeJson = income.toJson();
      incomeJson['month'] = _getIncomeMonth(DateTime.parse(income.startDate));
      return jsonEncode(incomeJson);
    }).toList();

    await prefs.setStringList('incomes', incomeList);
  }

  void _addIncome() {
    double amount = double.parse(_amountController.text);
    String startDateString = _startDate.toString().split(' ')[0];
    String endDateString =
        _startDate.add(const Duration(days: 30)).toString().split(' ')[0];

    setState(() {
      int existingIndex =
          _incomes.indexWhere((income) => income.startDate == startDateString);
      if (existingIndex != -1) {
        // Update existing income amount
        _incomes[existingIndex].amount += amount;
      } else {
        // Add new income
        _incomes.add(Income(amount, startDateString, endDateString));
      }
    });

    _saveIncomes();

    _amountController.clear();
  }

  void _updateIncome(int index, double newAmount) {
    setState(() {
      _incomes[index].amount = newAmount;
    });

    _saveIncomes();
  }

  void _deleteIncome(int index) {
    setState(() {
      _incomes.removeAt(index);
    });

    _saveIncomes();
  }

  Future<void> _showDatePicker(BuildContext context) async {
    DateTime? pickedDate;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.indigo,
              backgroundColor: Colors.transparent,
              cardColor: Colors.indigo,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: Localizations.override(
            context: context,
            locale: Locale(widget.currentLanguage),
            child: DatePickerDialog(
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            ),
          ),
        );
      },
    ).then((value) {
      pickedDate = value as DateTime?;
    });

    if (pickedDate != null) {
      setState(() {
        _startDate = pickedDate!;
      });
    }
  }

  final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
    textStyle: TextStyle(fontSize: 16),
    fixedSize: Size(275, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTranslatedString('Income Page')),
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 16.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: _getTranslatedString('Amount'),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: ElevatedButton(
                      onPressed: () => _showDatePicker(context),
                      style: elevatedButtonStyle,
                      child: Text(_startDate == true
                          ? _getTranslatedString('Select Start Date')
                          : '${_getTranslatedString('Start Date')}: ${_startDate.toString().substring(0, 10)}'),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _addIncome,
                    style: elevatedButtonStyle,
                    child: Text(_getTranslatedString('Add Income')),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _incomes.length,
                itemBuilder: (context, index) {
                  Income income = _incomes[index];
                  return ListTile(
                    title: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_getTranslatedString('Amount')}: ${income.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_getTranslatedString('Start Date')}: ${income.startDate.substring(0, 10)}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_getTranslatedString('End Date')}: ${income.endDate.substring(0, 10)}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                            onPressed: () => _showUpdateDialog(index),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => _deleteIncome(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_getTranslatedString('Update Income Amount')),
          content: TextField(
            keyboardType: TextInputType.number,
            controller:
                TextEditingController(text: _incomes[index].amount.toString()),
            onChanged: (value) {
              setState(() {
                _incomes[index].amount = double.parse(value);
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _updateIncome(index, _incomes[index].amount);
              },
              child: Text(_getTranslatedString('Save')),
            ),
          ],
        );
      },
    );
  }
}

class Income {
  double amount;
  String startDate;
  String endDate;

  Income(this.amount, this.startDate, this.endDate);

  factory Income.fromJson(Map<String, dynamic> json) => Income(
        json['amount'] as double,
        json['startDate'] as String,
        json['endDate'] as String,
      );

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'startDate': startDate,
        'endDate': endDate,
      };
}
