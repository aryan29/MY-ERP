import 'package:ERPApp/homeScreen.dart';

import 'FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'widgets/entryFields.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'blocs/bloc1.dart';
import 'package:workmanager/workmanager.dart';
import 'script.dart';
import 'package:firebase_database/firebase_database.dart';
import 'widgets/Model.dart';

bool onPressed = false;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

storeData(String username, var res) async {
  print("Inside Store Data");
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

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      body: Builder(builder: (context) {
        return Scaffold(
          body: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FadeAnimation(
                    1.2,
                    Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(
                  height: 30,
                ),
                FadeAnimation(
                    1.5,
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        children: <Widget>[
                          EntryField(text: "Username"),
                          EntryField(text: "Password"),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 40,
                ),
                FadeAnimation(
                    1.8,
                    Center(
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            onPressed = true;
                          });
                          print("Tapped");
                          String username = store.get("Username");
                          String pass = store.get("Password");
                          var res = await getToken(username, pass);
                          if (res != "") {
                            await storeData(username, res["marks"]);
                            SharedPreferences _prefs =
                                await SharedPreferences.getInstance();
                            SharedPreferences prefs = await _prefs;
                            await prefs.setString("marks", res["marks"]);
                            await prefs.setString(
                                "attendance", res["attendance"]);
                            final storage = new FlutterSecureStorage();
                            await storage.write(
                                key: "username", value: username);
                            await storage.write(key: "password", value: pass);
                            await Workmanager.registerPeriodicTask(
                                "2", "simplePeriodicTask",
                                frequency: Duration(minutes: 3),
                                existingWorkPolicy: ExistingWorkPolicy.replace
                                //Now send the person to homeScreen
                                );

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          } else {
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Something Went Wrong")));
                            //Show in Snack Bar that something went wrong
                            print("Something went wrong");
                          }
                          setState(() {
                            onPressed = false;
                          });
                        },
                        child: Container(
                          width: 120,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue[800]),
                          child: Center(
                              child: (onPressed)
                                  ? CircularProgressIndicator()
                                  : Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(.7)),
                                    )),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        );
      }),
    );
  }
}
