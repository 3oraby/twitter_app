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
import 'package:twitter_app/core/widgets/custom_container_button.dart';
import 'package:twitter_app/features/auth/data/models/user_model.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';
import 'package:twitter_app/features/settings/data/models/update_user_screen_arguments_model.dart';
import 'package:twitter_app/features/settings/presentation/cubits/update_user_information_cubit.dart/update_user_information_cubit.dart';
import 'package:twitter_app/features/user/domain/repo_interface/user_repo.dart';

class UpdateUserInformationScreen extends StatelessWidget {
  const UpdateUserInformationScreen({
    super.key,
    required this.arguments,
  });

  static const String routeId = 'kUpdateUserInformationScreen';
  final UpdateUserScreenArgumentsModel arguments;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateUserInformationCubit(
        userRepo: getIt<UserRepo>(),
      ),
      child: UpdateUserInformationBlocConsumerBody(arguments: arguments),
    );
  }
}

class UpdateUserInformationBlocConsumerBody extends StatefulWidget {
  const UpdateUserInformationBlocConsumerBody({
    super.key,
    required this.arguments,
  });

  final UpdateUserScreenArgumentsModel arguments;

  @override
  State<UpdateUserInformationBlocConsumerBody> createState() =>
      _UpdateUserInformationBlocConsumerBodyState();
}

class _UpdateUserInformationBlocConsumerBodyState
    extends State<UpdateUserInformationBlocConsumerBody> {
  bool isDoneButtonEnabled = false;
  TextEditingController textEditingController = TextEditingController();
  late UserEntity currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = getCurrentUserEntity();
    textEditingController.addListener(() {
      setState(() {
        isDoneButtonEnabled = textEditingController.text.trim().isNotEmpty;
      });
    });
  }

  _onDoneButtonPressed() {
    setState(() {
      isDoneButtonEnabled = false;
    });
    final content = textEditingController.text.trim();

    UserEntity newUserData;

    switch (widget.arguments.title) {
      case "First Name":
        newUserData = currentUser.copyWith(
          firstName: content,
        );
      case "Last Name":
        newUserData = currentUser.copyWith(
          lastName: content,
        );
      case "Bio":
        newUserData = currentUser.copyWith(
          bio: content,
        );
      case "Phone number":
        newUserData = currentUser.copyWith(
          phoneNumber: content,
        );
      case "Age":
        newUserData = currentUser.copyWith(
          age: int.parse(content),
        );
      default:
        newUserData = currentUser;
    }

    BlocProvider.of<UpdateUserInformationCubit>(context).updateUserData(
      documentId: currentUser.userId,
      data: UserModel.fromEntity(newUserData).toJson(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateUserInformationCubit, UpdateUserInformationState>(
      listener: (context, state) {
        if (state is UpdateUserInformationLoadedState) {
          showCustomSnackBar(
              context, "Your profile has been updated successfully! 🎉");
          Navigator.pop(context);
        } else if (state is UpdateUserInformationFailureState) {
          showCustomSnackBar(context, context.tr(state.message));
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return AbsorbPointer(
          absorbing: state is UpdateUserInformationLoadingState,
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
                      style: AppTextStyles.uberMoveMedium20,
                    ),
                  ),
                  Text(
                    "Update ${widget.arguments.title}",
                    style: AppTextStyles.uberMoveBlack20,
                  ),
                  CustomContainerButton(
                    internalVerticalPadding: 4,
                    backgroundColor: isDoneButtonEnabled
                        ? AppColors.twitterAccentColor
                        : AppColors.lightTwitterAccentColor,
                    onPressed: isDoneButtonEnabled
                        ? () => _onDoneButtonPressed()
                        : null,
                    child: Text(
                      "Done",
                      style: AppTextStyles.uberMoveMedium18
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                state is UpdateUserInformationLoadingState
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
                    spacing: 16,
                    children: [
                      Text(
                        "Current",
                        style: AppTextStyles.uberMoveExtraBold20,
                      ),
                      Text(
                        widget.arguments.currentValue,
                        style: AppTextStyles.uberMoveRegular18,
                      ),
                      Text(
                        "New",
                        style: AppTextStyles.uberMoveExtraBold20,
                      ),
                      TextFormField(
                        controller: textEditingController,
                        maxLength: switch (widget.arguments.title) {
                          "Bio" => 50,
                          "Phone number" => 11,
                          "Age" => 3,
                          _ => 25
                        },
                        keyboardType: switch (widget.arguments.title) {
                          "Age" => TextInputType.number,
                          "Phone number" => TextInputType.phone,
                          _ => TextInputType.text,
                        },
                        decoration: InputDecoration(
                          hintText: widget.arguments.title,
                          hintStyle: AppTextStyles.uberMoveMedium18.copyWith(
                            color: AppColors.thirdColor,
                          ),
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.5,
                              color: AppColors.dividerColor,
                            ),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 0.5,
                              color: AppColors.dividerColor,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
