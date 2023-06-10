class Item {
  String category;
  String name;
  double initialValue;
  List<double> values;

  Item(this.category, this.name, this.initialValue, this.values);

  double calculateInflation(int valueIndex) {
    if (valueIndex <= 0 || valueIndex >= values.length) {
      return 0.0;
    }

    double currentValue = values[valueIndex];
    double previousValue = values[valueIndex - 1];
    double inflation = ((currentValue - previousValue) / previousValue) * 100.0;
    return double.parse(inflation.toStringAsFixed(2));
  }
}
