
import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/suggestion_followers/presentation/widgets/user_info_card.dart';

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
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Suggested for you",
                    style: AppTextStyles.uberMoveBlack24,
                  ),
                ],
              ),
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
      ),
    );
  }
}
