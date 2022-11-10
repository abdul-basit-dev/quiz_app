import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? _id;
  late String _firstName;
  late String _lastName;
  late String _phone;
  late String _password;
  late String _email;

  //constructor for add
  UserModel(
    this._firstName,
    this._lastName,
    this._phone,
    this._email,
    this._password,
  );

  //Constructor for edit
  UserModel.withId(
    this._id,
    this._firstName,
    this._lastName,
    this._phone,
    this._email,
    this._password,
  );

  //getters
  String? get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get phone => _phone;
  String get email => _email;
  String get getPassword => _password;

  //Setters
  set setFirstName(String firstName) {
    _firstName = firstName;
  }

  set setLastName(String lastName) {
    _lastName = lastName;
  }

  set setPhone(String phone) {
    _phone = phone;
  }

  set setEmail(String email) {
    _email = email;
  }

  set setPassword(String pass) {
    _password = pass;
  }

//Converting snapshot back to class object
  UserModel.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _id = (snapshot.value as dynamic)["id"];
    _firstName = (snapshot.value as dynamic)["firstName"];
    _lastName = (snapshot.value as dynamic)["lastName"];
    _password = (snapshot.value as dynamic)["password"];
    _phone = (snapshot.value as dynamic)["phone"];
    _email = (snapshot.value as dynamic)["email"];
  }

//Converting class object to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": _id,
      "firstName": _firstName,
      "lastName": _lastName,
      "password": _password,
      "phone": _phone,
      "email": _email,
    };
  }
}
