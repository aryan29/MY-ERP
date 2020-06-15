//Main.dart will not decide on which screen he should send
//the app based on whether person is logged in or not
import 'package:flutter/material.dart';
import 'Marks.dart';
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
    return Scaffold(
      body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  //Check Button for now
                  //Will delete everything
                  // SharedPreferences prefs =
                  //     await SharedPreferences.getInstance();
                  // prefs.clear();
                  // FlutterSecureStorage f = FlutterSecureStorage();
                  // await f.deleteAll();
                  // Workmanager.cancelAll();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AttendanceScreen()));
                },
                child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            spreadRadius: 1.0,
                            blurRadius: 5.0)
                      ],
                      borderRadius: BorderRadius.circular(150),
                    ),
                    child: Center(
                        child: Text("View Attendance",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)))),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MarksScreen()));
                },
                child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            spreadRadius: 1.0,
                            blurRadius: 5.0)
                      ],
                      borderRadius: BorderRadius.circular(150),
                    ),
                    child: Center(
                        child: Text("View Marks",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)))),
              )
            ],
          )),
    );
  }
}
