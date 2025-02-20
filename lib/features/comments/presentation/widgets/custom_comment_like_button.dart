import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/widgets/custom_like_button_body.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/data/models/comment_likes_model.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/domain/repos/comment_likes_repo.dart';
import 'package:twitter_app/features/comments/presentation/cubits/toggle_comment_likes_cubit/toggle_comment_likes_cubit.dart';

class CustomCommentLikeButton extends StatelessWidget {
  const CustomCommentLikeButton({
    super.key,
    required this.commentDetailsEntity,
    required this.currentUser,
    this.isActive = false,
  });

  final UserEntity currentUser;
  final CommentDetailsEntity commentDetailsEntity;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ToggleCommentLikesCubit(
        commentLikesRepo: getIt<CommentLikesRepo>(),
      ),
      child: CommentLikeButtonBlocConsumerBody(
        isActive: isActive,
        commentDetailsEntity: commentDetailsEntity,
        currentUser: currentUser,
      ),
    );
  }
}

class CommentLikeButtonBlocConsumerBody extends StatefulWidget {
  const CommentLikeButtonBlocConsumerBody({
    super.key,
    required this.commentDetailsEntity,
    required this.currentUser,
    this.isActive = false,
  });
  final UserEntity currentUser;
  final CommentDetailsEntity commentDetailsEntity;
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
  String? toggledLikeId;

  @override
  void initState() {
    super.initState();
    isActive = widget.isActive;
    likesCount = widget.commentDetailsEntity.comment.likes?.length ?? 0;
    if (isActive) {
      amount = -1;
    } else {
      amount = 1;
    }
  }

  void updateCommentDetailsEntity(String likeId) {
    if (isActive) {
      widget.commentDetailsEntity.addLike(likeId);
    } else {
      widget.commentDetailsEntity.removeLike(likeId);
    }
  }

  Future<bool?> _onToggleLikeButtonPressed(bool isLiked) async {
    BlocProvider.of<ToggleCommentLikesCubit>(context).toggleCommentLikes(
      data: CommentLikesModel(
        commentId: widget.commentDetailsEntity.commentId,
        userId: widget.currentUser.userId,
        originalAuthorId:
            widget.commentDetailsEntity.commentAuthorData.userId,
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
          showCustomSnackBar(context, context.tr(state.message));
          setState(() {
            isActive = !isActive;
            likesCount += amount;
            amount *= -1;
          });
        } else if (state is ToggleCommentLikesLoadedState) {
          toggledLikeId = state.toggledLikeId;
          updateCommentDetailsEntity(state.toggledLikeId);
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
