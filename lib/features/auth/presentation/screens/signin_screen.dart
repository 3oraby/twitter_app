import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/helpers/functions/show_success_auth_modal_bottom_sheet.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/custom_modal_progress_hud.dart';
import 'package:twitter_app/features/auth/domain/repo_interface/auth_repo.dart';
import 'package:twitter_app/features/auth/presentation/cubits/signin_cubits/sign_in_cubit.dart';
import 'package:twitter_app/features/auth/presentation/widgets/signin_body.dart';
import 'package:twitter_app/features/home/presentation/screens/home_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
  static const String routeId = 'kSignInScreen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(
        authRepo: getIt<AuthRepo>(),
      ),
      child: Scaffold(
        appBar: buildCustomAppBar(
          context,
          title: Text(
            context.tr("Sign In"),
            style: AppTextStyles.uberMoveBold24,
          ),
        ),
        body: const SignInBLocConsumerBody(),
      ),
    );
  }
}

class SignInBLocConsumerBody extends StatelessWidget {
  const SignInBLocConsumerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      listener: (context, state) {
        if (state is SignInFailureState) {
          showCustomSnackBar(context, state.message);
        } else if (state is SignInLoadedState) {
          log("account successfully logged in");
          showSuccessAuthModalBottomSheet(
            context: context,
            sheetTitle: "Welcome Back! 🎉",
            sheetDescription:
                "You’ve logged in successfully. Now you can request a ride instantly and enjoy a smooth journey to your destination.",
            buttonDescription: 'Request a Ride',
            onNextButtonPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                HomeScreen.routeId,
                (Route<dynamic> route) => false,
              );
            },
          );
        }
      },
      builder: (context, state) {
        return CustomModalProgressHUD(
          inAsyncCall: state is SignInLoadingState,
          child: const SignInBody(),
        );
      },
    );
  }
}
