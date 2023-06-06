import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Currency {
  String symbol;
  String name;
  String flag;

  Currency({required this.symbol, required this.name, required this.flag});
}

class ExchangePage extends StatefulWidget {
  @override
  _ExchangePageState createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  double amount = 0;
  Currency? firstCurrency;
  Currency? secondCurrency;
  Map<String, double> exchangeRates = {};
  List<Currency> currencies = [];

  @override
  void initState() {
    super.initState();
    _fetchExchangeRates();
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
                  name: getCurrencyName(entry.key),
                  flag: getCurrencyFlag(entry.key),
                ))
            .toList();
        firstCurrency = currencies[0];
        secondCurrency = currencies[1];
      });
    }
  }

  String getCurrencyName(String symbol) {
    Map<String, String> currencyNames = {
      'USD': 'United States Dollar',
      'EUR': 'Euro',
      'GBP': 'British Pound',
      'TRY': 'Turkish Lira',
    };

    return currencyNames[symbol] ?? symbol;
  }

  String getCurrencyFlag(String symbol) {
    Map<String, String> currencyFlags = {
      'USD': '🇺🇸',
      'EUR': '🇪🇺',
      'GBP': '🇬🇧',
      'TRY': '🇹🇷',
    };

    return currencyFlags[symbol] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Currency Converter',
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
                labelText: 'Amount',
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
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Select First Currency'),
                      content: Container(
                        width: double.maxFinite,
                        child: ListView.builder(
                          itemCount: currencies.length,
                          itemBuilder: (BuildContext context, int index) {
                            Currency currency = currencies[index];
                            return ListTile(
                              title: Text('${currency.flag} ${currency.name}'),
                              onTap: () {
                                setState(() {
                                  firstCurrency = currency;
                                });
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
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
                      'First Currency: ${firstCurrency?.name ?? ""}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Select Second Currency'),
                      content: Container(
                        width: double.maxFinite,
                        child: ListView.builder(
                          itemCount: currencies.length,
                          itemBuilder: (BuildContext context, int index) {
                            Currency currency = currencies[index];
                            return ListTile(
                              title: Text('${currency.flag} ${currency.name}'),
                              onTap: () {
                                setState(() {
                                  secondCurrency = currency;
                                });
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
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
                      'Second Currency: ${secondCurrency?.name ?? ""}',
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
                'Convert',
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
                        title: Text('Converted Amount'),
                        content: Text(
                            '$amount ${firstCurrency!.symbol} = $convertedAmount ${secondCurrency!.symbol}'),
                        actions: [
                          TextButton(
                            child: Text('Close'),
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
