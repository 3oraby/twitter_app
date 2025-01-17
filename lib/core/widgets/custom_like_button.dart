import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/features/tweet/data/models/tweet_likes_model.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_likes_repo.dart';
import 'package:twitter_app/features/tweet/presentation/cubits/toggle_tweet_like_cubit/toggle_tweet_like_cubit.dart';

class CustomLikeButton extends StatelessWidget {
  const CustomLikeButton({
    super.key,
    required this.tweetId,
    required this.originalAuthorId,
    required this.userId,
  });

  final String tweetId;
  final String originalAuthorId;
  final String userId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToggleTweetLikeCubit(
        tweetLikesRepo: getIt<TweetLikesRepo>(),
      ),
      child: LikeButtonBlocConsumerBody(
        userId: userId,
        tweetId: tweetId,
        originalAuthorId: originalAuthorId,
      ),
    );
  }
}

class LikeButtonBlocConsumerBody extends StatefulWidget {
  const LikeButtonBlocConsumerBody({
    super.key,
    required this.tweetId,
    required this.originalAuthorId,
    required this.userId,
  });
  final String tweetId;
  final String originalAuthorId;
  final String userId;
  @override
  State<LikeButtonBlocConsumerBody> createState() =>
      _LikeButtonBlocConsumerBodyState();
}

class _LikeButtonBlocConsumerBodyState
    extends State<LikeButtonBlocConsumerBody> {
  bool isActive = false;

  _onToggleLikeButtonPressed() async {
    await BlocProvider.of<ToggleTweetLikeCubit>(context).toggleTweetLike(
      data: TweetLikesModel(
        tweetId: widget.tweetId,
        userId: widget.userId,
        originalAuthorId: widget.originalAuthorId,
        likedAt: Timestamp.now(),
      ).toJson(),
    );
    setState(() {
      isActive = !isActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToggleTweetLikeCubit, ToggleTweetLikeState>(
      listener: (context, state) {
        if (state is ToggleTweetLikeFailureState) {
          showCustomSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return IconButton(
          onPressed: _onToggleLikeButtonPressed,
          icon: isActive
              ? const Icon(
                  Icons.favorite,
                  color: Colors.red,
                )
              : const Icon(
                  Icons.favorite_border,
                ),
        );
      },
    );
  }
}
