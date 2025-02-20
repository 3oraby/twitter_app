import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/build_custom_app_bar.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/widgets/custom_container_button.dart';
import 'package:twitter_app/features/settings/data/models/update_user_screen_arguments_model.dart';

class UpdateUserInformationScreen extends StatelessWidget {
  const UpdateUserInformationScreen({
    super.key,
    required this.arguments,
  });

  static const String routeId = 'kUpdateUserInformationScreen';
  final UpdateUserScreenArgumentsModel arguments;

  @override
  Widget build(BuildContext context) {
    return UpdateUserInformationBlocConsumerBody(arguments: arguments);
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

  _onDoneButtonPressed() {}
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                onPressed:
                    isDoneButtonEnabled ? () => _onDoneButtonPressed() : null,
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
            const Divider(
              color: AppColors.dividerColor,
              height: 0,
              thickness: 2,
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
  }
}
