import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';

class LeadingAppBarUserImage extends StatelessWidget {
  const LeadingAppBarUserImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Scaffold.of(context).openDrawer();
      },
      child: Row(
        children: [
          BuildUserCircleAvatarImage(
            profilePicUrl: getCurrentUserEntity().profilePicUrl,
            circleAvatarRadius: 20,
          ),
        ],
      ),
    );
  }
}
