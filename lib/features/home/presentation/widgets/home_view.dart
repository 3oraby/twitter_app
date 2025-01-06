import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_svgs.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
  });
  AppBar buildHomeAppBar({
    required BuildContext context,
  }) {
    UserEntity currentUser = getCurrentUserEntity();
    return buildCustomAppBar(
      context,
      title: SvgPicture.asset(AppSvgs.svgXLogoWhiteBackground48),
      leading: GestureDetector(
        onTap: () {
          Scaffold.of(context).openDrawer();
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildHomeAppBar(
          context: context,
        ),
        Container(
            color: Colors.red, child: const Center(child: Text('Page 1'))),
      ],
    );
  }
}
