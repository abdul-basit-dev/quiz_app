import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_quiz_app/helper/config.dart';
import 'package:my_quiz_app/screens/home/home_screen.dart';
import 'package:my_quiz_app/screens/login/login_screen.dart';
import 'package:my_quiz_app/size_config.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return const Scaffold(
      body: Body(),
    );
  }

  checkAuthentication() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
        });
      } else {
        print('User is signed in!');
        if (box!.get('login') == true) {
          Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.routeName, (Route route) => false);
        }
      }
    });
  }
}
