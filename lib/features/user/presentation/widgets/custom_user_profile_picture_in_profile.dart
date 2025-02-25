
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/open_full_screen_gallery.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_popup_menu_item_widget.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/user/presentation/screens/update_user_profile_picture_screen.dart';

class CustomUserProfilePictureInProfile extends StatelessWidget {
  const CustomUserProfilePictureInProfile({
    super.key,
    required this.userEntity,
  });

  final UserEntity userEntity;
  void showCustomUserImageMenu(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: CustomPopupMenuItemWidget(
                title: context.tr("Save photo"),
                icon: FontAwesomeIcons.download,
              ),
            ),
            if (userEntity.profilePicUrl != null)
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  openFullScreenGallery(
                    context,
                    mediaUrl: [userEntity.profilePicUrl!],
                  );
                },
                child: CustomPopupMenuItemWidget(
                  title: context.tr("See profile picture"),
                  icon: FontAwesomeIcons.circleUser,
                ),
              ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                    context, UpdateUserProfilePictureScreen.routeId);
              },
              child: CustomPopupMenuItemWidget(
                title: context.tr("Select profile picture"),
                icon: FontAwesomeIcons.image,
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                // widget.onDeleteTweetTap?.call();
              },
              isDestructiveAction: true,
              child: CustomPopupMenuItemWidget(
                title: context.tr("Delete profile picture"),
                icon: FontAwesomeIcons.xmark,
                iconColor: AppColors.errorColor,
                titleColor: AppColors.errorColor,
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              context.tr('Cancel'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      start: AppConstants.horizontalPadding,
      bottom: 220,
      child: GestureDetector(
        onTap: () {
          showCustomUserImageMenu(context);
        },
        child: BuildUserCircleAvatarImage(
          profilePicUrl: userEntity.profilePicUrl,
          circleAvatarRadius: 40,
        ),
      ),
    );
  }
}
