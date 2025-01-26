import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/bookmark/data/models/bookmark_model.dart';
import 'package:twitter_app/features/bookmark/domain/repos/bookmark_repo.dart';
import 'package:twitter_app/features/bookmark/presentation/cubits/toggle_bookmarks_cubit/toggle_bookmarks_cubit.dart';

class CustomBookmarkButton extends StatelessWidget {
  const CustomBookmarkButton({
    super.key,
    required this.tweetId,
    required this.originalAuthorId,
    this.isActive = false,
  });

  final String tweetId;
  final String originalAuthorId;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToggleBookmarksCubit(
        bookmarkRepo: getIt<BookmarkRepo>(),
      ),
      child: BookmarkButtonBlocConsumerBody(
        tweetId: tweetId,
        originalAuthorId: originalAuthorId,
        isActive: isActive,
      ),
    );
  }
}

class BookmarkButtonBlocConsumerBody extends StatefulWidget {
  const BookmarkButtonBlocConsumerBody({
    super.key,
    required this.tweetId,
    required this.originalAuthorId,
    this.isActive = false,
  });
  final String tweetId;
  final String originalAuthorId;
  final bool isActive;
  @override
  State<BookmarkButtonBlocConsumerBody> createState() =>
      _BookmarkButtonBlocConsumerBodyState();
}

class _BookmarkButtonBlocConsumerBodyState
    extends State<BookmarkButtonBlocConsumerBody> {
  late bool isActive;
  late UserEntity currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity();
    isActive = widget.isActive;
  }

  Future<bool?> _onToggleBookmarkButtonPressed(bool isBookmarked) async {
    BlocProvider.of<ToggleBookmarksCubit>(context).toggleBookmark(
      data: BookmarkModel(
        tweetId: widget.tweetId,
        userId: currentUser.userId,
        originalAuthorId: widget.originalAuthorId,
        bookmarkedAt: Timestamp.now(),
      ).toJson(),
    );
    setState(() {
      isActive = !isBookmarked;
    });
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
