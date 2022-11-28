import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_quiz_app/constants.dart';
import 'package:my_quiz_app/helper/config.dart';
import 'package:my_quiz_app/models/quiz_model.dart';
import 'package:my_quiz_app/models/user_model.dart';
import 'package:my_quiz_app/screens/login/login_screen.dart';
import 'package:my_quiz_app/screens/quiz/quiz_screen.dart';

import '../../components/custom_nav_bar.dart';
import '../../enums.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;
  final DatabaseReference userRefernece =
      FirebaseDatabase.instance.ref().child('Users');
  var userData = [];
  List<UserModel> userModel = <UserModel>[];
  bool isLoadingName = false;
  bool isLoading = false;
  String? name;

  final DatabaseReference quizRef =
      FirebaseDatabase.instance.ref().child('Quiz');

  var quizData = [];
  List<QuizModel> quizModel = <QuizModel>[];

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
    getCurrentUser();
    getQuizCategories();
  }

  signOutFromFirebase() {
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isLoadingName == false
            ? const CircularProgressIndicator()
            : Text(
                name!,
                style: const TextStyle(color: Colors.white),
              ),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              setState(() {
                if (box!.get('login') == true) {
                  signOutFromFirebase();
                  box!.delete('login');

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    LoginScreen.routeName,
                    (route) => false,
                  );
                }
              });
            },
          )
        ],
      ),
      body: isLoading == false
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: quizModel.length,
                itemBuilder: ((context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                                quizId: quizModel[index].id!,
                                quizTitle: quizModel[index].getQuizTitle),
                          ));
                    },
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        title: Text(
                          quizModel[index].getQuizTitle,
                        ),
                        subtitle: Text(
                          quizModel[index].getCategory,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
      bottomNavigationBar: const CustomBottomNavBar(
        selectedMenu: MenuState.home,
      ),
    );
  }

  Future<void> getCurrentUser() async {
    userRefernece.onValue.listen((DatabaseEvent event) {
      var snapshot = event.snapshot;

      userData.clear();
      userModel.clear();

      for (var data in snapshot.children) {
        userData.add(data.value);
      }

      setState(() {
        if (snapshot.exists && userData.isNotEmpty) {
          for (int x = 0; x < userData.length; x++) {
            if (userData[x]['id'] == currentUser!.uid.toString()) {
              String id = userData[x]['id'].toString();
              String firstName = userData[x]['firstName'];
              String lastName = userData[x]['lastName'];
              name = firstName + ' ' + lastName;
              print(name!);
              String password = userData[x]['password'];
              String phone = userData[x]['phone'];
              String email = userData[x]['email'];
              //Adding data to Hive
              box!.put("firstName", firstName);
              box!.put("lastName", lastName);
              box!.put("phone", userData[x]['phone']);
              //TODO:
              box!.put("photourl", userData[x]['empty']);
              box!.put("email", email);

              userModel.add(UserModel.withId(
                id,
                firstName,
                lastName,
                phone,
                email,
                password,
              ));
            }
            isLoadingName = true;
          }
        } else {
          isLoadingName = false;
        }
      });
    });
  }

  Future<void> getQuizCategories() async {
    quizRef.onValue.listen((DatabaseEvent event) {
      var snapshot = event.snapshot;

      quizData.clear();
      quizModel.clear();

      for (var data in snapshot.children) {
        quizData.add(data.value);
      }

      setState(() {
        if (snapshot.exists && quizData.isNotEmpty) {
          for (int x = 0; x < quizData.length; x++) {
            String quizId = quizData[x]['quizId'].toString();
            String category = quizData[x]['category'];
            String quizTitle = quizData[x]['quizTitle'];
            String totalMarks = quizData[x]['totalMarks'];

            quizModel.add(QuizModel.withId(
              quizId,
              quizTitle,
              totalMarks,
              category,
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
