import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/presentation/widgets/custom_make_reply_section.dart';
import 'package:twitter_app/features/comments/presentation/widgets/show_tweet_comments_part.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_main_details_tweet_card.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class ShowTweetCommentsScreen extends StatefulWidget {
  const ShowTweetCommentsScreen({
    super.key,
    required this.tweetDetailsEntity,
  });

  static const String routeId = 'kShowTweetCommentsScreen';
  final TweetDetailsEntity tweetDetailsEntity;

  @override
  _ShowTweetCommentsScreenState createState() =>
      _ShowTweetCommentsScreenState();
}

class _ShowTweetCommentsScreenState extends State<ShowTweetCommentsScreen> {
  bool isSectionExpanded = false;
  late UserEntity currentUser;
  final ScrollController _scrollController = ScrollController();

  void toggleSection() {
    setState(() {
      isSectionExpanded = !isSectionExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
        context,
        title: Text(
          "Post",
          style: AppTextStyles.uberMoveBlack20,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          if (isSectionExpanded) {
            toggleSection();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      CustomMainDetailsTweetCard(
                        tweetDetailsEntity: widget.tweetDetailsEntity,
                      ),
                      const Divider(
                        color: AppColors.dividerColor,
                        height: 32,
                      ),
                      ShowTweetCommentsPart(
                        tweetDetailsEntity: widget.tweetDetailsEntity,
                      ),
                    ],
                  ),
                ),
              ),
              CustomMakeReplySection(
                tweetDetailsEntity: widget.tweetDetailsEntity,
                isSectionExpanded: isSectionExpanded,
                onTextFieldTap: toggleSection,
                currentUser: currentUser,
              ),
              const VerticalGap(16),
            ],
          ),
        ),
      ),
    );
  }
}
