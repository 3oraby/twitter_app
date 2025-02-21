class GetTweetsFilterOptionModel {
  final bool isForFollowingOnly;
  final bool includeLikedTweets;
  final bool includeUserTweets;
  final bool includeTweetsWithImages;
  final bool includeBookmarkedTweets;
  final bool includeRetweetedTweets;

  const GetTweetsFilterOptionModel({
    this.isForFollowingOnly = false,
    this.includeLikedTweets = false,
    this.includeUserTweets = false,
    this.includeTweetsWithImages = false,
    this.includeBookmarkedTweets = false,
    this.includeRetweetedTweets = false,
  });
}
