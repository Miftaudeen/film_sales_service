import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:film_sales_service/data/dummy.dart';
import 'package:film_sales_service/data/formatter.dart';
import 'package:film_sales_service/models/genre.dart';
import 'package:film_sales_service/models/user.dart';
import 'package:film_sales_service/widgets/custom_show_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:validators/validators.dart';

class AddFilm extends StatefulWidget {
  @override
  AddFilmState createState() => AddFilmState();
}

class AddFilmState extends State<AddFilm> {
  BuildContext _context;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;

  String _price;
  String _title;
  String _year;
  String _description;
  String _director;
  String _label;
  String _downloadLink;
  String _banner;

  Genre _genre;

  Future<User> _user;

  List<User> users;

  List<Genre> genres = Dummy.FILM_ITEMS.map((e) => e.genre).toList();

  bool _obscureText = true;

  var _retrieveDataError;

  var _selectedPicture;

  var _pickImageError;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Add Film "),
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
                  child: DropdownButtonFormField<Genre>(
                    value: this._genre,
                    icon: Icon(Icons.expand_more),
                    iconSize: 12,
                    isExpanded: true,
                    hint: Text(
                      "Genre",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    elevation: 8,
                    onChanged: (Genre newValue) {
                      setState(() {
                        this._genre = newValue;
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
                    items: (genres ?? <Genre>[])
                        .map<DropdownMenuItem<Genre>>((Genre value) {
                      return DropdownMenuItem<Genre>(
                        value: value,
                        child: Text(value.name,
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
                      labelText: "Title",
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).hintColor, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    onSaved: (val) => _title = val,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: false),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: DropdownButtonFormField<String>(
                    value: this._year,
                    icon: Icon(Icons.expand_more),
                    iconSize: 12,
                    isExpanded: true,
                    hint: Text(
                      "Year",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    elevation: 8,
                    onChanged: (String newValue) {
                      setState(() {
                        this._year = newValue;
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
                    items: ((List<int>.generate(
                                    100, (i) => DateTime.now().year - i)
                                .map((e) => e.toString())).toList() ??
                            <String>[])
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: Theme.of(context).textTheme.bodyText2),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.bodyText2,
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).hintColor, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    onSaved: (val) => _description = val,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      labelText: "Label",
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).hintColor, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    onSaved: (val) => _label = val,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: false),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      labelText: "Director",
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).hintColor, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    onSaved: (val) => _director = val,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: false),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 50,
                          //margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 42),
                          child: OutlineButton(
                              onPressed: () =>
                                  _onImageButtonPressed(ImageSource.gallery),
                              //shape: CircleBorder(),
                              child: new Text(
                                "Choose Photo",
                              )),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Center(
                          child: Platform.isAndroid
                              ? FutureBuilder<void>(
                                  future: retrieveLostData(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<void> snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                      case ConnectionState.waiting:
                                        return const Text(
                                          'You have not yet picked an image.',
                                          textAlign: TextAlign.center,
                                        );
                                      case ConnectionState.done:
                                        return _previewImage();
                                      default:
                                        if (snapshot.hasError) {
                                          return Text(
                                            'Pick image error: ${snapshot.error}}',
                                            textAlign: TextAlign.center,
                                          );
                                        } else {
                                          return const Text(
                                            'You have not yet picked an image.',
                                            textAlign: TextAlign.center,
                                          );
                                        }
                                    }
                                  },
                                )
                              : (_previewImage()),
                        ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.bodyText2,
                    decoration: InputDecoration(
                      labelText: "Download Link",
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).hintColor, width: 1),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    onSaved: (val) => _downloadLink = val,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: false),
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

  void _onImageButtonPressed(ImageSource source) async {
    try {
      PickedFile imageFile =
          await ImagePicker.platform.pickImage(source: source);
      _selectedPicture = await ImageCropper.cropImage(
          sourcePath: imageFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_selectedPicture != null) {
      return Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: FileImage(
              _selectedPicture,
            ),
          )));
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else if (_banner != null) {
      return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(_banner),
          )));
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await ImagePicker.platform.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _selectedPicture = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  showSnackBar(String text, {int time = 20}) {
    scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(text), duration: Duration(seconds: time)));
  }
}
