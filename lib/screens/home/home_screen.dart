import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_quiz_app/constants.dart';
import 'package:my_quiz_app/helper/config.dart';
import 'package:my_quiz_app/models/user_model.dart';
import 'package:my_quiz_app/screens/login/login_screen.dart';

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
  bool isLoading = false;
  String? name;

  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;
    getCurrentUser();
  }

  signOutFromFirebase() {
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isLoading == false ? CircularProgressIndicator() : Text(name!),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
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
      body: isLoading == true ? CircularProgressIndicator() : Container(),
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
            isLoading = true;
          }
        } else {
          isLoading = false;
        }
      });
    });
  }
}
