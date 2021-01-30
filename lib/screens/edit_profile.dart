import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:film_sales_service/data/formatter.dart';
import 'package:film_sales_service/models/roles.dart';
import 'package:film_sales_service/models/user.dart';
import 'package:film_sales_service/widgets/custom_show_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class EditProfile extends StatefulWidget {
  final User user;

  const EditProfile({Key key, this.user}) : super(key: key);
  @override
  EditProfileState createState() => EditProfileState(this.user);
}

class EditProfileState extends State<EditProfile> {
  BuildContext _context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  final User user;

  String _emailAddress;
  String _dateOfBirth;
  String _address;
  String _name;
  String _phoneNumber;
  String _oldPassword;
  String _password;
  String _confirmPassword;

  Role _role;

  Future<User> _user;

  List<User> users;

  List<Role> roles = [Role.admin, Role.customer];

  bool _obscureText = true;

  EditProfileState(this.user);

  @override
  Widget build(BuildContext context) {
    _context = context;
    _role = user.role;
    _name = user.name;
    _emailAddress = user.email;
    _dateOfBirth = user.dateOfBirth;
    _address = user.address;
    _phoneNumber = user.phoneNumber;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Edit Profile"),
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
                  child: DateTimePicker(
                    type: DateTimePickerType.date,
                    style: Theme.of(context).textTheme.bodyText2,
                    initialValue: _dateOfBirth,
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
                    initialValue: _name,
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
                    initialValue: _address,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Address",
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).hintColor, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    onSaved: (val) => _address = val,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.bodyText2,
                    initialValue: _phoneNumber,
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
