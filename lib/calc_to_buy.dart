import 'package:flutter/material.dart';

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

  Map<String, Map<String, String>> allTranslations = {
    'en': {
      'Salary Calculation': 'Salary Calculation',
      'How long do I need to work?': 'How long do I need to work?',
      'Your Salary': 'Your Salary',
      'Product Price': 'Product Price',
      'Calculate': 'Calculate',
      'You need to work for {years} years, {months} months, and {days} days to buy the desired product.':
      'You need to work for {years} years, {months} months, and {days} days to buy the desired product.',
    },
    'tr': {
      'Salary Calculation': 'Maaş Hesaplama',
      'How long do I need to work?': 'Ne kadar süre çalışmam gerekiyor?',
      'Your Salary': 'Maaşınız',
      'Product Price': 'Ürün Fiyatı',
      'Calculate': 'Hesapla',
      'You need to work for {years} years, {months} months, and {days} days to buy the desired product.':
      'İstenilen ürünü almak için {years} yıl, {months} ay ve {days} gün çalışmanız gerekiyor.',
    },
    'fr': {
      'Salary Calculation': 'Calcul du salaire',
      'How long do I need to work?': 'Combien de temps dois-je travailler?',
      'Your Salary': 'Votre salaire',
      'Product Price': 'Prix du produit',
      'Calculate': 'Calculer',
      'You need to work for {years} years, {months} months, and {days} days to buy the desired product.':
      'Vous devez travailler pendant {years} années, {months} mois et {days} jours pour acheter le produit souhaité.',
    },
  };

  String _getTranslatedString(String key, {Map<String, dynamic>? replacements}) {
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
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade200,
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.0),
                Text(
                  _getTranslatedString('How long do I need to work?'),
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
