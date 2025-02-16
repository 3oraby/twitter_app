import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/helpers/functions/pick_image_from_gallery.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/custom_container_button.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/data/models/comment_details_model.dart';
import 'package:twitter_app/features/comments/data/models/comment_model.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/presentation/cubits/update_comment_cubit/update_comment_cubit.dart';
import 'package:twitter_app/features/home/presentation/widgets/custom_floating_action_button.dart';
import 'package:twitter_app/features/home/presentation/widgets/make_new_tweet_text_field.dart';
import 'package:twitter_app/features/home/presentation/widgets/preview_chosen_media.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';

class UpdateCommentsAndRepliesScreen extends StatelessWidget {
  const UpdateCommentsAndRepliesScreen({
    super.key,
    this.commentDetailsEntity,
    this.replyDetailsEntity,
  });
  static const String routeId = "kUpdateCommentsAndRepliesScreen";
  final CommentDetailsEntity? commentDetailsEntity;
  final ReplyDetailsEntity? replyDetailsEntity;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<UpdateCommentCubit>(),
      child: UpdateCommentsAndRepliesBlocConsumerBody(
        commentDetailsEntity: commentDetailsEntity,
        replyDetailsEntity: replyDetailsEntity,
      ),
    );
  }
}

class UpdateCommentsAndRepliesBlocConsumerBody extends StatefulWidget {
  const UpdateCommentsAndRepliesBlocConsumerBody({
    super.key,
    this.commentDetailsEntity,
    this.replyDetailsEntity,
  });

  final CommentDetailsEntity? commentDetailsEntity;
  final ReplyDetailsEntity? replyDetailsEntity;

  @override
  State<UpdateCommentsAndRepliesBlocConsumerBody> createState() =>
      _UpdateCommentsAndRepliesBlocConsumerBodyState();
}

class _UpdateCommentsAndRepliesBlocConsumerBodyState
    extends State<UpdateCommentsAndRepliesBlocConsumerBody> {
  final TextEditingController textContoller = TextEditingController();
  late UserEntity userEntity;
  List<File> mediaFiles = [];
  List<String> removedMediaUrls = [];
  List<File> constantMediaUrl = [];
  List<String>? networkMediaUrls;
  bool _isPostButtonEnabled = false;
  bool isImageLoading = false;

  @override
  void initState() {
    super.initState();
    userEntity = getCurrentUserEntity();

    if (widget.commentDetailsEntity != null) {
      textContoller.text = widget.commentDetailsEntity!.comment.content ?? '';
      networkMediaUrls = List.from(
          widget.commentDetailsEntity!.comment.mediaUrl as Iterable<dynamic>);
    } else {
      textContoller.text = widget.replyDetailsEntity!.reply.content ?? '';
      networkMediaUrls = List.from(
          widget.replyDetailsEntity!.reply.mediaUrl as Iterable<dynamic>);
    }

    textContoller.addListener(() {
      String newContent = textContoller.text.trim();

      String? realContent = widget.commentDetailsEntity != null
          ? widget.commentDetailsEntity!.comment.content
          : widget.replyDetailsEntity!.reply.content;

      setState(() {
        _isPostButtonEnabled =
            (newContent.isNotEmpty && newContent != realContent) ||
                (mediaFiles.isNotEmpty);
      });
    });
  }

  _buildAppBar() {
    return buildCustomAppBar(
      context,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Row(
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              context.tr("Cancel"),
              style: AppTextStyles.uberMoveMedium20,
            ),
          ),
        ],
      ),
      actions: [
        CustomContainerButton(
          internalVerticalPadding: 4,
          backgroundColor: _isPostButtonEnabled
              ? AppColors.twitterAccentColor
              : AppColors.lightTwitterAccentColor,
          onPressed:
              _isPostButtonEnabled ? () => _onPostButtonPressed(context) : null,
          child: Text(
            context.tr("Update"),
            style: AppTextStyles.uberMoveMedium18.copyWith(color: Colors.white),
          ),
        ),
        const HorizontalGap(AppConstants.horizontalPadding),
      ],
    );
  }

  Future<void> _onAddImagePressed() async {
    try {
      setState(() {
        isImageLoading = true;
      });
      XFile? image = await pickImageFromGallery();
      if (image != null) {
        setState(() {
          mediaFiles.add(File(image.path));
          _isPostButtonEnabled = true;
        });
      }
    } catch (e) {
      log("Image picking error: $e");
    } finally {
      setState(() {
        isImageLoading = false;
      });
    }
  }

  void _onRemoveImageButtonPressed(int index) {
    setState(() {
      mediaFiles.removeAt(index);
      _isPostButtonEnabled =
          textContoller.text.trim().isNotEmpty || mediaFiles.isNotEmpty;
    });
  }

  void _onRemoveNetworkImageUrlPressed(int index) {
    setState(() {
      removedMediaUrls.add(networkMediaUrls![index]);
      networkMediaUrls!.removeAt(index);
      _isPostButtonEnabled =
          textContoller.text.trim().isNotEmpty || networkMediaUrls!.isNotEmpty;
    });
  }

  void _onPostButtonPressed(BuildContext context) async {
    setState(() {
      _isPostButtonEnabled = false;
    });
    final content = textContoller.text.trim();
    if (widget.commentDetailsEntity != null) {
      CommentModel newCommentModel =
          CommentModel.fromEntity(widget.commentDetailsEntity!.comment)
              .copyWith(
        content: content,
        updatedAt: Timestamp.now(),
      );

      CommentDetailsModel newCommentDetails =
          CommentDetailsModel.fromEntity(widget.commentDetailsEntity!).copyWith(
        comment: newCommentModel.toEntity(),
      );

      BlocProvider.of<UpdateCommentCubit>(context).updateComment(
        commentId: widget.commentDetailsEntity!.commentId,
        data: newCommentDetails.toJson(),
        mediaFiles: mediaFiles,
        constantMediaUrls: networkMediaUrls,
        removedMediaUrls: removedMediaUrls,
      );
    }
  }

  @override
  void dispose() {
    textContoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateCommentCubit, UpdateCommentState>(
      listener: (context, updateCommentState) {
        if (updateCommentState is UpdateCommentLoadedState) {
          Navigator.pop(context);
        } else if (updateCommentState is UpdateCommentFailureState) {
          showCustomSnackBar(context, context.tr(updateCommentState.message));
          Navigator.pop(context);
        }
      },
      builder: (context, updateCommentState) => AbsorbPointer(
        absorbing: updateCommentState is UpdateCommentLoadingState,
        child: Scaffold(
          appBar: _buildAppBar(),
          floatingActionButton: CustomFloatingActionButton(
            iconData: Icons.add_a_photo,
            onPressed: _onAddImagePressed,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalPadding),
            child: ListView(
              children: [
                Visibility(
                  visible: updateCommentState is UpdateCommentLoadingState,
                  child: LinearProgressIndicator(
                    color: AppColors.twitterAccentColor,
                  ),
                ),
                const VerticalGap(6),
                MakeNewTweetTextField(
                  userEntity: userEntity,
                  textTweetController: textContoller,
                  hintText: context.tr("What`s happening?"),
                ),
                const VerticalGap(28),
                PreviewChosenMedia(
                  mediaFiles: mediaFiles,
                  onRemoveImageButtonPressed: _onRemoveImageButtonPressed,
                  onRemoveNetworkImageUrlPressed:
                      _onRemoveNetworkImageUrlPressed,
                  isLoading: isImageLoading,
                  networkMediaUrls: networkMediaUrls,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
