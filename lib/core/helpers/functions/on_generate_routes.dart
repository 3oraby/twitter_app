import 'package:flutter/material.dart';
import 'package:twitter_app/core/widgets/wrong_route_page.dart';
import 'package:twitter_app/features/auth/presentation/screens/add_user_profile_picture_screen.dart';
import 'package:twitter_app/features/auth/presentation/screens/complete_user_profile_screen.dart';
import 'package:twitter_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:twitter_app/features/auth/presentation/screens/signin_with_phone_number_screen.dart';
import 'package:twitter_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:twitter_app/features/follow_relationships/presentation/screens/user_connections_screen.dart';
import 'package:twitter_app/features/home/presentation/screens/main_app_screen.dart';
import 'package:twitter_app/features/home/presentation/screens/make_new_tweet_screen.dart';
import 'package:twitter_app/features/follow_relationships/presentation/screens/followers_suggestion_screen.dart';

Route<dynamic> onGenerateRoutes(RouteSettings settings) {
  switch (settings.name) {
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
    case MakeNewTweetScreen.routeId:
      return MaterialPageRoute(
          builder: (context) => const MakeNewTweetScreen());

    case FollowersSuggestionScreen.routeId:
      return MaterialPageRoute(
        builder: (context) => const FollowersSuggestionScreen(),
      );
    case UserConnectionsScreen.routeId:
      return MaterialPageRoute(
        builder: (context) => const UserConnectionsScreen(),
      );
    // case CheckoutView.routeName:
    //   return MaterialPageRoute(
    //       builder: (context) => CheckoutView(
    //             cartEntity: settings.arguments as CartEntity,
    //           ));
    default:
      return MaterialPageRoute(
        builder: (context) => const WrongRoutePage(),
      );
  }
}
