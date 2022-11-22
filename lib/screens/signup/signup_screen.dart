import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_quiz_app/constants.dart';
import 'package:my_quiz_app/models/user_model.dart';
import 'package:my_quiz_app/screens/login/login_screen.dart';

import '../../components/default_button.dart';
import '../../helper/keyboard.dart';
import '../../size_config.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = '/signup';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String? email;
  String? password;
  String? confirmPassword;
  String? firstName;
  String? lastName;
  String? phone;

  bool remember = false;
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController firstNameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? fireBaseuser;
  final DatabaseReference userRefernece =
      FirebaseDatabase.instance.ref().child('Users');

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
                'Create a New Account',
                style: headingStyle1,
              ),
              SizedBox(height: getProportionateScreenHeight(24)),
              buildFirstNameFormField(),
              SizedBox(height: getProportionateScreenHeight(8)),
              buildLastNameFormField(),
              SizedBox(height: getProportionateScreenHeight(8)),
              buildEmailFormField(),
              SizedBox(height: getProportionateScreenHeight(8)),
              buildPhoneFormField(),
              SizedBox(height: getProportionateScreenHeight(8)),
              buildPasswordFormField(),
              SizedBox(height: getProportionateScreenHeight(8)),
              DefaultButton(
                press: () {
                  if (_formKey.currentState!.validate()) {
                    KeyboardUtil.hideKeyboard(context);
                    //TODO:SIGNUP
                    signupwithFirebase();
                  }
                },
                text: 'Sign Up',
              ),
              SizedBox(height: getProportionateScreenHeight(48)),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                          text: 'Already have an account',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' Login',
                                style: const TextStyle(
                                    color: Colors.blueAccent, fontSize: 18),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // navigate to SIgnup screen

                                    Navigator.pushNamed(
                                        context, LoginScreen.routeName);
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

  signupwithFirebase() async {
    try {
      final UserCredential credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text,
        password: passCtrl.text,
      );
      if (credential != null) {
        fireBaseuser = credential.user;
        await fireBaseuser!.reload();
        fireBaseuser = _auth.currentUser;
        saveUserToFirebase();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  saveUserToFirebase() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      KeyboardUtil.hideKeyboard(context);

      var pushId = userRefernece.push();

      UserModel userModel = UserModel.withId(
          fireBaseuser!.uid,
          firstNameCtrl.text,
          lastNameCtrl.text,
          phoneCtrl.text,
          emailCtrl.text,
          passCtrl.text);

      await userRefernece
          .child(fireBaseuser!.uid.toString())
          .set(userModel.toJson())
          .then(
        (value) {
          setState(() {
            firstNameCtrl.text = '';
          });
          Navigator.pushNamed(context, LoginScreen.routeName);
        },
      );
    }
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      controller: firstNameCtrl,
      textInputAction: TextInputAction.next,
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.name,
      onSaved: (newValue) => firstName = newValue!,
      validator: (value) {
        if (value!.isEmpty) {
          return kNamelNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        labelStyle: const TextStyle(color: kPrimaryColor),
        focusColor: kPrimaryColor,
        hintText: "First Name",
        fillColor: kFormColor,
        filled: true,
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      controller: lastNameCtrl,
      cursorColor: kPrimaryColor,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      onSaved: (newValue) => lastName = newValue!,
      validator: (value) {
        if (value!.isEmpty) {
          return kNamelNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        labelStyle: const TextStyle(color: kPrimaryColor),
        focusColor: kPrimaryColor,
        hintText: "Last Name",
        fillColor: kFormColor,
        filled: true,
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: emailCtrl,
      textInputAction: TextInputAction.next,
      cursorColor: kPrimaryColor,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          //removeError(error: kEmailNullError);
          setState(() {
            //  _formKey.currentState!.validate();
          });
        } else if (emailValidatorRegExp.hasMatch(value)) {
          // removeError(error: kInvalidEmailError);
          // _formKey.currentState!.validate();
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          //addError(error: kEmailNullError);
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          // addError(error: kInvalidEmailError);
          return kInvalidEmailError;
        }
        return null;
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        labelStyle: const TextStyle(color: kPrimaryColor),
        focusColor: kPrimaryColor,
        hintText: "Enter email",
        fillColor: kFormColor,
        filled: true,
      ),
    );
  }

  TextFormField buildPhoneFormField() {
    return TextFormField(
      controller: phoneCtrl,
      cursorColor: kPrimaryColor,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      onSaved: (newValue) => phone = newValue!,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter';
        }
        return null;
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        labelStyle: const TextStyle(color: kPrimaryColor),
        focusColor: kPrimaryColor,
        hintText: "Phone Number",
        fillColor: kFormColor,
        filled: true,
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: passCtrl,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      obscureText: _obscureText,
      enableSuggestions: false,
      cursorColor: kPrimaryColor,
      onSaved: (newValue) => password = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          // removeError(error: kPassNullError);
          setState(() {
            // _formKey.currentState!.validate();
          });
        } else if (value.length >= 8) {
          // removeError(error: kShortPassError);
          setState(() {
            //  _formKey.currentState!.validate();
          });
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          //addError(error: kPassNullError);

          return kPassNullError;
        } else if (value.length < 8) {
          //addError(error: kShortPassError);
          return kShortPassError;
        }
        return null;
      },
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        hintText: "Enter your password",
        fillColor: kFormColor,
        filled: true,
        labelStyle: const TextStyle(color: kPrimaryColor),
        suffixIcon: GestureDetector(
          onTap: _toggle,
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: kTextColorSecondary,
          ),
        ),
      ),
    );
  }
}
