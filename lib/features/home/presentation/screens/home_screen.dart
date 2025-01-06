import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_svgs.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_app_drawer.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeId = "kHomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    UserEntity currentUser = getCurrentUserEntity();
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomAppDrawer(),
      appBar: buildCustomAppBar(
        context,
        title: SvgPicture.asset(AppSvgs.svgXLogoWhiteBackground48),
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Row(
            children: [
              const HorizontalGap(AppConstants.horizontalPadding),
              BuildUserCircleAvatarImage(
                profilePicUrl: currentUser.profilePicUrl,
                circleAvatarRadius: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTabChange: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: HomeBody(
        currentIndex: currentIndex,
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.onTabChange,
  });

  final ValueChanged onTabChange;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding,
          vertical: 16,
        ),
        child: GNav(
            gap: 4,
            backgroundColor: Colors.transparent,
            color: AppColors.primaryColor,
            activeColor: AppColors.primaryColor,
            tabBackgroundColor: AppColors.lightBackgroundColor,
            padding: const EdgeInsets.all(16),
            onTabChange: onTabChange,
            tabs: AppConstants.bottomNavigationBarItems(context: context).map(
              (item) {
                return GButton(
                  icon: item.itemIcon,
                  text: item.name,
                );
              },
            ).toList()),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({
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
          SearchView(),
          NotificationView(),
          SettingView(),
        ],
      ),
    );
  }
}

class SettingView extends StatelessWidget {
  const SettingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue, child: const Center(child: Text('Page 4')));
  }
}

class NotificationView extends StatelessWidget {
  const NotificationView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue, child: const Center(child: Text('Page 3')));
  }
}

class SearchView extends StatelessWidget {
  const SearchView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green, child: const Center(child: Text('Page 2')));
  }
}

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.red, child: const Center(child: Text('Page 1')));
  }
}
