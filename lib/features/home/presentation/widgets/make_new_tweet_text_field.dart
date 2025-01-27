
import 'package:flutter/material.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_text_form_field.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

class MakeNewTweetTextField extends StatelessWidget {
  const MakeNewTweetTextField({
    super.key,
    required this.userEntity,
    required this.textTweetController,
    this.hintText,
  });

  final UserEntity userEntity;
  final TextEditingController textTweetController;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BuildUserCircleAvatarImage(
          profilePicUrl: userEntity.profilePicUrl,
          circleAvatarRadius: 20,
        ),
        const HorizontalGap(24),
        Expanded(
          child: CustomTextFormFieldWidget(
            controller: textTweetController,
            contentPadding: 0,
            borderWidth: 0,
            borderColor: Colors.white,
            focusedBorderWidth: 0,
            focusedBorderColor: Colors.white,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: AppTextStyles.uberMoveRegular22.copyWith(
              color: AppColors.secondaryColor,
            ),
            maxLines: null,
          ),
        ),
      ],
    );
  }
}
