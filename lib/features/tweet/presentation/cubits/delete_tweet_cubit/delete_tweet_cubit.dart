import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_repo.dart';

part 'delete_tweet_state.dart';

class DeleteTweetCubit extends Cubit<DeleteTweetState> {
  DeleteTweetCubit({
    required this.tweetRepo,
  }) : super(DeleteTweetInitial());

  final TweetRepo tweetRepo;

  Future<void> deleteTweet({
    required String tweetId,
  }) async {
    emit(DeleteTweetLoadingState());
    var res = await tweetRepo.deleteTweet(tweetId: tweetId);
    res.fold(
      (failure) => emit(DeleteTweetFailureState(message: failure.message)),
      (success) => emit(DeleteTweetLoadedState()),
    );
  }
}
