import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/features/tweet/data/models/get_tweets_filter_option_model.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';
import 'package:twitter_app/features/tweet/domain/repos/tweet_repo.dart';

part 'get_tweets_state.dart';

class GetTweetsCubit extends Cubit<GetTweetsState> {
  GetTweetsCubit({required this.tweetRepo}) : super(GetTweetsInitial());
  final TweetRepo tweetRepo;

  Future<void> getTweets({
    GetTweetsFilterOptionModel tweetFilterOption =
        const GetTweetsFilterOptionModel(),
  }) async {
    emit(GetTweetsLoadingState());
    var result = await tweetRepo.getTweets(
      tweetFilterOption: tweetFilterOption,
    );
    result.fold(
      (failure) => emit(GetTweetsFailureState(message: failure.message)),
      (tweets) => emit(GetTweetsLoadedState(tweets: tweets)),
    );
  }
}
