
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/follow_relationships/presentation/widgets/user_info_card.dart';

class FollowersSuggestionsBody extends StatefulWidget {
  const FollowersSuggestionsBody({
    super.key,
    required this.suggestionUsers,
  });

  final List<UserEntity> suggestionUsers;

  @override
  State<FollowersSuggestionsBody> createState() =>
      _FollowersSuggestionsBodyState();
}

class _FollowersSuggestionsBodyState extends State<FollowersSuggestionsBody> {
  late UserEntity currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  context.tr("Suggested for you"),
                  style: AppTextStyles.uberMoveBlack(context,24),
                ),
              ],
            ),
            const VerticalGap(24),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.suggestionUsers.length,
              separatorBuilder: (context, index) => const VerticalGap(24),
              itemBuilder: (context, index) => UserInfoCard(
                user: widget.suggestionUsers[index],
                currentUserId: currentUser.userId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
