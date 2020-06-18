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
  Subject.fromData() {
    code = "";
    name = "";
    internal1 = "";
    midsem = "";
    internal2 = "";
    end = "";
  }
}

class SubjectStat {
  String name;
  double internal1, midsem, internal2, end;
  int cint1, cmid, cint2, cend;
  double ainternal1, amidsem, ainternal2, aend;
  double minternal1, mmidsem, minternal2, mend;
  SubjectStat() {
    internal1 = 0;
    midsem = 0;
    internal2 = 0;
    end = 0;
    cint1 = 0;
    cmid = 0;
    cint2 = 0;
    cend = 0;
    ainternal1 = 0;
    amidsem = 0;
    ainternal2 = 0;
    aend = 0;
    minternal1 = 0;
    mmidsem = 0;
    minternal2 = 0;
    mend = 0;
  }
}
