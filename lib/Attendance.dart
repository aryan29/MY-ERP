//Main.dart will not decide on which screen he should send
//the app based on whether person is logged in or not
import 'package:flutter/material.dart';
import 'widgets/Model2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceScreen extends StatefulWidget {
  AttendanceScreen({Key key}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  retrieve() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
     await prefs.reload();
    String s = prefs.getString("attendance");
    return {"items": processText(s), "time": prefs.getString("time")};
  }

  List<Subject2> processText(String s) {
    String s1 = "";
    List<Subject2> li = [];
    for (int i = 0; i < s.length; i++) {
      if (s[i] == "*") {
        li.add(new Subject2(s1));
        s1 = "";
        continue;
      }
      s1 += s[i];
    }
    return li;
  }

  Container getWidget(int i, List<Subject2> li) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 5)),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Column(

        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(5.0)),
          Row(
            children: <Widget>[
              Text("Subject code: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  "${li[i].code}",
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.all(5.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Teacher: ", style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  "${li[i].tname}",
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.all(5.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Total classes: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  "${li[i].tclasses}",
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.all(5.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Present: ", style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  "${li[i].present}",
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.all(5.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Absent: ", style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  "${li[i].absent}",
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.all(5.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Percentage: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  "${li[i].percent}",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.black,
          //Retrieve Marks from Shared Preferences String
          //And show them here
          child: FutureBuilder(
              future: retrieve(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Subject2> li = snapshot.data['items'];
                  return Container(
                      child: ListView(
                    children: <Widget>[
                      for (int i = 0; i < li.length; i++) getWidget(i, li)
                    ],
                  ));
                } else {
                  return Container(child:Center(child: CircularProgressIndicator()));
                }
              })),
    );
  }
}
