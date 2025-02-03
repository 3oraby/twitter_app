import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/build_user_circle_avatar_image.dart';
import 'package:twitter_app/core/widgets/custom_background_icon.dart';
import 'package:twitter_app/core/widgets/custom_container_button.dart';
import 'package:twitter_app/core/widgets/custom_text_form_field.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/data/models/comment_model.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/presentation/cubits/make_new_comment_cubit/make_new_comment_cubit.dart';
import 'package:twitter_app/features/comments/presentation/cubits/reply_media_files_cubit/reply_media_files_cubit.dart';
import 'package:twitter_app/features/home/presentation/widgets/preview_chosen_media.dart';
import 'package:twitter_app/features/replies/data/models/reply_model.dart';
import 'package:twitter_app/features/replies/presentation/cubits/make_new_reply_cubit/make_new_reply_cubit.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class ExpandedMakeReplySection extends StatefulWidget {
  const ExpandedMakeReplySection({
    super.key,
    required this.currentUser,
    required this.replyingToUserName,
    this.tweetDetailsEntity,
    this.commentDetailsEntity,
    this.isComment = true,
    this.onFieldSubmitted,
  });

  final UserEntity currentUser;
  final TweetDetailsEntity? tweetDetailsEntity;
  final CommentDetailsEntity? commentDetailsEntity;
  final String replyingToUserName;
  final bool isComment;
  final void Function(String?)? onFieldSubmitted;

  @override
  State<ExpandedMakeReplySection> createState() =>
      _ExpandedMakeReplySectionState();
}

class _ExpandedMakeReplySectionState extends State<ExpandedMakeReplySection> {
  late FocusNode _focusNode;

  final TextEditingController textReplyController = TextEditingController();
  List<File> mediaFiles = [];
  bool _isReplyButtonEnabled = false;
  late ReplyMediaFilesCubit replyMediaFilesCubit;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    replyMediaFilesCubit = BlocProvider.of<ReplyMediaFilesCubit>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    textReplyController.addListener(() {
      setState(() {
        if (textReplyController.text.trim().isNotEmpty ||
            mediaFiles.isNotEmpty) {
          _isReplyButtonEnabled = true;
        } else {
          _isReplyButtonEnabled = false;
        }
      });
    });
  }

  Future<void> _onAddImagePressed() async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        addMediaFilesToCubit(image);
        setState(() {
          _isReplyButtonEnabled = true;
        });
      }
    } catch (e) {
      log("Image picking error: $e");
    } finally {}
  }

  void addMediaFilesToCubit(XFile image) {
    replyMediaFilesCubit.addMediaFile(File(image.path));
  }

  void _onRemoveImageButtonPressed(int index) {
    setState(() {
      replyMediaFilesCubit.removeMediaFile(index);
      if (mediaFiles.isEmpty && textReplyController.text.trim().isEmpty) {
        _isReplyButtonEnabled = false;
      }
    });
  }

  void _onReplyButtonPressed() async {
    setState(() {
      _isReplyButtonEnabled = false;
    });
    final content = textReplyController.text.trim();

    if (widget.isComment) {
      CommentModel commentModel = CommentModel(
        tweetId: widget.tweetDetailsEntity!.tweetId,
        tweetAuthorData: widget.tweetDetailsEntity!.user,
        commentAuthorData: widget.currentUser,
        content: content,
        createdAt: Timestamp.now(),
      );
      BlocProvider.of<MakeNewCommentCubit>(context).makeNewComment(
        data: commentModel.toJson(),
        mediaFiles: mediaFiles,
      );
    } else {
      ReplyModel replyModel = ReplyModel(
        commentId: widget.commentDetailsEntity!.commentId,
        commentAuthorData:
            widget.commentDetailsEntity!.comment.commentAuthorData,
        replyAuthorData: widget.currentUser,
        content: content,
        createdAt: Timestamp.now(),
      );

      BlocProvider.of<MakeNewReplyCubit>(context).makeNewReply(
        data: replyModel.toJson(),
        mediaFiles: mediaFiles,
      );
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReplyMediaFilesCubit, ReplyMediaFilesState>(
      listener: (context, state) {
        if (state is ReplyMediaFilesUpdatedState) {
          setState(() {
            mediaFiles = state.mediaFiles;
          });
        }
      },
      child: BlocBuilder<MakeNewCommentCubit, MakeNewCommentState>(
        builder: (context, newCommentState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: BuildUserCircleAvatarImage(
                  profilePicUrl: widget.currentUser.profilePicUrl,
                  circleAvatarRadius: 20,
                ),
                title: Text(
                  "${widget.currentUser.firstName} ${widget.currentUser.lastName}",
                ),
                subtitle: Text(widget.currentUser.email),
              ),
              const VerticalGap(2),
              BlocBuilder<MakeNewReplyCubit, MakeNewReplyState>(
                builder: (context, newReplyState) {
                  return Visibility(
                    visible: newCommentState is MakeNewCommentLoadingState ||
                        newReplyState is MakeNewReplyLoadingState,
                    child: LinearProgressIndicator(
                      color: AppColors.twitterAccentColor,
                    ),
                  );
                },
              ),
              const VerticalGap(10),
              Row(
                children: [
                  Text("Replying to"),
                  Text(
                    " @${widget.replyingToUserName}",
                    style: AppTextStyles.uberMoveMedium18
                        .copyWith(color: AppColors.twitterAccentColor),
                  ),
                ],
              ),
              const VerticalGap(8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.lightBackgroundColor,
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                ),
                padding: mediaFiles.isNotEmpty
                    ? EdgeInsets.all(16)
                    : EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Visibility(
                      visible: mediaFiles.isNotEmpty,
                      child: PreviewChosenMedia(
                        previewChosenMediaLength: 100,
                        mediaFiles: mediaFiles,
                        onRemoveImageButtonPressed: _onRemoveImageButtonPressed,
                      ),
                    ),
                    const VerticalGap(16),
                    CustomTextFormFieldWidget(
                      controller: textReplyController,
                      hintText: "Post your reply...",
                      focusNode: _focusNode,
                      maxLines: null,
                      contentPadding: 0,
                      borderWidth: 0,
                      borderColor: Colors.white,
                      focusedBorderWidth: 0,
                      focusedBorderColor: Colors.white,
                      hintStyle: AppTextStyles.uberMoveBold20.copyWith(
                        color: AppColors.secondaryColor,
                      ),
                      onFieldSubmitted: widget.onFieldSubmitted,
                    ),
                  ],
                ),
              ),
              const VerticalGap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _onAddImagePressed,
                    child: CustomBackgroundIcon(
                      iconData: Icons.add_a_photo,
                      iconColor: AppColors.primaryColor,
                    ),
                  ),
                  CustomContainerButton(
                    internalVerticalPadding: 6,
                    internalHorizontalPadding: 16,
                    backgroundColor: _isReplyButtonEnabled
                        ? AppColors.twitterAccentColor
                        : AppColors.lightTwitterAccentColor,
                    onPressed:
                        _isReplyButtonEnabled ? _onReplyButtonPressed : null,
                    child: Text(
                      "Reply",
                      style: AppTextStyles.uberMoveBold16.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
