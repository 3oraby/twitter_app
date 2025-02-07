import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/domain/repos/comments_repo.dart';

part 'get_tweet_comments_state.dart';

class GetTweetCommentsCubit extends Cubit<GetTweetCommentsState> {
  GetTweetCommentsCubit({
    required this.commentsRepo,
  }) : super(GetTweetCommentsInitial());

  final CommentsRepo commentsRepo;

  Future<void> getTweetComments({
    required String tweetId,
    String? filter,
    int? limit,
    DocumentSnapshot? lastDocument,
    dynamic startAfterValue,
    String? startAfterField,
    dynamic startAt,
    dynamic startAfter,
  }) async {
    emit(GetTweetCommentsLoadingState());
    var res = await commentsRepo.getTweetComments(
      tweetId: tweetId,
      filter: filter,
      limit: limit,
      lastDocument: lastDocument,
      startAfterField: startAfterField,
      startAfterValue: startAfterValue,
      startAt: startAt,
      startAfter: startAfter,
    );
    res.fold(
      (failure) => emit(GetTweetCommentsFailureState(message: failure.message)),
      (comments) {
        if (comments.isEmpty) {
          emit(GetTweetCommentsEmptyState());
        } else {
          emit(GetTweetCommentsLoadedState(comments: comments));
        }
      },
    );
  }
}
