import 'package:flutter/material.dart';

class CalcToBuyPage extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Salary Calculation',
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30.0),
              Text(
                'How long do I need to work?',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                width: 250.0,
                child: TextField(
                  controller: salaryController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Your Salary',
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
                  ),
                  decoration: InputDecoration(
                    labelText: 'Product Price',
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
                  'Calculate',
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
                    double salary = double.tryParse(salaryController.text) ?? 0;
                    double productPrice =
                        double.tryParse(productPriceController.text) ?? 0;
                    int totalMonths = (productPrice / salary).floor();
                    int years = totalMonths ~/ 12;
                    int months = totalMonths % 12;
                    int days = ((productPrice / salary * 30) % 30).ceil();
                    result =
                        'You need to work for $years years, $months months, and $days days to buy the desired product.';
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
    );
  }
}
