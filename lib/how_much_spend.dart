import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'langs/lang.dart';

class HowMuchToSpend extends StatefulWidget {
  final String currentLanguage;

  HowMuchToSpend({required this.currentLanguage});

  @override
  _HowMuchToSpendState createState() => _HowMuchToSpendState();
}

class _HowMuchToSpendState extends State<HowMuchToSpend> {
  TextEditingController incomeController = TextEditingController();
  TextEditingController futureDateController = TextEditingController();
  TextEditingController subtractValueController = TextEditingController();
  int remainingDays = 0;
  double dailyExpense = 0.0;

  String _getTranslatedString(String key) {
    Map<String, String> translations =
        allTranslations[widget.currentLanguage] ?? {};
    return translations[key] ?? key;
  }

  @override
  void initState() {
    super.initState();
    loadSavedData();
  }

  @override
  void dispose() {
    incomeController.dispose();
    futureDateController.dispose();
    subtractValueController.dispose();
    super.dispose();
  }

  Future<void> loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      incomeController.text = prefs.getDouble('income')?.toString() ?? '';
      futureDateController.text = prefs.getString('futureDate') ?? '';
      remainingDays = prefs.getInt('remainingDays') ?? 0;
      dailyExpense = prefs.getDouble('dailyExpense') ?? 0.0;
    });
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double income = double.parse(incomeController.text);
    DateTime futureDate =
        DateFormat('yyyy-MM-dd').parse(futureDateController.text);
    DateTime currentDate = DateTime.now();
    int daysRemaining = futureDate.difference(currentDate).inDays + 1;
    double expense = income / daysRemaining;
    await prefs.setDouble('income', income);
    await prefs.setString('futureDate', futureDateController.text);
    await prefs.setInt('remainingDays', daysRemaining);
    await prefs.setDouble('dailyExpense', expense);

    await prefs.setString('lastUpdatedDate',
        DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDate));

    setState(() {
      remainingDays = daysRemaining;
      dailyExpense = expense;
    });
  }

  Future<void> selectDate() async {
    final DateTime? selectedDate = await showDialog(
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
    );

    if (selectedDate != null) {
      setState(() {
        futureDateController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  Future<void> resetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('income');
    prefs.remove('futureDate');
    prefs.remove('remainingDays');
    prefs.remove('dailyExpense');

    setState(() {
      incomeController.text = '';
      futureDateController.text = '';
      remainingDays = 0;
      dailyExpense = 0.0;
    });
  }

  void subtractValue() {
    double income = double.parse(incomeController.text);
    double subtractValue = double.parse(subtractValueController.text);
    double updatedIncome = income - subtractValue;
    incomeController.text = updatedIncome.toString();
    calculateExpense();

    saveData();
  }

  void calculateExpense() {
    saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          _getTranslatedString("How Much Can I Spend?"),
          style: TextStyle(
            color: Colors.white,
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.0),
              TextField(
                controller: incomeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _getTranslatedString('Income Amount'),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: selectDate,
                child: AbsorbPointer(
                  child: TextField(
                    controller: futureDateController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText:
                          _getTranslatedString('Future Date (yyyy-MM-dd)'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: calculateExpense,
                child: Text(_getTranslatedString('Calculate')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.all(16.0),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: subtractValueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _getTranslatedString('Subtraction Value'),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: subtractValue,
                child: Text(
                  _getTranslatedString('Subtract from Value'),
                  style: TextStyle(fontSize: 16.0),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
              SizedBox(height: 32.0),
              Visibility(
                visible: remainingDays != 0,
                child: Column(
                  children: [
                    Text(
                      '${_getTranslatedString('Remaining Days:')} ${remainingDays != 0 ? remainingDays : ''}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 8.0),
                    Visibility(
                      visible: dailyExpense > 0,
                      child: Text(
                        '${_getTranslatedString('Daily Expense Amount:')} $dailyExpense',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: resetData,
                      child: Text(
                        _getTranslatedString('Reset'),
                        style: TextStyle(fontSize: 16.0),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.all(16.0),
                        minimumSize: Size(double.infinity, 0),
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
