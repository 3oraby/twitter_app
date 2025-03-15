import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_app/core/services/firebase_auth_service.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_svgs.dart';
import 'package:twitter_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:twitter_app/features/home/presentation/screens/main_app_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeId = 'kSplashScreen';
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(
      const Duration(seconds: 3),
      _navigateToNextPage,
    );
  }

  FutureOr<Null> _navigateToNextPage() {
    if (getIt<FirebaseAuthService>().isUserLoggedIn()) {
      Navigator.pushReplacementNamed(context, MainAppScreen.routeId);
    } else {
      Navigator.pushReplacementNamed(context, SignInScreen.routeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: Center(
        child: SvgPicture.asset(
          AppSvgs.svgXLogoWhiteBackground36,
          height: 100,
          width: 100,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
