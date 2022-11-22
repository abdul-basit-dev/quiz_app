import 'package:flutter/material.dart';
import 'package:my_quiz_app/enums.dart';
import 'package:my_quiz_app/screens/home/home_screen.dart';
import 'package:my_quiz_app/screens/home/quiz_history/quiz_history.dart';
import 'package:my_quiz_app/screens/profile/profile_screen.dart';

import '../constants.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    const Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.home_outlined,
                        color: MenuState.home == selectedMenu
                            ? kPrimaryColor
                            : inActiveIconColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            HomeScreen.routeName, (route) => false);
                        // Navigator.pushNamed(context, HomeScreen.routeName);
                      }),
                  Container(
                    child: MenuState.home == selectedMenu
                        ? const Visibility(
                            visible: true,
                            child: Text(
                              "Home",
                              style: TextStyle(color: kPrimaryColor),
                            ),
                          )
                        : const Visibility(
                            visible: false,
                            child: Text("Home"),
                          ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.history,
                      color: MenuState.history == selectedMenu
                          ? kPrimaryColor
                          : inActiveIconColor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, QuizHistory.routeName);
                    },
                  ),
                  Container(
                    child: MenuState.history == selectedMenu
                        ? const Visibility(
                            visible: true,
                            child: Text(
                              "History",
                              style: TextStyle(color: kPrimaryColor),
                            ),
                          )
                        : const Visibility(
                            visible: false,
                            child: Text("History"),
                          ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.person,
                      color: MenuState.profile == selectedMenu
                          ? kPrimaryColor
                          : inActiveIconColor,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, ProfileScreen.routeName);
                    },
                  ),
                  Container(
                    child: MenuState.profile == selectedMenu
                        ? const Visibility(
                            visible: true,
                            child: Text(
                              "Profile",
                              style: TextStyle(color: kPrimaryColor),
                            ),
                          )
                        : const Visibility(
                            visible: false,
                            child: Text("Profile"),
                          ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
