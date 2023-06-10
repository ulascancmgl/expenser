import 'package:expenser/calculate_buy.dart';
import 'package:expenser/how_much_spend.dart';
import 'package:expenser/total_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'calc_to_buy.dart';
import 'exchange.dart';
import 'income.dart';
import 'expense.dart';
import 'inflation.dart';
import 'langs/lang.dart';

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
        scaffoldBackgroundColor: Colors.blueGrey,
      ),
      home: HomePage(),
      supportedLocales: const [
        Locale('en', ''),
        Locale('tr', ''),
        Locale('fr', ''),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? currentLanguage;

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Iterable<Locale> get supportedLocales {
    return [
      const Locale('en', ''),
      const Locale('tr', ''),
      const Locale('fr', ''),
    ];
  }

  Future<void> _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedLanguage = prefs.getString('selectedLanguage');
    if (selectedLanguage != null) {
      setState(() {
        currentLanguage = selectedLanguage;
      });
    } else {
      String preferredLanguage = Localizations.localeOf(context).languageCode;

      if (supportedLocales.contains(Locale(preferredLanguage, ''))) {
        setState(() {
          currentLanguage = preferredLanguage;
        });
      } else {
        setState(() {
          currentLanguage = 'en';
        });
      }
    }
  }

  Future<void> _saveSelectedLanguage(String selectedLanguage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', selectedLanguage);
  }

  String _getTranslatedString(String originalString) {
    return allTranslations[currentLanguage]?[originalString] ?? originalString;
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
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.language_sharp,
              color: Colors.white,
              size: 24.0,
            ),
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
              PopupMenuItem(
                value: 'fr',
                child: Text('Français'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: currentLanguage != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                IncomePage(currentLanguage: currentLanguage!),
                          ),
                        );
                      }
                    : null,
                style: elevatedButtonStyle,
                child: Text(_getTranslatedString('Income')),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: currentLanguage != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ExpensePage(currentLanguage: currentLanguage!),
                          ),
                        );
                      }
                    : null,
                style: elevatedButtonStyle,
                child: Text(_getTranslatedString('Expense')),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: currentLanguage != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TotalExpensePage(
                                currentLanguage: currentLanguage!),
                          ),
                        );
                      }
                    : null,
                style: elevatedButtonStyle,
                child: Text(_getTranslatedString('Total Expense')),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: currentLanguage != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InflationPage(
                                currentLanguage: currentLanguage!),
                          ),
                        );
                      }
                    : null,
                style: elevatedButtonStyle,
                child: Text(_getTranslatedString('Inflation')),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: currentLanguage != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HowMuchToSpend(
                                currentLanguage: currentLanguage!),
                          ),
                        );
                      }
                    : null,
                style: elevatedButtonStyle,
                child: Text(_getTranslatedString('How much to spend daily')),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: currentLanguage != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CalcToBuyPage(
                                currentLanguage: currentLanguage!),
                          ),
                        );
                      }
                    : null,
                style: elevatedButtonStyle,
                child: Text(_getTranslatedString('Calculate To Buy')),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: currentLanguage != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CalculateBuyPage(
                                currentLanguage: currentLanguage!),
                          ),
                        );
                      }
                    : null,
                style: elevatedButtonStyle,
                child: Text(_getTranslatedString('Calculate Loan')),
              ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: currentLanguage != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ExchangePage(currentLanguage: currentLanguage!),
                          ),
                        );
                      }
                    : null,
                style: elevatedButtonStyle,
                child: Text(_getTranslatedString('Exchange')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
