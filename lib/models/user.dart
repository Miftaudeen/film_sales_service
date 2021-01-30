import 'package:film_sales_service/models/roles.dart';

import 'gender.dart';

class User {
  String name;
  String email;
  String address;
  String dateOfBirth;
  String phoneNumber;
  Role role;
  String password;
  Gender gender;
  String photo;

  User(
      {this.name,
      this.email,
      this.photo,
      this.address,
      this.dateOfBirth,
      this.phoneNumber,
      this.role,
      this.gender,
      this.password});
}
