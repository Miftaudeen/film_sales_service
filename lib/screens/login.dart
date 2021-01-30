import 'package:film_sales_service/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

import 'home_page.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _errorMessage = "";

  bool _isLoading;

  var _obscureText = true;
  String _baseURL;

  var scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _textFieldController = TextEditingController();

  String _customer;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container();
  }

  Widget _showForm() {
    Size size = MediaQuery.of(context).size;
    return new Container(
        padding: EdgeInsets.all(20.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.width * 0.95,
                  margin: EdgeInsets.only(top: 20),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      "Film Sales Service",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color(0xffA6AAB4)),
                    ),
                  ),
                ),
              ),
              showEmailInput(),
              showPasswordInput(),
              Align(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  onPressed: () => null,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: Color(0xff5564B8)),
                  ),
                ),
              ),
              showPrimaryButton(size),
              showSecondaryButton(size),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showEmailInput() {
    return Container(
      child: TextFormField(
        decoration:
            InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email)),
        validator: (value) {
          if (!isEmail(value)) {
            return 'Please enter a valid email address';
          }
          return null;
        },
        onSaved: (val) {
          setState(() {
            _email = val.trim();
          });
        },
      ),
      margin: EdgeInsets.symmetric(vertical: 25),
    );
  }

  Widget showPasswordInput() {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "Password",
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _obscureText ? Icons.visibility_off : Icons.visibility,
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
        validator: (val) => val.trim() != "" ? null : "Password can't be empty",
      ),
      margin: EdgeInsets.symmetric(vertical: 15),
    );
  }

  Widget showPrimaryButton(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: MaterialButton(
        onPressed: () => signIn(),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        color: Color(0xff5564B8),
        minWidth: size.width * 0.9,
        child: Text(
          "Sign in",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget showSecondaryButton(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: MaterialButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUp())),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        color: Color(0xff5564B8),
        minWidth: size.width * 0.9,
        child: Text(
          "Create an account",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
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

  signIn() async {
    final _formState = _formKey.currentState;
    setState(() {
      _isLoading = true;
    });
    if (_formState.validate()) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      showErrorMessage();
      setState(() {
        _isLoading = false;
      });
    }
  }
}
