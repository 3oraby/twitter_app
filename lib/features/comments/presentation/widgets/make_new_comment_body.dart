import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_tweet_info_card.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/presentation/cubits/make_new_comment_cubit/make_new_comment_cubit.dart';
import 'package:twitter_app/features/home/presentation/widgets/make_new_tweet_preview_media.dart';
import 'package:twitter_app/features/home/presentation/widgets/make_new_tweet_text_field.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class MakeNewCommentBody extends StatelessWidget {
  const MakeNewCommentBody({
    super.key,
    required this.tweetDetailsEntity,
    required this.currentUser,
    required this.textCommentController,
    required this.mediaFiles,
    required this.onRemoveImageButtonPressed,
  });

  final TweetDetailsEntity tweetDetailsEntity;
  final UserEntity currentUser;
  final TextEditingController textCommentController;
  final void Function(int index) onRemoveImageButtonPressed;
  final List<File> mediaFiles;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MakeNewCommentCubit, MakeNewCommentState>(
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state is MakeNewCommentLoadingState,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalPadding,
                vertical: AppConstants.topPadding,
              ),
              child: Column(
                children: [
                  Visibility(
                    visible: state is MakeNewCommentLoadingState,
                    child: LinearProgressIndicator(
                      color: AppColors.twitterAccentColor,
                    ),
                  ),
                  const VerticalGap(6),
                  CustomTweetInfoCard(
                    tweetDetailsEntity: tweetDetailsEntity,
                    mediaHeight: 150,
                    mediaWidth: 100,
                    showInteractionsRow: false,
                  ),
                  const VerticalGap(24),
                  Row(
                    children: [
                      Text(
                        "Replying to",
                        style: AppTextStyles.uberMoveMedium16.copyWith(
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      Text(
                        " @${tweetDetailsEntity.user.email}",
                        style: AppTextStyles.uberMoveMedium16.copyWith(
                          color: AppColors.twitterAccentColor,
                        ),
                      ),
                    ],
                  ),
                  const VerticalGap(16),
                  MakeNewTweetTextField(
                    userEntity: currentUser,
                    textTweetController: textCommentController,
                    hintText: "Post your comment",
                  ),
                  const VerticalGap(16),
                  MakeNewTweetPreviewMedia(
                    mediaFiles: mediaFiles,
                    onRemoveImageButtonPressed: onRemoveImageButtonPressed,
                  ),
                  const VerticalGap(24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
