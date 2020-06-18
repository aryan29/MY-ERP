//Main.dart will not decide on which screen he should send
//the app based on whether person is logged in or not
import 'package:flutter/material.dart';
import 'Marks.dart';
import 'Stats.dart';
import 'Attendance.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    print("Building homescreen");
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 90),
          Text(
            "MY ERP",
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.indigo[900],
                    Colors.indigo[600],
                  ]),
              borderRadius: BorderRadius.only(topRight: Radius.circular(80.0)),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: () async {
                      //Check Button for now
                      //Will delete everything
                      // SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();
                      // prefs.clear();InkWell
                      // FlutterSecureStorage f = FlutterSecureStorage();
                      // await f.deleteAll();
                      // Workmanager.cancelAll();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AttendanceScreen()));
                    },
                    child: Container(
                        height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3.0)),
                        child: Center(
                            child: Text("View Attendance",
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800)))),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MarksScreen()));
                    },
                    child: Container(
                        height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                            child: Text("View Marks",
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800)))),
                  ),
                  InkWell(
                    onTap: () {
                      print("Will take you to stats screen");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Stats()));
                    },
                    splashColor: Colors.grey,
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        height: 70,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Center(
                            child: Text("Marks Statistics",
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800)))),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
