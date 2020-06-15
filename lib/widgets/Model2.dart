class Subject2{
  String code, tname, tclasses, present,absent,percent;
  Subject2(String s) {
    int c = 0;
    code = "";
    tname = "";
    tclasses = "";
    present = "";
    absent = "";
    percent = "";
    for (int i = 0; i < s.length; i++) {
      if (s[i] == '&') {
        c++;
        continue;
      }
      if (c == 0)
        code += s[i];
      else if (c == 1)
        tname += s[i];
      else if (c == 2)
         tclasses+= s[i];
      else if (c == 3)
        present += s[i];
      else if (c == 4)
        absent += s[i];
      else if (c == 5) percent += s[i];
    }
  }
}
