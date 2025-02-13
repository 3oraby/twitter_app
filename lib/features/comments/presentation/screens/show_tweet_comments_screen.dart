import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/features/comments/domain/repos/comments_repo.dart';
import 'package:twitter_app/features/comments/presentation/cubits/make_new_comment_cubit/make_new_comment_cubit.dart';
import 'package:twitter_app/features/comments/presentation/cubits/reply_media_files_cubit/reply_media_files_cubit.dart';
import 'package:twitter_app/features/comments/presentation/widgets/show_tweet_comments_listener_body.dart';
import 'package:twitter_app/features/replies/domain/repos/replies_repo.dart';
import 'package:twitter_app/features/replies/presentation/cubits/make_new_reply_cubit/make_new_reply_cubit.dart';
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
            context.tr("post_noun"),
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
