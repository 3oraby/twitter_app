import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_popup_menu_item_widget.dart';
import 'package:twitter_app/core/widgets/custom_show_tweet_media.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_tweet_interactions_row.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';
import 'package:twitter_app/features/user/presentation/screens/user_profile_screen.dart';

class CustomTweetInfoCard extends StatefulWidget {
  const CustomTweetInfoCard({
    super.key,
    required this.tweetDetailsEntity,
    required this.currentUser,
    this.showInteractionsRow = true,
    this.mediaHeight = 300,
    this.mediaWidth = 250,
    this.onTweetTap,
    this.onDeleteTweetTap,
    this.onEditTweetTap,
  });

  final TweetDetailsEntity tweetDetailsEntity;
  final UserEntity currentUser;
  final bool showInteractionsRow;
  final double mediaHeight;
  final double mediaWidth;
  final VoidCallback? onTweetTap;
  final VoidCallback? onDeleteTweetTap;
  final VoidCallback? onEditTweetTap;

  @override
  State<CustomTweetInfoCard> createState() => _CustomTweetInfoCardState();
}

class _CustomTweetInfoCardState extends State<CustomTweetInfoCard> {
  void _handleNotInterested() {
    log('User selected: Not interested in this post');
    showCustomSnackBar(
      context,
      "You marked this post as 'Not Interested'",
    );
  }

  void _onUserProfileTweetTap() {
    log('User selected: user profile');
    Navigator.pushNamed(
      context,
      UserProfileScreen.routeId,
      arguments: widget.tweetDetailsEntity.user,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTweetTap,
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _onUserProfileTweetTap,
              child: BuildUserCircleAvatarImage(
                profilePicUrl: widget.tweetDetailsEntity.user.profilePicUrl,
              ),
            ),
            const HorizontalGap(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _onUserProfileTweetTap,
                    child: Row(
                      children: [
                        Text(
                          "${widget.tweetDetailsEntity.user.firstName} ${widget.tweetDetailsEntity.user.lastName}",
                          style: AppTextStyles.uberMoveBold18,
                        ),
                        const HorizontalGap(8),
                        Flexible(
                          child: Text(
                            widget.tweetDetailsEntity.user.email,
                            style: AppTextStyles.uberMoveMedium16
                                .copyWith(color: AppColors.secondaryColor),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.more_horiz,
                            color: AppColors.twitterAccentColor,
                          ),
                          onPressed: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoActionSheet(
                                  actions: [
                                    if (widget.currentUser.userId !=
                                        widget.tweetDetailsEntity.tweet.userId)
                                      CupertinoActionSheetAction(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _handleNotInterested();
                                        },
                                        child: CustomPopupMenuItemWidget(
                                          title: context.tr(
                                              "Not interested in this post"),
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
                                    if (widget.currentUser.userId ==
                                        widget.tweetDetailsEntity.tweet
                                            .userId) ...[
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
                                      'Cancel',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  if (widget.tweetDetailsEntity.tweet.content != null)
                    Column(
                      children: [
                        const VerticalGap(4),
                        Text(
                          widget.tweetDetailsEntity.tweet.content!,
                          style: AppTextStyles.uberMoveRegular16,
                        ),
                      ],
                    ),
                  if (widget.tweetDetailsEntity.tweet.mediaUrl?.isNotEmpty ??
                      false)
                    Column(
                      children: [
                        const VerticalGap(8),
                        CustomShowTweetsMedia(
                          mediaUrl: widget.tweetDetailsEntity.tweet.mediaUrl!,
                          mediaHeight: widget.mediaHeight,
                          mediaWidth: widget.mediaWidth,
                        ),
                      ],
                    ),
                  const VerticalGap(8),
                  Visibility(
                    visible: widget.showInteractionsRow,
                    child: CustomTweetInteractionsRow(
                      tweetDetailsEntity: widget.tweetDetailsEntity,
                      currentUser: widget.currentUser,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
