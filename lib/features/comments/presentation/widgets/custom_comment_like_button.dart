import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/widgets/custom_like_button_body.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/data/models/comment_likes_model.dart';
import 'package:twitter_app/features/comments/domain/repos/comment_likes_repo.dart';
import 'package:twitter_app/features/comments/presentation/cubits/toggle_comment_likes_cubit/toggle_comment_likes_cubit.dart';

class CustomCommentLikeButton extends StatelessWidget {
  const CustomCommentLikeButton({
    super.key,
    required this.commentId,
    required this.originalAuthorId,
    required this.likesCount,
    this.isActive = false,
  });

  final String commentId;
  final String originalAuthorId;
  final int likesCount;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToggleCommentLikesCubit(
        commentLikesRepo: getIt<CommentLikesRepo>(),
      ),
      child: CommentLikeButtonBlocConsumerBody(
        commentId: commentId,
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
    required this.commentId,
    required this.originalAuthorId,
    required this.likesCount,
    this.isActive = false,
  });
  final String commentId;
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
    BlocProvider.of<ToggleCommentLikesCubit>(context).toggleCommentLikes(
      data: CommentLikesModel(
        commentId: widget.commentId,
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
    return BlocConsumer<ToggleCommentLikesCubit, ToggleCommentLikesState>(
      listener: (context, state) {
        if (state is ToggleCommentLikesFailureState) {
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
