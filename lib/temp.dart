import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'script.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
  var ios = new IOSInitializationSettings();
  var initSettings = new InitializationSettings(android, ios);
  await flutterLocalNotificationsPlugin.initialize(initSettings,
      onSelectNotification: (String payload) {
    debugPrint("payload : $payload");
    runApp(MyApp());
    return Future.value("ok");
  });
  await Workmanager.initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  runApp(MyApp());
}

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
const simpleTask = "simpleTask";
const simplePeriodicTask = "simplePeriodicTask";
var time;

void callbackDispatcher() async {
  print('callbackDispatcher');
  await Workmanager.executeTask((task, inputData) async {
    String marksNew = await getToken();
    String marksOld = "";

    time = new DateTime.now();
    print(time.toString());
    SharedPreferences prefs = await _prefs;
    prefs.setString("time", time.toString());
    if (prefs.containsKey("marks")) {
      marksOld = prefs.getString("marks");
    }
    print("Succeeded");
    // print(marksOld);
    // print(marksNew);
    if (marksOld != marksNew && marksNew != "") {
      //Raise a notification here
      print(marksNew);
      prefs.setString("marks", marksNew);
    }
    var android1 = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION');
    var ios1 = new IOSNotificationDetails();
    var platform = new NotificationDetails(android1, ios1);
    await flutterLocalNotificationsPlugin.show(
        0, 'Marks Seem to be changed', 'Why you not working', platform,
        payload: "Anything you say");

    return Future.value(true);
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var t = "";
  getText() async {
    print("Coming to get Text");
    var t1;
    SharedPreferences prefs = await _prefs;
    t1 = prefs.get("time");
    return t1;
  }

  @override
  Widget build(BuildContext context) {
    print("Will Come to build again whenever you opens app");
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter WorkManager Example"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FlatButton(
                  child: Text("Register One time Task"),
                  onPressed: () {
                    Workmanager.registerOneOffTask(
                      "1",
                      simpleTask,
                    );
                  }),
              FlatButton(
                  child: Text("Register Periodic Task"),
                  onPressed: () {
                    print("Clicked");
                    Workmanager.registerPeriodicTask(
                      "2",
                      simplePeriodicTask,
                      frequency: Duration(minutes: 3),
                      existingWorkPolicy: ExistingWorkPolicy.replace
                    );
                  }),
              Container(
                  child: FutureBuilder(
                      future: getText(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data);
                        } else
                          return Text("");
                      })),
              FlatButton(
                child: Text("Is Working"),
                onPressed: () async {
                  await getToken();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
