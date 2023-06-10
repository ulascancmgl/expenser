import 'package:flutter/material.dart';

import 'langs/lang.dart';

class CalcToBuyPage extends StatefulWidget {
  final String currentLanguage;

  CalcToBuyPage({required this.currentLanguage});

  @override
  _CalcToBuyPageState createState() => _CalcToBuyPageState();
}

class _CalcToBuyPageState extends State<CalcToBuyPage> {
  TextEditingController salaryController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  String result = '';
  bool showResult = false;

  @override
  void dispose() {
    salaryController.dispose();
    productPriceController.dispose();
    super.dispose();
  }

  String _getTranslatedString(String key,
      {Map<String, dynamic>? replacements}) {
    Map<String, String> translations =
        allTranslations[widget.currentLanguage] ?? {};
    String translation = translations[key] ?? key;

    if (replacements != null) {
      replacements.forEach((key, value) {
        translation = translation.replaceAll('{$key}', value.toString());
      });
    }

    return translation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getTranslatedString('Salary Calculation'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.0),
                Text(
                  _getTranslatedString('How long do I need to work?'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 300.0),
                Container(
                  width: 250.0,
                  child: TextField(
                    controller: salaryController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      labelText: _getTranslatedString('Your Salary'),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  width: 250.0,
                  child: TextField(
                    controller: productPriceController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      labelText: _getTranslatedString('Product Price'),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  child: Text(
                    _getTranslatedString('Calculate'),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 16.0,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      double salary =
                          double.tryParse(salaryController.text) ?? 0;
                      double productPrice =
                          double.tryParse(productPriceController.text) ?? 0;
                      int totalMonths = (productPrice / salary).floor();
                      int years = totalMonths ~/ 12;
                      int months = totalMonths % 12;
                      int days = ((productPrice / salary * 30) % 30).ceil();
                      result = _getTranslatedString(
                        'You need to work for {years} years, {months} months, and {days} days to buy the desired product.',
                        replacements: {
                          'years': years.toString(),
                          'months': months.toString(),
                          'days': days.toString(),
                        },
                      );
                      showResult = true;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                if (showResult)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      result,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
