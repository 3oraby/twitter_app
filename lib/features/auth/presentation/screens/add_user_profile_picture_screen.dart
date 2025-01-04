import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/helpers/functions/show_success_auth_modal_bottom_sheet.dart';
import 'package:twitter_app/core/repos/files_repo/files_repo.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_svgs.dart';
import 'package:twitter_app/core/widgets/custom_modal_progress_hud.dart';
import 'package:twitter_app/features/auth/presentation/cubits/add_user_profile_picture_cubit/add_user_profile_picture_cubit.dart';
import 'package:twitter_app/features/auth/presentation/widgets/add_user_profile_picture_body.dart';
import 'package:twitter_app/features/home/presentation/screens/home_screen.dart';
import 'package:twitter_app/features/user/domain/repo_interface/user_repo.dart';

class AddUserProfilePictureScreen extends StatefulWidget {
  const AddUserProfilePictureScreen({super.key});

  static const String routeId = 'kAddUserProfilePictureScreen';

  @override
  State<AddUserProfilePictureScreen> createState() =>
      _AddUserProfilePictureScreenState();
}

class _AddUserProfilePictureScreenState
    extends State<AddUserProfilePictureScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddUserProfilePictureCubit(
        filesRepo: getIt<FilesRepo>(),
        userRepo: getIt<UserRepo>(),
      ),
      child: Scaffold(
        appBar: buildCustomAppBar(
          context,
          title: SvgPicture.asset(AppSvgs.svgXLogoWhiteBackground48),
        ),
        body: const AddUserProfilePictureBlocConsumerBody(),
      ),
    );
  }
}

class AddUserProfilePictureBlocConsumerBody extends StatelessWidget {
  const AddUserProfilePictureBlocConsumerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddUserProfilePictureCubit, AddUserProfilePictureState>(
      listener: (context, state) {
        if (state is AddUserProfilePictureFailureState) {
          showCustomSnackBar(context, state.message);
        } else if (state is AddUserProfilePictureLoadedState) {
          log("image uploaded successfully");
          showSuccessAuthModalBottomSheet(
            context: context,
            sheetTitle: context.tr("Profile Picture Uploaded! 🎉"),
            sheetDescription: context.tr(
                "Your profile picture has been uploaded successfully. You're all set to explore tweets and connect with friends!"),
            buttonDescription: context.tr('Explore Now'),
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
          inAsyncCall: state is AddUserProfilePictureLoadingState,
          child: const AddUserProfilePictureBody(),
        );
      },
    );
  }
}
