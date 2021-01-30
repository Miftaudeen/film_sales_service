import 'dart:io';

import 'package:film_sales_service/data/dummy.dart';
import 'package:film_sales_service/models/film.dart';
import 'package:film_sales_service/models/gender.dart';
import 'package:film_sales_service/models/roles.dart';
import 'package:film_sales_service/models/user.dart';
import 'package:film_sales_service/widgets/side_nav_widget.dart';
import 'package:film_sales_service/widgets/video_item.dart';
import 'package:flutter/material.dart';

import 'add_film.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BuildContext _context;

  var billInfo;
  TextEditingController controller;
  var dashboardComplaints;

  var messageInfo;

  var expectedVisitor;

  dynamic imageURLs;

  dynamic estateInfo;

  String filter;

  var isLoading = false;
  bool endReached = false;
  bool startReached = true;
  var walletBalance;

  @override
  void initState() {
    controller = TextEditingController();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    User user = User(
      name: "John Doe",
      phoneNumber: "+2348098775671",
      email: "johndoe@gmail.com",
      photo: "assets/images/profile_pic.jpg",
      role: Role.admin,
      gender: Gender.male,
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Film Sales Service"),
      ),
      drawer: SideNavWidget(
        user: user,
      ),
      floatingActionButton: user.role == Role.admin
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddFilm())),
            )
          : null,
      body: ListView(children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 80,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Color(0xffeeeeee),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffeeeeee)),
                  borderRadius: BorderRadius.circular(25.7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(25.7),
                ),
                labelText: "Find Film"),
            controller: controller,
          ),
        ),
        filter == null || filter == ""
            ? getFilms(textTheme, user)
            : getFilteredFilmItems(textTheme, filter, user),
      ]),
    );
  }

  Widget getFilms(TextTheme textTheme, User user) {
    return Column(
        children: Dummy.FILM_ITEMS
            .map<Widget>((Film film) => VideoItem(
                  film: film,
                  user: user,
                ))
            .toList());
  }

  getFilteredFilmItems(TextTheme textTheme, String filter, User user) {
    return Column(
        children: Dummy.FILM_ITEMS
            .where((Film film) =>
                film.title.toLowerCase().contains(filter.toLowerCase()))
            .map<Widget>((Film film) => VideoItem(
                  film: film,
                  user: user,
                ))
            .toList());
  }
}
