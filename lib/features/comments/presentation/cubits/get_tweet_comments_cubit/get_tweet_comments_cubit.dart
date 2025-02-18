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
  }) async {
    emit(GetTweetCommentsLoadingState());
    var res = await commentsRepo.getTweetComments(
      tweetId: tweetId,
      filter: filter,
    );
    res.fold(
      (failure) => emit(GetTweetCommentsFailureState(message: failure.message)),
      (comments) => emit(GetTweetCommentsLoadedState(comments: comments)),
    );
  }
}
