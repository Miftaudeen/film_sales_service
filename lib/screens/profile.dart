import 'package:film_sales_service/data/formatter.dart';
import 'package:film_sales_service/models/user.dart';
import 'package:film_sales_service/widgets/side_nav_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'edit_profile.dart';

class Profile extends StatefulWidget {
  final User user;

  const Profile({Key key, this.user}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState(this.user);
}

class _ProfileState extends State<Profile> {
  User user;

  _ProfileState(this.user);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("User Profile"),
        ),
        drawer: SideNavWidget(
          user: user,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EditProfile(user: user))),
          child: Icon(Icons.edit),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 26, vertical: 20),
          child: ListView(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin:
                      EdgeInsets.only(top: 10, left: 10, right: 20, bottom: 5),
                  child: user?.photo == null
                      ? CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: size.width / 6,
                          foregroundColor: Colors.white,
                          backgroundImage: AssetImage(
                            "assets/images/profile_pic.jpg",
                          ))
                      : CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: size.width / 6,
                          foregroundColor: Colors.white,
                          backgroundImage: AssetImage(
                            user?.photo,
                          )),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${user?.name ?? ""}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${user?.role ?? ""}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: size.width * 0.4,
                    child: Text(
                      "Gender:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(user?.gender?.toString()?.toUpperCase() ?? ""),
                ],
              ),
              Divider(
                thickness: 1.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: size.width * 0.4,
                    child: Text(
                      "Address:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    width: size.width * 0.4,
                    child: Text(
                      user?.address ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 1.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: size.width * 0.4,
                    child: Text(
                      "Phone Number:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${user?.phoneNumber ?? ""}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 1.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: size.width * 0.4,
                    child: Text(
                      "Date of Birth:",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  user?.dateOfBirth == null
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${Formatter.getDate(user?.dateOfBirth) ?? ""}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ));
  }
}
