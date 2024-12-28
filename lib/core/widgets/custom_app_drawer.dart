import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/cubits/logout_cubits/logout_cubit.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/widgets/app_drawer_body.dart';
import 'package:twitter_app/core/widgets/custom_modal_progress_hud.dart';
import 'package:twitter_app/features/auth/domain/repo_interface/auth_repo.dart';
import 'package:twitter_app/features/auth/presentation/screens/signin_screen.dart';

class CustomAppDrawer extends StatelessWidget {
  const CustomAppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogoutCubit(
        authRepo: getIt<AuthRepo>(),
      ),
      child: const DrawerBlocConsumerBody(),
    );
  }
}

class DrawerBlocConsumerBody extends StatelessWidget {
  const DrawerBlocConsumerBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogOutFailureState) {
          showCustomSnackBar(context, state.message);
        } else if (state is LogoutLoadedState) {
          showCustomSnackBar(context, "Logged out successfully");
          Navigator.pushNamedAndRemoveUntil(
            context,
            SignInScreen.routeId,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        return CustomModalProgressHUD(
          inAsyncCall: state is LogoutLoadingState,
          child: const AppDrawerBody(),
        );
      },
    );
  }
}
