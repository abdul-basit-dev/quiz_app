import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/custom_nav_bar.dart';
import '../../constants.dart';
import '../../enums.dart';
import '../../helper/config.dart';
import '../../models/user_model.dart';
import '../edit_profile/edit_profile_screen.dart';

//import 'components/body.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseReference _userReference =
      FirebaseDatabase.instance.ref().child('Users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;
  var isLoading = false;
  var userData = [];
  List<UserModel> userModel = <UserModel>[];
  String address = '';
  String name = '';
  @override
  void initState() {
    super.initState();
    currentUser = _auth.currentUser;

    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(color: kTextColor),
        ),
        automaticallyImplyLeading: false,
      ),
      body: isLoading == false
          ? const CircularProgressIndicator()
          : Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50.0,
                          backgroundColor: kPrimaryColor,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 48.0,
                            child: box!.get('photourl') == 'empty'
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(48.0),
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 150,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(48.0),
                                    child: Image.network(
                                      box!.get('photourl'),
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 150,
                                    ),
                                  ),
                          ),
                        ),
                        ListTile(
                          title: const Text('Name'),
                          subtitle: Text(
                            box!.get('firstName') + " " + box!.get('lastName'),
                            style: headingStyle,
                          ),
                        ),
                        ListTile(
                          title: const Text('Email'),
                          subtitle: Text(
                            box!.get('email'),
                            style: headingStyle,
                          ),
                        ),
                        ListTile(
                          title: const Text('Contact'),
                          subtitle: Text(
                            box!.get('phone'),
                            style: headingStyle,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(80, 24, 80, 0),
                          child: SizedBox(
                            width: 124,
                            height: 32,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const EditProfileScreen()))
                                    .then((value) => setState(
                                          () {
                                            getCurrentUser();
                                          },
                                        ));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: const Text(
                                "Edit Profile",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const CustomBottomNavBar(
        selectedMenu: MenuState.profile,
      ),
    );
  }

  Future<void> getCurrentUser() async {
    _userReference.onValue.listen((DatabaseEvent event) {
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
              print(name);
              String password = userData[x]['password'];
              String phone = userData[x]['phone'];
              String email = userData[x]['email'];
              //Adding data to Hive
              box!.put("firstName", userData[x]['firstName']);
              box!.put("lastName", userData[x]['lastName']);
              box!.put("phone", userData[x]['phone']);

              if (userData[x]['image'] != null &&
                  userData[x]['image'] != 'empty') {
                box!.put("photourl", userData[x]['image']);
              } else {
                box!.put("photourl", 'empty');
              }

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
