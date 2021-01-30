import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:film_sales_service/data/formatter.dart';
import 'package:film_sales_service/models/roles.dart';
import 'package:film_sales_service/models/user.dart';
import 'package:film_sales_service/widgets/custom_show_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class SignUp extends StatefulWidget {
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  BuildContext _context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  String _effectiveDate;
  String _emailAddress;
  String _dateOfBirth;
  String _address;
  String _name;
  String _phoneNumber;
  String _password;
  String _confirmPassword;

  Role _role;

  Future<User> _user;

  List<User> users;

  List<Role> roles = [Role.admin, Role.customer];

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Register"),
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
                  child: DropdownButtonFormField<Role>(
                    value: this._role,
                    icon: Icon(Icons.expand_more),
                    iconSize: 12,
                    isExpanded: true,
                    hint: Text(
                      "Role",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    elevation: 8,
                    onChanged: (Role newValue) {
                      setState(() {
                        this._role = newValue;
                      });
                    },
                    validator: (val) =>
                        val == null ? "This field cannot be empty" : null,
                    decoration: InputDecoration(
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).hintColor, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    items: (roles ?? <Role>[])
                        .map<DropdownMenuItem<Role>>((Role value) {
                      return DropdownMenuItem<Role>(
                        value: value,
                        child: Text(value.toString().toUpperCase(),
                            style: Theme.of(context).textTheme.bodyText2),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.bodyText2,
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
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: DateTimePicker(
                    type: DateTimePickerType.date,
                    style: Theme.of(context).textTheme.bodyText2,
                    dateMask: 'yyyy/MM/dd',
                    decoration: InputDecoration(
                      labelText: "Date of Birth",
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).hintColor, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    //initialValue: _initialValue,
                    firstDate: DateTime.utc(DateTime.now().year - 200),
                    lastDate: DateTime.utc(DateTime.now().year - 12),
                    icon: Icon(Icons.event),
                    validator: (val) => isDate(val) ? null : "Invalid Date",
                    dateLabelText: 'Date of Birth',
                    onSaved: (val) => setState(() => _dateOfBirth = val),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).hintColor, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    onSaved: (val) => _name = val,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.bodyText2,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).hintColor, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    onSaved: (val) => _phoneNumber = val,
                  ),
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
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
                      labelText: "Confirm Password",
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
