class BackendEndpoints {
  static const String supabaseUrl = 'https://ohbgfbpjtbzfvpgsfret.supabase.co';
  // users
  static const String addUserData = 'users';
  static const String getUserData = 'users';
  static const String updateUserData = 'users';
  static const String getUserConnections = "users";
  static const String getSuggestionFollowers = "users";
  static const String uploadFiles = 'UploadFiles';
  static const String toggleFollowRelationShip = "followRelationShips";
  // tweets
  static const String makeNewTweet = "tweets";
  static const String getTweets = "tweets";
  static const String toggleTweetLike = "tweetLikes";
  static const String getTweetLikes = "tweetLikes";
  static const String updateTweetData = "tweets";
  static const String deleteTweet = "tweets";
  static const String updateTweet = "tweets";
  // retweets
  static const String toggleRetweet = "retweets";
  static const String getRetweets = "retweets";
  // bookmarks
  static const String toggleBookMarks = "bookmarks";
  static const String getBookMarks = "bookmarks";
  // comments
  static const String makeNewComment = "comments";
  static const String getComments = "comments";
  static const String deleteComment = "comments";
  static const String updateComment = "comments";
  static const String toggleCommentLikes = "commentLikes";
  static const String getCommentLikes = "commentLikes";
  static const String updateCommentData = "comments";
  // replies
  static const String makeNewReply = "Replies";
  static const String getReplies = "Replies";
  static const String deleteReply = "Replies";
  static const String updateReply = "Replies";
  static const String updateReplyData = "Replies";
  static const String toggleReplyLikes = "ReplyLikes";
  static const String getReplyLikes = "ReplyLikes";
}
