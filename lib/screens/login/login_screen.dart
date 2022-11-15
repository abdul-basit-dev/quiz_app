import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_quiz_app/components/default_button.dart';
import 'package:my_quiz_app/constants.dart';
import 'package:my_quiz_app/helper/keyboard.dart';
import 'package:my_quiz_app/screens/home/home_screen.dart';
import 'package:my_quiz_app/screens/signup/signup_screen.dart';
import 'package:my_quiz_app/size_config.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  String? email, password;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                width: 96,
                height: 96,
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              Text(
                'Welcome',
                style: headingStyle,
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              Text(
                'Login',
                style: headingStyle1,
              ),
              SizedBox(height: getProportionateScreenHeight(24)),
              buildEmailField(),
              SizedBox(height: getProportionateScreenHeight(8)),
              buildPasswordField(),
              SizedBox(height: getProportionateScreenHeight(16)),
              DefaultButton(
                press: () {
                  loginwithFirebase();
                },
                text: 'Login',
              ),
              SizedBox(height: getProportionateScreenHeight(48)),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                          text: 'Don\'t have an account?',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Sign up',
                                style: const TextStyle(
                                    color: Colors.blueAccent, fontSize: 18),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // navigate to SIgnup screen

                                    Navigator.pushNamed(
                                        context, SignUpScreen.routeName);
                                  }),
                          ]),
                    ),
                  ))
            ],
          )),
        ),
      ),
    );
  }

  checkAuthentication() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.routeName, (Route route) => false);
      }
    });
  }

  loginwithFirebase() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      KeyboardUtil.hideKeyboard(context);
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailCtrl.text,
          password: passwordCtrl.text,
        );
        if (credential != null) {
          gotToHomeScreen();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    } else {
      print('Error');
    }
  }

  gotToHomeScreen() {
    Navigator.pushNamedAndRemoveUntil(
        context, HomeScreen.routeName, (Route route) => false);
  }

  TextFormField buildEmailField() {
    return TextFormField(
      controller: emailCtrl,
      textInputAction: TextInputAction.next,
      onSaved: (newValue) {
        email = newValue;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {});
        } else if (emailValidatorRegExp.hasMatch(value)) {}
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          return kInvalidEmailError;
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kPrimaryColor)),
      ),
    );
  }

  TextFormField buildPasswordField() {
    return TextFormField(
      controller: passwordCtrl,
      textInputAction: TextInputAction.done,
      onSaved: (newValue) {
        password = newValue;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return kPassNullError;
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.password),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
      ),
    );
  }
}
