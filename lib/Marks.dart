//Main.dart will not decide on which screen he should send
//the app based on whether person is logged in or not
import 'package:flutter/material.dart';
import 'widgets/Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarksScreen extends StatefulWidget {
  MarksScreen({Key key}) : super(key: key);

  @override
  _MarksScreenState createState() => _MarksScreenState();
}

class _MarksScreenState extends State<MarksScreen> {
  retrieve() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    String s = prefs.getString("marks");
    return {"items": processText(s), "time": prefs.getString("time")};
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

  Container getWidget(int i,List<Subject>li) {
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
          Text("Subject Name ${li[i].name}",textAlign: TextAlign.left,),
          Text("Internal1 ${li[i].internal1}",textAlign: TextAlign.left,),
          Text("Midsem ${li[i].midsem}",textAlign: TextAlign.left,),
          Text("Internal2 ${li[i].internal2}",textAlign: TextAlign.left,),
          Text("End Sem Marks ${li[i].end}",textAlign: TextAlign.left,)
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
                  List<Subject> li = snapshot.data['items'];
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
