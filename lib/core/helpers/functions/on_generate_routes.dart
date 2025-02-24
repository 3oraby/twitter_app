import 'package:flutter/material.dart';
import 'package:twitter_app/core/widgets/wrong_route_page.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/auth/presentation/screens/add_user_profile_picture_screen.dart';
import 'package:twitter_app/features/auth/presentation/screens/complete_user_profile_screen.dart';
import 'package:twitter_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:twitter_app/features/auth/presentation/screens/signin_with_phone_number_screen.dart';
import 'package:twitter_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:twitter_app/features/bookmark/presentation/screens/user_bookmarks_screen.dart';
import 'package:twitter_app/features/comments/domain/entities/comment_details_entity.dart';
import 'package:twitter_app/features/comments/presentation/screens/make_new_comment_screen.dart';
import 'package:twitter_app/features/comments/presentation/screens/show_tweet_comments_screen.dart';
import 'package:twitter_app/features/comments/presentation/screens/update_comments_and_replies_screen.dart';
import 'package:twitter_app/features/follow_relationships/presentation/screens/user_connections_screen.dart';
import 'package:twitter_app/features/home/presentation/screens/main_app_screen.dart';
import 'package:twitter_app/features/home/presentation/screens/create_or_update_tweet_screen.dart';
import 'package:twitter_app/features/follow_relationships/presentation/screens/followers_suggestion_screen.dart';
import 'package:twitter_app/features/replies/domain/entities/reply_details_entity.dart';
import 'package:twitter_app/features/search/presentation/screens/search_results_screen.dart';
import 'package:twitter_app/features/search/presentation/screens/search_screen.dart';
import 'package:twitter_app/features/settings/data/models/update_user_screen_arguments_model.dart';
import 'package:twitter_app/features/settings/presentation/screens/change_app_language_screen.dart';
import 'package:twitter_app/features/settings/presentation/screens/display_and_languages_screen.dart';
import 'package:twitter_app/features/settings/presentation/screens/update_user_information_screen.dart';
import 'package:twitter_app/features/settings/presentation/screens/user_account_information_screen.dart';
import 'package:twitter_app/features/settings/presentation/screens/your_account_screen.dart';
import 'package:twitter_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:twitter_app/features/tweet/domain/entities/tweet_details_entity.dart';
import 'package:twitter_app/features/user/presentation/screens/user_profile_screen.dart';

Route<dynamic> onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case SplashScreen.routeId:
      return MaterialPageRoute(builder: (context) => const SplashScreen());
    case SignInScreen.routeId:
      return MaterialPageRoute(builder: (context) => const SignInScreen());
    case SignUpScreen.routeId:
      return MaterialPageRoute(builder: (context) => const SignUpScreen());
    case SignInWithPhoneNumberScreen.routeId:
      return MaterialPageRoute(
          builder: (context) => const SignInWithPhoneNumberScreen());
    case CompleteUserProfileScreen.routeId:
      return MaterialPageRoute(
          builder: (context) => const CompleteUserProfileScreen());
    case MainAppScreen.routeId:
      return MaterialPageRoute(builder: (context) => const MainAppScreen());
    case AddUserProfilePictureScreen.routeId:
      return MaterialPageRoute(
          builder: (context) => const AddUserProfilePictureScreen());
    case CreateOrUpdateTweetScreen.routeId:
      return MaterialPageRoute(
        builder: (context) => CreateOrUpdateTweetScreen(
          tweetDetails: settings.arguments is TweetDetailsEntity
              ? settings.arguments as TweetDetailsEntity
              : null,
        ),
      );

    case FollowersSuggestionScreen.routeId:
      return MaterialPageRoute(
        builder: (context) => const FollowersSuggestionScreen(),
      );
    case UserConnectionsScreen.routeId:
      return MaterialPageRoute(
        builder: (context) => UserConnectionsScreen(
          targetUser: settings.arguments as UserEntity,
        ),
      );
    case MakeNewCommentScreen.routeId:
      return MaterialPageRoute(
        builder: (context) => MakeNewCommentScreen(
          tweetDetailsEntity: settings.arguments as TweetDetailsEntity,
        ),
      );
    case ShowTweetCommentsScreen.routeId:
      return MaterialPageRoute(
        builder: (context) => ShowTweetCommentsScreen(
          tweetDetailsEntity: settings.arguments as TweetDetailsEntity,
        ),
      );
    case UserProfileScreen.routeId:
      return MaterialPageRoute(
        builder: (context) => UserProfileScreen(
          userEntity: settings.arguments as UserEntity,
        ),
      );
    case UpdateCommentsAndRepliesScreen.routeId:
      return MaterialPageRoute(builder: (context) {
        var argument = settings.arguments;
        return argument is CommentDetailsEntity
            ? UpdateCommentsAndRepliesScreen(commentDetailsEntity: argument)
            : UpdateCommentsAndRepliesScreen(
                replyDetailsEntity: argument as ReplyDetailsEntity);
      });

    case YourAccountScreen.routeId:
      return MaterialPageRoute(
        builder: (context) => const YourAccountScreen(),
      );
    case UserAccountInformationScreen.routeId:
      return MaterialPageRoute(
        builder: (context) => const UserAccountInformationScreen(),
      );
    case DisplayAndLanguagesScreen.routeId:
      return MaterialPageRoute(
        builder: (context) => const DisplayAndLanguagesScreen(),
      );
    case ChangeAppLanguageScreen.routeId:
      return MaterialPageRoute(
        builder: (context) => const ChangeAppLanguageScreen(),
      );
    case UpdateUserInformationScreen.routeId:
      return MaterialPageRoute(
        builder: (context) => UpdateUserInformationScreen(
          arguments: settings.arguments as UpdateUserScreenArgumentsModel,
        ),
      );

    case UserBookmarksScreen.routeId:
      return MaterialPageRoute(
        builder: (context) => const UserBookmarksScreen(),
      );
    case SearchScreen.routeId:
      return MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      );
    case SearchResultsScreen.routeId:
      return MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
          query: settings.arguments as String,
        ),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const WrongRoutePage(),
      );
  }
}
