import 'package:flutter/material.dart';
import 'package:twitter_app/core/widgets/wrong_route_page.dart';
import 'package:twitter_app/features/auth/presentation/screens/complete_user_profile_screen.dart';
import 'package:twitter_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:twitter_app/features/auth/presentation/screens/signin_with_phone_number_screen.dart';
import 'package:twitter_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:twitter_app/features/home/presentation/screens/home_screen.dart';

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
    case HomeScreen.routeId:
      return MaterialPageRoute(builder: (context) => const HomeScreen());
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
