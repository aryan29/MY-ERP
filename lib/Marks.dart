//Main.dart will not decide on which screen he should send
//the app based on whether person is logged in or not
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    await prefs.reload();
    String s = prefs.getString("marks");
    String time = prefs.getString("time");
    // print(time);
    return {"items": processText(s), "time": time};
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

  Container getWidget(int i, List<Subject> li) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.white, width: 5),
          // color: Colors.blue[100],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(
                0.8, 0.0), // 10% of the width, so there are ten blinds.
            colors: [
              // Colors.greenAccent,
              Colors.yellow[400],
              Colors.yellow[600],
            ], // whitish to gray
            tileMode: TileMode.clamp,
          )),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(10.0)),
          Row(
            children: <Widget>[
              Text("Subject code: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                "${li[i].code}",
              ),
            ],
          ),
          Padding(padding: EdgeInsets.all(10.0)),

          // constraints: BoxConstraints(maxWidth: 200),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Subject: ", style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  "${li[i].name}",
                ),
              ),
            ],
          ),

          Padding(padding: EdgeInsets.all(10.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Internal",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    "${li[i].internal1}",
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text("Midsem", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    "${li[i].midsem}",
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text("Internal2",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    "${li[i].internal2}",
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text("Endsem", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    "${li[i].end}",
                  ),
                ],
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
          // color: Colors.black,
          //Retrieve Marks from Shared Preferences String
          //And show them here
          child: FutureBuilder(
              future: retrieve(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Subject> li = snapshot.data['items'];
                  return CustomScrollView(slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      //  leading: Container(),
                      elevation: 20.0,
                      iconTheme: IconThemeData(color: Colors.black),
                      expandedHeight: 100,
                      pinned: true,
                      floating: false,
                      backgroundColor: Colors.indigo,
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(45.0),
                              bottomRight: Radius.circular(45.0))),
                      // elevation: 20.0,
                      flexibleSpace: FlexibleSpaceBar(
                        title: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "MY ",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              TextSpan(
                                  text: "Marks",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ])),
                      ),
                    ),
                    SliverList(
                        // crossAxisCount: 1,
                        delegate: SliverChildBuilderDelegate(
                      // padding: const EdgeInsets.all(10.0),
                      (context, index) {
                        return getWidget(index, li);
                      },
                      childCount: li.length,
                    )),
                  ]);
                } else {
                  return Container(
                      child: Center(child: CircularProgressIndicator()));
                }
              })),
    );
  }
}
