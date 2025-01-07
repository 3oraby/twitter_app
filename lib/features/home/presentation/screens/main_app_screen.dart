import 'package:flutter/material.dart';
import 'package:twitter_app/core/widgets/custom_app_drawer.dart';
import 'package:twitter_app/features/home/presentation/screens/make_new_tweet_screen.dart';
import 'package:twitter_app/features/home/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:twitter_app/features/home/presentation/widgets/custom_floating_action_button.dart';
import 'package:twitter_app/features/home/presentation/widgets/main_app_body.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});
  static const String routeId = "kMainAppScreen";

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomAppDrawer(),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTabChange: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      floatingActionButton: CustomFloatingActionButton(
        iconData: Icons.add,
        onPressed: () {
          Navigator.pushNamed(context, MakeNewTweetScreen.routeId);
        },
      ),
      body: MainAppBody(
        currentIndex: currentIndex,
      ),
    );
  }
}
