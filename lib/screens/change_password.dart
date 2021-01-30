import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:film_sales_service/data/formatter.dart';
import 'package:film_sales_service/models/roles.dart';
import 'package:film_sales_service/models/user.dart';
import 'package:film_sales_service/widgets/custom_show_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class ChangePasswordPage extends StatefulWidget {
  final User user;

  const ChangePasswordPage({Key key, this.user}) : super(key: key);
  @override
  ChangePasswordPageState createState() => ChangePasswordPageState(this.user);
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  BuildContext _context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  final User user;

  String _emailAddress;
  String _address;
  String _oldPassword;
  String _password;
  String _confirmPassword;

  Role _role;

  Future<User> _user;

  List<User> users;

  List<Role> roles = [Role.admin, Role.customer];

  bool _obscureText = true;

  ChangePasswordPageState(this.user);

  @override
  Widget build(BuildContext context) {
    _context = context;
    _emailAddress = user?.email;
    _address = user?.address;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Change Password"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.bodyText2,
                    initialValue: _emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).hintColor, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    onSaved: (val) => _emailAddress = val,
                    validator: (value) {
                      if (!isEmail(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: false),
                  ),
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Old Password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          _toggle();
                        },
                      ),
                    ),
                    obscureText: _obscureText,
                    onSaved: (val) => _oldPassword = val,
                    validator: (val) =>
                        val.trim() != "" ? null : "Password can't be empty",
                  ),
                  margin: EdgeInsets.symmetric(vertical: 15),
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "New Password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          _toggle();
                        },
                      ),
                    ),
                    obscureText: _obscureText,
                    onSaved: (val) => _password = val,
                    validator: (val) =>
                        val.trim() != "" ? null : "Password can't be empty",
                  ),
                  margin: EdgeInsets.symmetric(vertical: 15),
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Confirm New Password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          _toggle();
                        },
                      ),
                    ),
                    obscureText: _obscureText,
                    onSaved: (val) => _confirmPassword = val,
                    validator: (val) => val.trim() == _password
                        ? null
                        : "Password does not match",
                  ),
                  margin: EdgeInsets.symmetric(vertical: 15),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Container(
                          width: 276,
                          height: 50,
                          margin: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 42),
                          child: MaterialButton(
                            onPressed: () => _submit(),
                            shape: CircleBorder(),
                            child: new Text(
                              "SUBMIT",
                              style: new TextStyle(color: Colors.white),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _submit() async {
    setState(() {
      _isLoading = true;
    });
    final form = formKey.currentState;
    if (form.validate()) {
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  showSnackBar(String text, {int time = 20}) {
    scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(text), duration: Duration(seconds: time)));
  }
}
