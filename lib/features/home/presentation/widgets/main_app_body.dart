import 'package:flutter/material.dart';
import 'package:twitter_app/features/home/presentation/widgets/home_view.dart';
import 'package:twitter_app/features/home/presentation/widgets/notification_view.dart';
import 'package:twitter_app/features/home/presentation/widgets/main_app_search_view.dart';
import 'package:twitter_app/features/settings/presentation/widgets/setting_view.dart';

class MainAppBody extends StatelessWidget {
  const MainAppBody({
    super.key,
    required this.currentIndex,
  });

  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: IndexedStack(
        index: currentIndex,
        children: const [
          HomeView(),
          MainAppSearchView(),
          NotificationView(),
          SettingView(),
        ],
      ),
    );
  }
}
