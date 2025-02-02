import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/presentation/widgets/collapsed_make_reply_section.dart';
import 'package:twitter_app/features/comments/presentation/widgets/expanded_make_reply_section.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class CustomMakeReplySection extends StatefulWidget {
  const CustomMakeReplySection({
    super.key,
    required this.tweetDetailsEntity,
  });
  final TweetDetailsEntity tweetDetailsEntity;
  @override
  State<CustomMakeReplySection> createState() => _CustomMakeReplySectionState();
}

class _CustomMakeReplySectionState extends State<CustomMakeReplySection> {
  late UserEntity currentUser;
  bool isSectionExpanded = false;
  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity();
  }

  @override
  Widget build(BuildContext context) {
    if (isSectionExpanded) {
      return ExpandedMakeReplySection(
        currentUser: currentUser,
        tweetDetailsEntity: widget.tweetDetailsEntity,
      );
    } else {
      return CollapsedMakeReplySection(
        currentUser: currentUser,
        onTextFieldTap: () {
          setState(() {
            isSectionExpanded = true;
          });
        },
      );
    }
  }
}