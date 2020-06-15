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

  Container getWidget(int i,List<Subject2>li) {
    return Container(
      decoration: BoxDecoration(
 color: Colors.blue[100],
 borderRadius: BorderRadius.circular(20),
 border:Border.all(color:Colors.white,width:5)

      ),
      padding:EdgeInsets.all(10),
      margin: EdgeInsets.all(10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Subject Code ${li[i].code}",textAlign: TextAlign.left,),
          Text("Teacher Name ${li[i].tname}",textAlign: TextAlign.left,),
          Text("Total Classes ${li[i].tclasses}",textAlign: TextAlign.left,),
          Text("Present ${li[i].present}",textAlign: TextAlign.left,),
          Text("Absent ${li[i].absent}",textAlign: TextAlign.left,),
          Text("Percentage ${li[i].percent}",textAlign: TextAlign.left,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color:Colors.black,
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
                      for(int i=0;i<li.length;i++)
                      getWidget(i, li)
                    ],
                  ));
                } else {
                  return Container();
                }
              })),
    );
  }
}
