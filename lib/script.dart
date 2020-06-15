import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

Future getToken(String username, String pass) async {
  try {
    String toBeStored = "";
    String toBeStored2 = "";
    Dio dio = new Dio();
    final CookieJar cookieJar = new CookieJar();
    Directory dir = await getApplicationDocumentsDirectory();
    dio.interceptors.add(CookieManager(cookieJar));
    var res = await dio.get("https://erp.bitmesra.ac.in");
    String doc = res.data;
    var soup = parse(res.data);
    String z = soup.getElementById("__VIEWSTATE").attributes['value'];
    String z1 = soup.getElementById("__VIEWSTATEGENERATOR").attributes['value'];
    res = await dio.get("https://erp.bitmesra.ac.in/GenerateCaptcha.ashx",
        options:
            Options(responseType: ResponseType.bytes, followRedirects: false));
    File file = new File('${dir.path}/captcha.png');
    file.writeAsBytesSync(res.data);
    // file.copy("/storage/emulated/0/captcha.png");
    FormData formData = FormData.fromMap({
      "apikey": "da8546ce3d88957",
      "filetype": "PNG",
      "language": "eng",
      "file": await MultipartFile.fromFile(file.path)
    });
    res = await dio.post("https://api.ocr.space/parse/image", data: formData);
    String captcha = res.data["ParsedResults"][0]["ParsedText"];
    captcha = captcha.trim();
    print(captcha);
    formData = FormData.fromMap({
      "Script_water_HiddenField":
          ";;AjaxControlToolkit,+Version=3.0.20229.20843,+Culture=neutral,+PublicKeyToken=28f01b0e84b6d53e:en-US:3b7d1b28-161f-426a-ab77-b345f2c428f5:e2e86ef9:1df13a87:8ccd9c1b",
      "__EVENTTARGET": "btnSubmit",
      "__EVENTARGUMENT": "",
      "__VIEWSTATE": z,
      "__VIEWSTATEGENERATOR": z1,
      "txt_username": username,
      "txt_password": pass,
      "txtcaptcha": captcha,
      "txtName": "",
      "txt_emailid": "",
      "txt_captcha": "",
      "TextBoxWatermarkExtender3_ClientState": "",
      "TextBoxWatermarkExtender2_ClientState": "",
      "TextBoxWatermarkExtender1_ClientState": "",
      "txt_captcha_TextBoxWatermarkExtender_ClientState": "",
    });
    String url =
        "https://erp.bitmesra.ac.in/iitmsv4eGq0RuNHb0G5WbhLmTKLmTO7YBcJ4RHuXxCNPvuIw=?%2fdefault.aspx/";
    res = await dio.post(url, data: formData, options: Options(
      validateStatus: (status) {
        return status < 450;
      },
    ));
    res = await dio.get(
        "https://erp.bitmesra.ac.in/Academic/iitmsPFkXjz+EbtRodaXHXaPVt3dlW3oTGB+3i1YZ7alodHeRzGm9eTr2C53AU6tMBXuOAm5RgR4bqtOVgfGG9isuhw==?enc=3Q2Y1k5BriJsFcxTY7ebQh0hExMANhAKSl1CmxvOF+Y=");
    soup = parse(res.data);
    // sleep(new Duration(seconds: 1));
    var listMarks = soup
        .getElementById("ctl00_ContentPlaceHolder1_grdExaMarDetl")
        .children[0]
        .children;
    for (int i = 1; i < listMarks.length; i++) {
      var col = listMarks[i].children;
      for (int j = 0; j < col.length; j++) {
        toBeStored += col[j].text.trim() + "&";
      }
      toBeStored += "*";
    }
    var listAttendance = soup.getElementById("div3").children[0].children[0].children[1].children;
    // print(listAttendance);

    for (int i = 0; i < listAttendance.length; i++) {
      var col = listAttendance[i].children;
      for (int j = 0; j < col.length; j++) {
        toBeStored2 += col[j].text.trim() + "&";
      }
      toBeStored2 += "*";
    }
    // print(toBeStored2);

    return {"marks": toBeStored, "attendance": toBeStored2};
  } catch (e) {
    print("Error Occured on Opening BIT Mesra Website");
    print(e);
    return "";
  }
}
