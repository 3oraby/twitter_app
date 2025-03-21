import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:twitter_app/core/helpers/functions/on_generate_routes.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/features/splash/presentation/screens/splash_screen.dart';

class TwitterApp extends StatelessWidget {
  const TwitterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
            iconTheme: const IconThemeData(
              color: AppColors.primaryColor,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              unselectedItemColor: Colors.white,
            ),
          ),
          themeMode: themeMode,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: onGenerateRoutes,
          initialRoute: SplashScreen.routeId,
        );
      },
    );
  }
}
