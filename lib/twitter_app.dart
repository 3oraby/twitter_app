
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/helpers/functions/on_generate_routes.dart';
import 'package:twitter_app/core/services/firebase_auth_service.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:twitter_app/features/home/presentation/screens/home_screen.dart';

class TwitterApp extends StatelessWidget {
  const TwitterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: onGenerateRoutes,
      initialRoute: getIt<FirebaseAuthService>().isUserLoggedIn()
          ? HomeScreen.routeId
          : SignInScreen.routeId,
    );
  }
}
