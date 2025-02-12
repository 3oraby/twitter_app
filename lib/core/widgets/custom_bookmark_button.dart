import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/bookmark/data/models/bookmark_model.dart';
import 'package:twitter_app/features/bookmark/domain/repos/bookmark_repo.dart';
import 'package:twitter_app/features/bookmark/presentation/cubits/toggle_bookmarks_cubit/toggle_bookmarks_cubit.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class CustomBookmarkButton extends StatelessWidget {
  const CustomBookmarkButton({
    super.key,
    required this.currentUser,
    required this.tweetDetailsEntity,
    this.isActive = false,
  });

  final TweetDetailsEntity tweetDetailsEntity;
  final UserEntity currentUser;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToggleBookmarksCubit(
        bookmarkRepo: getIt<BookmarkRepo>(),
      ),
      child: BookmarkButtonBlocConsumerBody(
        currentUser: currentUser,
        tweetDetailsEntity: tweetDetailsEntity,
        isActive: isActive,
      ),
    );
  }
}

class BookmarkButtonBlocConsumerBody extends StatefulWidget {
  const BookmarkButtonBlocConsumerBody({
    super.key,
    required this.currentUser,
    required this.tweetDetailsEntity,
    this.isActive = false,
  });

  final TweetDetailsEntity tweetDetailsEntity;
  final UserEntity currentUser;
  final bool isActive;
  @override
  State<BookmarkButtonBlocConsumerBody> createState() =>
      _BookmarkButtonBlocConsumerBodyState();
}

class _BookmarkButtonBlocConsumerBodyState
    extends State<BookmarkButtonBlocConsumerBody> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.isActive;
  }

  void updateTweetDetailsEntity() {
    if (isActive) {
      widget.tweetDetailsEntity.addToBookmarks();
    } else {
      widget.tweetDetailsEntity.removeFromBookmarks();
    }
  }

  Future<bool?> _onToggleBookmarkButtonPressed(bool isBookmarked) async {
    BlocProvider.of<ToggleBookmarksCubit>(context).toggleBookmark(
      data: BookmarkModel(
        tweetId: widget.tweetDetailsEntity.tweetId,
        userId: widget.currentUser.userId,
        originalAuthorId: widget.tweetDetailsEntity.tweet.userId,
        bookmarkedAt: Timestamp.now(),
      ).toJson(),
    );
    setState(() {
      isActive = !isBookmarked;
    });
    updateTweetDetailsEntity();
    return !isBookmarked;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToggleBookmarksCubit, ToggleBookmarksState>(
      listener: (context, state) {
        if (state is ToggleBookmarksFailureState) {
          showCustomSnackBar(context, state.message);
          setState(() {
            isActive = !isActive;
          });
          updateTweetDetailsEntity();
        }
      },
      builder: (context, state) {
        return LikeButton(
          isLiked: isActive,
          onTap: _onToggleBookmarkButtonPressed,
          bubblesColor: BubblesColor(
            dotPrimaryColor: AppColors.twitterAccentColor,
            dotSecondaryColor: AppColors.lightTwitterAccentColor,
            dotThirdColor: AppColors.lightTwitterAccentColor,
            dotLastColor: AppColors.twitterAccentColor,
          ),
          likeBuilder: (isBookmarked) {
            return Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              color: isBookmarked
                  ? AppColors.twitterAccentColor
                  : AppColors.thirdColor,
            );
          },
        );
      },
    );
  }
}
