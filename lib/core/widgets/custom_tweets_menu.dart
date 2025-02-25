import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/widgets/custom_background_icon.dart';
import 'package:twitter_app/core/widgets/custom_popup_menu_item_widget.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/user/presentation/screens/user_profile_screen.dart';

class CustomTweetsMenu extends StatefulWidget {
  const CustomTweetsMenu({
    super.key,
    required this.currentUserId,
    required this.autherEntity,
    this.onDeleteTweetTap,
    this.onEditTweetTap,
    this.showNotIntrestedOption = false,
  });
  final String currentUserId;
  final UserEntity autherEntity;
  final VoidCallback? onDeleteTweetTap;
  final VoidCallback? onEditTweetTap;
  final bool showNotIntrestedOption;

  @override
  State<CustomTweetsMenu> createState() => _CustomTweetsMenuState();
}

class _CustomTweetsMenuState extends State<CustomTweetsMenu> {
  void _handleNotInterested() {
    showCustomSnackBar(
      context,
      context.tr("You will see fewer posts like this."),
    );
  }

  void _onUserProfileTweetTap() {
    log('User selected: user profile');
    Navigator.pushNamed(
      context,
      UserProfileScreen.routeId,
      arguments: widget.autherEntity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundIcon(
      iconData: Icons.more_horiz,
      iconColor: AppColors.twitterAccentColor,
      contentPadding: 4,
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              actions: [
                if (widget.showNotIntrestedOption &&
                    widget.currentUserId != widget.autherEntity.userId)
                  CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                      _handleNotInterested();
                    },
                    child: CustomPopupMenuItemWidget(
                      title: context.tr("Not interested in this post"),
                      icon: FontAwesomeIcons.faceAngry,
                    ),
                  ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                    _onUserProfileTweetTap();
                  },
                  child: CustomPopupMenuItemWidget(
                    title: context.tr("Profile"),
                    icon: FontAwesomeIcons.person,
                  ),
                ),
                if (widget.currentUserId == widget.autherEntity.userId) ...[
                  CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onEditTweetTap?.call();
                    },
                    child: CustomPopupMenuItemWidget(
                      title: context.tr("Edit"),
                      icon: FontAwesomeIcons.penToSquare,
                    ),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onDeleteTweetTap?.call();
                    },
                    isDestructiveAction: true,
                    child: CustomPopupMenuItemWidget(
                      title: context.tr("Delete post"),
                      icon: FontAwesomeIcons.xmark,
                      iconColor: AppColors.errorColor,
                      titleColor: AppColors.errorColor,
                    ),
                  ),
                ],
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
      },
    );
  }
}
