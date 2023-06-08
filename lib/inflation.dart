import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model.dart';

class InflationPage extends StatefulWidget {
  final String currentLanguage;

  InflationPage({required this.currentLanguage});

  @override
  _InflationPageState createState() => _InflationPageState();
}

class _InflationPageState extends State<InflationPage> {
  List<Item> items = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController initialValueController = TextEditingController();
  final Map<int, TextEditingController> newValueControllers = {};

  String selectedCategory = 'Food';

  Map<String, Map<String, String>> allTranslations = {
    'en': {
      'Food': 'Food',
      'Transportation': 'Transportation',
      'Shopping': 'Shopping',
      'Entertainment': 'Entertainment',
      'Bills': 'Bills',
      'Others': 'Others',
      'Product Name': 'Product Name',
      'Initial Value': 'Initial Value',
      'Save': 'Save',
      'Update': 'Update',
      'New Value': 'New Value',
      'Inflation Page': 'Inflation Page',
      'Calculate': 'Calculate',
      'Reset': 'Reset',
      'Remaining Days:': 'Remaining Days:',
      'Daily Expense Amount:': 'Daily Expense Amount:',
      'Inflation': 'Inflation',
    },
    'tr': {
      'Food': 'Yiyecek',
      'Transportation': 'Ulaşım',
      'Shopping': 'Alışveriş',
      'Entertainment': 'Eğlence',
      'Bills': 'Faturalar',
      'Others': 'Diğerleri',
      'Product Name': 'Ürün Adı',
      'Initial Value': 'İlk Değer',
      'Save': 'Kaydet',
      'Update': 'Güncelle',
      'New Value': 'Yeni Değer',
      'Inflation Page': 'Enflasyon Sayfası',
      'Calculate': 'Hesapla',
      'Reset': 'Sıfırla',
      'Remaining Days:': 'Kalan Günler:',
      'Daily Expense Amount:': 'Günlük Harcama Miktarı:',
      'Inflation': 'Enflasyon',
    },
    'fr': {
      'Food': 'Alimentation',
      'Transportation': 'Transport',
      'Shopping': 'Shopping',
      'Entertainment': 'Divertissement',
      'Bills': 'Factures',
      'Others': 'Autres',
      'Product Name': 'Nom du Produit',
      'Initial Value': 'Valeur Initiale',
      'Save': 'Enregistrer',
      'Update': 'Mettre à jour',
      'New Value': 'Nouvelle Valeur',
      'Inflation Page': 'Page de l\'Inflation',
      'Calculate': 'Calculer',
      'Reset': 'Réinitialiser',
      'Remaining Days:': 'Jours Restants :',
      'Daily Expense Amount:': 'Montant des Dépenses Quotidiennes :',
      'Inflation': 'Inflation',
    },
  };

  String _getTranslatedString(String key) {
    Map<String, String> translations =
        allTranslations[widget.currentLanguage] ?? {};
    return translations[key] ?? key;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadItems();
  }

  Future<void> loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> itemStrings = prefs.getStringList('items') ?? [];
    setState(() {
      items = itemStrings.map((str) {
        List<String> parts = str.split('|');
        List<double> values =
            parts.sublist(3).map((val) => double.parse(val)).toList();
        return Item(parts[0], parts[1], double.parse(parts[2]), values);
      }).toList();

      newValueControllers.clear();
      items.asMap().forEach((index, item) {
        newValueControllers[index] = TextEditingController();
      });
    });
  }

  Future<void> saveItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> itemStrings = items.map((item) {
      List<String> values = item.values.map((val) => val.toString()).toList();
      return '${item.category}|${item.name}|${item.initialValue}|${values.join('|')}';
    }).toList();
    await prefs.setStringList('items', itemStrings);
  }

  void addNewValueController(int itemIndex) {
    newValueControllers[itemIndex] = TextEditingController();
  }

  void removeNewValueController(int itemIndex) {
    newValueControllers.remove(itemIndex);
  }

  void deleteItem(int itemIndex) {
    setState(() {
      items.removeAt(itemIndex);
      saveItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inflation Page',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          SizedBox(height: 16.0),
          DropdownButton<String>(
            value: selectedCategory,
            items: [
              'Food',
              'Transportation',
              'Shopping',
              'Entertainment',
              'Bills',
              'Others',
            ].map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(_getTranslatedString(category)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
              });
            },
          ),
          SizedBox(height: 16.0),
          Container(
            width: 250.0,
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: _getTranslatedString('Product Name'),
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
              controller: initialValueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _getTranslatedString('Initial Value'),
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
              _getTranslatedString('Save'),
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
              String name = nameController.text.trim();
              double initialValue =
                  double.tryParse(initialValueController.text.trim()) ?? 0.0;
              if (name.isNotEmpty && initialValue > 0) {
                setState(() {
                  Item newItem = Item(
                      selectedCategory, name, initialValue, [initialValue]);
                  items.add(newItem);
                  nameController.clear();
                  initialValueController.clear();
                  saveItems();
                  addNewValueController(items.length - 1);
                });
              }
            },
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                Item item = items[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(item.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${item.category} - ${item.initialValue}'),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: item.values.length - 1,
                            itemBuilder: (context, valueIndex) {
                              double value = item.values[valueIndex + 1];
                              double inflation =
                                  item.calculateInflation(valueIndex + 1);
                              return Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Row(
                                  children: [
                                    Text('$value'),
                                    SizedBox(width: 8.0),
                                    Text(_getTranslatedString('Inflation') +
                                        ': $inflation%'),
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            width: 250.0,
                            child: TextField(
                              controller: newValueControllers[index],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: _getTranslatedString('New Value'),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                child: Text(
                                  _getTranslatedString('Update'),
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
                                    horizontal: 20.0,
                                    vertical: 12.0,
                                  ),
                                ),
                                onPressed: () {
                                  double newValue = double.tryParse(
                                          newValueControllers[index]!
                                              .text
                                              .trim()) ??
                                      0.0;
                                  if (newValue > 0) {
                                    setState(() {
                                      item.values.add(newValue);
                                      newValueControllers[index]!.clear();
                                      saveItems();
                                    });
                                  }
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  deleteItem(index);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
