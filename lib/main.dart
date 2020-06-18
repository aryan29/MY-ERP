import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'script.dart';
import 'login.dart';
import 'homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'widgets/Model.dart';

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
    WidgetsFlutterBinding.ensureInitialized();
    runApp(MyApp());
    return Future.value("ok");
  });
  await Workmanager.initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  runApp(MyApp());
}

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
const simpleTask = "simpleTask";
const simplePeriodicTask = "simplePeriodicTask";
var time;

void callbackDispatcher() {
  // print("Coming to Callback dispatcher");
  Workmanager.executeTask((task, inputData) async {
    final storage = new FlutterSecureStorage();
    String username = await storage.read(key: "username");
    String password = await storage.read(key: "password");
    print("Coming Inside here");
    var mp = await getToken(username, password);
    String marksNew = await mp["marks"];
    String marksOld = "";
    String attendanceNew = mp["attendance"];
    String attendanceOld = "";

    time = new DateTime.now();
    print("$time inside callback");
    SharedPreferences prefs = await _prefs;
    prefs.setString("time", time.toString());
    if (prefs.containsKey("marks")) {
      marksOld = prefs.getString("marks");
    }
    if (prefs.containsKey("attendance")) {
      attendanceOld = prefs.getString("attendance");
    }
    print("Succeeded");
    if (marksOld != marksNew && marksNew != "") {
      //Raise a notification here
      await storeData(username, marksNew);
      print(marksNew);
      prefs.setString("marks", marksNew);
      var android1 = new AndroidNotificationDetails(
          'channel id', 'channel NAME', 'CHANNEL DESCRIPTION');
      var ios1 = new IOSNotificationDetails();
      var platform = new NotificationDetails(android1, ios1);
      await flutterLocalNotificationsPlugin.show(
          0, 'Marks updated!', 'Click to check it', platform,
          payload: "Anything you say");
    } else if (attendanceNew != attendanceOld && attendanceNew != "") {
      prefs.setString("attendance", attendanceNew);
      var android1 = new AndroidNotificationDetails(
          'channel id', 'channel NAME', 'CHANNEL DESCRIPTION');
      var ios1 = new IOSNotificationDetails();
      var platform = new NotificationDetails(android1, ios1);
      await flutterLocalNotificationsPlugin.show(
          0,
          'Attendance Seem to be changed',
          'Check out yours new attendance by clicking me',
          platform,
          payload: "Anything you say");
    }
    // else {
    //   var android1 = new AndroidNotificationDetails(
    //       'channel id', 'channel NAME', 'CHANNEL DESCRIPTION');
    //   var ios1 = new IOSNotificationDetails();
    //   var platform = new NotificationDetails(android1, ios1);
    //   await flutterLocalNotificationsPlugin.show(
    //       0,
    //       'Marks Seem not to be changed',
    //       'Will notify you whenver something will get changed',
    //       platform,
    //       payload: "Anything you say");
    // }
    return Future.value(true);
  });
}

storeData(String username, var res) async {
  List<Subject> li = processText(res);
  DatabaseReference database;
  username = username.replaceAll("/", "");
  for (int i = 0; i < li.length; i++) {
    database = FirebaseDatabase.instance
        .reference()
        .child("test")
        .child(li[i].name)
        .child(username);
    await database.remove();
    await database.push().set({
      "Internal1": li[i].internal1,
      "Midesem": li[i].midsem,
      "Internal2": li[i].internal2,
      "Endsem": li[i].end
    });
  }
  print("FireBase Updation Completed");
  return;
}

List<Subject> processText(String s) {
  String s1 = "";
  List<Subject> li = [];
  for (int i = 0; i < s.length; i++) {
    if (s[i] == "*") {
      li.add(new Subject(s1));
      s1 = "";
      continue;
    }
    s1 += s[i];
  }
  return li;
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  checkIsLoggedIn() async {
    final storage = new FlutterSecureStorage();
    if (await storage.read(key: "username") != null &&
        await storage.read(key: "password") != null) {
      return 1;
    } else
      return 0;
  }

  Widget build(BuildContext context) {
    print("Will Come to build again whenever you opens app");
    return MaterialApp(
        home: Scaffold(
            body: FutureBuilder(
                future: checkIsLoggedIn(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == 1) {
                      //Open the Home Screen of App
                      return HomeScreen();
                    } else {
                      return LoginPage();
                      //Open the logging screen for user
                    }
                    //Check result here
                  } else {
                    return Container();
                  }
                  //Depending on result see which screen to open
                })));
  }
}
