import 'package:film_sales_service/screens/genre_report.dart';
import 'package:film_sales_service/screens/monthly_report.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  final int selectedTab;

  const ReportPage({Key key, this.selectedTab}) : super(key: key);
  @override
  _ReportPageState createState() => _ReportPageState(this.selectedTab);
}

class _ReportPageState extends State<ReportPage> with TickerProviderStateMixin {
  BuildContext _context;

  var tabWidgets = List<Widget>();
  int selectedTabIndex = 0;
  TabController tabController;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  _ReportPageState(this.selectedTabIndex);

  void onTabSelected(int index) {
    tabController.animateTo(index);
    setState(() {
      selectedTabIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    tabWidgets = <StatefulWidget>[GenreReport(), MonthlyReport()];
    tabController = new TabController(vsync: this, length: tabWidgets.length);
    tabController.animateTo(0);
    tabController.addListener(() {
      setState(() {
        selectedTabIndex = tabController.index;
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(getTitle(selectedTabIndex)),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 10, left: 6, right: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 180,
                      height: 32,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: MaterialButton(
                        onPressed: () => onTabSelected(0),
                        shape: CircleBorder(),
                        child: new Text(
                          "Genres Report",
                          style: selectedTabIndex == 0
                              ? TextStyle(color: Colors.white)
                              : new TextStyle(
                                  color: Theme.of(context).accentColor),
                        ),
                      ),
                      decoration: selectedTabIndex == 0
                          ? BoxDecoration(
                              color: Color(0xffe56a54),
                              borderRadius: BorderRadius.circular(15),
                            )
                          : BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).hintColor, width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                    ),
                    Container(
                      width: 180,
                      height: 32,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: MaterialButton(
                        onPressed: () => onTabSelected(1),
                        shape: CircleBorder(),
                        child: new Text(
                          "Monthly Report",
                          style: selectedTabIndex == 1
                              ? TextStyle(color: Colors.white)
                              : new TextStyle(
                                  color: Theme.of(context).accentColor),
                        ),
                      ),
                      decoration: selectedTabIndex == 1
                          ? BoxDecoration(
                              color: Color(0xffe56a54),
                              borderRadius: BorderRadius.circular(15),
                            )
                          : BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).hintColor, width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                    ),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                child: new TabBarView(
                  controller: tabController,
                  children: tabWidgets,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showSnackBar(String text, {int time = 20}) {
    scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(text), duration: Duration(seconds: time)));
  }

  getTitle(int selectedTabIndex) {
    switch (selectedTabIndex) {
      case 1:
        return "Monthly Report";
      default:
        return "Genres Report";
    }
  }
}
