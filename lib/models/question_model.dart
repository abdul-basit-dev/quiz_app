import 'package:firebase_database/firebase_database.dart';

class QuestionModel {
  String? _id;

  late String _question;
  late String _option1;
  late String _option2;
  late String _option3;
  late String _option4;
  late String _correctOp;
  late String _marks;

  //constructor for add
  QuestionModel(
    this._question,
    this._option1,
    this._option2,
    this._option3,
    this._option4,
    this._marks,
    this._correctOp,
  );

  //Constructor for edit
  QuestionModel.withId(
    this._id,
    this._question,
    this._option1,
    this._option2,
    this._option3,
    this._option4,
    this._marks,
    this._correctOp,
  );

  //getters
  String? get id => _id;

  String get getQustion => _question;
  String get getOP1 => _option1;
  String get getOP3 => _option3;
  String get getOP2 => _option2;
  String get getOP4 => _option4;
  String get getCorrectOp => _correctOp;
  String get getMarks => _marks;

  //Setters

  set setLastName(String lastName) {
    _question = lastName;
  }

  set setPhone(String phone) {
    _option1 = phone;
  }

  set setEmail(String email) {
    _option3 = email;
  }

  set setPassword(String pass) {
    _option2 = pass;
  }

//Converting snapshot back to class object
  QuestionModel.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _id = (snapshot.value as dynamic)["id"];

    _question = (snapshot.value as dynamic)["question"];
    _option1 = (snapshot.value as dynamic)["option1"];
    _option2 = (snapshot.value as dynamic)["option2"];
    _option3 = (snapshot.value as dynamic)["option3"];
    _option4 = (snapshot.value as dynamic)["option4"];
    _correctOp = (snapshot.value as dynamic)["correctOp"];
    _marks = (snapshot.value as dynamic)["marks"];
  }

//Converting class object to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": _id,
      "question": _question,
      "option1": _option1,
      "option2": _option2,
      "option3": _option3,
      "option4": _option4,
      "correctOp": _correctOp,
      "marks": _marks,
    };
  }
}
