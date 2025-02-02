import 'package:flutter/material.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/presentation/widgets/collapsed_make_reply_section.dart';
import 'package:twitter_app/features/comments/presentation/widgets/expanded_make_reply_section.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class CustomMakeReplySection extends StatelessWidget {
  const CustomMakeReplySection({
    super.key,
    required this.tweetDetailsEntity,
    required this.isSectionExpanded,
    required this.onTextFieldTap,
    required this.currentUser,
  });

  final TweetDetailsEntity tweetDetailsEntity;
  final bool isSectionExpanded;
  final VoidCallback onTextFieldTap;
  final UserEntity currentUser;

  @override
  Widget build(BuildContext context) {
    if (isSectionExpanded) {
      return GestureDetector(
        onTap: () {},
        child: ExpandedMakeReplySection(
          currentUser: currentUser,
          tweetDetailsEntity: tweetDetailsEntity,
        ),
      );
    } else {
      return CollapsedMakeReplySection(
        currentUser: currentUser,
        onTextFieldTap: onTextFieldTap,
      );
    }
  }
}
