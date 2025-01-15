import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_svgs.dart';
import 'package:twitter_app/core/widgets/custom_modal_progress_hud.dart';
import 'package:twitter_app/features/auth/presentation/cubits/complete_user_profile_cubit/complete_user_profile_cubit.dart';
import 'package:twitter_app/features/auth/presentation/screens/add_user_profile_picture_screen.dart';
import 'package:twitter_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:twitter_app/features/auth/presentation/widgets/complete_user_profile_body.dart';
import 'package:twitter_app/features/user/domain/repo_interface/user_repo.dart';

class CompleteUserProfileScreen extends StatefulWidget {
  const CompleteUserProfileScreen({super.key});

  static const String routeId = 'kCompleteUserProfileScreen';

  @override
  State<CompleteUserProfileScreen> createState() =>
      _CompleteUserProfileScreenState();
}

class _CompleteUserProfileScreenState extends State<CompleteUserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompleteUserProfileCubit(
        userRepo: getIt<UserRepo>(),
      ),
      child: Scaffold(
        appBar: buildCustomAppBar(
          context,
          title: SvgPicture.asset(AppSvgs.svgXLogoWhiteBackground36),
        ),
        body: const CompleteUserProfileBlocConsumerBody(),
      ),
    );
  }
}

class CompleteUserProfileBlocConsumerBody extends StatelessWidget {
  const CompleteUserProfileBlocConsumerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompleteUserProfileCubit, CompleteUserProfileState>(
      listener: (context, state) {
        if (state is CompleteUserProfileFailureState) {
          log(state.message);
          showCustomSnackBar(context, state.message);
          Navigator.pushReplacementNamed(context, SignInScreen.routeId);
        } else if (state is CompleteUserProfileLoadedState) {
          log("user data is successfully added");
          Navigator.pushReplacementNamed(context, AddUserProfilePictureScreen.routeId);
        }
      },
      builder: (context, state) {
        return CustomModalProgressHUD(
          inAsyncCall: state is CompleteUserProfileLoadingState,
          child: const CompleteUserProfileBody(),
        );
      },
    );
  }
}
