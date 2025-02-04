
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/widgets/custom_like_button_body.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/replies/data/models/reply_likes_model.dart';
import 'package:twitter_app/features/replies/domain/repos/reply_likes_repo.dart';
import 'package:twitter_app/features/replies/presentation/cubits/toggle_reply_likes_cubit/toggle_reply_likes_cubit.dart';

class CustomReplyLikeButton extends StatelessWidget {
  const CustomReplyLikeButton({
    super.key,
    required this.replyId,
    required this.originalAuthorId,
    required this.likesCount,
    this.isActive = false,
  });

  final String replyId;
  final String originalAuthorId;
  final int likesCount;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToggleReplyLikesCubit(
        replyLikesRepo: getIt<ReplyLikesRepo>(),
      ),
      child: CommentLikeButtonBlocConsumerBody(
        replyId: replyId,
        originalAuthorId: originalAuthorId,
        likesCount: likesCount,
        isActive: isActive,
      ),
    );
  }
}

class CommentLikeButtonBlocConsumerBody extends StatefulWidget {
  const CommentLikeButtonBlocConsumerBody({
    super.key,
    required this.replyId,
    required this.originalAuthorId,
    required this.likesCount,
    this.isActive = false,
  });
  final String replyId;
  final String originalAuthorId;
  final int likesCount;
  final bool isActive;
  @override
  State<CommentLikeButtonBlocConsumerBody> createState() =>
      _CommentLikeButtonBlocConsumerBodyState();
}

class _CommentLikeButtonBlocConsumerBodyState
    extends State<CommentLikeButtonBlocConsumerBody> {
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
    BlocProvider.of<ToggleReplyLikesCubit>(context).toggleReplyLikes(
      data: ReplyLikesModel(
        replyId: widget.replyId,
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
    return BlocConsumer<ToggleReplyLikesCubit, ToggleReplyLikesState>(
      listener: (context, state) {
        if (state is ToggleReplyLikesFailureState) {
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
