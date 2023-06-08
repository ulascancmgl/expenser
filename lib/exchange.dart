import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'currency_utils.dart';

class Currency {
  String symbol;
  String name;
  String flag;

  Currency({required this.symbol, required this.name, required this.flag});
}

class ExchangePage extends StatefulWidget {
  final String currentLanguage;

  ExchangePage({required this.currentLanguage});

  @override
  _ExchangePageState createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  double amount = 0;
  Currency? firstCurrency;
  Currency? secondCurrency;
  Map<String, double> exchangeRates = {};
  List<Currency> currencies = [];
  CurrencyUtils currencyUtils = CurrencyUtils();

  @override
  void initState() {
    super.initState();
    _fetchExchangeRates();
  }

  Map<String, Map<String, String>> allTranslations = {
    'en': {
      'Currency Converter': 'Currency Converter',
      'Amount': 'Amount',
      'Select Currency': 'Select Currency',
      'Convert': 'Convert',
      'Converted Amount': 'Converted Amount',
      'Close': 'Close',
      'Search...': 'Search...',
    },
    'tr': {
      'Currency Converter': 'Para Dönüştürücüsü',
      'Amount': 'Miktar',
      'Select Currency': 'Para Birimi Seç',
      'Convert': 'Dönüştür',
      'Converted Amount': 'Dönüştürülen Miktar',
      'Close': 'Kapat',
      'Search...': 'Ara...',
    },
  };

  String _getTranslatedString(String key) {
    Map<String, String> translations =
        allTranslations[widget.currentLanguage] ?? {};
    return translations[key] ?? key;
  }

  Future<void> _fetchExchangeRates() async {
    var url = Uri.parse('https://api.exchangerate-api.com/v4/latest/TRY');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var rates = jsonData['rates'] as Map<String, dynamic>;

      var convertedRates = <String, double>{};
      rates.forEach((key, value) {
        convertedRates[key] = value.toDouble();
      });

      setState(() {
        exchangeRates = convertedRates;
        currencies = rates.entries
            .map((entry) => Currency(
                  symbol: entry.key,
                  name: currencyUtils.getCurrencyName(entry.key),
                  flag: currencyUtils.getCurrencyFlag(entry.key),
                ))
            .toList();
        firstCurrency = currencies[0];
        secondCurrency = currencies[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
        _getTranslatedString('Currency Converter'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Container(
        color: Colors.grey.shade200,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  amount = double.parse(value);
                });
              },
              decoration: InputDecoration(
                labelText: _getTranslatedString('Amount'),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            InkWell(
              onTap: () async {
                final selectedCurrency = await showDialog<Currency>(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController searchController =
                        TextEditingController();

                    return StatefulBuilder(
                      builder: (context, setState) {
                        List<Currency> filteredCurrencies =
                            currencies.where((currency) {
                          String searchTerm =
                              searchController.text.toLowerCase();
                          String currencyName = currency.name.toLowerCase();
                          return currencyName.contains(searchTerm);
                        }).toList();

                        return AlertDialog(
                          title: Text(_getTranslatedString('Select Currency')),
                          content: Container(
                            width: double.maxFinite,
                            child: Column(
                              children: [
                                TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    hintText: _getTranslatedString('Search...'),
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                                SizedBox(height: 10.0),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: filteredCurrencies.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Currency currency =
                                          filteredCurrencies[index];
                                      return ListTile(
                                        title: Text(
                                            '${currency.flag} ${currency.name}'),
                                        onTap: () {
                                          Navigator.pop(context, currency);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );

                if (selectedCurrency != null) {
                  setState(() {
                    firstCurrency = selectedCurrency;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${firstCurrency?.name ?? _getTranslatedString("Select Currency")}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            InkWell(
              onTap: () async {
                final selectedCurrency = await showDialog<Currency>(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController searchController =
                        TextEditingController();

                    return StatefulBuilder(
                      builder: (context, setState) {
                        List<Currency> filteredCurrencies =
                            currencies.where((currency) {
                          String searchTerm =
                              searchController.text.toLowerCase();
                          String currencyName = currency.name.toLowerCase();
                          return currencyName.contains(searchTerm);
                        }).toList();

                        return AlertDialog(
                          title: Text(_getTranslatedString('Select Currency')),
                          content: Container(
                            width: double.maxFinite,
                            child: Column(
                              children: [
                                TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    hintText: _getTranslatedString('Search...'),
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                                SizedBox(height: 10.0),
                                Expanded(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: filteredCurrencies.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Currency currency =
                                          filteredCurrencies[index];
                                      return ListTile(
                                        title: Text(
                                            '${currency.flag} ${currency.name}'),
                                        onTap: () {
                                          Navigator.pop(context, currency);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );

                if (selectedCurrency != null) {
                  setState(() {
                    secondCurrency = selectedCurrency;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${secondCurrency?.name ?? _getTranslatedString("Select Currency")}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text(
                _getTranslatedString('Convert'),
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
                if (firstCurrency != null && secondCurrency != null) {
                  double convertedAmount = amount *
                      (exchangeRates[secondCurrency!.symbol]! /
                          exchangeRates[firstCurrency!.symbol]!);
                  convertedAmount =
                      double.parse(convertedAmount.toStringAsFixed(2));
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(_getTranslatedString('Converted Amount')),
                        content: Text(
                            '$amount ${firstCurrency!.symbol} = $convertedAmount ${secondCurrency!.symbol}'),
                        actions: [
                          TextButton(
                            child: Text(_getTranslatedString('Close')),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
