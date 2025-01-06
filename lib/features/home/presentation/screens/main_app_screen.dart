import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_svgs.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_app_drawer.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/home/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:twitter_app/features/home/presentation/widgets/main_app_body.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});
  static const String routeId = "kMainAppScreen";

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
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
      body: MainAppBody(
        currentIndex: currentIndex,
      ),
    );
  }
}


