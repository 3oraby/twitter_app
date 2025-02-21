import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_repo.dart';

part 'get_tweets_state.dart';

class GetTweetsCubit extends Cubit<GetTweetsState> {
  GetTweetsCubit({required this.tweetRepo}) : super(GetTweetsInitial());
  final TweetRepo tweetRepo;

  Future<void> getTweets({
    bool? isForFollowingOnly,
    bool? includeLikedTweets,
    bool? includeUserTweets,
    bool? includeTweetsWithImages,
  }) async {
    emit(GetTweetsLoadingState());
    var result = await tweetRepo.getTweets(
      isForFollowingOnly: isForFollowingOnly,
      includeLikedTweets: includeLikedTweets,
      includeUserTweets: includeUserTweets,
      includeTweetsWithImages: includeTweetsWithImages,
    );
    result.fold(
      (failure) => emit(GetTweetsFailureState(message: failure.message)),
      (tweets) => emit(GetTweetsLoadedState(tweets: tweets)),
    );
  }
}
