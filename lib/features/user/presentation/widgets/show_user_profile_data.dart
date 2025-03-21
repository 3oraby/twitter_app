import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/format_date_from_timestamp.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/custom_container_button.dart';
import 'package:twitter_app/core/widgets/custom_user_follow_relation_ships_count.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/settings/presentation/screens/user_account_information_screen.dart';
import 'package:twitter_app/features/user/presentation/widgets/custom_user_profile_picture_in_profile.dart';

class ShowUserProfileData extends StatefulWidget {
  const ShowUserProfileData({
    super.key,
    required this.userEntity,
  });

  final UserEntity userEntity;

  @override
  State<ShowUserProfileData> createState() => _ShowUserProfileDataState();
}

class _ShowUserProfileDataState extends State<ShowUserProfileData> {
  late UserEntity userEntity;

  @override
  void initState() {
    super.initState();
    userEntity = widget.userEntity;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 280,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white
                : Colors.black,
            image: userEntity.coverPicUrl != null
                ? DecorationImage(
                    image: NetworkImage(userEntity.coverPicUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
        CustomUserProfilePictureInProfile(userEntity: userEntity),
        PositionedDirectional(
          start: AppConstants.horizontalPadding,
          bottom: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${userEntity.firstName ?? ''} ${userEntity.lastName ?? ''}",
                style: AppTextStyles.uberMoveBlack(context, 26),
              ),
              Text(
                "@${userEntity.email}",
                style: AppTextStyles.uberMoveMedium(context, 20).copyWith(
                  color: AppColors.thirdColor,
                ),
              ),
              const VerticalGap(12),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: AppColors.thirdColor,
                  ),
                  const HorizontalGap(4),
                  Text(
                    "${context.tr("Joined")} ${formatDateFromTimestamp(
                      context: context,
                      timestamp: userEntity.joinedAt,
                      monthYearOnly: true,
                    )}",
                    style: AppTextStyles.uberMoveMedium(context, 18)
                        .copyWith(color: AppColors.thirdColor),
                  ),
                ],
              ),
              const VerticalGap(12),
              CustomUserFollowRelationShipsCount(userEntity: userEntity),
              const VerticalGap(12),
            ],
          ),
        ),
        Visibility(
          visible: userEntity.userId == getCurrentUserEntity().userId,
          child: PositionedDirectional(
            end: 16,
            bottom: 230,
            child: CustomContainerButton(
              onPressed: () {
                Navigator.pushNamed(
                        context, UserAccountInformationScreen.routeId)
                    .then(
                  (value) {
                    setState(() {
                      userEntity = getCurrentUserEntity();
                    });
                  },
                );
              },
              internalVerticalPadding: 4,
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.white
                  : Colors.black,
              borderColor: AppColors.borderColor,
              borderWidth: 1,
              child: Text(
                context.tr("Edit profile"),
                style: AppTextStyles.uberMoveExtraBold(context, 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
