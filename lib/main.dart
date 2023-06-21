import 'package:expenser/total_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'calc_to_buy.dart';
import 'calculate_buy.dart';
import 'exchange.dart';
import 'how_much_spend.dart';
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
    return ChangeNotifierProvider(
      create: (_) => ThemeChanger()..initializeColor(),
      child: Consumer<ThemeChanger>(
        builder: (context, themeChanger, _) {
          return MaterialApp(
            title: 'BudgetX',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: themeChanger.scaffoldColor,
            ),
            home: HomePage(),
            supportedLocales: const [
              Locale('en', ''),
              Locale('tr', ''),
              Locale('fr', ''),
              Locale('de', ''),
              Locale('es', ''),
              Locale('ja', ''),
              Locale('vi', ''),
              Locale('zh', ''),
              Locale('ar', ''),
              Locale('hi', ''),
            ],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}

class ThemeChanger extends ChangeNotifier {
  Color scaffoldColor = Colors.blueGrey;

  Future<void> initializeColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedColor = prefs.getInt('scaffoldColor');
    if (savedColor != null) {
      scaffoldColor = Color(savedColor);
    }
    notifyListeners();
  }

  void changeColor(Color newColor) async {
    scaffoldColor = newColor;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('scaffoldColor', newColor.value);
    notifyListeners();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? currentLanguage;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      const Locale('de', ''),
      const Locale('es', ''),
      const Locale('ja', ''),
      const Locale('vi', ''),
      const Locale('zh', ''),
      const Locale('ar', ''),
      const Locale('hi', ''),
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

  void changeLanguage(String languageCode) {
    setState(() {
      currentLanguage = languageCode;
      _saveSelectedLanguage(languageCode);
      _loadSelectedLanguage();
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

  Future<void> clearUserData(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_getTranslatedString('Clear Data')),
          content: Text(_getTranslatedString(
              'Are you sure you want to clear all user data ?')),
          actions: [
            TextButton(
              child: Text(_getTranslatedString('Cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(_getTranslatedString('OK')),
              onPressed: () async {
                await prefs.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void changeScaffoldColor(BuildContext context, Color newColor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('scaffoldColor');
    await prefs.setInt('scaffoldColor', newColor.value);
    ThemeChanger themeChanger =
        Provider.of<ThemeChanger>(context, listen: false);
    themeChanger.changeColor(newColor);
  }

  void showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(_getTranslatedString('Select Color')),
          children: [
            ListTile(
              title: Text(_getTranslatedString('BlueGrey')),
              onTap: () {
                changeScaffoldColor(context, Colors.blueGrey);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(_getTranslatedString('Red')),
              onTap: () {
                changeScaffoldColor(context, Colors.red);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(_getTranslatedString('Green')),
              onTap: () {
                changeScaffoldColor(context, Colors.green);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(_getTranslatedString('Yellow')),
              onTap: () {
                changeScaffoldColor(context, Colors.yellow);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(_getTranslatedString('Orange')),
              onTap: () {
                changeScaffoldColor(context, Colors.orange);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(_getTranslatedString('Purple')),
              onTap: () {
                changeScaffoldColor(context, Colors.purple);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(_getTranslatedString('Pink')),
              onTap: () {
                changeScaffoldColor(context, Colors.pink);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(_getTranslatedString('Teal')),
              onTap: () {
                changeScaffoldColor(context, Colors.teal);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(_getTranslatedString('Cyan')),
              onTap: () {
                changeScaffoldColor(context, Colors.cyan);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(_getTranslatedString('Amber')),
              onTap: () {
                changeScaffoldColor(context, Colors.amber);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(_getTranslatedString('Deep Purple')),
              onTap: () {
                changeScaffoldColor(context, Colors.deepPurple);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(_getTranslatedString('Indigo')),
              onTap: () {
                changeScaffoldColor(context, Colors.indigo);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
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
        leading: Row(
          children: [
            SizedBox(width: 12.0),
            Image.asset('assets/images/walletapp.png', width: 40, height: 40),
            SizedBox(width: 4.0),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _scaffoldKey.currentState!.openEndDrawer();
            },
          ),
        ],
        title: Center(
          child: Text(_getTranslatedString('BudgetX')),
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
              child: Text(
                _getTranslatedString('Settings'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ExpansionTile(
              title: Row(
                children: [
                  Icon(Icons.language_sharp, size: 24),
                  SizedBox(width: 10),
                  Text(_getTranslatedString('Languages')),
                ],
              ),
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Text('🇺🇸', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 10),
                      Text('English'),
                    ],
                  ),
                  onTap: () {
                    changeLanguage('en');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Text('🇹🇷', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 10),
                      Text('Türkçe'),
                    ],
                  ),
                  onTap: () {
                    changeLanguage('tr');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Text('🇷🇺', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 10),
                      Text('Русский'),
                    ],
                  ),
                  onTap: () {
                    changeLanguage('ru');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Text('🇩🇪', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 10),
                      Text('Deutsch'),
                    ],
                  ),
                  onTap: () {
                    changeLanguage('de');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Text('🇪🇸', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 10),
                      Text('Español'),
                    ],
                  ),
                  onTap: () {
                    changeLanguage('es');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Text('🇫🇷', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 10),
                      Text('Français'),
                    ],
                  ),
                  onTap: () {
                    changeLanguage('fr');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Text('🇯🇵', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 10),
                      Text('日本語'),
                    ],
                  ),
                  onTap: () {
                    changeLanguage('ja');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Text('🇨🇳', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 10),
                      Text('中文'),
                    ],
                  ),
                  onTap: () {
                    changeLanguage('zh');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Text('🇮🇳', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 10),
                      Text('हिन्दी'),
                    ],
                  ),
                  onTap: () {
                    changeLanguage('hi');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Text('🇻🇳', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 10),
                      Text('Tiếng Việt'),
                    ],
                  ),
                  onTap: () {
                    changeLanguage('vi');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Text('🇸🇦', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 10),
                      Text('العربية'),
                    ],
                  ),
                  onTap: () {
                    changeLanguage('ar');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: Row(
                children: [
                  Icon(Icons.settings_applications, size: 24),
                  SizedBox(width: 10),
                  Text(_getTranslatedString('Application Settings')),
                ],
              ),
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.delete_forever, size: 24),
                      Text(_getTranslatedString('Clear Application Data'),
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  onTap: () {
                    clearUserData(context);
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.color_lens, size: 24),
                      Text(_getTranslatedString('Change Background Color'),
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  onTap: () {
                    showColorPicker(context);
                  },
                ),
              ],
            ),
          ],
        ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 90,
                    child: ElevatedButton(
                      onPressed: currentLanguage != null
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IncomePage(
                                      currentLanguage: currentLanguage!),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_balance_wallet_rounded),
                          SizedBox(width: 8.0),
                          Text(_getTranslatedString('Income')),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Container(
                    width: 150,
                    height: 90,
                    child: ElevatedButton(
                      onPressed: currentLanguage != null
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExpensePage(
                                      currentLanguage: currentLanguage!),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_balance_wallet_outlined),
                          SizedBox(width: 8.0),
                          Text(_getTranslatedString('Expense')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 140.0),
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
                child: Text(_getTranslatedString('Price Index Calculator')),
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
                child: Text(
                  _getTranslatedString('How much to spend daily'),
                  textAlign: TextAlign.center,
                ),
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
