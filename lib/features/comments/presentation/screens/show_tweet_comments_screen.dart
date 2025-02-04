import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/domain/repos/comments_repo.dart';
import 'package:twitter_app/features/comments/presentation/cubits/make_new_comment_cubit/make_new_comment_cubit.dart';
import 'package:twitter_app/features/comments/presentation/cubits/reply_media_files_cubit/reply_media_files_cubit.dart';
import 'package:twitter_app/features/comments/presentation/widgets/custom_make_reply_section.dart';
import 'package:twitter_app/features/comments/presentation/widgets/show_tweet_comments_part.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/replies/domain/repos/replies_repo.dart';
import 'package:twitter_app/features/replies/presentation/cubits/make_new_reply_cubit/make_new_reply_cubit.dart';
import 'package:twitter_app/features/tweet/presentation/widgets/custom_main_details_tweet_card.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';

class ShowTweetCommentsScreen extends StatelessWidget {
  const ShowTweetCommentsScreen({
    super.key,
    required this.tweetDetailsEntity,
  });

  static const String routeId = 'kShowTweetCommentsScreen';
  final TweetDetailsEntity tweetDetailsEntity;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ReplyMediaFilesCubit(),
        ),
        BlocProvider(
          create: (context) => MakeNewCommentCubit(
            commentsRepo: getIt<CommentsRepo>(),
          ),
        ),
        BlocProvider(
          create: (context) => MakeNewReplyCubit(
            repliesRepo: getIt<RepliesRepo>(),
          ),
        ),
      ],
      child: Scaffold(
        appBar: buildCustomAppBar(
          context,
          title: Text(
            "Post",
            style: AppTextStyles.uberMoveBlack20,
          ),
        ),
        body: ShowTweetCommentsListenerBody(
          tweetDetailsEntity: tweetDetailsEntity,
        ),
      ),
    );
  }
}

class ShowTweetCommentsListenerBody extends StatefulWidget {
  const ShowTweetCommentsListenerBody({
    super.key,
    required this.tweetDetailsEntity,
  });

  final TweetDetailsEntity tweetDetailsEntity;
  @override
  State<ShowTweetCommentsListenerBody> createState() =>
      _ShowTweetCommentsListenerBodyState();
}

class _ShowTweetCommentsListenerBodyState
    extends State<ShowTweetCommentsListenerBody> {
  bool isSectionExpanded = false;
  bool isComment = true;
  List<File> mediaFiles = [];
  late UserEntity currentUser;
  final ScrollController _scrollController = ScrollController();
  late String replyingToUserName;
  CommentDetailsEntity? _commentDetailsEntity;
  ReplyDetailsEntity? _replyDetailsEntity;

  void toggleSection() {
    setState(() {
      isSectionExpanded = !isSectionExpanded;
    });
  }

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity();
    replyingToUserName = widget.tweetDetailsEntity.user.email;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ReplyMediaFilesCubit, ReplyMediaFilesState>(
          listener: (context, state) {
            if (state is ReplyMediaFilesUpdatedState) {
              setState(() {
                log("listen about media files in showTweetCommentsScreen");
                mediaFiles = state.mediaFiles;
              });
            }
          },
        ),
        BlocListener<MakeNewCommentCubit, MakeNewCommentState>(
          listener: (context, state) {
            if (state is MakeNewCommentLoadedState) {
              setState(() {
                isSectionExpanded = false;
              });
            }
          },
        ),
        BlocListener<MakeNewReplyCubit, MakeNewReplyState>(
          listener: (context, state) {
            if (state is MakeNewReplyLoadedState) {
              setState(() {
                isSectionExpanded = false;
              });
            }
          },
        ),
      ],
      child: GestureDetector(
        onTap: () {
          if (isSectionExpanded) {
            if (mediaFiles.isNotEmpty) {
              FocusScope.of(context).unfocus();
            } else {
              toggleSection();
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalPadding,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      CustomMainDetailsTweetCard(
                        tweetDetailsEntity: widget.tweetDetailsEntity,
                      ),
                      const Divider(
                        color: AppColors.dividerColor,
                        height: 32,
                      ),
                      ShowTweetCommentsPart(
                        tweetDetailsEntity: widget.tweetDetailsEntity,
                        onReplyButtonPressed: (entity) {
                          entity.fold(
                            (commentDetailsEntity) {
                              setState(() {
                                isComment = false;
                                isSectionExpanded = true;
                                replyingToUserName = commentDetailsEntity
                                    .comment.commentAuthorData.email;
                                _commentDetailsEntity = commentDetailsEntity;
                              });
                            },
                            (replyDetailsEntity) {
                              setState(() {
                                isComment = false;
                                isSectionExpanded = true;
                                replyingToUserName = replyDetailsEntity
                                    .reply.commentAuthorData.email;
                                _replyDetailsEntity = replyDetailsEntity;
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              CustomMakeReplySection(
                tweetDetailsEntity: widget.tweetDetailsEntity,
                commentDetailsEntity: _commentDetailsEntity,
                replyDetailsEntity: _replyDetailsEntity,
                isSectionExpanded: isSectionExpanded,
                onTextFieldTap: toggleSection,
                currentUser: currentUser,
                replyingToUserName: replyingToUserName,
                onFieldSubmitted: (text) {
                  if ((text?.isEmpty ?? false) && mediaFiles.isEmpty) {
                    setState(() {
                      isSectionExpanded = false;
                    });
                  }
                },
                isComment: isComment,
              ),
              const VerticalGap(16),
            ],
          ),
        ),
      ),
    );
  }
}
