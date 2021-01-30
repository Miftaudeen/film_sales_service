import 'dart:ui';

import 'package:film_sales_service/models/roles.dart';
import 'package:film_sales_service/models/user.dart';
import 'package:film_sales_service/screens/change_password.dart';
import 'package:film_sales_service/screens/home_page.dart';
import 'package:film_sales_service/screens/login.dart';
import 'package:film_sales_service/screens/profile.dart';
import 'package:film_sales_service/screens/report_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideNavWidget extends StatelessWidget {
  BuildContext _context;

  var _pickImageError;

  User user;
  SideNavWidget({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Drawer(
        child: Column(children: <Widget>[
      UserAccountsDrawerHeader(
        accountName: Text(user.name),
        accountEmail: Text(user.email),
      ),
      ListTile(
        leading: Icon(Icons.home),
        title: Text('Home'),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomePage())),
      ),
      ListTile(
        leading: Icon(Icons.person),
        title: Text('Profile'),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Profile(
                  user: user,
                ))),
      ),
      ListTile(
        leading: Icon(Icons.shopping_cart),
        title: Text('Purchases'),
        onTap: () => {Navigator.of(context).pop()},
      ),
      user.role == Role.admin
          ? ListTile(
              leading: Icon(Icons.analytics),
              title: Text('Report'),
              onTap: () => {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => ReportPage()))
              },
            )
          : Container(),
      Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.white, width: 2)),
            color: Color(0xffff0000),
          ),
          child: ListTile(
            leading: new Icon(
              Icons.close,
              color: Colors.white,
            ),
            title: new Text(
              "Log out",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => logout(context),
          )),
      Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.white, width: 2)),
            color: Color(0xcc113445),
          ),
          child: ListTile(
            leading: new Icon(
              Icons.autorenew,
              color: Colors.white,
            ),
            title: new Text(
              "Change Password",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => changePassword(user),
          )),
    ]));
  }

  logout(BuildContext context) async {
    Navigator.pushAndRemoveUntil(_context,
        MaterialPageRoute(builder: (context) => SignIn()), (_) => false);
  }

  launchURL(String url) async {
//    if (await canLaunch(url)) {
//      launch(url,
//          forceWebView: true, forceSafariVC: true, enableJavaScript: true);
//    } else {
//      print("Cannot launch url");
//    }
  }

  changePassword(User user) {
    Navigator.push(
        _context,
        MaterialPageRoute(
            builder: (context) => ChangePasswordPage(
                  user: user,
                )));
  }
}
