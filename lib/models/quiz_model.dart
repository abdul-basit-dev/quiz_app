import 'package:firebase_database/firebase_database.dart';

class QuizModel {
  String? _id;
  late String _quizTitle;
  late String _totalMarks;
  late String _category;

  //constructor for add
  QuizModel(
    this._quizTitle,
    this._totalMarks,
    this._category,
  );

  //Constructor for edit
  QuizModel.withId(
    this._id,
    this._quizTitle,
    this._totalMarks,
    this._category,
  );

  //getters
  String? get id => _id;
  String get getQuizTitle => _quizTitle;
  String get getTotalMarks => _totalMarks;
  String get getCategory => _category;

  //Setters
  set setFirstName(String firstName) {
    _quizTitle = firstName;
  }

  set setLastName(String lastName) {
    _totalMarks = lastName;
  }

  set setPhone(String phone) {
    _category = phone;
  }

//Converting snapshot back to class object
  QuizModel.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _id = (snapshot.value as dynamic)["quizId"];
    _quizTitle = (snapshot.value as dynamic)["quizTitle"];
    _totalMarks = (snapshot.value as dynamic)["totalMarks"];

    _category = (snapshot.value as dynamic)["category"];
  }

//Converting class object to JSON
  Map<String, dynamic> toJson() {
    return {
      "quizId": _id,
      "category": _category,
      "quizTitle": _quizTitle,
      "totalMarks": _totalMarks,
    };
  }
}
