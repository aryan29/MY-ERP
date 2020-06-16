import 'package:flutter/material.dart';

class Bloc extends ChangeNotifier {
  // static String time;
  static ValueNotifier val = ValueNotifier(false);
  static void changeVal() {
    val.value = !val.value;
    val.notifyListeners();
  }
}
