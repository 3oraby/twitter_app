import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/core/helpers/functions/get_current_user.dart';
import 'package:twitter_app/core/utils/app_colors.dart';
import 'package:twitter_app/core/utils/app_text_styles.dart';
import 'package:twitter_app/core/utils/validators.dart';
import 'package:twitter_app/core/widgets/custom_text_form_field.dart';
import 'package:twitter_app/core/widgets/custom_trigger_button.dart';
import 'package:twitter_app/core/widgets/horizontal_gap.dart';
import 'package:twitter_app/core/widgets/vertical_gap.dart';
import 'package:twitter_app/features/auth/data/models/complete_profile_user_model.dart';
import 'package:twitter_app/features/auth/data/models/firebase_auth_user_model.dart';
import 'package:twitter_app/features/auth/presentation/cubits/complete_user_profile_cubit/complete_user_profile_cubit.dart';

class CompleteUserProfileBody extends StatefulWidget {
  const CompleteUserProfileBody({super.key});

  @override
  State<CompleteUserProfileBody> createState() =>
      _CompleteUserProfileBodyState();
}

class _CompleteUserProfileBodyState extends State<CompleteUserProfileBody> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  Gender selectedGender = Gender.male;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AppConstants.autovalidateMode;

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    phoneNumberController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.horizontalPadding),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VerticalGap(16),
              Text(
                'Tell us about yourself',
                style: AppTextStyles.uberMoveBold22,
              ),
              const VerticalGap(16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormFieldWidget(
                      autovalidateMode: autovalidateMode,
                      labelText: 'First Name',
                      hintText: 'Enter your first name',
                      controller: firstNameController,
                      validator: (value) =>
                          Validators.validateNormalText(context, value),
                    ),
                  ),
                  const HorizontalGap(16),
                  Expanded(
                    child: CustomTextFormFieldWidget(
                      autovalidateMode: autovalidateMode,
                      labelText: 'Last Name',
                      hintText: 'Enter your last name',
                      controller: lastNameController,
                      validator: (value) =>
                          Validators.validateNormalText(context, value),
                    ),
                  ),
                ],
              ),
              const VerticalGap(24),
              CustomTextFormFieldWidget(
                autovalidateMode: autovalidateMode,
                labelText: 'Age',
                hintText: 'Enter your age',
                keyboardType: TextInputType.number,
                controller: ageController,
                validator: (value) => Validators.validateAge(context, value),
              ),
              const VerticalGap(16),
              CustomTextFormFieldWidget(
                autovalidateMode: autovalidateMode,
                labelText: 'Phone Number',
                hintText: 'Enter your phone number',
                keyboardType: TextInputType.phone,
                controller: phoneNumberController,
                validator: (value) =>
                    Validators.validatePhoneNumber(context, value),
              ),
              const VerticalGap(16),
              Text(
                'Gender',
                style: AppTextStyles.uberMoveBold16,
              ),
              const VerticalGap(8),
              DropdownButtonFormField<Gender>(
                value: selectedGender,
                onChanged: (Gender? newValue) {
                  setState(() {
                    selectedGender = newValue!;
                  });
                },
                items: Gender.values.map((Gender gender) {
                  return DropdownMenuItem<Gender>(
                    value: gender,
                    child: Text(gender.name.capitalize()),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightBackgroundColor,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadius),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
              ),
              const VerticalGap(32),
              CustomTriggerButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    FirebaseAuthUserModel firebaseAuthUserModel =
                        getCurrentUser();

                    final CompleteProfileUserModel completeProfileUserModel =
                        CompleteProfileUserModel(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      email: firebaseAuthUserModel.email,
                      age: int.parse(ageController.text),
                      gender: selectedGender,
                      phoneNumber: phoneNumberController.text,
                      createdAt: Timestamp.now(),
                    );
                    log("complete User Profile Data: ${completeProfileUserModel.toJson().toString()}");

                    BlocProvider.of<CompleteUserProfileCubit>(context)
                        .addUserData(
                      data: completeProfileUserModel.toJson(),
                      documentId: firebaseAuthUserModel.uid,
                    );
                  } else {
                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                    });
                  }
                },
                buttonDescription: Text(
                  'Complete Profile',
                  style: AppTextStyles.uberMoveBold18
                      .copyWith(color: Colors.white),
                ),
              ),
              const VerticalGap(16),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}
