class Subject {
  String code, name, internal1, midsem, internal2, end;
  Subject(String s) {
    int c = 0;
    code = "";
    name = "";
    internal1 = "";
    midsem = "";
    internal2 = "";
    end = "";
    for (int i = 0; i < s.length; i++) {
      if (s[i] == '&') {
        c++;
        continue;
      }
      if (c == 0)
        code += s[i];
      else if (c == 1)
        name += s[i];
      else if (c == 2)
        internal1 += s[i];
      else if (c == 3)
        midsem += s[i];
      else if (c == 4)
        internal2 += s[i];
      else if (c == 5) end += s[i];
    }
  }
}
