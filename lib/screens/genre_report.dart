import 'dart:async';
import 'package:film_sales_service/data/dummy.dart';
import 'package:film_sales_service/models/film.dart';
import 'package:film_sales_service/models/genre.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GenreReport extends StatefulWidget {
  @override
  GenreReportState createState() {
    return GenreReportState();
  }
}

class GenreReportState extends State<GenreReport> {
  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "GenreReportState");
  charts.BarChart chart;
  Padding chartWidget;
  List<Film> films = Dummy.FILM_ITEMS;

  @override
  void initState() {
    initialise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 6, right: 6),
                child: Text(
                  "Total Films: ${films?.length ?? 0}",
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 126),
                child: chartWidget,
              ),
            )
          ],
        ),
      ),
    );
  }

  downloadBill() {}

  void initialise() {
    renderChart();
  }

  void renderChart() {
    List<charts.Series<dynamic, String>> series = [];
    List<Genre> genres = films.map<Genre>((Film film) => film.genre).toList();
    series.add(new charts.Series(
      domainFn: (dynamic genre, _) => genre.name,
      measureFn: (dynamic genre, _) =>
          films.where((element) => element.genre == genre).length,
      colorFn: (dynamic film, _) => charts.Color.fromHex(code: "ff00ffff"),
      id: "Genre",
      data: genres,
    ));
    chart = new charts.BarChart(
      series,
      animate: true,
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
            labelStyle: charts.TextStyleSpec(
              fontSize: 8,
            ),
            lineStyle: charts.LineStyleSpec(
                color: charts.Color.fromHex(code: "ffe56a54")),
            axisLineStyle: charts.LineStyleSpec(
                color: charts.Color.fromHex(code: "ffe56a54"))),
        showAxisLine: true,
      ),
    );
    chartWidget = new Padding(padding: EdgeInsets.all(1), child: chart);
  }

  showSnackBar(String text, {int time = 20}) {
    scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(text), duration: Duration(seconds: time)));
  }
}
