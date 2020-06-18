import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'widgets/Model.dart';

class StatGraph extends StatefulWidget {
  final SubjectStat obj;
  StatGraph({Key key, this.obj}) : super(key: key);

  @override
  _StatGraphState createState() => _StatGraphState();
}

class MyChart {
  String name;
  double val;
  MyChart(this.name, this.val);
}

class _StatGraphState extends State<StatGraph> {
  @override
  SubjectStat li;
  List<charts.Series> data;
  void initState() {
    // TODO: implement initState
    super.initState();
    li = widget.obj;
    data = getChartData(li);
  }

  getChartData(SubjectStat obj) {
    final li1 = [
      MyChart("Internal1", obj.internal1),
      MyChart("MidSem", obj.midsem),
      MyChart("Internal2", obj.internal1),
      MyChart("EndSem", obj.end),
    ];
    final li2 = [
      MyChart("Internal1", obj.ainternal1),
      MyChart("MidSem", obj.amidsem),
      MyChart("Internal2", obj.ainternal1),
      MyChart("EndSem", obj.aend),
    ];
    final li3 = [
      MyChart("Internal1", obj.minternal1),
      MyChart("MidSem", obj.mmidsem),
      MyChart("Internal2", obj.minternal1),
      MyChart("EndSem", obj.mend),
    ];
    return [
      charts.Series<MyChart, String>(
          id: 'Your Marks',
          domainFn: (MyChart obj, _) => obj.name,
          measureFn: (MyChart obj, _) => obj.val,
          data: li1,
          ),
      charts.Series<MyChart, String>(
          id: 'Avg Marks',
          domainFn: (MyChart obj, _) => obj.name,
          measureFn: (MyChart obj, _) => obj.val,
          data: li2),
      charts.Series<MyChart, String>(
          id: 'Max Marks',
          domainFn: (MyChart obj, _) => obj.name,
          measureFn: (MyChart obj, _) => obj.val,
          data: li3),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(li.name,style:TextStyle(color:Colors.grey,fontSize: 25,fontWeight: FontWeight.bold))),
                Center(
                  child: Container(
                    height:MediaQuery.of(context).size.height*0.6,
                    width:MediaQuery.of(context).size.width*0.8,
                      child: charts.BarChart(
      data,
      behaviors: [new charts.SeriesLegend()],
      animate: true,
      vertical: true,

      barGroupingType: charts.BarGroupingType.grouped,
      defaultRenderer: charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.grouped, strokeWidthPx: 1.0),
    )),
                ),
              ],
            ));
  }
}
