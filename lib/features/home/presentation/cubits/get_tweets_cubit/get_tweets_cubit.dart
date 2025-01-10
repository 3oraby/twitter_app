import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/home/domain/entities/tweet_entity.dart';
import 'package:twitter_app/features/home/domain/repos/tweet_repo.dart';

part 'get_tweets_state.dart';

class GetTweetsCubit extends Cubit<GetTweetsState> {
  GetTweetsCubit({required this.tweetRepo}) : super(GetTweetsInitial());
  final TweetRepo tweetRepo;

  Future<void> getTweets({bool isForFollowingOnly = false}) async {
    emit(GetTweetsLoadingState());
    var result =
        await tweetRepo.getTweets(isForFollowingOnly: isForFollowingOnly);
    result.fold(
      (failure) => emit(GetTweetsFailureState(message: failure.message)),
      (tweets) => emit(GetTweetsLoadedState(tweets: tweets)),
    );
  }
}
