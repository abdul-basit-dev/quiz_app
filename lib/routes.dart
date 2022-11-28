import 'package:my_quiz_app/screens/login/login_screen.dart';
import 'package:my_quiz_app/screens/profile/profile_screen.dart';
import 'package:my_quiz_app/screens/quiz/quiz_screen.dart';
import 'package:my_quiz_app/screens/quiz_history/quiz_history.dart';
import 'package:my_quiz_app/screens/signup/signup_screen.dart';

import 'package:my_quiz_app/screens/splash/splash_screen.dart';
import 'package:flutter/widgets.dart';

import 'screens/edit_profile/edit_profile_screen.dart';
import 'screens/home/home_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  EditProfileScreen.routeName: (context) => const EditProfileScreen(),
  QuizHistory.routeName: (context) => const QuizHistory(),
  QuizScreen.routeName: (context) =>
      const QuizScreen(quizId: '', quizTitle: ''),
};
