import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_quiz_app/helper/config.dart';

import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../helper/keyboard.dart';
import '../../../size_config.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  static String routeName = "/edit_profile";

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final Reference _storageReference =
      FirebaseStorage.instance.ref().child("user_images");
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('Users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentFirebaseUser;
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

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String imageUrl = 'empty';
  String? fileName;

  @override
  void initState() {
    super.initState();
    currentFirebaseUser = _auth.currentUser;
    if (box!.get('login') == true) {
      emailCtrl = TextEditingController(text: box!.get('email'));
      firstNameCtrl = TextEditingController(text: box!.get('firstName'));
      lastNameCtrl = TextEditingController(text: box!.get('lastName'));
      phoneCtrl = TextEditingController(text: box!.get('phone'));
      imageUrl = box!.get('photourl');
    }

    print('imageUrl');
    print(imageUrl);
    print('boxValue');
    print(box!.get('photourl'));
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
              SizedBox(height: getProportionateScreenHeight(48)),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.white,
                      child: InkWell(
                        onTap: () {
                          _optionsDialogBox();
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 48.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(48.0),
                            child: imageUrl == 'empty'
                                ? Image.asset(
                                    'assets/images/logo.png',
                                    fit: BoxFit.fill,
                                    width: 150,
                                    height: 150,
                                  )
                                : FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/logo.png',
                                    image: imageUrl,
                                    fit: BoxFit.cover,
                                    width: 150,
                                    height: 150,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(7.5),
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(48.0),
                            color: kPrimaryColor),
                        child: InkWell(
                          onTap: () {
                            _optionsDialogBox();
                          },
                          child: const Icon(
                            Icons.linked_camera,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
              SizedBox(height: getProportionateScreenHeight(8)),
              SizedBox(height: getProportionateScreenHeight(24)),
              DefaultButton(
                press: () {
                  updateUserProfile();
                },
                text: 'Update',
              ),
              SizedBox(height: getProportionateScreenHeight(48)),
            ],
          )),
        ),
      ),
    );
  }

  //Update profile to firebase
  Future<void> updateUserProfile() async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Users").child(currentFirebaseUser!.uid);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      KeyboardUtil.hideKeyboard(context);
      await ref.update({
        "firstName": firstNameCtrl.text,
        "lastName": lastNameCtrl.text,
        "phone": phoneCtrl.text,
        "image": imageUrl
      }).then(
        (value) {
          Navigator.of(context).pop();
        },
      );
    } else {
      print('Error Updating Profile');
    }
  }

  //Camera Method
  Future openCamera() async {
    imageUrl = 'empty';
    Navigator.of(context).pop();
    var imageFrmCamera =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _selectedImage = File(imageFrmCamera!.path);
      fileName = _selectedImage!.path.split('/').last;

      uploadImageToFirebase(_selectedImage!, fileName!);
    });
  }

  //Gallery method
  Future openGallery() async {
    imageUrl = 'empty';
    Navigator.of(context).pop();
    var pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _selectedImage = File(pickedFile!.path);
      fileName = _selectedImage!.path.split('/').last;

      uploadImageToFirebase(_selectedImage!, fileName!);
    });
    // if (mounted) Navigator.of(context).pop();
  }

  void uploadImageToFirebase(File file, String fileName) async {
    file.absolute.existsSync();
    _storageReference.child(fileName).putFile(file).then((firebaseFile) async {
      var downloadUrl = await firebaseFile.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });
    });
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Your Method'),
          backgroundColor: kFormColor,
          contentPadding: const EdgeInsets.all(20.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text("Take a Picture"),
                  onTap: openCamera,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                const Divider(
                  color: Colors.white70,
                  height: 1.0,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: const Text("Open Gallery"),
                  onTap: openGallery,
                ),
              ],
            ),
          ),
        );
      },
    );
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
      enabled: false,
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
}
