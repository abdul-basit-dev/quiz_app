import 'package:flutter/material.dart';

import '../../../components/custom_nav_bar.dart';
import '../../../enums.dart';

class QuizHistory extends StatefulWidget {
  static String routeName = "/history";
  const QuizHistory({super.key});

  @override
  State<QuizHistory> createState() => _QuizHistoryState();
}

class _QuizHistoryState extends State<QuizHistory> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: CustomBottomNavBar(
        selectedMenu: MenuState.history,
      ),
    );
  }
}
