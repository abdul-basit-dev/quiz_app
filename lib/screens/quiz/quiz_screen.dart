// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_quiz_app/constants.dart';
import 'package:my_quiz_app/models/question_model.dart';

class QuizScreen extends StatefulWidget {
  static String routeName = "/quiz";
  const QuizScreen({
    super.key,
    required this.quizId,
    required this.quizTitle,
  });
  final String quizId, quizTitle;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final DatabaseReference quizRef =
      FirebaseDatabase.instance.ref().child('Quiz');
  var questionData = [];
  List<QuestionModel> questionModel = <QuestionModel>[];
  bool isLoading = false;

  var _index = 0;
  var _totalMarks = 0;

  void getAnswers() {
    setState(() {
      _index = _index + 1;
    });

    print(_index);

    if (_index < questionModel.length) {
      print("You have more questions");
    } else {
      print("All Questions Attempted");
    }
  }

  void restQuiz() {
    setState(() {
      _index = 0;
      _totalMarks = 0;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuizQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          widget.quizTitle,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _index < questionModel.length
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    questionModel[_index].getQustion,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.clip,
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () {
                      if (questionModel[_index].getCorrectOp == 'option1') {
                        _totalMarks += 10;
                      } else {
                        _totalMarks -= 2;
                      }
                      getAnswers();
                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          questionModel[_index].getOP1,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () {
                      if (questionModel[_index].getCorrectOp == 'option2') {
                        _totalMarks += 10;
                      } else {
                        _totalMarks -= 2;
                      }
                      getAnswers();
                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          questionModel[_index].getOP2,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  InkWell(
                    onTap: () {
                      if (questionModel[_index].getCorrectOp == 'option3') {
                        _totalMarks += 10;
                      } else {
                        _totalMarks -= 2;
                      }
                      getAnswers();
                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          questionModel[_index].getOP3,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  InkWell(
                    onTap: () {
                      if (questionModel[_index].getCorrectOp == 'option4') {
                        _totalMarks += 10;
                      } else {
                        _totalMarks -= 2;
                      }
                      getAnswers();
                    },
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          questionModel[_index].getOP4,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                  ),
                  Text(_totalMarks.toString()),
                ],
              )
            : Container(
                child: ElevatedButton(
                  onPressed: () {
                    restQuiz();
                  },
                  child: const Text('Play Again'),
                ),
              ),
      ),
    );
  }

  Future<void> getQuizQuestions() async {
    quizRef
        .child(widget.quizId)
        .child('Questions')
        .onValue
        .listen((DatabaseEvent event) {
      var snapshot = event.snapshot;

      questionData.clear();
      questionModel.clear();

      for (var data in snapshot.children) {
        questionData.add(data.value);
      }

      print(questionData);

      setState(() {
        if (snapshot.exists && questionData.isNotEmpty) {
          for (int x = 0; x < questionData.length; x++) {
            String id = questionData[x]['id'].toString();
            String question = questionData[x]['question'];
            String option1 = questionData[x]['option1'];
            String option2 = questionData[x]['option2'];
            String option3 = questionData[x]['option3'];
            String option4 = questionData[x]['option4'];
            String correctOp = questionData[x]['correctOp'];
            String marks = questionData[x]['marks'];

            questionModel.add(QuestionModel.withId(
              id,
              question,
              option1,
              option2,
              option3,
              option4,
              marks,
              correctOp,
            ));

            isLoading = true;
          }
        } else {
          isLoading = false;
        }
      });
    });
  }
}
