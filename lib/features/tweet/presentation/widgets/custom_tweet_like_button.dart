import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/widgets/custom_like_button_body.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/tweet/data/models/tweet_likes_model.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_likes_repo.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/toggle_tweet_like_cubit/toggle_tweet_like_cubit.dart';

class CustomTweetLikeButton extends StatelessWidget {
  const CustomTweetLikeButton({
    super.key,
    required this.tweetId,
    required this.originalAuthorId,
    required this.likesCount,
    this.isActive = false,
  });

  final String tweetId;
  final String originalAuthorId;
  final int likesCount;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToggleTweetLikeCubit(
        tweetLikesRepo: getIt<TweetLikesRepo>(),
      ),
      child: TweetLikeButtonBlocConsumerBody(
        tweetId: tweetId,
        originalAuthorId: originalAuthorId,
        likesCount: likesCount,
        isActive: isActive,
      ),
    );
  }
}

class TweetLikeButtonBlocConsumerBody extends StatefulWidget {
  const TweetLikeButtonBlocConsumerBody({
    super.key,
    required this.tweetId,
    required this.originalAuthorId,
    required this.likesCount,
    this.isActive = false,
  });
  final String tweetId;
  final String originalAuthorId;
  final int likesCount;
  final bool isActive;
  @override
  State<TweetLikeButtonBlocConsumerBody> createState() =>
      _TweetLikeButtonBlocConsumerBodyState();
}

class _TweetLikeButtonBlocConsumerBodyState
    extends State<TweetLikeButtonBlocConsumerBody> {
  late bool isActive;
  late int likesCount;
  late int amount;
  late UserEntity currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity();
    isActive = widget.isActive;
    likesCount = widget.likesCount;
    if (isActive) {
      amount = -1;
    } else {
      amount = 1;
    }
  }

  Future<bool?> _onToggleLikeButtonPressed(bool isLiked) async {
    BlocProvider.of<ToggleTweetLikeCubit>(context).toggleTweetLike(
      data: TweetLikesModel(
        tweetId: widget.tweetId,
        userId: currentUser.userId,
        originalAuthorId: widget.originalAuthorId,
        likedAt: Timestamp.now(),
      ).toJson(),
    );
    setState(() {
      isActive = !isLiked;
      likesCount += amount;
      amount *= -1;
    });
    return !isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToggleTweetLikeCubit, ToggleTweetLikeState>(
      listener: (context, state) {
        if (state is ToggleTweetLikeFailureState) {
          showCustomSnackBar(context, state.message);
          setState(() {
            isActive = !isActive;
            likesCount += amount;
            amount *= -1;
          });
        }
      },
      builder: (context, state) {
        return CustomLikeButtonBody(
          isActive: isActive,
          likesCount: likesCount,
          onToggleLikeButtonPressed: _onToggleLikeButtonPressed,
        );
      },
    );
  }
}
