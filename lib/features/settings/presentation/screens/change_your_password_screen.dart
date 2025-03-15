import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user_entity.dart';
import 'package:twitter_app/core/helpers/functions/show_custom_snack_bar.dart';
import 'package:twitter_app/core/services/get_it_service.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/utils/validators.dart';
import 'package:twitter_app/core/widgets/custom_container_button.dart';
import 'package:twitter_app/core/widgets/password_text_form_field.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/auth/domain/repo_interface/auth_repo.dart';
import 'package:twitter_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:twitter_app/features/settings/presentation/cubits/change_password_cubit/change_password_cubit.dart';

class ChangeYourPasswordScreen extends StatelessWidget {
  const ChangeYourPasswordScreen({super.key});

  static const String routeId = 'kChangeYourPasswordScreen';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordCubit(
        authRepo: getIt<AuthRepo>(),
      ),
      child: const ChangeYourPasswordBlocConsumerBody(),
    );
  }
}

class ChangeYourPasswordBlocConsumerBody extends StatefulWidget {
  const ChangeYourPasswordBlocConsumerBody({super.key});

  @override
  State<ChangeYourPasswordBlocConsumerBody> createState() =>
      _ChangeYourPasswordBlocConsumerBodyState();
}

class _ChangeYourPasswordBlocConsumerBodyState
    extends State<ChangeYourPasswordBlocConsumerBody> {
  bool isDoneButtonEnabled = false;
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late UserEntity currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity();

    void updateDoneButtonState() {
      setState(() {
        isDoneButtonEnabled = currentPasswordController.text.isNotEmpty &&
            newPasswordController.text.isNotEmpty &&
            confirmNewPasswordController.text.isNotEmpty;
      });
    }

    currentPasswordController.addListener(updateDoneButtonState);
    newPasswordController.addListener(updateDoneButtonState);
    confirmNewPasswordController.addListener(updateDoneButtonState);
  }

  _onDoneButtonPressed() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isDoneButtonEnabled = false;
      });
      final currentPasswordText = currentPasswordController.text.trim();
      final newPasswordText = newPasswordController.text.trim();

      BlocProvider.of<ChangePasswordCubit>(context).changePassword(
        email: currentUser.email,
        oldPassword: currentPasswordText,
        newPassword: newPasswordText,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordLoadedState) {
          showCustomSnackBar(context,
              context.tr("Your password has been updated successfully! 🎉"));

          Navigator.pushNamedAndRemoveUntil(
            context,
            SignInScreen.routeId,
            (route) => false,
          );
        } else if (state is ChangePasswordFailureState) {
          showCustomSnackBar(context, context.tr(state.message));
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state is ChangePasswordLoadingState,
          child: Scaffold(
            appBar: buildCustomAppBar(
              context,
              automaticallyImplyLeading: false,
              centerTitle: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      context.tr("Cancel"),
                      style: AppTextStyles.uberMoveMedium(context,20),
                    ),
                  ),
                  Text(
                    context.tr("Update password"),
                    style: AppTextStyles.uberMoveBlack(context,20),
                  ),
                  CustomContainerButton(
                    internalVerticalPadding: 4,
                    backgroundColor: isDoneButtonEnabled
                        ? AppColors.twitterAccentColor
                        : AppColors.lightTwitterAccentColor,
                    onPressed:
                        isDoneButtonEnabled ? _onDoneButtonPressed : null,
                    child: Text(
                      context.tr("Done"),
                      style: AppTextStyles.uberMoveMedium(context,18)
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: [
                  state is ChangePasswordLoadingState
                      ? const LinearProgressIndicator(
                          color: AppColors.twitterAccentColor,
                        )
                      : const Divider(
                          color: AppColors.dividerColor,
                          height: 0,
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.horizontalPadding,
                      vertical: AppConstants.topPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr("Current password"),
                          style: AppTextStyles.uberMoveExtraBold(context,20),
                        ),
                        const VerticalGap(8),
                        PasswordTextFieldWidget(
                          controller: currentPasswordController,
                          hintText: context.tr("Enter your current password"),
                          validator: (value) =>
                              Validators.validatePassword(context, value),
                        ),
                        const VerticalGap(28),
                        Text(
                          context.tr("New password"),
                          style: AppTextStyles.uberMoveExtraBold(context,20),
                        ),
                        const VerticalGap(8),
                        PasswordTextFieldWidget(
                          controller: newPasswordController,
                          hintText: context.tr("Enter your new password"),
                          validator: (value) {
                            if (value == currentPasswordController.text) {
                              return "New password must be different from the current password".tr();
                            }
                            return Validators.validatePassword(context, value);
                          },
                        ),
                        const VerticalGap(28),
                        Text(
                          context.tr("Confirm new password"),
                          style: AppTextStyles.uberMoveExtraBold(context,20),
                        ),
                        const VerticalGap(8),
                        PasswordTextFieldWidget(
                          controller: confirmNewPasswordController,
                          hintText: context.tr("Re-enter your new password"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please confirm your new password".tr();
                            }
                            if (value != newPasswordController.text) {
                              return "Passwords do not match".tr();
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
