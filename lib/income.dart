import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomePage extends StatefulWidget {
  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  late TextEditingController _amountController;
  late DateTime _startDate;
  List<Income> _incomes = [];

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
    List<String> incomeList =
        _incomes.map((income) => jsonEncode(income.toJson())).toList();

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
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Income Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Amount'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => _showDatePicker(context),
                  child: Text(_startDate == true
                      ? 'Select Start Date'
                      : 'Start Date: ${_startDate.toString().substring(0, 10)}'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _addIncome,
                  child: Text('Add Income'),
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
                  title: Text('Amount: ${income.amount.toStringAsFixed(2)}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start Date: ${income.startDate.substring(0, 10)}'),
                      Text('End Date: ${income.endDate.substring(0, 10)}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showUpdateDialog(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteIncome(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Income Amount'),
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
              child: Text('Save'),
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
