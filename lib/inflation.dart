import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model.dart';
import 'langs/lang.dart';

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
          _getTranslatedString('Inflation Page'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
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
            SizedBox(height: 20.0),
            Container(
              width: 250.0,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Align(
                alignment: Alignment.center,
                child: DropdownButton<String>(
                  value: selectedCategory,
                  dropdownColor: Colors.white,
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
                      child: Text(
                        _getTranslatedString(category),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                  style: TextStyle(color: Colors.black),
                  underline: Container(),
                  icon: Icon(Icons.arrow_drop_down),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
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
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.1),
                        child: Center(
                          child: FractionallySizedBox(
                            widthFactor: 0.8,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                              ),
                              child: ListTile(
                                title: Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_getTranslatedString(item.category)} - ${item.initialValue}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.white,
                                      ),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: item.values.length - 1,
                                        itemBuilder: (context, valueIndex) {
                                          double value =
                                              item.values[valueIndex + 1];
                                          double inflation =
                                              item.calculateInflation(
                                                  valueIndex + 1);
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '$value',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  _getTranslatedString(
                                                          'Inflation') +
                                                      ': $inflation%',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 16.0),
                                    Container(
                                      width: 250.0,
                                      child: TextField(
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        controller: newValueControllers[index],
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText:
                                              _getTranslatedString('New Value'),
                                          filled: true,
                                          fillColor: Colors.white,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
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
                                                newValueControllers[index]!
                                                    .clear();
                                                saveItems();
                                              });
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            deleteItem(index);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
      ),
    );
  }
}
