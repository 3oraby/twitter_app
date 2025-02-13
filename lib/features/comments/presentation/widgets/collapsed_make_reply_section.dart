
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_text_form_field.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

class CollapsedMakeReplySection extends StatelessWidget {
  const CollapsedMakeReplySection({
    super.key,
    required this.currentUser,
    required this.onTextFieldTap,
  });

  final UserEntity currentUser;
  final VoidCallback onTextFieldTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BuildUserCircleAvatarImage(
          profilePicUrl: currentUser.profilePicUrl,
          circleAvatarRadius: 20,
        ),
        const HorizontalGap(16),
        Expanded(
          child: CustomTextFormFieldWidget(
            hintText: context.tr("Post your reply"),
            contentPadding: 16,
            onTap: onTextFieldTap,
          ),
        ),
      ],
    );
  }
}
