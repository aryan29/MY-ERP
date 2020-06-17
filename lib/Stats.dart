import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'widgets/Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

class Stats extends StatefulWidget {
  Stats({Key key}) : super(key: key);

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  bool check(String s) {
    return s != "-";
  }

  retrieve() async {
    DatabaseReference database;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    await prefs.reload();
    String s = prefs.getString("marks");
    List<Subject> li = processText(s);
    List<SubjectStat> data = new List();
    for (int i = 0; i < li.length; i++) {
      SubjectStat obj = new SubjectStat();

      String name = li[i].name;
      obj.name = name;

      print(name);
      database =
          FirebaseDatabase.instance.reference().child("test").child(li[i].name);
      var snapshot = await database.once();
      var res = snapshot.value.values as Iterable;
      for (var item in res) {
        print("here");
        var yo = item.values.elementAt(0);
        print(yo['Midesem']);
        if (check(yo['Midesem'])) {
          // print("here");
          obj.midsem += double.tryParse(yo['Midesem']);
          obj.cmid++;
          obj.mmidsem = max(obj.mmidsem, double.tryParse(yo['Midesem']));
        }
        if (check(yo['Endsem'])) {
          obj.end += double.tryParse(yo['Endsem']);
          obj.cend++;
          obj.mend = max(obj.mend, double.tryParse(yo['Endsem']));
        }
        if (check(yo['Internal1'])) {
          obj.internal1 += double.tryParse(yo['Internal1']);
          obj.cint1++;
          obj.minternal1 = max(obj.minternal1, double.tryParse(yo['Internal1']));
        }
        if (check(yo['Internal2'])) {
          obj.internal2 += double.tryParse(yo['Internal2']);
          obj.cint2++;
          obj.minternal2 = max(obj.minternal2, double.tryParse(yo['Internal2']));
        }
      }
      // Work Done for all users for particular subject
      if (obj.cmid != 0) {
        obj.amidsem = (obj.midsem / obj.cmid);
      }
      if (obj.cend != 0) {
        obj.aend = (obj.end / obj.cend);
      }
      if (obj.cint1 != 0) {
        obj.ainternal1 = (obj.internal1 / obj.cint1);
      }
      if (obj.cint2 != 0) {
        obj.ainternal2 = (obj.internal2 / obj.cint2);
      }
      if(check(li[i].internal1))
      obj.internal1 = double.tryParse(li[i].internal1);
      if(check(li[i].midsem))
      obj.midsem = double.tryParse(li[i].midsem);
      if(check(li[i].internal2))

      obj.internal2 = double.tryParse(li[i].internal2);
      if(check(li[i].end))
      obj.end = double.tryParse(li[i].end);
      //Work for one subject done
      print("Work done");
      data.add(obj);
    }
    print(data);
    return data;
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

  Container getWidget(int i, List<SubjectStat> li) {
    return Container(

      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.white, width: 5),
        color: Colors.blue[100],
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Subject Name:- ${li[i].name}"),
          Text("Your Internal1 Marks:- ${li[i].internal1}"),
          Text("Average Internal1  Marks:- ${li[i].ainternal1}"),
          Text("Maximum Internal1 Marks:- ${li[i].minternal1}"),
          Text("Your Midsem Marks:- ${li[i].midsem}"),
          Text("Average Midsem Marks:- ${li[i].amidsem}"),
          Text("Maximum Midsem Marks:- ${li[i].mmidsem}"),
          Text("Your Internal2 Marks:- ${li[i].internal2}"),
          Text("Average Inernal2 Marks:- ${li[i].ainternal2}"),
          Text("Maximum Internal2 Marks:- ${li[i].minternal2}"),
          Text("Your EndSem Marks:- ${li[i].end}"),
          Text("Average EndSem Marks:- ${li[i].aend}"),
          Text("Maximum EndSem Marks:- ${li[i].mend}"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:BoxDecoration(
          color:Colors.black
        ),
          child: FutureBuilder(
        future: retrieve(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<SubjectStat> li = snapshot.data;
            return ListView.builder(
              // crossAxisCount: 1,
              itemCount: li.length,
              padding: const EdgeInsets.all(10.0),

              itemBuilder: (context, index) {
                return getWidget(index, li);
              },
            );
          } else
            return Container(child: Center(child: CircularProgressIndicator()));
        },
      )),
    );
  }
}
