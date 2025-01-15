import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/helpers/functions/show_success_auth_modal_bottom_sheet.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_svgs.dart';
import 'package:twitter_app/core/widgets/custom_modal_progress_hud.dart';
import 'package:twitter_app/features/auth/domain/repo_interface/auth_repo.dart';
import 'package:twitter_app/features/auth/presentation/cubits/signup_cubits/sign_up_cubit.dart';
import 'package:twitter_app/features/auth/presentation/screens/complete_user_profile_screen.dart';
import 'package:twitter_app/features/auth/presentation/widgets/sign_up_body.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  static const String routeId = 'kSignUpScreen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(
        authRepo: getIt<AuthRepo>(),
      ),
      child: Scaffold(
        appBar: buildCustomAppBar(
          context,
          title: SvgPicture.asset(AppSvgs.svgXLogoWhiteBackground36),
          automaticallyImplyLeading: false,
        ),
        body: const SignUpBlocConsumerBody(),
      ),
    );
  }
}

class SignUpBlocConsumerBody extends StatelessWidget {
  const SignUpBlocConsumerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SignUpFailureState) {
          showCustomSnackBar(context, state.message);
        } else if (state is SignUpLoadedState) {
          log("account successfully created");
          showSuccessAuthModalBottomSheet(
            context: context,
            sheetTitle:
                context.tr("Your Account Has Been Created Successfully! 🎉"),
            sheetDescription: context.tr(
                "Next step: Complete your profile by adding essential details like your first name, bio, and more to get started."),
            buttonDescription: context.tr('Complete Your Profile'),
            onNextButtonPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                CompleteUserProfileScreen.routeId,
                (Route<dynamic> route) => false,
              );
            },
          );
        }
      },
      builder: (context, state) {
        return CustomModalProgressHUD(
          inAsyncCall: state is SignUpLoadingState,
          child: const SignUpBody(),
        );
      },
    );
  }
}
