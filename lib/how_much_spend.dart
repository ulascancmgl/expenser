import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class HowMuchToSpend extends StatefulWidget {
  @override
  _HowMuchToSpendState createState() => _HowMuchToSpendState();
}

class _HowMuchToSpendState extends State<HowMuchToSpend> {
  TextEditingController incomeController = TextEditingController();
  TextEditingController futureDateController = TextEditingController();
  TextEditingController subtractValueController = TextEditingController();
  int remainingDays = 0;
  double dailyExpense = 0.0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel channel;
  bool notificationPermissionGranted = false;
  bool showNotificationButton = true;

  @override
  void initState() {
    super.initState();
    loadSavedData();
    initializeNotifications();
  }

  @override
  void dispose() {
    incomeController.dispose();
    futureDateController.dispose();
    subtractValueController.dispose();
    super.dispose();
  }

  Future<void> loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      incomeController.text = prefs.getDouble('income')?.toString() ?? '';
      futureDateController.text = prefs.getString('futureDate') ?? '';
      remainingDays = prefs.getInt('remainingDays') ?? 0;
      dailyExpense = prefs.getDouble('dailyExpense') ?? 0.0;
    });
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double income = double.parse(incomeController.text);
    DateTime futureDate =
        DateFormat('yyyy-MM-dd').parse(futureDateController.text);
    DateTime currentDate = DateTime.now();
    int daysRemaining = futureDate.difference(currentDate).inDays;
    double expense = income / daysRemaining;
    await prefs.setDouble('income', income);
    await prefs.setString('futureDate', futureDateController.text);
    await prefs.setInt('remainingDays', daysRemaining);
    await prefs.setDouble('dailyExpense', expense);

    await prefs.setString('lastUpdatedDate',
        DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDate));

    setState(() {
      remainingDays = daysRemaining;
      dailyExpense = expense;
    });
  }

  Future<void> selectDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (selectedDate != null) {
      setState(() {
        futureDateController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  Future<void> resetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('income');
    prefs.remove('futureDate');
    prefs.remove('remainingDays');
    prefs.remove('dailyExpense');

    setState(() {
      incomeController.text = '';
      futureDateController.text = '';
      remainingDays = 0;
      dailyExpense = 0.0;
    });
  }

  void subtractValue() {
    double income = double.parse(incomeController.text);
    double subtractValue = double.parse(subtractValueController.text);
    double updatedIncome = income - subtractValue;
    incomeController.text = updatedIncome.toString();
    calculateExpense();

    saveData();

    saveSubtractedValue(updatedIncome, DateTime.now());
  }

  Future<void> saveSubtractedValue(double value, DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double subtractedValue = double.parse(subtractValueController.text);
    String subtractedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

    List<String>? previousValues = prefs.getStringList('subtractedValues');

    List<String> updatedValues = [];
    if (previousValues != null) {
      updatedValues.addAll(previousValues);
    }
    updatedValues.add('$subtractedValue;$subtractedDate');

    await prefs.setStringList('subtractedValues', updatedValues);
  }

  Future<void> initializeNotifications() async {
    channel = const AndroidNotificationChannel(
      'reminder_channel',
      'Reminder Channel',
      description: 'Channel for daily reminders',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await requestNotificationPermission();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    notificationPermissionGranted = status.isGranted;
    if (notificationPermissionGranted) {
      setState(() {
        showNotificationButton = false;
      });
    }
  }

  Future<void> showDailyNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelShowBadge: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Daily Notification',
      'A notification redirected to this page!',
      platformChannelSpecifics,
      payload: 'notification',
    );
  }

  void showNotificationRequest() async {
    if (notificationPermissionGranted) {
      showDailyNotification();
    } else {
      await requestNotificationPermission();
    }
  }

  void calculateExpense() {
    saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "How Much Can I Spend?",
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.0),
              TextField(
                controller: incomeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Income Amount',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: selectDate,
                child: AbsorbPointer(
                  child: TextField(
                    controller: futureDateController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: 'Future Date (yyyy-MM-dd)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: calculateExpense,
                child: Text('Calculate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.all(16.0),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: subtractValueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Subtraction Value',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: subtractValue,
                child: Text(
                  'Subtract from Value',
                  style: TextStyle(fontSize: 16.0),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
              SizedBox(height: 32.0),
              Visibility(
                visible: remainingDays != 0,
                child: Column(
                  children: [
                    Text(
                      'Remaining Days: ${remainingDays != 0 ? remainingDays : ''}',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(height: 8.0),
                    Visibility(
                      visible: dailyExpense > 0,
                      child: Text(
                        'Daily Expense Amount: $dailyExpense',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: resetData,
                      child: Text(
                        'Reset',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.all(16.0),
                        minimumSize: Size(double.infinity, 0),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Visibility(
                visible: showNotificationButton,
                child: ElevatedButton(
                  onPressed: showNotificationRequest,
                  child: Text('Request Notification'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.all(16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
